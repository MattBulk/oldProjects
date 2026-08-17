package
{

import flash.events.IOErrorEvent;
import flash.events.OutputProgressEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.system.Capabilities;
import flash.utils.ByteArray;

import gui.Constant;
import utils.Settings;
import starling.core.*;
import starling.utils.*;
import utils.ProgressBar;
	
	public class TheAtlasLoader
	{
		
		private static var instance:TheAtlasLoader = new TheAtlasLoader();
		private var appDir:File;
        private var stream:FileStream;
        private var _type:String;
		public var assets:AssetManager;
        public var isLoading:Boolean;
		
		public function TheAtlasLoader() 
		{
			if ( instance ) throw Error("Library Class is Singleton.");
		}
		public static function getInstance():TheAtlasLoader {
			return instance;
		}
		
		public function initTheLoader(type:String, scaleFactor):void {

            _type = type;

            assets = new AssetManager(scaleFactor);
            assets.useMipMaps = false;
			appDir = File.applicationDirectory;
			
			assets.verbose = Capabilities.isDebugger;
			assets.enqueue(

                appDir.resolvePath("assets/" + _type)
			);
			
			var progressBar:ProgressBar = new ProgressBar(175, 20);

			progressBar.x = Settings.STAGE_WIDTH / 2 - progressBar.width/2;
			progressBar.y = Settings.STAGE_HEIGHT / 2;
			progressBar.y = Settings.STAGE_HEIGHT * 0.85;

            Game.GAME.addChild(progressBar);
			
			assets.loadQueue(function onProgress(ratio:Number):void
			{
				progressBar.ratio = ratio;
				// a progress bar should always show the 100% for a while,
				// so we show the main menu only after a short delay. 
				
				if (ratio == 1) {
					Starling.juggler.delayCall(function():void { progressBar.removeFromParent(true); }, .5);
					Starling.juggler.delayCall(function():void { Game.GAME.init(); }, 1);
                }
				
			});

		}

        public function addToQueue(_theFIle:String):void {

            isLoading = true;

            assets.enqueue(appDir.resolvePath("assets/textures/" + _type + "/SCENES/" + _theFIle + ".dbswf"));
                           //appDir.resolvePath("assets/textures/" + _type + "/SCENES/" + _theFIle + ".xml"),
                           //appDir.resolvePath("assets/textures/" + _type + "/SCENES/skeleton.xml"));

            var progressBar:ProgressBar = new ProgressBar(175, 20);

            progressBar.x = Constant.STAGE_WIDTH / 2 - progressBar.width/2;
            progressBar.y = Constant.STAGE_HEIGHT / 2;
            progressBar.y = Constant.STAGE_HEIGHT * 0.85;
            Game.GAME.addChild(progressBar);

            assets.loadQueue(function onProgress(ratio:Number):void
            {
                progressBar.ratio = ratio;
                // a progress bar should always show the 100% for a while,
                // so we show the main menu only after a short delay.
                if (ratio == 1) {

                    Starling.juggler.delayCall(function():void { progressBar.removeFromParent(true); }, .2);
                    isLoading = false;
                }

            });

        }

        public function loadXML(LEVEL:String):XML {

            var file:File = appDir.resolvePath("db/" + LEVEL + ".xml");

            stream = new FileStream();


            if(file.exists) {
                stream.open(file, FileMode.READ);

                stream.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
                stream.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
                stream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onProgressComplete, false, 0, true);

                var THEXML:XML = new XML(stream.readUTFBytes(stream.bytesAvailable));
            }

            stream.close();
            stream.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
            stream.removeEventListener(ProgressEvent.PROGRESS, onProgress);
            stream.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onProgressComplete);

            return THEXML;
        }

        public function loadScene(scene:String):ByteArray {

            var file:File = appDir.resolvePath("assets/textures/" + _type + "/SCENES/" + scene + ".png");

            stream = new FileStream();


            if(file.exists) {
                stream.open(file, FileMode.READ);

                stream.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
                stream.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
                stream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onProgressComplete, false, 0, true);

                var bite_array:ByteArray = stream.readUTFBytes(stream.bytesAvailable) as ByteArray;

                trace(bite_array)

            }

            stream.close();
            stream.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
            stream.removeEventListener(ProgressEvent.PROGRESS, onProgress);
            stream.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onProgressComplete);

            return bite_array;
        }

        public function onProgress(Event:ProgressEvent):void {
            trace("onProgress");
        }

        public function onProgressComplete(Event:OutputProgressEvent):void {

            trace("onProgressComplete");
        }

        public function onIOError(evt:IOErrorEvent):void
        {
            trace(evt);
        }

	}
}