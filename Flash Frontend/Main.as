package  {
	import flash.display.SimpleButton;
	import flash.display.Sprite;
    import flash.events.*;
    import flash.net.*;
	import flash.display.*;
	import com.greensock.*;	
	import com.greensock.easing.*;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import com.adobe.serialization.json.*;
	
	
	public class Main extends Sprite 
	{
		public var hold:MovieClip;
		public var main:MovieClip;
		public var Q:Array;
		public var quizQ:int = 5;
		public var showexit:Boolean = false;
		public var correctans:int;
		public var endshow:MovieClip;
		public var totalcorrect:int;
		public var feedback:MovieClip;
		public var ans:Array;
		var mins:int, secs:int, milli:int;
		var timee:MovieClip = Quiz.getAssetClass("Timee");
		var timeend:Boolean = false;
		public var leadingZeroSeconds:String;
		public var leadingZeroMiliseconds:String;
		public var startTime:int;
		public var timeDifference:int = 0;
		public var score:Number;
		public static var email:String;
		public static var name:String;
		public static var fbid:String;
		public var local:Boolean = false;
		public var fbids:Array;
		public var names:Array;
		public var times:Array;
		public var scores:Array;
		public var welcome:MovieClip;
		var pic1:Loader, pic2:Loader, pic3:Loader, pic4:Loader, pic5:Loader;
		var index:int = -1;
		var m_prevTime:int = 0;
		var indexans:int = -1;
		
		public function Main():void 
		{
			if (ExternalInterface.available) 
			{
				try 
				{
					ExternalInterface.addCallback("getFBid", putFBid);
					ExternalInterface.addCallback("getEmail", putEmail);
					ExternalInterface.addCallback("getName", putName);
					
					ExternalInterface.call("sendFBid");
					ExternalInterface.call("sendName");
					ExternalInterface.call("sendEmail");
				} catch (error:SecurityError) 
				{
					
				} catch (error:Error) 
				{
					trace("trying extinterface er" + error.message);
					local = true;
				}
			}
			else
			{
				trace("running locally");
			}
		}
		
		public function Welcome():void
		{
	  		welcome = Quiz.getAssetClass("MainBG");
			this.addChild(welcome);
			welcome.x = Quiz.thestage.stageWidth / 2;
			welcome.y = Quiz.thestage.stageHeight / 2;
			(welcome.getChildByName("playButton") as SimpleButton).addEventListener(MouseEvent.CLICK, startIt);
		}		
		
		public function startIt(e:MouseEvent):void
		{
			if (welcome != null && this.contains(welcome))
			{
				this.removeChild(welcome);
			}
			Init();
		}
		
		public function Init():void
		{
			quizQ = 5;
			m_prevTime = 0;
			correctans = 10;
			totalcorrect = 0;
			showexit = false;
			main = null;
			hold = null;
			names = null;
			fbids = null;
			times = null;
			scores = null;
			endshow = null;
			feedback = null;
			timeend = false;
			startTime = 0;
			timeDifference = 0;
			pic1 = null;
			pic2 = null;
			pic3 = null;
			pic4 = null;
			pic5 = null;
			main = Quiz.getAssetClass("How");
			this.addChild(main);
			main.x = Quiz.thestage.stageWidth / 2;
			main.y = Quiz.thestage.stageHeight / 2;
			(main.getChildByName("next") as SimpleButton).addEventListener(MouseEvent.CLICK, startFade);
			if (local == false)
			{
				getTopScores();
			}			
		}
		
		public function getTopScores()
		{
			var variables:URLVariables = new URLVariables();
			var urlloader:URLLoader = new URLLoader;
			if (Quiz.sec == true)
			{
				var urlrequest:URLRequest = new URLRequest(GameConfig.httpspathtodb2dotphp);
			}
			else
			{
				var urlrequest:URLRequest = new URLRequest(GameConfig.httppathtodb2dotphp);
			}
			urlrequest.method = URLRequestMethod.POST;
			urlrequest.data = variables;         
			urlloader.load(urlrequest);
			urlloader.addEventListener(Event.COMPLETE, CompleteHandler2, false, 0, true);
			urlloader.addEventListener(IOErrorEvent.IO_ERROR , ErrorHandler, false, 0, true);
		}

		private function CompleteHandler2(e:Event) {
			//Received Variables from PHP script
			fbids = new Array();
			times = new Array();
			names = new Array();
			scores = new Array();
			trace("[" + e.target.data + "]");
			var t:Array = new Array();
			var t:Array = JSON.decode("[" + e.target.data + "]");
			for each(var h:Object in t)
			{
				fbids = h.fbid;
				names = h.name;
				times = h.time;
				scores = h.score;
			}

		}
		
		public function startFade(e:MouseEvent):void
		{
			TweenMax.to(main, 1, { blurFilter: { blurX:80, blurY:80, quality:3 }, ease:Quad.easeInOut, onComplete:startQuiz });
		}
		
		public function startQuiz():void
		{
			if (main != null && this.contains(main))
			{
				this.removeChild(main);
			}
			main = null;
			get5Q();
			startTimer();
			rotateIt();
		}
		
		public function rotateIt():void
		{
			if (quizQ >= 1)
			{
				--quizQ;
				nextQ();
			}			
		}
		
		public function putEmail(myFlashVar:String)
		{		
			if (myFlashVar != null)
			{
				email = myFlashVar;
			}
		}
		
		public function putFBid(myFlashVar:String)
		{		
			if (myFlashVar != null)
			{
				fbid = myFlashVar;
			}
		}
		
		public function putName(myFlashVar:String)
		{		
			if (myFlashVar != null)
			{
				name = myFlashVar;
			}
		}		
		
		
		public function startTimer():void
		{
			trace("startit");
			m_prevTime = getTimer();
			this.addEventListener(Event.ENTER_FRAME,showtime, false, 0, true);
		}		
		
		public function showtime(e:Event)
		{
			if (this.contains(timee))
			{
			  var currTime:int = getTimer();
			  timeDifference += currTime - m_prevTime;
			  m_prevTime = currTime;
			  //timeDifference = getTimer() - startTime;
			  milli = (timeDifference % 1000);

			  /* figure out if miliseconds needs a leading zero so .001 displays as .001 and not .1 */
			  if (milli < 100) {
				leadingZeroMiliseconds = "0";
			  } else if (milli < 10) {
				leadingZeroMiliseconds = "00";
			  } else {
				leadingZeroMiliseconds = "";
			  }
			  /* divide by 1,000 and mod by 60 to cut off the minutes to give you seconds*/
			  secs = Math.floor( (timeDifference/1000) % 60);

			  /* if time is less than 10 set leading zero to zero. otherwise leave it blank */
			  if (secs < 10) {
				leadingZeroSeconds = "0";
			  } else {
				leadingZeroSeconds = "";
			  }
			  /* divide by 60,000 and round down to get minutes  */
			  mins = Math.floor( (timeDifference/60000) );
		 
			  /* to see what the formatted time would look like */
			  (timee.getChildByName("time") as TextField).text = mins + ":" + leadingZeroSeconds + secs + "." + leadingZeroMiliseconds + milli;
			}			
		
		}
		
		public function nextQ():void
		{
				if (ans !=  null)
				{
					ans.length = 0;
				}
				if (quizQ == 0)
				{
					showexit = true;
				}
			
				hold = Quiz.getAssetClass("QuestionBG1");
				this.addChild(hold);
				hold.x = Quiz.thestage.stageWidth / 2;
				hold.y = Quiz.thestage.stageHeight / 2;
				(hold.getChildByName("hint") as SimpleButton).addEventListener(MouseEvent.CLICK, opentwin);
				if (!this.contains(timee))
				{
					this.addChild(timee);
					timee.x = Quiz.thestage.stageWidth / 2;
					timee.y = Quiz.thestage.stageHeight / 2;
				}				
				var currentQ:int = Q[(Q.length -1)];
				Q.pop();
				indexans = currentQ;
				if (currentQ == 9) //the big ones
				{
					
					(hold.getChildByName("optiona") as SimpleButton).visible = false;
					(hold.getChildByName("optionatxt") as TextField).visible = false;
					
					(hold.getChildByName("optionb") as SimpleButton).visible = false;
					(hold.getChildByName("optionbtxt") as TextField).visible = false;					
										
					
					(hold.getChildByName("question") as TextField).text = GameConfig.questions[currentQ];
					(hold.getChildByName("questionno") as TextField).text = "Question " + ((4 - quizQ) + 1) + " of 5";
					ans = (GameConfig.answers[currentQ] as String).split(";");
					var s:String = ans[0];
					ans.sort( randomize );
					correctans = ans.indexOf(s);					
					
					(hold.getChildByName("largea") as TextField).text = "A)   " + ans[0];
					(hold.getChildByName("largea") as TextField).mouseEnabled = false;
					(hold.getChildByName("optionxa") as SimpleButton).addEventListener(MouseEvent.CLICK, addArguments(showans, 0));
					(hold.getChildByName("optionxa") as SimpleButton).addEventListener(MouseEvent.MOUSE_OVER, addArguments2(enlargecaptainpanel, (hold.getChildByName("largea") as TextField),(hold.getChildByName("optionxa") as SimpleButton)));

					(hold.getChildByName("largeb") as TextField).text = "B)   " + ans[1];
					(hold.getChildByName("largeb") as TextField).mouseEnabled = false;
					(hold.getChildByName("optionxb") as SimpleButton).addEventListener(MouseEvent.CLICK, addArguments(showans, 1));				
					(hold.getChildByName("optionxb") as SimpleButton).addEventListener(MouseEvent.MOUSE_OVER, addArguments2(enlargecaptainpanel, (hold.getChildByName("largeb") as TextField),(hold.getChildByName("optionxb") as SimpleButton)));
					
				}
				else
				{
					
					(hold.getChildByName("largea") as TextField).visible = false;
					(hold.getChildByName("optionxa") as SimpleButton).visible = false;
					
					(hold.getChildByName("largeb") as TextField).visible = false;
					(hold.getChildByName("optionxb") as SimpleButton).visible = false;					
					trace(currentQ);
					(hold.getChildByName("question") as TextField).text = GameConfig.questions[currentQ];
					(hold.getChildByName("questionno") as TextField).text = "Question " + ((4 - quizQ) + 1) + " of 5";
					ans = (GameConfig.answers[currentQ] as String).split(";");
					var s:String = ans[0];
					ans.sort( randomize );
					correctans = ans.indexOf(s);
					
					(hold.getChildByName("optionatxt") as TextField).text = "A)   " + ans[0];
					(hold.getChildByName("optionatxt") as TextField).mouseEnabled = false;
					(hold.getChildByName("optiona") as SimpleButton).addEventListener(MouseEvent.CLICK, addArguments(showans, 0));
					(hold.getChildByName("optiona") as SimpleButton).addEventListener(MouseEvent.MOUSE_OVER, addArguments2(enlargecaptainpanel, (hold.getChildByName("optionatxt") as TextField),(hold.getChildByName("optiona") as SimpleButton)));


					(hold.getChildByName("optionbtxt") as TextField).text = "B)   " + ans[1];
					(hold.getChildByName("optionbtxt") as TextField).mouseEnabled = false;
					(hold.getChildByName("optionb") as SimpleButton).addEventListener(MouseEvent.CLICK, addArguments(showans, 1));
					(hold.getChildByName("optionb") as SimpleButton).addEventListener(MouseEvent.MOUSE_OVER, addArguments2(enlargecaptainpanel, (hold.getChildByName("optionbtxt") as TextField),(hold.getChildByName("optionb") as SimpleButton)));					
					
				}
				(hold.getChildByName("nextbtn") as SimpleButton).addEventListener(MouseEvent.CLICK, gotonext);
			
		}
		
			function enlargecaptainpanel(event:Event,evt:TextField, x:SimpleButton)
			{
				trace("over");
				evt.textColor = 0xFFFFFF;
				x.addEventListener(MouseEvent.MOUSE_OUT, addArguments2(restoercaptinpanel, evt, x));
				x.removeEventListener(MouseEvent.MOUSE_OVER, enlargecaptainpanel);
			}
			function restoercaptinpanel(event:Event,evt:TextField, x:SimpleButton)
			{
				evt.textColor = 0x966D29;
				x.removeEventListener(MouseEvent.MOUSE_OUT, restoercaptinpanel);
				x.addEventListener(MouseEvent.MOUSE_OVER, addArguments2(enlargecaptainpanel, evt, x));
			}		
		
		function gotonext(e:MouseEvent):void
		{
			if (feedback != null && this.contains(feedback))
			{
				this.removeChild(feedback);
			}			
			if (timee != null && this.contains(timee))
			{
				this.removeChild(timee);
			}			
			if (hold != null && this.contains(hold))
			{
				this.removeChild(hold);
			}
			if (showexit == true)
			{
				showend();
			}
			else
			{
				rotateIt();
			}		
		}
		
		function opentwin(e:MouseEvent)
		{
			navigateToURL(new URLRequest("http://company.com"), "_blank");
		}
		
		
		function randomize ( a : *, b : * ) : int {
			return (Math.random() < .5) ? -1 : 1;
		}		
		
		
		//Universal function to pass listener arguments with non movieclip target
		function addArguments(method:Function, boxMC:int):Function 
		{
		  return function(event:Event):void {method.apply(null, [event].concat(boxMC));}
		}
		
		function addArguments2(method:Function, t:TextField,s:SimpleButton):Function 
		{
		  return function(event:Event):void {method.apply(null, [event].concat(t,s));}
		}		
		
		function pauseTime():void
		{
			this.removeEventListener(Event.ENTER_FRAME, showtime);
		}
		
		function playTime():void
		{
			m_prevTime = getTimer();
			this.addEventListener(Event.ENTER_FRAME, showtime);
		}		
		
		public function showans(event:Event, pressed:int):void
		{
			pauseTime();
			feedback = Quiz.getAssetClass("Feedback");
			this.addChild(feedback);
			//feedback.scaleX *= 0.2;
			//feedback.scaleY *= 0.2;
			//TweenMax.to(feedback, 0.3, {scaleX:1, scaleY:1});
			feedback.x = Quiz.thestage.stageWidth / 2;
			feedback.y = Quiz.thestage.stageHeight / 2;			
			(feedback.getChildByName("correctanstxt") as TextField).mouseEnabled = false;
			(feedback.getChildByName("correctwrong") as TextField).mouseEnabled = false;
			(feedback.getChildByName("okbtn") as SimpleButton).addEventListener(MouseEvent.CLICK, record);
			(feedback.getChildByName("correctans") as TextField).mouseEnabled = false;
			(feedback.getChildByName("contextans") as TextField).mouseEnabled = false;
			(feedback.getChildByName("correctans") as TextField).text = getSerialno(correctans) + ans[correctans];
			(feedback.getChildByName("contextans") as TextField).text = "\"" + GameConfig.context[indexans] + "\"";
			
			if (pressed == correctans)
			{
				totalcorrect++;
				
				(feedback.getChildByName("correctanstxt") as TextField).text = "You\'ve got it absolutely right!";
				(feedback.getChildByName("correctwrong") as TextField).text = "Cheers!";
				
			}
			else
			{
				(feedback.getChildByName("correctanstxt") as TextField).text = "That’s not the correct answer. It is this:";
				(feedback.getChildByName("correctwrong") as TextField).text = "Oh Dear";
				
			}		
			
		}
		
		public function getSerialno(ass:int):String
		{
			if (ass == 0)
			{
				return "A)  ";
			}
			else if (ass == 1)
			{
				return "B)  ";
			}
			else if (ass == 2)
			{
				return "C)  ";
			}
			else
			{
				return "D)  ";
			}
		}
		
		public function record(e:MouseEvent):void
		{
			if (feedback != null && this.contains(feedback))
			{
				this.removeChild(feedback);
			}			
			if (timee != null && this.contains(timee))
			{
				this.removeChild(timee);
			}			
			if (hold != null && this.contains(hold))
			{
				this.removeChild(hold);
			}
			if (showexit == true)
			{
				showend();
			}
			else
			{
				playTime();
				rotateIt();
			}
			
		}
		
		//If a ending time is needed
		public function taketoend(e:TimerEvent):void
		{
			timeend = true;
			if (feedback != null && this.contains(feedback))
			{
				this.removeChild(feedback);
			}			
			if (timee != null && this.contains(timee))
			{
				this.removeChild(timee);
			}			
			if (hold != null && this.contains(hold))
			{
				this.removeChild(hold);
			}
			showend();
			
		}
		
		public function showend():void
		{
			this.removeEventListener(Event.ENTER_FRAME, showtime);
			var b:Number = Number(10000 / Number(timeDifference));
			score = Number((1000 * totalcorrect) + b)*1000;
			trace("scored:" + score);
			mergeWithToppers();
			if (local == false)
			{
				SendScore(score);
			}
			endshow = Quiz.getAssetClass("EndShow");
			this.addChild(endshow);
			endshow.x = Quiz.thestage.stageWidth / 2;
			endshow.y = Quiz.thestage.stageHeight / 2;			
			(endshow.getChildByName("playagainbtn") as SimpleButton).addEventListener(MouseEvent.CLICK, replay);
			(endshow.getChildByName("youscored") as TextField).mouseEnabled = false;
			(endshow.getChildByName("congrats") as TextField).mouseEnabled = false;
			if (totalcorrect > 1)
			{
				if (timeend == false)
				{
					(endshow.getChildByName("congrats") as TextField).text = "Congratulations!!!";
				}
				else
				{
					(endshow.getChildByName("congrats") as TextField).text = "Time ran Out!";
				}
				
				(endshow.getChildByName("youscored") as TextField).text = "You answered " + totalcorrect + " out of 5 questions correctly in " + mins + ":" + leadingZeroSeconds + secs + "." + leadingZeroMiliseconds + milli + " minutes.";
				
			}
			else
			{
				if (timeend == false)
				{
					(endshow.getChildByName("congrats") as TextField).text = "Sorry!!!";
				}
				else
				{
					(endshow.getChildByName("congrats") as TextField).text = "Time ran Out!";
				}				
				(endshow.getChildByName("youscored") as TextField).text = "You answered only " + totalcorrect + " out of 5 questions correctly in " + mins + ":" + leadingZeroSeconds + secs + "." + leadingZeroMiliseconds + milli + " minutes.";
			}
			(endshow.getChildByName("sharebtn") as SimpleButton).addEventListener(MouseEvent.CLICK, shareonWall);
			
			(endshow.getChildByName("invite") as TextField).mouseEnabled = false;
			(endshow.getChildByName("invitebtn") as SimpleButton).addEventListener(MouseEvent.CLICK, inviteFriends);
			
			

			for (var a:int = 1; a < 6; a++)
			{
				(endshow["rank" + a] as TextField).text = names[a - 1];
				(endshow["time" + a] as TextField).text = getfrac(times[a - 1]);
				if (index != -1 && index == (a - 1))
				{
					(endshow["rank" + a] as TextField).textColor = 0x999999;
					(endshow["time" + a] as TextField).textColor = 0x999999;
				}
				this["pic" + a] = new Loader();
				this["pic" + a].load(new URLRequest("http://graph.facebook.com/" + fbids[a - 1] + "/picture?width=40&height=40"));
				(endshow.getChildByName("pic" + a) as MovieClip).addChild(this["pic" + a]);
			}
		}
		
		public function inviteFriends(e:MouseEvent):void
		{
			
			if (ExternalInterface.available)
			{				
                try {
					var s:String = "Twining Quiz Contest";
					ExternalInterface.call("sendRequest", s);
                } catch (error:SecurityError) {
                } catch (error:Error) {
                }
            }
		}
		
		public function mergeWithToppers():void
		{
			index = -1;
			
			for (var i:int = scores.length-1; i >= 0;i--)
			{
				if (Number(score) >= Number(scores[i]))
				{
					index = i;
				}
			}
			
			if (index != -1)
			{
				fbids[index] = fbid;
			
				names[index] = name;
				
				scores[index] = Number(score);
			
				times[index] = timeDifference;			
			}
			
		}
		
		
		
		public function getfrac(timeD:int):String
		{
			var lMiliseconds:String, lSeconds:String;
			  var mill:int = (timeD % 1000);
			  if (milli < 100) {
				lMiliseconds = "0";
			  } else if (milli < 10) {
				lMiliseconds = "00";
			  } else {
				lMiliseconds = "";
			  }
			  var se:int = Math.floor( (timeD/1000) % 60);
			  if (se < 10) {
				lSeconds = "0";
			  } else {
				lSeconds = "";
			  }
			  var min:int = Math.floor( (timeD / 60000) );
			  return (min + ":" + lSeconds + se + "." + lMiliseconds + mill);
		}
		
		private function SendScore(score:int) {
			var variables:URLVariables = new URLVariables();
			variables.fbid = fbid;
			variables.name = name;
			variables.email = email;
			variables.score = Number(score);
			variables.time = timeDifference;
			variables.correct = totalcorrect;
			var urlloader:URLLoader = new URLLoader;
			if (Quiz.sec == true)
			{
				var urlrequest:URLRequest = new URLRequest(GameConfig.httpspathtodbdotphp);
			}
			else
			{
				var urlrequest:URLRequest = new URLRequest(GameConfig.httppathtodbdotphp);
			}			
			urlrequest.method = URLRequestMethod.POST;
			urlrequest.data = variables;         
			urlloader.load(urlrequest);
			urlloader.addEventListener(Event.COMPLETE, CompleteHandler, false, 0, true);
			urlloader.addEventListener(IOErrorEvent.IO_ERROR , ErrorHandler, false, 0, true);
		}

		private function CompleteHandler(e:Event) {
			//Received Variables from PHP script
			var vars:URLVariables = new URLVariables(e.target.data);
		}

		//ErrorHandler to receive error messages and don't fire exception errors
		private function ErrorHandler(e:IOErrorEvent) {
			trace('Error occured');
		}		
		
		
		public function shareonWall(e:MouseEvent):void
		{
			
			if (ExternalInterface.available)
			{				
                try {
					var s:String = "Twining Quiz Contest";
					ExternalInterface.call("sendfeed", s);
                } catch (error:SecurityError) {
                } catch (error:Error) {
                }
            } 			
		}		
		
		
		public function replay(e:MouseEvent):void
		{
			if (endshow != null && this.contains(endshow))
			{
				this.removeChild(endshow);
			}			
			Init();
			
		}
		
		
		public function get5Q():void
		{
			Q = null;
			Q = new Array();
			if (GameConfig.questions.length != 0)
			{
				var rQ:int = quizQ;
				var rand:int;
				while (rQ >= 1)
				{
					do
					{
						rand = Math.floor(Math.random() * (1 + GameConfig.noofquestions - 0) + 0);
						
					}while ((Q.indexOf(rand) >= 0))
					Q.push(rand);
					--rQ;
				}
			}
			
		}
		
		
		public function getbgName():String
		{
			if (GameConfig.bgNames.length != 0)
			{
				var randomNoIndex:int = Math.round(Math.random() * (GameConfig.bgNames.length)) - 1;
				if (randomNoIndex < 0)
				randomNoIndex = GameConfig.bgNames.length - 1;
				return GameConfig.bgNames[randomNoIndex];
			}
			else
			{
				return "empty";
			}
			
		}
	}
}