package  {
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.display.ProgressCircleLite;
    import flash.events.*;
    import flash.net.*;
	import flash.display.Sprite;	
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.Stage;
	import flash.system.Security;
	import flash.external.ExternalInterface;	
	
	//Initial Quiz Version
	//Alok Mishra
	//June 2013

	public class Quiz extends Sprite 
	{
		public var queue:LoaderMax;
		public static var urls:Array = ["http://pathto/Pics.swf"];
		private var _progressDisplay:ProgressCircleLite;
		public static var game:Main;
		public static var thestage:Stage;
		public static var sec:Boolean = false;
		
		public function Quiz():void 
		{
			if (ExternalInterface.available) 
			{
				try 
				{
					ExternalInterface.addCallback("getProt", putProt);

					
					ExternalInterface.call("sendProt");
				} catch (error:SecurityError) 
				{
					
				} catch (error:Error) 
				{

				}
			}
			
		}
		//Facebook problem for http and https
		public function putProt(myFlashVar:String)
		{		
			if (myFlashVar != null && myFlashVar == "https:")
			{
				sec = true;
				urls.length = 0;
				urls = ["https://pathto/Pics.swf"];
				Security.loadPolicyFile("https://graph.facebook.com/crossdomain.xml");
				Security.loadPolicyFile("https://fbcdn-profile-a.akamaihd.net/crossdomain.xml");
				Security.allowDomain("*");
				Security.allowInsecureDomain("*");	
				LoaderMax.activate([SWFLoader]); 
				queue = LoaderMax.parse(urls, { estimatedBytes:200280,auditSize:false, maxConnections:6, requireWithRoot:this.root, onComplete:completeHandler, onError:errorHandler }, { scaleMode:"none" , requireWithRoot:this.root, autoPlay:false, noCache:false } );
				_progressDisplay = new ProgressCircleLite({radius:26, thickness:4, trackColor:0xFFFFFF,
														   trackAlpha:0.25, trackThickness:4, 
														   autoTransition:false, smoothProgress:0});
				
				this.addChild(_progressDisplay);
				_progressDisplay.mouseEnabled = false;
				_progressDisplay.x = stage.stageWidth/2;
				_progressDisplay.y = stage.stageHeight/2;
				thestage = stage;
				_progressDisplay.addLoader(queue);
				//start loading
				queue.prioritize(true);
				queue.load();					
			}
			else
			{
			trace("Entered preloader");
				Security.loadPolicyFile("http://graph.facebook.com/crossdomain.xml");
				Security.loadPolicyFile("http://fbcdn-profile-a.akamaihd.net/crossdomain.xml");
				Security.allowDomain("*");
				Security.allowInsecureDomain("*");	
				LoaderMax.activate([SWFLoader]); 
				queue = LoaderMax.parse(urls, { estimatedBytes:200280,auditSize:false, maxConnections:6, requireWithRoot:this.root, onComplete:completeHandler, onError:errorHandler }, { scaleMode:"none" , requireWithRoot:this.root, autoPlay:false, noCache:false } );
				_progressDisplay = new ProgressCircleLite({radius:26, thickness:4, trackColor:0xFFFFFF,
														   trackAlpha:0.25, trackThickness:4, 
														   autoTransition:false, smoothProgress:0});
				
				this.addChild(_progressDisplay);
				_progressDisplay.mouseEnabled = false;
				_progressDisplay.x = stage.stageWidth/2;
				_progressDisplay.y = stage.stageHeight/2;
				thestage = stage;
				_progressDisplay.addLoader(queue);
				//start loading
				queue.prioritize(true);
				queue.load();				
			}
		}		
		
		function completeHandler(event:LoaderEvent):void 
		{
			if (this != null && this.contains(_progressDisplay))
			{
				this.removeChild(_progressDisplay);
			}
			_progressDisplay.removeLoader(queue);
			_progressDisplay = null;
			
			game = new Main();
			game.Welcome();
			stage.addChild(game);
			stage.align  = StageAlign.TOP_LEFT;
			trace("Complete preloading");
		}

		function errorHandler(event:LoaderEvent):void 
		{
		}
		
		public static function getAssetClass(assetName:String):MovieClip 
		{
			var ClassReference:Class;
			for (var i:int = 0; i < urls.length; i++) 
			{
				ClassReference = (LoaderMax.getLoader(urls[i]).getClass(assetName) as Class);
				if (ClassReference != null)
				{
					var _newAsset:MovieClip = (new ClassReference as MovieClip);
					return _newAsset;					
				}
			}
			return _newAsset;
		}
	}
}