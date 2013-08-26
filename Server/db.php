<?php

require './config.php';



if (!mysql_connect($db_host, $db_user, $db_pwd))
    die("Can't connect to database");

if (!mysql_select_db($database))
    die("Can't select database");





$sql = "INSERT INTO `player_info`
(fbid,email,name,time,questions,score) 
VALUES
('".$_POST['fbid']."', '".$_POST['email']."', '".$_POST['name']."',
'".$_POST['time']."', ".$_POST['correct'].", ".$_POST['score'].")
ON DUPLICATE KEY UPDATE time = CASE WHEN ".$_POST['score']." > score THEN '".$_POST['time']."' ELSE time END,
questions = CASE WHEN ".$_POST['score']." > score THEN ".$_POST['correct']." ELSE questions END, score = CASE
WHEN ".$_POST['score']." > score THEN ".$_POST['score']." ELSE score END;";




// sending query
$result = mysql_query($sql);
if (!$result) {
    die("Query to show fields from table failed");
}


//Here we send back a variable to AS3:
//Can be read in CompleteHandler with vars.success
if($result) echo('success=true');
else echo('success=false');

