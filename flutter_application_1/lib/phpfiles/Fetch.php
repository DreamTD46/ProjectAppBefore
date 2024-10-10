<?php
$db = mysqli_connect('localhost', 'root', '', 'userdata');

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header('Content-Type: application/json');

if (!$db) {
    echo json_encode(["status" => "error", "message" => "Database connection failed"]);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $activity_name = $_POST['name'] ?? '';
    $description = $_POST['note'] ?? '';
    $activity_date = $_POST['dateTime'] ?? '';
    $activity_time = $_POST['dateTime'] ?? '';

    if (!empty($activity_name) && !empty($activity_date)) {
        $sql = "INSERT INTO activities (activity_name, description, activity_date,activity_time)
                VALUES ('$activity_name', '$description', '$activity_date, '$activity_time')";

        if (mysqli_query($db, $sql)) {
            echo json_encode("Success");
        } else {
            echo json_encode("Error: " . mysqli_error($db));
        }
    } else {
        echo json_encode("Error: Missing required fields");
    }
} else {
    $sql = "SELECT * FROM activities";
    $result = mysqli_query($db, $sql);

    $activities = [];

    if ($result && mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_assoc($result)) {
            $activities[] = [
                'id' => $row['id'],
                'activity_name' => $row['activity_name'],
                'description' => $row['description'],
                'activity_date' => $row['activity_date'],
                'activity_time' => $row['activity_time'],
            ];
        }

        echo json_encode(['status' => 'success', 'activities' => $activities]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'No activities found']);
    }
}
?>
