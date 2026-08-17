package objects
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BulletPlasma extends Sprite
	{
		private var bulletArt:Image;
		private var _type:uint;
		
		public function BulletPlasma(type:uint)
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_type = type;
		}
		
		public function get type():uint
		{
			return _type;
		}

		public function set type(value:uint):void
		{
			_type = value;
		}

		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			bulletArt = new Image(Assets.getRobotAtlas().getTexture("Bullet" + _type));
			this.addChild(bulletArt);
			bulletArt.x = 0;
			bulletArt.y = 0;
			
		}
		
	}
}