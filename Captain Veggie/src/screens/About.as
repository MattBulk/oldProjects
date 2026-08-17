package screens
{
	import events.NavigationEvent;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.*;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class About extends Sprite
	{
		private var bg:Image;
		private var backBtn:Button;
		
		private var twitter:Button;
		private var facebook:Button;
		private var moreApps:Button;
		
		public function About()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			drawScreen();
		}
		
		private function drawScreen():void
		{
			bg = new Image(Assets.getBackgroundAtlas().getTexture("about_bg"));
			this.addChild(bg);
		}
		
		private function drawMenu():void
		{
			
			backBtn = new Button(Assets.getBackgroundAtlas().getTexture("back_btn"));
			backBtn.x = -backBtn.width;
			backBtn.y = stage.stageHeight - backBtn.height * 1.5;
			this.addChild(backBtn);
			
			twitter = new Button(Assets.getBackgroundAtlas().getTexture("tw_btn"));
			twitter.x = stage.stageWidth/2 + twitter.width * 2.2;
			twitter.y = stage.stageHeight + twitter.height;
			this.addChild(twitter);
			
			facebook = new Button(Assets.getBackgroundAtlas().getTexture("fb_btn"));
			facebook.x = stage.stageWidth/2 + facebook.width * 2.2;
			facebook.y = stage.stageHeight + facebook.height;
			this.addChild(facebook);
			
			moreApps = new Button(Assets.getBackgroundAtlas().getTexture("apps_btn"));
			moreApps.x = stage.stageWidth/2 + moreApps.width * 2.2;
			moreApps.y = stage.stageHeight + moreApps.height;
			this.addChild(moreApps);
			
			var t:Tween = new Tween(backBtn, 3, Transitions.EASE_OUT_ELASTIC);
			t.moveTo(50, backBtn.y);
			t.delay = 1;
			Starling.juggler.add(t);
			
			var t1:Tween = new Tween(twitter, 3, Transitions.EASE_OUT_ELASTIC);
			t1.moveTo(twitter.x, 250);
			t1.delay = 2;
			Starling.juggler.add(t1);
			
			var t2:Tween = new Tween(facebook, 3, Transitions.EASE_OUT_ELASTIC);
			t2.moveTo(twitter.x, 350);
			t2.delay = 3;
			Starling.juggler.add(t2);
			
			var t3:Tween = new Tween(moreApps, 3, Transitions.EASE_OUT_ELASTIC);
			t3.moveTo(twitter.x, 450);
			t3.delay = 4;
			Starling.juggler.add(t3);
			
			this.addEventListener(Event.TRIGGERED, onMainMenuClick);
			
		}
		
		private function onMainMenuClick(event:Event):void
		{
			CaptainVeggie.MAIN.SM.playSound("../sounds/Blip_Select.mp3");
			var buttonClicked:Button = event.target as Button;
			if((buttonClicked as Button) == backBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "mainFromAbout"}, true));
			}
			if((buttonClicked as Button) == twitter)
			{
				navigateToURL(new URLRequest("https://twitter.com/#kidFunKit"));
			}
			if((buttonClicked as Button) == facebook)
			{
				navigateToURL(new URLRequest("http://www.facebook.com/KidFunKit?sk=wall"));
			}
			if((buttonClicked as Button) == moreApps)
			{
				navigateToURL(new URLRequest("http://itunes.com/apps/22lineegrafiche"));
			}
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
			removeChild(backBtn, true);
			removeChild(twitter, true);
			removeChild(moreApps, true);
			removeChild(facebook, true);
		}
		
		public function initialize():void
		{
			this.visible = true;
			drawMenu();
		}
	}
}