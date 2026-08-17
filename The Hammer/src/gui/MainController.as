/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 1/13/14
 * Time: 7:23 PM
 * To change this template use File | Settings | File Templates.
 */
package gui {

import feathers.controls.ScreenNavigator;
import feathers.controls.ScreenNavigatorItem;

import gui.screens.ControlScreen;

import gui.screens.LevelScreen;
import gui.screens.MainScreen;
import gui.screens.ManualScreen;
import gui.screens.SettingScreen;
import gui.screens.WorldScreen;

import starling.display.Sprite;
import starling.events.Event;

public class MainController extends Sprite {

    private var _navigator:ScreenNavigator;
    private var _transitionManager:ScreenSlidingDirectionsStackTransitionManager;


    private static const START_SCREEN:String = "startScreen";
    private static const SETTING_SCREEN:String = "settingScreen";
    private static const WORLD_SCREEN:String = "worldScreen";
    private static const LEVEL_SCREEN:String = "levelScreen";
    private static const CONTROLS_SCREEN:String = "controlsScreen";
    private static const MANUAL:String = "theManual";

    public function MainController() {

        super();

        this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

    }

    private function addedToStageHandler(event:Event):void
    {

        this._navigator = new ScreenNavigator();

        this.addChild(this._navigator);

        this._navigator.addScreen(START_SCREEN, new ScreenNavigatorItem(MainScreen,
                {
                    showWorld: WORLD_SCREEN,
                    showManual: MANUAL,
                    showSetting: SETTING_SCREEN

                }));

        this._navigator.addScreen(WORLD_SCREEN, new ScreenNavigatorItem(WorldScreen,
                {
                    showScreen: LEVEL_SCREEN,

                    complete:START_SCREEN
                }));

        this._navigator.addScreen(LEVEL_SCREEN, new ScreenNavigatorItem(LevelScreen,
                {
                    showControls: CONTROLS_SCREEN,

                    complete:WORLD_SCREEN
                }));

        this._navigator.addScreen(CONTROLS_SCREEN, new ScreenNavigatorItem(ControlScreen,
                {
                    showLevelComplete: LEVEL_SCREEN,

                    complete:LEVEL_SCREEN
                }));

        this._navigator.addScreen(SETTING_SCREEN, new ScreenNavigatorItem(SettingScreen,
                {
                    complete:START_SCREEN
                }));

        this._navigator.addScreen(MANUAL, new ScreenNavigatorItem(ManualScreen,
                {
                    complete:START_SCREEN
                }));

        this._navigator.showScreen(START_SCREEN);

        this._transitionManager = new ScreenSlidingDirectionsStackTransitionManager(this._navigator);

        this._transitionManager.directions.push({id:START_SCREEN, direction:1});
        this._transitionManager.directions.push({id:WORLD_SCREEN, direction:1});
        this._transitionManager.directions.push({id:MANUAL, direction:0});
        this._transitionManager.directions.push({id:SETTING_SCREEN, direction:0});
        this._transitionManager.directions.push({id:CONTROLS_SCREEN, direction:0});
        this._transitionManager.duration = 1.5;

    }

}
}
