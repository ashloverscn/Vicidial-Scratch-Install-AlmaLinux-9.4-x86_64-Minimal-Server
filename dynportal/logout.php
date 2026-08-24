<?php
# logout.php - Minimal VICIdial Portal Session Cleaner

session_start();
$_SESSION = array();

if (ini_get("session.use_cookies")) {
    $params = session_get_cookie_params();
    setcookie(session_name(), '', time() - 42000,
        $params["path"], $params["domain"],
        $params["secure"], $params["httponly"]
    );
}

session_destroy();

// Grab the current host and custom port (e.g., 192.168.29.203:446)
$host = $_SERVER['HTTP_HOST'];

// Redirect explicitly to the dynportal directory
header("Location: https://$host/dynportal/valid8.php");
exit();
?>