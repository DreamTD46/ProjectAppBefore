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

// Get the ID from POST request
$id = isset($_POST['id']) ? $_POST['id'] : null;

if ($id === null) {
    echo json_encode(["status" => "error", "message" => "Error: Missing data"]);
    mysqli_close($db);
    exit();
}

// Check if the record exists
$sql = "SELECT id FROM activities WHERE id = ?";
$stmt = mysqli_prepare($db, $sql);
if ($stmt === false) {
    echo json_encode(["status" => "error", "message" => "Failed to prepare SELECT statement"]);
    mysqli_close($db);
    exit();
}

mysqli_stmt_bind_param($stmt, 'i', $id);
mysqli_stmt_execute($stmt);
mysqli_stmt_store_result($stmt);

if (mysqli_stmt_num_rows($stmt) == 1) {
    // Record exists, prepare delete statement
    $delete = "DELETE FROM activities WHERE id = ?";
    $stmt = mysqli_prepare($db, $delete);
    if ($stmt === false) {
        echo json_encode(["status" => "error", "message" => "Failed to prepare DELETE statement"]);
        mysqli_close($db);
        exit();
    }

    mysqli_stmt_bind_param($stmt, 'i', $id);
    if (mysqli_stmt_execute($stmt)) {
        echo json_encode(["status" => "success", "message" => "Record deleted successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error deleting record: " . mysqli_error($db)]);
    }
} else {
    // Record does not exist
    echo json_encode(["status" => "error", "message" => "Error: Record not found"]);
}

// Close statement and connection
mysqli_stmt_close($stmt);
mysqli_close($db);
?>
