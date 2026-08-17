package objects
{
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class PowerUps extends Sprite
	{
		private var _powerUpType:int;
		private var itemImage:Image;
		
		public function PowerUps(_powerUpType:int)
		{
			super();
			
			this.powerUpType = _powerUpType;
		}
		
		public function get powerUpType():int
		{
			return _powerUpType;
		}
		
		public function set powerUpType(value:int):void
		{
			_powerUpType = value;
			
			itemImage = new Image(Assets.getRobotAtlas().getTexture("powerUp" + _powerUpType));
			itemImage.x = itemImage.texture.width * 0.5;
			itemImage.y = itemImage.texture.height * 0.5;
			this.addChild(itemImage);
		}
	}
}