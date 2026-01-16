<?php
$servername = "localhost"; // Nome del server MySQL
$username = "dbuser"; // Nome utente
$password = "password"; // Password dell'utente
$dbname = "mydb"; // Nome del database

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connessione fallita: " . $conn->connect_error);
}

$sql = "SELECT id, content FROM posts";
$result = $conn->query($sql);

echo "<!DOCTYPE html>
<html lang='it'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>Lista Post</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
    </style>
</head>
<body>
    <h1>Lista Post</h1>";

if ($result->num_rows > 0) {
    // Se ci sono dei post, mostrali in una tabella
    echo "<table>
            <tr>
                <th>ID</th>
                <th>Contenuto del Post</th>
            </tr>";
    
    while($row = $result->fetch_assoc()) {
        echo "<tr>
                <td>" . $row["id"] . "</td>
                <td>" . $row["content"] . "</td>
              </tr>";
    }
    
    echo "</table>";
} else {
    echo "<p>Non ci sono post da visualizzare.</p>";
}

$conn->close();

echo "</body>
</html>";
?>