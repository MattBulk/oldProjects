package
{
	import events.NavigationEvent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import screens.RecipeBook;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class TheLoader
	{
		
		private static var instance:TheLoader = new TheLoader();
		private static var allTexture:Vector.<Texture> = new Vector.<Texture>();
		
		private var txtToArray:Array = [];
		private var loadCount:int = 0;
		private var nextToLoad:int = 0;
		private var txtLoader:URLLoader;
		private var textureLoader:Loader;
		public var _allLoaded:Boolean;

			
		public function TheLoader() 
		{
			if ( instance ) throw Error("Library Class is Singleton.");
		}
		public static function getInstance():TheLoader {
			return instance;
		}
		
		public function initTheLoader(imagePath:String):void {
			
			txtLoader = new URLLoader();
			txtLoader.load(new URLRequest(imagePath));
			txtLoader.addEventListener(Event.COMPLETE, dataLoaded, false, 0, true);
		}
		
		private function dataLoaded(evt:Event):void
		{
			var stringOfWords:String = evt.target.data;
			txtToArray = stringOfWords.split(/\r\n|\n|\r/);
			
			addTexture(nextToLoad);
		}
		
		public function addTexture(thisNumber:int):void
		{
			textureLoader = new Loader();
			textureLoader.load(new URLRequest("bookImg/"+ txtToArray[thisNumber]));
			textureLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
		}
		
		private function onComplete(event:Event):void
		{
			
			var loadedBitmap:Bitmap = event.currentTarget.loader.content as Bitmap;
			var currentTexture:Texture = Texture.fromBitmap(loadedBitmap, false);
			loadedBitmap.bitmapData.dispose();
			loadedBitmap = null;
			
			allTexture.push(currentTexture);
			loadCount++;
			if (loadCount == txtToArray.length) {
				
				_allLoaded = true;

			}
			else {
				nextToLoad++;
				addTexture(nextToLoad);
			}
		}
		
		public static function getTexture(number:int):Texture
		{
			var thisTexture:Texture = allTexture[number];
			return thisTexture;
		}
	
	}
}