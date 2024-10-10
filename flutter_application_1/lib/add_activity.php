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
$id = isset($_POST['id']) ? $_POST['id'] : '';
$activity_name = isset($_POST['name']) ? $_POST['name'] : null;
$description = isset($_POST['note']) ? $_POST['note'] : null;
$activity_date = isset($_POST['dateTime']) ? $_POST['dateTime'] : null;

// Array to hold missing fields
$missingFields = [];

if ($activity_name === null || $activity_name === '') $missingFields[] = "name";
if ($description === null || $description === '') $missingFields[] = "note";
if ($activity_date === null || $activity_date === '') $missingFields[] = "dateTime";

if (!empty($missingFields)) {
    echo json_encode([
        "status" => "error",
        "message" => "Error: Missing data",
        "missing_fields" => $missingFields
    ]);
    exit();
}

// Determine whether to add or update the activity
if ($id !== null && $id !== '') {
    // Record exists, update it
    $update = "UPDATE activities SET activity_name = ?, description = ?, activity_date = ? WHERE id = ?";
    $stmt = mysqli_prepare($db, $update);
    mysqli_stmt_bind_param($stmt, 'sssi', $activity_name, $description, $activity_date, $id);
    if (mysqli_stmt_execute($stmt)) {
        echo json_encode(["status" => "success", "message" => "Record updated successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error updating record: " . mysqli_error($db)]);
    }
} else {
    // Record does not exist, insert it
    $insert = "INSERT INTO activities (activity_name, description, activity_date) VALUES (?, ?, ?)";
    $stmt = mysqli_prepare($db, $insert);
    mysqli_stmt_bind_param($stmt, 'sss', $activity_name, $description, $activity_date);
    if (mysqli_stmt_execute($stmt)) {
        echo json_encode(["status" => "success", "message" => "Record added successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error adding record: " . mysqli_error($db)]);
    }
}

// Close statement and connection
mysqli_stmt_close($stmt);
mysqli_close($db);
?>
