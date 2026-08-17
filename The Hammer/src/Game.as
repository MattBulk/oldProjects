/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 8/26/13
 * Time: 11:21 AM
 * To change this template use File | Settings | File Templates.
 */
package {

import events.ControlsEvent;

import gui.MainController;

import interfaces.IModality;
import interfaces.modalities.Arcade;
import interfaces.modalities.ArcadeDebug;

import starling.display.DisplayObject;


import starling.display.Image;
import starling.display.Sprite;

import utils.Settings;
import utils.WriteTheFile;

public class Game extends Sprite {

    //PRIVATE
    private var mCurrentRoom:Sprite;
    private var theGui:MainController;
    //PUBLIC
    public var backGround:Image;
    public var iModality:IModality;

    public static var GAME:Object;

    public function Game() {

        var folderType:String;
        var assetsFactor:uint;

        trace(Settings.STAGE_WIDTH);

        switch (Settings.STAGE_WIDTH) {

            case 960:
            case 1024 :
                folderType = "SD";
                assetsFactor = 1;

                break;
            case 1136:
                folderType = "SD";
                assetsFactor = 1;
                break;
            case 2048:
                folderType = "HD";
                assetsFactor = 1;
                Settings.SCALE_FACTOR = 2;
                break;
            default :
                folderType = "SD";
                assetsFactor = 1;
                break;

        }

        GAME = this;

        TheAtlasLoader.getInstance().initTheLoader(folderType, assetsFactor);

        WriteTheFile.getInstance().initTheWorlds();

    }

    public function init():void {

        //BACKGROUND IMAGE
//        backGround = new Image(Constant.MAINBACKGROUND);
//
//        backGround.pivotX = backGround.width/2;
//        backGround.pivotY = backGround.height/2;
//
//        if(Constant.STAGEWIDTH == 1136) {
//            backGround.scaleX = 1.11;
//            backGround.scaleY = 1.02;
//        }
//
//        backGround.x = Constant.STAGEWIDTH/2;
//        backGround.y = Constant.STAGEHEIGHT/2;
//        addChild(backGround);

        theGui = new MainController();
        this.addChild(theGui);

        this.addEventListener(ControlsEvent.SET_CONTROL, listenHandler);

        //selectTheScene("test");

    }

    private function listenHandler(evt:ControlsEvent):void {

        iModality.receiveDirections(evt.params);
    }

    public function selectTheScene(page:String):void {

        var path:String = page;
        //HIDE THE GUI
        //backGround.visible = false;

        //DEFINE THE CLASS
        //var sceneClass:Class = getDefinitionByName(path) as Class;
        //ADD THE CLASS TO A DISPLAY
        iModality = new ArcadeDebug();

        iModality.loadTheLevel();
        iModality.init();

        mCurrentRoom = iModality as Sprite;

        this.addChild(mCurrentRoom);
        this.setChildIndex(mCurrentRoom, 0);


    }

    public function disposeTheGame():void {

        backGround.visible = true;

        mCurrentRoom.removeFromParent(true);
        mCurrentRoom = null;

    }

}
}
