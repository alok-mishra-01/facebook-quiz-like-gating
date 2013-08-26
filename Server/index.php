<?php

/* 
First version:
Alok Mishra
June 2013

This is a working version of a facebook quiz. Done for a client who wanted:
- A quiz on his facebook page
- A player can play only if he 'likes' the page
- Integrated with the latest facebook PHP API. Also has the facility to post on his wall
- Rich graphics, hence flash was used. It also stores the high scores of players
  with a complete dynamic leaderboard at the end of the quiz.

Quizes like this are high in demand for social media marketing these days.

Anyone having a similar requirement should look no further and can just use this project.

*/

require './config.php';
require './facebook.php';

//Create facebook application instance.
$facebook = new Facebook(array(
  'appId'  => $fb_app_id,
  'secret' => $fb_secret,
  'cookie' => true,
));


$userData = null;

$user = $facebook->getUser();

//redirect to facebook page
if(isset($_GET['code'])){
	if($fb_auto_post && $user){
		$msg = array(
			'message' => 'I started using ' . $fb_app_url
		);
		$facebook->api('/me/feed', 'POST', $msg);
	}

	header("Location: " . $fb_app_url);
	exit;
}

if ($user) {
	//get user data
	try {
		$userData = $facebook->api('/me');
	} catch (FacebookApiException $e) {
		 $loc = $this->fb_login_url(); redirect($loc);
	}
	  	$fquery = "SELECT uid,name FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me())";

		$friends = $facebook->api(array(
			'method' => 'fql.query',
			'query' => $fquery,
		));	
	
       

} else {
	$loginUrl = $facebook->getLoginUrl(array(
		'canvas' => 1,
		'fbconnect' => 0,
        'scope' => 'publish_actions,email',
        'redirect_uri' => $fb_app_url,
	));

	if($fb_auto_redirect){
		header("Location: " . $loginUrl);
		exit;
	}
}

?>
<!DOCTYPE html 
	PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="et" lang="en">
	<head>
		<title>Quiz</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<style type="text/css">
			body { font-family:Verdana,"Lucida Grande",Lucida,sans-serif; font-size: 12px}
.imgA1 { position:absolute; top: 25px; left: 25px; z-index: 1; } 	
.imgB1 {
     width: 48px;
     overflow: hidden;
     left: 620px;
     position: absolute;
     top: 509px;
     z-index: 3;
}

html {
    overflow: hidden;
}

body {
    width: 808px;
    margin: 0;
    padding: 0;
    overflow-x: hidden;
    padding-bottom: 20px;
}


		</style>
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js"></script>
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js"></script>
	</head>
	<body>
    <div id="fb-root"></div>
	<script src="//connect.facebook.net/en_US/all.js"></script>
    <script type="text/javascript">


FB.init({
appId      : '<?php echo $fb_app_id; ?>',
channelUrl : '//<?php echo $_SERVER["HTTP_HOST"]; ?>/channel.html', // Channel File
status     : true, // check login status
cookie     : true, // enable cookies to allow the server to access the session
xfbml      : true  // parse XFBML
});  
	  


    function sendRequest(msg) {
      FB.ui({method: 'apprequests',
        message: msg
      }, function(response) {
		   });
    }

    //JS api to post on the user's wall
	function sendfeed(nam)
	{
		 FB.ui(
		   {
		     method: 'feed',
		     name: nam,
		     link: '',
		     picture: '',
		     caption: 'Earn daily prizes, Play the quiz now!',
		     actions: [{"name":'Play Quiz!',"link":''}],
		     description: ""
		   },
		   function(response) {
		   }
		 );
	}


function sendEmail()
{
	var email = '<?php if (isset($userData)): echo $userData['email']; else: echo "a@b.com"; endif; ?>';
      var swf = swfobject.getObjectById("EQ");
      swf.getEmail(email);
}


function sendName()
{
	var nam = '<?php if (isset($userData)): echo $userData['first_name']; else: echo "John Doe"; endif; ?>';
      var swf = swfobject.getObjectById("EQ");
      swf.getName(nam);
}


function sendFBid()
{
	var fid = '<?php if (isset($user)): echo $user; else: echo "00000"; endif; ?>';
      var swf = swfobject.getObjectById("EQ");
      swf.getFBid(fid);  
}

function sendProt()
{
      var ur = location.protocol;
      var swf = swfobject.getObjectById("EQ");
      swf.getProt(ur);  
}


FB.Event.subscribe('edge.create',
    function(href, widget) {
		top.window.location ='<?php if (isset($fb_app_url)): echo $fb_app_url; else: echo "config not set"; endif; ?>';
    }
);

    </script>		
			<?php  
			
			function parsePageSignedRequest() {
    if (isset($_REQUEST['signed_request'])) {
      $encoded_sig = null;
      $payload = null;
      list($encoded_sig, $payload) = explode('.', $_REQUEST['signed_request'], 2);
      $sig = base64_decode(strtr($encoded_sig, '-_', '+/'));
      $data = json_decode(base64_decode(strtr($payload, '-_', '+/'), true));
      return $data;
    }
    return false;
  }
			
			//Here we show the quiz only to people who liked our page
			if($signed_request = parsePageSignedRequest()) {
    if($signed_request->page->liked) {  
	  			if ($user){ ?>
        <script type="text/javascript">
        var flashvars = {};
        var parameters = {};
        parameters.wmode = 'opaque';
        var attributes = {};
        //Put your own values and swf link here
        swfobject.embedSWF('Quiz.swf?v=1', 'EQ', '810', '612', '9.0.0', false, flashvars, parameters, attributes);


</script>

        <div id='EQ'>
        <p>This page requires Adobe Flash Player, which you can download free at <a href="http://get.adobe.com/flashplayer/">http://get.adobe.com/flashplayer/</a></p>
        </div>
			<?php } else {  ?>
              <script type="text/javascript">
                  var url = "<?php echo $loginUrl; ?>";
              top.window.location = url;
              </script>
			<?php } 
	  
	  
    } else {
	  ?>
	  <img class="imgA1" src="without_like.jpg">
	<div class="imgB1">
	<fb:like href='<?php if (isset($fb_page_url)): echo $fb_page_url; else: echo "config not set"; endif; ?>' send="false" width="450" show_faces="false"></fb:like>	
	</div>
		  <?php
    }
  }
			?>
			

			
	</body>
</html>
