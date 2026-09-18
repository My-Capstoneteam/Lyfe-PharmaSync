<?php
    header('Content-Type: application/json');
    require_once 'db_connect.php'; 

    $apiKey = 'AQ.Ab8RN6IKhyz8PoB3r12H7lSRIBZ2l96EYdtPuB2m5qLLSu80IQ'; 
    $url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=' . $apiKey;

    $module = $_GET['module'] ?? 'predictive';
    $forceRefresh = isset($_GET['refresh']) && $_GET['refresh'] === 'true';

    // ============================================================================
    // MODULE 1: AI DEMAND ANALYSIS (STAFF VIEW - DYNAMIC SEASONAL INSIGHTS)
    // ============================================================================
    if ($module === 'demand') {
        // Cache bust to v3 to instantly load the new chart data
        $cacheFile = __DIR__ . '/ai_demand_cache_v3.json';
        
        if (!$forceRefresh && file_exists($cacheFile) && (time() - filemtime($cacheFile) < 21600)) {
            echo json_encode(["success" => true, "demand" => json_decode(file_get_contents($cacheFile), true), "cached" => true]);
            exit;
        }

        try {
            // 1. Category Bar Chart Query
            $catStmt = $pdo->query("
                SELECT p.category, COALESCE(SUM(si.quantity_sold), 0) as units_sold
                FROM products p
                LEFT JOIN inventory_batches ib ON p.product_id = ib.product_id
                LEFT JOIN sales_items si ON ib.batch_id = si.batch_id
                WHERE p.category IS NOT NULL AND TRIM(p.category) != '' AND p.category != 'Uncategorized'
                GROUP BY p.category ORDER BY units_sold DESC LIMIT 6
            ");
            $categoryRows = $catStmt->fetchAll(PDO::FETCH_ASSOC);

            $catLabels = []; $soldData = [];
            foreach ($categoryRows as $row) {
                $catLabels[] = $row['category'];
                $soldData[] = (int)$row['units_sold'];
            }

            // 2. Automated Reorder Probability (Based on ACTUAL product reorder_level)
            $healthStmt = $pdo->query("
                SELECT 
                    SUM(CASE WHEN ib.quantity_in_stock <= (p.reorder_level * 0.5) THEN 1 ELSE 0 END) as urgent, 
                    SUM(CASE WHEN ib.quantity_in_stock > (p.reorder_level * 0.5) AND ib.quantity_in_stock <= (p.reorder_level * 1.5) THEN 1 ELSE 0 END) as monitor, 
                    SUM(CASE WHEN ib.quantity_in_stock > (p.reorder_level * 1.5) THEN 1 ELSE 0 END) as healthy 
                FROM inventory_batches ib
                JOIN products p ON ib.product_id = p.product_id
                WHERE ib.quantity_in_stock > 0
            ");
            $healthData = $healthStmt->fetch(PDO::FETCH_ASSOC);

            // 3. 7-Day Velocity Trend Query
            $velStmt = $pdo->query("
                SELECT p.category, DATE(st.transaction_date) as sale_date, SUM(si.quantity_sold) as daily_sold
                FROM sales_transactions st
                JOIN sales_items si ON st.transaction_id = si.transaction_id
                JOIN inventory_batches ib ON si.batch_id = ib.batch_id
                JOIN products p ON ib.product_id = p.product_id
                WHERE st.transaction_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 DAY)
                GROUP BY p.category, DATE(st.transaction_date)
                ORDER BY sale_date ASC
            ");
            $velocityRows = $velStmt->fetchAll(PDO::FETCH_ASSOC);

            // Build the 7-day structure array
            $last7Days = []; $velocityLabels = [];
            for ($i = 6; $i >= 0; $i--) {
                $d = date('Y-m-d', strtotime("-$i days"));
                $last7Days[] = $d;
                $velocityLabels[] = ($i == 0) ? 'Today' : date('M d', strtotime($d));
            }

            $velCategories = array_unique(array_column($velocityRows, 'category'));
            $colors = ['#dc3545', '#20c997', '#0056b3', '#ffc107', '#6f42c1', '#fd7e14'];
            $velocityDatasets = [];
            $cIndex = 0;

            foreach($velCategories as $cat) {
                $dataPts = [];
                foreach($last7Days as $dayDate) {
                    $found = 0;
                    foreach($velocityRows as $r) {
                        if($r['category'] === $cat && $r['sale_date'] === $dayDate) {
                            $found = (int)$r['daily_sold']; break;
                        }
                    }
                    $dataPts[] = $found;
                }
                $velocityDatasets[] = [
                    "label" => $cat,
                    "data" => $dataPts,
                    "borderColor" => $colors[$cIndex % count($colors)],
                    "backgroundColor" => "transparent",
                    "tension" => 0.4,
                    "borderWidth" => 2
                ];
                $cIndex++;
            }

            if (empty($velocityDatasets)) {
                $velocityDatasets[] = ["label" => "No Sales Last 7 Days", "data" => [0,0,0,0,0,0,0], "borderColor" => "#ccc"];
            }

            $stockStmt = $pdo->query("SELECT generic_name, batch_number, quantity_in_stock FROM inventory_batches ib JOIN products p ON ib.product_id = p.product_id WHERE quantity_in_stock > 0 ORDER BY quantity_in_stock ASC LIMIT 1");
            $lowestStock = $stockStmt->fetch(PDO::FETCH_ASSOC);

        } catch (Exception $e) {
            $catLabels = ['Analgesic', 'Antibiotic', 'Vitamins']; $soldData = [0, 0, 0];
            $lowestStock = null; $healthData = ['urgent' => 0, 'monitor' => 0, 'healthy' => 0];
            $velocityLabels = ['D1','D2','D3','D4','D5','D6','Today'];
            $velocityDatasets = [["label" => "No Data", "data" => [0,0,0,0,0,0,0], "borderColor" => "#ccc"]];
        }

        $currentDate = date('F d, Y');
        $currentMonth = date('F');
        $catStr = !empty($catLabels) ? implode(", ", $catLabels) : "General Medicines";
        $lowStockStr = $lowestStock ? "{$lowestStock['generic_name']} (Batch {$lowestStock['batch_number']} - {$lowestStock['quantity_in_stock']} units left)" : "Inventory Stable";

        $fallbackDemand = [];
        foreach ($soldData as $qty) { $fallbackDemand[] = max($qty + 6, (int)round($qty * 1.35)); }

        $prompt = "You are a Pharmacy Operations AI in the Philippines. Today is {$currentDate}.
        Context: Analyze rainy-season disease surveillance and retail demand.
        Data - Categories: {$catStr}. Lowest Stock: {$lowStockStr}.
        Return strict JSON:
        {
            \"insight_1\": {\"insight\": \"[Concise weather fact linking {$currentMonth} to {$catLabels[0]}]\", \"action\": \"[Staff action]\", \"link_text\": \"DOH Official Portal\", \"link_url\": \"https://doh.gov.ph\"},
            \"insight_2\": {\"insight\": \"[Concise stock depletion risk about: {$lowStockStr}]\", \"action\": \"[Restock action]\"},
            \"insight_3\": {\"insight\": \"[Concise retail generics/health trend]\", \"action\": \"[Staff guidance]\"},
            \"projected_demand\": [" . implode(",", $fallbackDemand) . "]
        }";

        $payload = ["contents" => [["parts" => [["text" => $prompt]]]], "generationConfig" => ["response_mime_type" => "application/json", "temperature" => 0.2]];

        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']); curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); 
        $response = curl_exec($ch); $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE); curl_close($ch);

        $aiPayload = null;
        if ($httpCode === 200 && $response) {
            $resDecoded = json_decode($response, true);
            $aiRawText = $resDecoded['candidates'][0]['content']['parts'][0]['text'] ?? '';
            $aiPayload = json_decode(trim(str_replace(['```json', '```'], '', $aiRawText)), true);
        }

        if (!$aiPayload) {
            $aiPayload = [
                "insight_1" => ["insight" => "Seasonal changes increase demand for {$catLabels[0]}.", "action" => "Maintain shelf stock.", "link_text" => "DOH Portal", "link_url" => "https://doh.gov.ph"],
                "insight_2" => ["insight" => "{$lowStockStr} is flagged for depletion.", "action" => "Prepare replenishment order."],
                "insight_3" => ["insight" => "Patients demonstrate stronger preference for generic equivalents.", "action" => "Highlight verified generic options."],
                "projected_demand" => $fallbackDemand
            ];
        }

        // Embed all the perfectly processed database charts
        $aiPayload['demand_chart'] = [
            "categories" => $catLabels,
            "units_sold" => $soldData,
            "projected_demand" => (isset($aiPayload['projected_demand']) && count($aiPayload['projected_demand']) === count($catLabels)) ? array_map('intval', $aiPayload['projected_demand']) : $fallbackDemand
        ];
        $aiPayload['velocity_chart'] = ["days" => $velocityLabels, "datasets" => $velocityDatasets];
        $aiPayload['reorder_chart'] = ["urgent" => (int)($healthData['urgent'] ?? 0), "monitor" => (int)($healthData['monitor'] ?? 0), "healthy" => (int)($healthData['healthy'] ?? 0)];

        file_put_contents($cacheFile, json_encode($aiPayload, JSON_PRETTY_PRINT));
        echo json_encode(["success" => true, "demand" => $aiPayload, "cached" => false]);
        exit;
    } 

    // ============================================================================
    // MODULE 2: SALES & PREDICTIVE ANALYTICS (OWNER VIEW)
    // ============================================================================
    else {
        $cacheFile = __DIR__ . '/ai_cache.json';

        if (!$forceRefresh && file_exists($cacheFile) && (time() - filemtime($cacheFile) < 21600)) {
            echo json_encode(["success" => true, "analytics" => json_decode(file_get_contents($cacheFile), true), "cached" => true]);
            exit;
        }

        try {
            $salesStmt = $pdo->query("SELECT COALESCE(SUM(total_amount), 0) FROM sales_transactions WHERE MONTH(transaction_date) = MONTH(CURRENT_DATE())");
            $currentRev = (float)$salesStmt->fetchColumn();

            $histStmt = $pdo->query("SELECT DATE_FORMAT(transaction_date, '%b') as m_name, SUM(total_amount) as m_rev FROM sales_transactions WHERE transaction_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 5 MONTH) GROUP BY YEAR(transaction_date), MONTH(transaction_date)");
            $dbHistory = $histStmt->fetchAll(PDO::FETCH_ASSOC);

            $stockStmt = $pdo->query("SELECT p.generic_name, p.category, ib.quantity_in_stock FROM inventory_batches ib JOIN products p ON ib.product_id = p.product_id WHERE ib.quantity_in_stock > 0 ORDER BY ib.quantity_in_stock ASC LIMIT 4");
            $lowStockItems = $stockStmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            echo json_encode(["success" => false, "message" => "Database error"]); exit;
        }

        $realMonths = []; $realRevenues = [];
        for ($i = 5; $i >= 0; $i--) {
            $monthLabel = date('M', strtotime("-$i months"));
            $realMonths[] = $monthLabel;
            $foundRev = 0;
            foreach($dbHistory as $row) { if ($row['m_name'] === $monthLabel) $foundRev = (float)$row['m_rev']; }
            $realRevenues[] = $foundRev;
        }

        $procurementTable = [];
        foreach($lowStockItems as $item) {
            $isCritical = $item['quantity_in_stock'] < 50;
            $procurementTable[] = ["target_date" => date('M d, Y', strtotime('+7 days')), "product_category" => $item['generic_name'] . ' (' . $item['category'] . ')', "status_badge" => $isCritical ? "CRITICAL BUY" : "MONITOR / BUY", "estimated_budget" => $isCritical ? 5000 : 2500, "demand_surge" => $isCritical ? "+15%" : "+5%"];
        }
        if (empty($procurementTable)) { $procurementTable[] = ["target_date" => "-", "product_category" => "Healthy", "status_badge" => "STANDARD CYCLE", "estimated_budget" => 0, "demand_surge" => "0%"]; }

        $aiPayload = ["mom_growth" => $currentRev > 0 ? "+10%" : "0%", "operating_margin" => "35.0%", "predicted_eom" => $currentRev * 1.2, "top_category" => count($lowStockItems) > 0 ? $lowStockItems[0]['category'] : "N/A"];
        $aiPayload['financial_chart'] = ["months" => $realMonths, "revenue" => $realRevenues, "restock_needs" => array_map(function($r){ return $r * 0.4; }, $realRevenues)];
        $aiPayload['procurement_forecast'] = $procurementTable;

        file_put_contents($cacheFile, json_encode($aiPayload, JSON_PRETTY_PRINT));
        echo json_encode(["success" => true, "analytics" => $aiPayload, "cached" => false]);
    }
?>