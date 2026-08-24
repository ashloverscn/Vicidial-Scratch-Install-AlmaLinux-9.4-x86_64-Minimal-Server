<?php
# logout.php - VICIdial Portal Session Cleaner & IP Removal

session_start();
$_SESSION = array();

if (ini_get("session.use_cookies")) {
    $params = session_get_cookie_params();
    setcookie(session_name(), '', time() - 42000,
        $params["path"], $params["domain"],
        $params["secure"], $params["httponly"]
    );
}

// Remove the client's current IP address from the firewall dynamiclist
$remoteip = $_SERVER['REMOTE_ADDR'];
if (!empty($remoteip)) {
    $SHELL_cmd = '/usr/bin/firewall-cmd --ipset=dynamiclist --remove-entry=' . escapeshellarg($remoteip) . ' 2>&1';
    shell_exec($SHELL_cmd);
}

session_destroy();

// Grab the current host and custom port (e.g., 192.168.29.203:446)
$host = $_SERVER['HTTP_HOST'];
$clean_host = preg_replace('/:\d+/', '', $host);

// Redirect explicitly to the dynportal directory
header("Location: https://$clean_host:446/valid8.php");
exit();
?>
