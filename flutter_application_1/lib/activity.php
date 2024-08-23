<?php
// เชื่อมต่อกับฐานข้อมูล
$db = mysqli_connect('localhost', 'root', '', 'userdata');

// ตั้งค่าหัวข้อ HTTP ให้สามารถรับการร้องขอจากที่มาหลายแหล่ง
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header('Content-Type: application/json');

// ตรวจสอบการเชื่อมต่อฐานข้อมูล
if (!$db) {
    echo json_encode(["status" => "error", "message" => "Database connection failed"]);
    exit;
}

// ตรวจสอบว่ามีการร้องขอ GET หรือไม่
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // คำสั่ง SQL เพื่อดึงข้อมูลกิจกรรมทั้งหมด
    $sql = "SELECT * FROM activities";
    $result = mysqli_query($db, $sql);

    $activities = [];

    // ตรวจสอบว่ามีข้อมูลหรือไม่
    if ($result && mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_assoc($result)) {
            $activities[] = [
                'id' => $row['id'],
                'activity_name' => $row['activity_name'],
                'description' => $row['description'],
                'activity_date' => $row['activity_date'],
            ];
        }

        echo json_encode(['status' => 'success', 'activities' => $activities]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'No activities found']);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}

mysqli_close($db);
?>
