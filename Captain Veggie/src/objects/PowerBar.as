package objects
{
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class PowerBar extends Sprite
	{
		private var powerBar:Quad;
		
		public function PowerBar()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			addPowerBar();
		}
		
		private function addPowerBar():void
		{
			powerBar = new Quad(2,40,0xFF0000)
			powerBar.x = powerBar.y = 0;
			addChild(powerBar);
		}
	}
}