package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.Font;
	import flash.utils.Dictionary;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Assets
	{
		
		[Embed(source="../media/graphics/background.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlBackground:Class;
		
		[Embed(source="../media/graphics/RobotArmy.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlRobot:Class;
		
		[Embed(source="../media/font/OogieBoogie.fnt", mimeType="application/octet-stream")]
		public static const FontXML:Class;
		
		public static var myFont:BitmapFont;
		
		private static var gameTextures:Dictionary = new Dictionary();
		
		private static var backgroundTextureAtlas:TextureAtlas;
		private static var robotTextureAtlas:TextureAtlas;
		
		
		public static function getFont():BitmapFont
		{
			var fontTexture:Texture = TheAtlasLoader.getTexture(2);
			var fontXML:XML = XML(new FontXML());
			
			var font:BitmapFont = new BitmapFont(fontTexture, fontXML);
			TextField.registerBitmapFont(font);
			
			return font;
		}
		
		public static function getRobotAtlas():TextureAtlas
		{
			if (robotTextureAtlas == null)
			{
				var texture:Texture = TheAtlasLoader.getTexture(1);
				var xml:XML = XML(new AtlasXmlRobot());
				robotTextureAtlas = new TextureAtlas(texture, xml);
			}
			return robotTextureAtlas;
		}
		
		public static function getBackgroundAtlas():TextureAtlas
		{
			if (backgroundTextureAtlas == null)
			{
				var texture:Texture = TheAtlasLoader.getTexture(0);
				var xml:XML = XML(new AtlasXmlBackground());
				backgroundTextureAtlas = new TextureAtlas(texture, xml);
			}
			return backgroundTextureAtlas;
		}
		
		public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap, false);
				bitmap.bitmapData.dispose();
				bitmap = null;
			}
			return gameTextures[name];
		}
		
	}
	
}