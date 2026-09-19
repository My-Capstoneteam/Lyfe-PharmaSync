<?php
    require_once 'db_connect.php';

    $action = $_POST['action'] ?? '';

    switch($action) {
        case 'fetch_inventory':
            $sql = "SELECT 
                        b.batch_id, b.batch_number, b.expiry_date, b.quantity_in_stock, b.selling_price, 
                        p.product_id, p.generic_name, p.brand_name, p.category, p.reorder_level, p.drug_type, p.dosage_form
                    FROM inventory_batches b
                    JOIN products p ON b.product_id = p.product_id
                    ORDER BY b.expiry_date ASC";
            
            $stmt = $pdo->prepare($sql);
            $stmt->execute();
            $inventoryData = $stmt->fetchAll();

            $formattedInventory = [];
            $today = new DateTime();

            foreach ($inventoryData as $item) {
                $expDate = new DateTime($item['expiry_date']);
                $daysToExpiry = $today->diff($expDate)->days;
                $isExpired = $today > $expDate;

                $status = 'Optimal';
                if ($isExpired) { $status = 'Expired'; } 
                elseif ($daysToExpiry <= 90) { $status = 'Expiring Soon'; } 
                elseif ($item['quantity_in_stock'] <= $item['reorder_level']) { $status = 'Low Stock'; }

                $formattedInventory[] = [
                    'id' => $item['batch_id'],
                    'product_id' => $item['product_id'], 
                    'batch' => $item['batch_number'],
                    'name' => trim($item['generic_name'] . ' (' . $item['brand_name'] . ')'),
                    'generic_name' => $item['generic_name'], 
                    'brand_name' => $item['brand_name'] === 'Generic' ? '' : $item['brand_name'], 
                    'category' => $item['category'],
                    'stock' => $item['quantity_in_stock'],
                    'price' => (float)$item['selling_price'],
                    'expiry' => $item['expiry_date'],
                    'status' => $status,
                    'drug_type' => $item['drug_type'] ?? 'OTC',
                    'dosage' => $item['dosage_form'] ?? ''
                ];
            }

            echo json_encode(["success" => true, "inventory" => $formattedInventory]);
        break;

        case 'update_inventory':
            $batchId = $_POST['batch_id'] ?? '';
            $batchNo = trim($_POST['batch_number'] ?? '');
            $qty = $_POST['quantity_in_stock'] ?? '';
            $price = $_POST['selling_price'] ?? '';
            $expiry = $_POST['expiry_date'] ?? '';
            $drugType = $_POST['drug_type'] ?? 'OTC';
            $dosageForm = trim($_POST['dosage_form'] ?? '');

            // NEW: Grab the updated master details from the Javascript!
            $name = ucwords(strtolower(trim($_POST['name'] ?? '')));
            $brand = ucwords(strtolower(trim($_POST['brand_name'] ?? '')));
            $category = ucwords(strtolower(trim($_POST['category'] ?? '')));
            if (empty($brand)) $brand = 'Generic';
            if (empty($category)) $category = 'Uncategorized';

            if (empty($batchId) || empty($batchNo) || $qty === '' || $price === '' || empty($expiry)) {
                echo json_encode(["success" => false, "message" => "All fields are required."]);
                exit;
            }

            try {
                $pdo->beginTransaction();
                
                // 1. Update the specific Batch Details (Stock, Price, Expiry)
                $stmt = $pdo->prepare("UPDATE inventory_batches SET batch_number = ?, quantity_in_stock = ?, selling_price = ?, expiry_date = ? WHERE batch_id = ?");
                $stmt->execute([$batchNo, $qty, $price, $expiry, $batchId]);
                
                // 2. Fetch the Master Product ID tied to this batch
                $prodStmt = $pdo->prepare("SELECT product_id FROM inventory_batches WHERE batch_id = ?");
                $prodStmt->execute([$batchId]);
                $productId = $prodStmt->fetchColumn();

                // 3. Update the Master Product Profile (Name, Brand, Category, Dosage, Rx)
                $updateProd = $pdo->prepare("UPDATE products SET generic_name = ?, brand_name = ?, category = ?, drug_type = ?, dosage_form = ? WHERE product_id = ?");
                $updateProd->execute([$name, $brand, $category, $drugType, $dosageForm, $productId]);
                
                // Log History
                $logStmt = $pdo->prepare("INSERT INTO audit_logs (user_id, action_type, description, timestamp) VALUES (?, 'Update', ?, NOW())");
                $logStmt->execute([$_SESSION['user_id'], "Updated Batch: $batchNo and synced Master Product details for $name."]);

                $pdo->commit();
                echo json_encode(["success" => true, "message" => "Inventory batch updated successfully."]);
            } catch (PDOException $e) {
                $pdo->rollBack();
                echo json_encode(["success" => false, "message" => "Database error: " . $e->getMessage()]);
            }
        break;

        case 'delete_inventory':
            $batchId = $_POST['batch_id'] ?? '';
            if (empty($batchId)) {
                echo json_encode(["success" => false, "message" => "No batch ID provided."]);
                exit;
            }

            try {
                $pdo->beginTransaction();
                
                // Fetch details for the log before deleting
                $getBatch = $pdo->prepare("SELECT batch_number FROM inventory_batches WHERE batch_id = ?");
                $getBatch->execute([$batchId]);
                $batchNumber = $getBatch->fetchColumn();


                // STEP 1: Find the master product_id tied to this batch BEFORE we delete it
                $getProd = $pdo->prepare("SELECT product_id FROM inventory_batches WHERE batch_id = ?");
                $getProd->execute([$batchId]);
                $productId = $getProd->fetchColumn();

                // STEP 2: Forcefully remove the item from past sales records
                $clearSales = $pdo->prepare("DELETE FROM sales_items WHERE batch_id = ?");
                $clearSales->execute([$batchId]);
                
                // STEP 3: Delete the actual inventory batch
                $deleteBatch = $pdo->prepare("DELETE FROM inventory_batches WHERE batch_id = ?");
                $deleteBatch->execute([$batchId]);
                
                // Log History
                $logStmt = $pdo->prepare("INSERT INTO audit_logs (user_id, action_type, description, timestamp) VALUES (?, 'Delete', ?, NOW())");
                $logStmt->execute([$_SESSION['user_id'], "Permanently deleted Batch: $batchNumber."]);


                // STEP 4: Delete the item from the products table IF it has no other active batches
                if ($productId) {
                    $checkRemaining = $pdo->prepare("SELECT COUNT(*) FROM inventory_batches WHERE product_id = ?");
                    $checkRemaining->execute([$productId]);
                    
                    if ($checkRemaining->fetchColumn() == 0) {
                        $deleteProd = $pdo->prepare("DELETE FROM products WHERE product_id = ?");
                        $deleteProd->execute([$productId]);
                    }
                }
                
                $pdo->commit();
                echo json_encode(["success" => true]);
                
            } catch (PDOException $e) {
                $pdo->rollBack();
                echo json_encode(["success" => false, "message" => "Database error: " . $e->getMessage()]);
            }
        break;

        case 'search_product':
            $query = trim($_POST['query'] ?? '');
            if (strlen($query) < 2) { echo json_encode(["success" => true, "results" => []]); exit; }
            
            $stmt = $pdo->prepare("SELECT * FROM products WHERE generic_name LIKE ? OR brand_name LIKE ? LIMIT 8");
            $stmt->execute(["%$query%", "%$query%"]);
            echo json_encode(["success" => true, "results" => $stmt->fetchAll(PDO::FETCH_ASSOC)]);
        break;

        case 'validate_batch':
            $productId = $_POST['product_id'] ?? '';
            $batchNo = trim($_POST['batch_number'] ?? '');
            
            if (!$productId || !$batchNo) { echo json_encode(["exists" => false]); exit; }

            $stmt = $pdo->prepare("SELECT expiry_date, quantity_in_stock, selling_price FROM inventory_batches WHERE product_id = ? AND batch_number = ?");
            $stmt->execute([$productId, $batchNo]);
            $data = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($data) {
                echo json_encode(["exists" => true, "data" => $data]);
            } else {
                echo json_encode(["exists" => false]);
            }
        break;
        
        case 'add_inventory':
            if (!isset($_SESSION['user_id'])) { echo json_encode(["success" => false, "message" => "Unauthorized session."]); exit; }

            // Base details
            $productId = $_POST['product_id'] ?? '';
            $batchNo = strtoupper(trim($_POST['batch_number'] ?? ''));
            $qty = (int)($_POST['quantity_in_stock'] ?? 0);
            $price = (float)($_POST['selling_price'] ?? 0);
            $expiry = $_POST['expiry_date'] ?? '';
            
            // Product details (Formatted)
            $name = ucwords(strtolower(trim($_POST['name'] ?? '')));
            $brand = ucwords(strtolower(trim($_POST['brand_name'] ?? '')));
            $category = ucwords(strtolower(trim($_POST['category'] ?? '')));
            $dosageForm = ucwords(strtolower(trim($_POST['dosage_form'] ?? '')));
            $drugType = $_POST['drug_type'] ?? 'OTC';
            if (empty($brand)) $brand = 'Generic';

            try {
                $pdo->beginTransaction();
                
                // 1. RESOLVE PRODUCT
                if (!$productId) {
                    $prodCheck = $pdo->prepare("SELECT product_id FROM products WHERE generic_name = ? AND brand_name = ?");
                    $prodCheck->execute([$name, $brand]);
                    $productId = $prodCheck->fetchColumn();

                    if (!$productId) {
                        // Generate a virtually collision-proof barcode
                        $barcode = 'BAR-' . date('ym') . rand(10000, 99999);
                        $prodStmt = $pdo->prepare("INSERT INTO products (barcode, generic_name, brand_name, category, reorder_level, drug_type, dosage_form) VALUES (?, ?, ?, ?, 50, ?, ?)");
                        $prodStmt->execute([$barcode, $name, $brand, $category, $drugType, $dosageForm]);
                        $productId = $pdo->lastInsertId();
                    }
                }

                // 2. MERGE OR CREATE BATCH
                $checkBatch = $pdo->prepare("SELECT batch_id, expiry_date, quantity_in_stock FROM inventory_batches WHERE product_id = ? AND batch_number = ?");
                $checkBatch->execute([$productId, $batchNo]);
                $existingBatch = $checkBatch->fetch(PDO::FETCH_ASSOC);

                if ($existingBatch) {
                    // Critical Traceability Block: A batch number CANNOT have two different expiration dates
                    if ($existingBatch['expiry_date'] !== $expiry) {
                        echo json_encode(["success" => false, "message" => "Validation Error: Batch {$batchNo} is already registered in the system with an expiration date of {$existingBatch['expiry_date']}. You cannot assign a different expiry date to the same batch."]);
                        $pdo->rollBack();
                        exit;
                    }

                    $newQty = $existingBatch['quantity_in_stock'] + $qty;
                    $updateStmt = $pdo->prepare("UPDATE inventory_batches SET quantity_in_stock = ?, selling_price = ? WHERE batch_id = ?");
                    $updateStmt->execute([$newQty, $price, $existingBatch['batch_id']]);
                    $logAction = "Merged incoming stock. Added $qty units to existing Batch: $batchNo.";
                    $responseMsg = "Matching lot detected! Merged $qty units into the existing batch.";
                } else {
                    // Create New Batch
                    $insertBatch = $pdo->prepare("INSERT INTO inventory_batches (product_id, batch_number, expiry_date, quantity_in_stock, selling_price, smart_pricing_status) VALUES (?, ?, ?, ?, ?, 'Inactive')");
                    $insertBatch->execute([$productId, $batchNo, $expiry, $qty, $price]);
                    $logAction = "Registered new lot: $name ($brand) (Batch: $batchNo) with $qty units.";
                    $responseMsg = "New batch registered successfully.";
                }

                $logStmt = $pdo->prepare("INSERT INTO audit_logs (user_id, action_type, description, timestamp) VALUES (?, 'Inventory Entry', ?, NOW())");
                $logStmt->execute([$_SESSION['user_id'], $logAction]);

                $pdo->commit();
                echo json_encode(["success" => true, "message" => $responseMsg]);
            } catch (Exception $e) {
                $pdo->rollBack();
                echo json_encode(["success" => false, "message" => "Database error: " . $e->getMessage()]);
            }
        break;

        case 'fetch_history':
            if (!isset($_SESSION['user_id'])) {
                echo json_encode(["success" => false, "message" => "Unauthorized session."]); 
                exit;
            }

            try {
                // Fetch the 100 most recent audit logs and join with the users table to get the full name
                $sql = "SELECT 
                            a.action_type, 
                            a.description, 
                            a.timestamp, 
                            CONCAT(u.first_name, ' ', u.last_name) AS user_name
                        FROM audit_logs a
                        JOIN users u ON a.user_id = u.user_id
                        ORDER BY a.timestamp DESC 
                        LIMIT 100";
                
                $stmt = $pdo->prepare($sql);
                $stmt->execute();
                $logs = $stmt->fetchAll(PDO::FETCH_ASSOC);

                $formattedLogs = [];
                foreach($logs as $row) {
                    $formattedLogs[] = [
                        'time' => date('M d, Y h:i A', strtotime($row['timestamp'])),
                        'user' => $row['user_name'],
                        'action' => $row['action_type'],
                        'desc' => $row['description']
                    ];
                }

                echo json_encode(["success" => true, "logs" => $formattedLogs]);
            } catch(PDOException $e) {
                echo json_encode(["success" => false, "message" => $e->getMessage()]);
            }
        break;

        case 'import_csv':
            // Security Check
            if (!isset($_SESSION['user_id'])) {
                echo json_encode(["success" => false, "message" => "Unauthorized session."]); exit;
            }

            $csvData = json_decode($_POST['csv_data'], true);
            if (!$csvData || empty($csvData)) { 
                echo json_encode(["success" => false, "message" => "No valid data received."]); exit; 
            }

            try {
                $pdo->beginTransaction();
                
                $prodCheck = $pdo->prepare("SELECT product_id FROM products WHERE generic_name = ? AND brand_name = ?");
                $prodInsert = $pdo->prepare("INSERT INTO products (barcode, generic_name, brand_name, category, reorder_level, drug_type) VALUES (?, ?, ?, ?, 50, 'OTC')");
                
                $batchCheck = $pdo->prepare("SELECT batch_id FROM inventory_batches WHERE product_id = ? AND batch_number = ?"); // Ensure product_id is checked
                $batchUpdate = $pdo->prepare("UPDATE inventory_batches SET quantity_in_stock = quantity_in_stock + ?, selling_price = ?, expiry_date = ? WHERE batch_number = ?");
                $batchInsert = $pdo->prepare("INSERT INTO inventory_batches (product_id, batch_number, expiry_date, quantity_in_stock, selling_price, smart_pricing_status) VALUES (?, ?, ?, ?, ?, 'Inactive')");
                
                $newCount = 0;
                $updatedCount = 0;

                foreach ($csvData as $row) {
                    $batch = strtoupper(trim($row['batch']));
                    $name = ucwords(strtolower(trim($row['name'])));
                    $brand = ucwords(strtolower(trim($row['brand'])));
                    $category = ucwords(strtolower(trim($row['category'])));
                    if (empty($brand)) $brand = 'Generic';

                    // 1. Resolve Product
                    $prodCheck->execute([$name, $brand]);
                    $productId = $prodCheck->fetchColumn();

                    if (!$productId) {
                        $prodInsert->execute(['BAR-' . rand(10000, 99999), $name, $brand, $category]);
                        $productId = $pdo->lastInsertId();
                    }

                    // 2. Resolve Batch
                    $batchCheck->execute([$productId, $batch]); // Pass $productId alongside $batch
                    if ($batchCheck->fetchColumn()) {
                        // Batch exists: ADD stock
                        $batchUpdate->execute([$row['stock'], $row['price'], $row['expiry'], $batch]);
                        $updatedCount++;
                    } else {
                        // Batch is new: INSERT
                        $batchInsert->execute([$productId, $batch, $row['expiry'], $row['stock'], $row['price']]);
                        $newCount++;
                    }
                }

                // 3. Log History
                $logStmt = $pdo->prepare("INSERT INTO audit_logs (user_id, action_type, description, timestamp) VALUES (?, 'Bulk Import', ?, NOW())");
                $logStmt->execute([$_SESSION['user_id'], "CSV Import processed. New items: $newCount. Existing batches updated: $updatedCount."]);

                $pdo->commit();
                echo json_encode(["success" => true, "message" => "Import Successful! Added $newCount new items. Updated $updatedCount existing batches."]);
            } catch (PDOException $e) {
                $pdo->rollBack();
                echo json_encode(["success" => false, "message" => "Database error: " . $e->getMessage()]);
            }
        break;

        case 'apply_smart_price':
            if (!isset($_SESSION['user_id'])) {
                echo json_encode(["success" => false, "message" => "Unauthorized session."]); 
                exit;
            }
            
            $batchId = $_POST['batch_id'] ?? '';
            $newPrice = $_POST['new_price'] ?? '';
            $oldPrice = $_POST['old_price'] ?? '';

            if (empty($batchId) || $newPrice === '') {
                echo json_encode(["success" => false, "message" => "Missing batch or price data."]); 
                exit;
            }

            try {
                $pdo->beginTransaction();
                
                // 1. Apply the discount and activate the smart pricing flag
                $stmt = $pdo->prepare("UPDATE inventory_batches SET selling_price = ?, smart_pricing_status = 'Active' WHERE batch_id = ?");
                $stmt->execute([$newPrice, $batchId]);
                
                // 2. Fetch item details for the audit log
                $infoStmt = $pdo->prepare("SELECT b.batch_number, p.generic_name FROM inventory_batches b JOIN products p ON b.product_id = p.product_id WHERE b.batch_id = ?");
                $infoStmt->execute([$batchId]);
                $info = $infoStmt->fetch();

                // 3. Log the financial change
                $logStmt = $pdo->prepare("INSERT INTO audit_logs (user_id, action_type, description, timestamp) VALUES (?, 'Smart Pricing', ?, NOW())");
                $desc = "Mitigation applied: Reduced price of {$info['generic_name']} (Batch: {$info['batch_number']}) from ₱{$oldPrice} to ₱{$newPrice}.";
                $logStmt->execute([$_SESSION['user_id'], $desc]);

                $pdo->commit();
                echo json_encode(["success" => true]);
            } catch (PDOException $e) {
                $pdo->rollBack();
                echo json_encode(["success" => false, "message" => "Database error: " . $e->getMessage()]);
            }
        break;

        case 'scan_barcode':
            $barcode = trim($_POST['barcode'] ?? '');
            
            // Initialize default variables before scanning
            $product = null;
            $extractedExpiry = "";
            $extractedDosage = "";
            $suggestedBatch = 'B-' . rand(1000, 9999);
            
            try {
                // CHECK A: Complex string barcode (e.g. PARACETAMOL|...|EXP:2028-08-31|...)
                if (strpos($barcode, '|') !== false) {
                    $parts = explode('|', $barcode);
                    $rawName = trim($parts[0] ?? '');
                    $extractedDosage = trim($parts[1] ?? '');
                    
                    // FIX: Remove double spaces and grab the first main word (e.g., "PARACETAMOL") 
                    $cleanName = preg_replace('/\s+/', ' ', $rawName);
                    $baseDrugName = explode(' ', $cleanName)[0];
                    
                    // Search master products by the base Generic Name
                    $stmt = $pdo->prepare("SELECT * FROM products WHERE generic_name LIKE ?");
                    $stmt->execute(["%" . $baseDrugName . "%"]);
                    $product = $stmt->fetch(PDO::FETCH_ASSOC);
                    
                    // Extract Expiry Date and Lot Number
                    foreach($parts as $part) {
                        if (strpos($part, 'EXP:') !== false) {
                            $extractedExpiry = trim(str_replace('EXP:', '', $part));
                        }
                        if (strpos($part, 'LOT') !== false) {
                            $suggestedBatch = trim(str_replace('LOT', 'B-', $part)); 
                        }
                    }
                } 
                // CHECK B: Standard 1D barcode (e.g. BAR-102)
                else {
                    $stmt = $pdo->prepare("SELECT * FROM products WHERE barcode = ?");
                    $stmt->execute([$barcode]);
                    $product = $stmt->fetch(PDO::FETCH_ASSOC);
                }

                // FINALLY: Send the data back to the JavaScript
                if ($product) {
                    // Fetch the most recent selling price for this exact product
                    $priceStmt = $pdo->prepare("SELECT selling_price FROM inventory_batches WHERE product_id = ? ORDER BY batch_id DESC LIMIT 1");
                    $priceStmt->execute([$product['product_id']]);
                    $latestPrice = $priceStmt->fetchColumn();

                    echo json_encode([
                        "success" => true, 
                        "product" => $product, 
                        "suggested_batch" => $suggestedBatch,
                        "extracted_expiry" => $extractedExpiry,
                        "extracted_dosage" => $extractedDosage, 
                        "suggested_price" => ($latestPrice !== false) ? number_format((float)$latestPrice, 2, '.', '') : ''
                    ]);
                } else {
                    echo json_encode(["success" => false, "message" => "Barcode not recognized in master database."]);
                }
            } catch (Exception $e) {
                echo json_encode(["success" => false, "message" => "Database error."]);
            }        
        break;

        default:
            echo json_encode(["success" => false, "message" => "Invalid action."]);
        break;
    }
?>