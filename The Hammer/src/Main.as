package {

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.*;
import flash.geom.*;
import flash.system.Capabilities;
import starling.core.*;
import starling.events.ResizeEvent;
import starling.utils.RectangleUtil;
import starling.utils.ScaleMode;

import utils.Settings;

public class Main extends Sprite {

    public var viewPort:Rectangle;

    public function Main() {

        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        Starling.handleLostContext = false;
        Starling.multitouchEnabled = true;

        Settings.STAGE_WIDTH = stage.fullScreenWidth;
        Settings.STAGE_HEIGHT = stage.fullScreenHeight;

        getViewPortRect();

        //BEFORE STARTING STARLING GET THE RIGHT DIMENSION
        var star:Starling = new Starling(Game, stage, getViewPortRect());
        star.simulateMultitouch  = true;

        //star.supportHighResolutions = true;
        star.enableErrorChecking = Capabilities.isDebugger;
        star.antiAliasing = 4;
        star.showStats = true;
        star.stage.color = 0x000000;
        star.nativeStage.frameRate = 60;
        star.start();

        stage.addEventListener(ResizeEvent.RESIZE, resizeStage);

    }

    private function getViewPortRect():Rectangle
    {
        viewPort = RectangleUtil.fit(
                new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight),
                new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), ScaleMode.SHOW_ALL);
        return viewPort;

    }

    private function resizeStage(e:Event):void
    {
        Starling.current.viewPort = getViewPortRect();
    }

}
}
