<?php
// Connect to the database
$db = mysqli_connect('localhost', 'root', '', 'userdata');

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');

// Check connection
if (!$db) {
    echo json_encode(["status" => "error", "message" => "Database connection failed"]);
    exit();
}

// Retrieve POST data and validate
$id = isset($_POST['id']) ? $_POST['id'] : null;
$activity_name = isset($_POST['name']) ? $_POST['name'] : null;
$description = isset($_POST['note']) ? $_POST['note'] : null;
$activity_date = isset($_POST['dateTime']) ? $_POST['dateTime'] : null;

// Array to hold missing fields
$missingFields = [];

if ($id === null) $missingFields[] = "id";
if ($activity_name === null) $missingFields[] = "name";
if ($description === null) $missingFields[] = "note";
if ($activity_date === null) $missingFields[] = "dateTime";

if (!empty($missingFields)) {
    echo json_encode([
        "status" => "error",
        "message" => "Error: Missing data",
        "missing_fields" => $missingFields
    ]);
    exit();
}

// Check if the record exists
$sql = "SELECT id FROM activities WHERE id = ?";
$stmt = mysqli_prepare($db, $sql);
mysqli_stmt_bind_param($stmt, 'i', $id);
mysqli_stmt_execute($stmt);
mysqli_stmt_store_result($stmt);

if (mysqli_stmt_num_rows($stmt) == 1) {
    // Record exists, update it
    $update = "UPDATE activities SET activity_name = ?, description = ?, activity_date = ? WHERE id = ?";
    $stmt = mysqli_prepare($db, $update);
    mysqli_stmt_bind_param($stmt, 'sssi', $activity_name, $description, $activity_date, $id);
    if (mysqli_stmt_execute($stmt)) {
        echo json_encode(["status" => "success", "message" => "Record updated successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error updating record"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Record not found"]);
}

// Close statement and connection
mysqli_stmt_close($stmt);
mysqli_close($db);
?>
