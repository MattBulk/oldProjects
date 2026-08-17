package screens
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class ScoringBoard extends Sprite
	{
		private var scoreText:TextField;
		private var distanceText:TextField;
		private var container:Sprite;
		private var goImage:Image;
		private var thisScore:String;
		private var thisDistance:String;
		
		public function ScoringBoard(score:String, distance:String)
		{
			super();
			
			thisScore = score;
			thisDistance = distance;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			container = new Sprite();
			this.addChild(container);
			container.x = stage.stageWidth/2;
			container.y = stage.stageHeight/2;
			
			goImage = new Image(Assets.getBackgroundAtlas().getTexture("scorePanel"));
			goImage.pivotX = goImage.width/2;
			goImage.pivotY = goImage.height/2;
			
			container.addChild(goImage);
			
			addFinalScore();
		}
		
		private function addFinalScore():void
		{
			scoreText = new TextField(300, 50, "", Assets.getFont().name, 24, 0xffffff);
			scoreText.hAlign = HAlign.LEFT;
			scoreText.vAlign = VAlign.TOP;
			scoreText.x = (goImage.x - goImage.width/2) + 25;
			scoreText.y = (goImage.y - goImage.width/2) + 95;
			container.addChild(scoreText);
			scoreText.text = "Score : " + thisScore;
			
			distanceText = new TextField(300, 50, "", Assets.getFont().name, 24, 0xffffff);
			distanceText.hAlign = HAlign.LEFT;
			distanceText.vAlign = VAlign.TOP;
			distanceText.x = scoreText.x
			distanceText.y = scoreText.y + scoreText.height/1.5;
			container.addChild(distanceText);
			distanceText.text = "Distance : " + thisDistance;
			
		}
		
	}
}