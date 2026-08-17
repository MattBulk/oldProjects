package screens
{
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import events.NavigationEvent;
	
	public class GameOver extends Sprite
	{
		private var screenBackground:Quad;
		private var scoreText:TextField;
		private var distanceText:TextField;
		private var thisArmyText:TextField;
		private var container:Sprite;
		private var goImage:Image;
		private var thisScore:int;
		private var thisDistance:int;
		private var thisArmy:int;
		
		private var backBtn:Button;
		
		public function GameOver(score:int, distance:int, redArmy:int)
		{
			super();
			
			thisScore = score;
			thisDistance = distance;
			thisArmy = redArmy;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			container = new Sprite();
			this.addChild(container);
			container.x = stage.stageWidth/2;
			container.y = stage.stageHeight/2;
			
			screenBackground = new Quad(660,500,0xffffff)
			container.addChild(screenBackground);
			screenBackground.alpha = .7;
			screenBackground.pivotX = screenBackground.width/2;
			screenBackground.pivotY = screenBackground.height/2;
			
			goImage = new Image(Assets.getBackgroundAtlas().getTexture("gameover_it"));
			addChild(goImage);
	
			addFinalScore();
		}
		
		private function addFinalScore():void
		{
			scoreText = new TextField(600, 100, "", Assets.getFont().name, 48, 0xffffff);
			scoreText.hAlign = HAlign.LEFT;
			scoreText.vAlign = VAlign.TOP;
			scoreText.x = (screenBackground.x - screenBackground.width/2) + 25;
			scoreText.y = (screenBackground.y - screenBackground.width/2) + 150;
			container.addChild(scoreText);
			scoreText.text = "Final Score : " + thisScore;
			
			distanceText = new TextField(600, 100, "", Assets.getFont().name, 48, 0xffffff);
			distanceText.hAlign = HAlign.LEFT;
			distanceText.vAlign = VAlign.TOP;
			distanceText.x = scoreText.x
			distanceText.y = scoreText.y + scoreText.height;
			container.addChild(distanceText);
			distanceText.text = "Final Distance : " + thisDistance;
			
			thisArmyText = new TextField(600, 100, "", Assets.getFont().name, 48, 0xffffff);
			thisArmyText.hAlign = HAlign.LEFT;
			thisArmyText.vAlign = VAlign.TOP;
			thisArmyText.x = scoreText.x
			thisArmyText.y = distanceText.y + scoreText.height;
			container.addChild(thisArmyText);
			thisArmyText.text = "RedBirds Destroyed : " + thisArmy;
			
			backBtn = new Button(Assets.getBackgroundAtlas().getTexture("main_btn"));
			backBtn.x = screenBackground.x - backBtn.width/2;
			backBtn.y = (screenBackground.y + screenBackground.height/2) - backBtn.height * 1.5;
			container.addChild(backBtn);
			
			backBtn.addEventListener(Event.TRIGGERED, onMainMenuClick);
		}
		
		private function onMainMenuClick(event:Event):void
		{
			// TODO Auto Generated method stub
			CaptainVeggie.MAIN.SM.playSound("../sounds/Blip_Select.mp3");
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "mainFromGameOver"}, true));
		}
		
	}
}