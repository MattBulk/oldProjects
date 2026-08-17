package screens
{
	import events.NavigationEvent;
	import flash.net.SharedObject;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.*;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import CaptainVeggie;
	import starling.events.EventDispatcher;
	
	public class Welcome extends Sprite
	{
		private var bg:Image;
		private var playBtn:Button;
		private var aboutBtn:Button;
		private var recipeBtn:Button;
		private var scoringBoard:ScoringBoard;
		
		public var captainVeggieSO:SharedObject;
		
		public static var WELCOME:Object;
		
		public function Welcome()
		{
			super();
			
			WELCOME = this;
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			CaptainVeggie.MAIN.SM.playSound("../sounds/CaptainVeggieIntro.mp3");
			drawScreen();
			captainVeggieSO = SharedObject.getLocal("CaptainVeggie");
		}
		
		private function drawScreen():void
		{
			bg = new Image(Assets.getBackgroundAtlas().getTexture("intro"));
			this.addChild(bg);
		}
		
		private function drawMenu():void
		{
			
			playBtn = new Button(Assets.getBackgroundAtlas().getTexture("play_btn"));
			playBtn.x = stage.stageWidth;
			playBtn.y = 200;
			this.addChild(playBtn);
			
			aboutBtn = new Button(Assets.getBackgroundAtlas().getTexture("about_btn"));
			aboutBtn.x = stage.stageWidth;
			aboutBtn.y = 325;
			this.addChild(aboutBtn);
			
			recipeBtn = new Button(Assets.getBackgroundAtlas().getTexture("cookbook_btn"));
			recipeBtn.x = stage.stageWidth;
			recipeBtn.y = 425;
			this.addChild(recipeBtn);
			
			var t:Tween = new Tween(playBtn, 4, Transitions.EASE_OUT_ELASTIC);
			t.moveTo(750, playBtn.y);
			Starling.juggler.add(t);
			
			var t1:Tween = new Tween(aboutBtn, 4, Transitions.EASE_OUT_ELASTIC);
			t1.moveTo(750, aboutBtn.y);
			t1.delay = 1;
			Starling.juggler.add(t1);
			
			var t0:Tween = new Tween(recipeBtn, 4, Transitions.EASE_OUT_ELASTIC);
			t0.moveTo(750, recipeBtn.y);
			t0.delay = 2;
			Starling.juggler.add(t0);
			
			this.addEventListener(Event.TRIGGERED, onMainMenuClick);
			
			if(captainVeggieSO.data.score && this.visible == true) {
				scoringBoard = new ScoringBoard(captainVeggieSO.data.score,captainVeggieSO.data.distance);
				addChild(scoringBoard);
				
				scoringBoard.y = stage.stageHeight;
				
				var t2:Tween = new Tween(scoringBoard, 2, Transitions.EASE_OUT_ELASTIC);
				t2.moveTo(scoringBoard.x, stage.stageHeight - scoringBoard.height * 3.2);
				t2.delay = 3;
				Starling.juggler.add(t2);
				
			}
			
		}
		
		private function onMainMenuClick(event:Event):void
		{
			var buttonClicked:Button = event.target as Button;
			CaptainVeggie.MAIN.SM.playSound("../sounds/Blip_Select.mp3");
			
			if((buttonClicked as Button) == playBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "play"}, true));
			}
			if((buttonClicked as Button) == aboutBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "about"}, true));
			}
			if((buttonClicked as Button) == recipeBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "recipe"}, true));
			}
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
			removeChild(playBtn, true);
			removeChild(aboutBtn, true);
			removeChild(recipeBtn, true);
			if(scoringBoard) removeChild(scoringBoard,true);
		}
		
		public function initialize():void
		{
			this.visible = true;
			drawMenu();
		}
		
	}
}