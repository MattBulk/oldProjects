package
{

import com.genome2d.core.GConfig;
import com.genome2d.core.GNodeFactory;
import com.genome2d.core.Genome2D;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;

import gui.LevelScreen;

import gui.MainScreen;
import gui.PlayerScreen;
import gui.SettingScreen;
import gui.WorldScreen;
import gui.builder.BuilderLevelScreen;
import gui.builder.BuilderScreen;

import mutation.events.MEvent;
import mutation.screens.MScreenNavigation;
import mutation.screens.MScreenNavigationItem;

public class MExamples extends Sprite {


    private var _core:Genome2D = Genome2D.getInstance();

    public function MExamples()
    {
        super();

        stage.frameRate = 60;

        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        stage.addEventListener(Event.RESIZE, resizeStage, false, 0, true);

        const config:GConfig = new GConfig(getViewPortRect(), "baseline");
        config.backgroundColor = 0x000000;
        config.enableStats = true;
        config.showExtendedStats = true;
        config.useFastMem = true;
        config.antiAliasing = 0;

        _core.onInitialized.addOnce(onGenome2DInitialized);
        _core.init(stage, config);

    }

    protected function resizeStage(evt:Event):void
    {
        _core.config.viewRect = getViewPortRect();
    }

    protected function getViewPortRect() : Rectangle
    {
        return new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);

    }

    protected function onGenome2DInitialized():void {

        switch (stage.stageWidth) {

            case 640:
                Settings.FOLDER = "1";
                Settings.SCALE_FACTOR = 1;
                break;
            case 768:
                Settings.FOLDER = "1";
                Settings.SCALE_FACTOR = 1;
                break;

            case 1536:
                Settings.FOLDER = "2";
                Settings.SCALE_FACTOR = 2;
                break;
        }

        AssetManager.getInstance().addToQueue(AssetManager.ATLAS, "GUI", Settings.FOLDER, "gui.png", "gui.xml");
        AssetManager.getInstance().addToQueue(AssetManager.ATLAS, "BUILDER", Settings.FOLDER, "builder.png", "builder.xml");
        AssetManager.getInstance().addToQueue(AssetManager.FONT, "ATLAS_FONT", Settings.FOLDER, "theFont.png", "theFont.fnt");
        AssetManager.getInstance().addToQueue(AssetManager.FONT_ADV, "FONT_ADV", Settings.FOLDER, "albert-red.png", "albert-red.fnt");

        AssetManager.getInstance().loadTheQueue();

        _core.stage.addEventListener(MEvent.LOADED, onLoadedTheAssets, false, 0, true);

    }

    //*************************************************** ASSETS ***************************************************//

    protected function onLoadedTheAssets(evt:MEvent):void
    {
        _core.stage.removeEventListener(MEvent.LOADED, onLoadedTheAssets);

        _core.stage.addEventListener(MEvent.LOADED, loadedWorld, false, 0, true);

        initTheGui();

    }

    protected static function loadedWorld(evt:MEvent):void {

        trace("loaded");
    }

    //*************************************************** GUI ***************************************************//

    protected function initTheGui():void {


        const _screenNavigation:MScreenNavigation = GNodeFactory.createNodeWithComponent(MScreenNavigation, "screenNavigator") as MScreenNavigation;

        _core.root.addChild(_screenNavigation.node);

        _screenNavigation.enqueueScreen("main", new MScreenNavigationItem(MainScreen, ""));
        _screenNavigation.enqueueScreen("setting", new MScreenNavigationItem(SettingScreen, "main"));
        _screenNavigation.enqueueScreen("player", new MScreenNavigationItem(PlayerScreen, "main"));
        _screenNavigation.enqueueScreen("world", new MScreenNavigationItem(WorldScreen, "player"));
        _screenNavigation.enqueueScreen("levelScreen", new MScreenNavigationItem(LevelScreen, "world"));
        //BUILDER
        _screenNavigation.enqueueScreen("builder_menu", new MScreenNavigationItem(BuilderScreen, "main"));
        _screenNavigation.enqueueScreen("builder_levelScreen", new MScreenNavigationItem(BuilderLevelScreen, "builder_menu"));
        _screenNavigation.showScreen("main");

    }
}
}