<?php

require './config.php';

if (!mysql_connect($db_host, $db_user, $db_pwd))
    die("Can't connect to database");

if (!mysql_select_db($database))
    die("Can't select database");


 
$sql2 = "SELECT fbid,name,time,score from player_info order by score DESC limit 5;";



// sending query
$result = mysql_query($sql2);
if (!$result) {
    die("Query to show fields from table failed");
}

$i = 0;

while ($line = mysql_fetch_array($result, MYSQL_ASSOC)) {
            $getID[$i] = $line['fbid'];
            $getName[$i] = $line['name'];
            $getTime[$i] = $line['time'];
            $getScore[$i] = $line['score'];
            $i++;
}


        $response['fbid'] = $getID;
        $response['name'] = $getName;
        $response['time'] = $getTime;
        $response['score'] = $getScore;

        echo json_encode($response);

