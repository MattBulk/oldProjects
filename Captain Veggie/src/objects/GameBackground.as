package objects
{
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.*;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	
	public class GameBackground extends Sprite
	{
		public static var GAMEBG:Sprite;
		
		public var backgroundContainer:Sprite;
		
		private var background1:Image;
		private var background2:Image;
		
		private var frontBuildings:Image;
		private var frontTrees:Image;
		private var backBuildings:Image;
		
		public var STAGEWIDTH:uint;
		public var STAGEHEIGHT:uint;
		
		public function GameBackground()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			GAMEBG = this;
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(Event.ENTER_FRAME, moveBackground);
			
			STAGEWIDTH = stage.stageWidth;
			STAGEHEIGHT = stage.stageHeight;
			
			this.addEventListener("CHANGEY", changeY);
			this.addEventListener("RESETY", resetY);
			
			background1 = new Image(Assets.getBackgroundAtlas().getTexture("background01"));
			background2 = new Image(Assets.getBackgroundAtlas().getTexture("background01"));
			
			backBuildings = new Image(Assets.getBackgroundAtlas().getTexture("background02"));
			frontBuildings = new Image(Assets.getBackgroundAtlas().getTexture("background03"));			
			frontTrees = new Image(Assets.getBackgroundAtlas().getTexture("background04"));
			
			background1.y = background2.y = 0;
			background1.x = 0;
			background2.x = background1.width - 1;
	
			backBuildings.y = STAGEHEIGHT + 50;
			backBuildings.x = STAGEWIDTH/2;
			backBuildings.pivotX = backBuildings.width/2;
			backBuildings.pivotY = backBuildings.height/2;
			
			frontBuildings.y = STAGEHEIGHT + 50;
			frontBuildings.x = STAGEWIDTH/2;
			frontBuildings.pivotX = frontBuildings.width/2;
			frontBuildings.pivotY = frontBuildings.height/2;
			
			frontTrees.y = STAGEHEIGHT + 50;
			frontTrees.x = STAGEWIDTH/2;
			frontTrees.pivotX = frontTrees.width/2;
			frontTrees.pivotY = frontTrees.height/2;
			
			backgroundContainer = new Sprite();
			
			backgroundContainer.addChild(background1);
			backgroundContainer.addChild(background2);
			
			addChild(backgroundContainer);
			addChild(backBuildings);
			addChild(frontBuildings);
			addChild(frontTrees);
		}
		
		private function resetY():void
		{
			var t:Tween = new Tween(backBuildings, 4);
			t.moveTo(backBuildings.x, STAGEHEIGHT + 50);
			Starling.juggler.add(t);
			
			var t1:Tween = new Tween(frontBuildings, 4);
			t1.moveTo(frontBuildings.x, STAGEHEIGHT + 50);
			Starling.juggler.add(t1);
			
			var t2:Tween = new Tween(frontTrees, 4);
			t2.moveTo(frontTrees.x, STAGEHEIGHT + 50);
			Starling.juggler.add(t2);
		}
		
		private function changeY():void
		{
			var t:Tween = new Tween(backBuildings, 4);
			t.moveTo(backBuildings.x, STAGEHEIGHT + 250);
			Starling.juggler.add(t);
			
			var t1:Tween = new Tween(frontBuildings, 4);
			t1.moveTo(frontBuildings.x, STAGEHEIGHT + 250);
			Starling.juggler.add(t1);
			
			var t2:Tween = new Tween(frontTrees, 4);
			t2.moveTo(frontTrees.x, STAGEHEIGHT + 250);
			Starling.juggler.add(t2);
			
		}
		
		private function moveBackground(e:Event):void
		{
			// scroll it
			backgroundContainer.x -= 12;
			backBuildings.rotation -= deg2rad(0.1);
			frontBuildings.rotation -= deg2rad(0.3);
			frontTrees.rotation -= deg2rad(0.9);
			// reset
			if ( backgroundContainer.x <= -background2.width )
				backgroundContainer.x = 0;
		}
		
	}
}