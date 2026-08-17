/**
 * Created by 22BoX on 2/4/14.
 */
package buildingTools {

import nape.callbacks.CbType;
import nape.space.Space;

import starling.display.Sprite;

import utils.Settings;

public class InGameVars {


    public static var NAPE_SPACE:Space;
    public static var GAME_CONT:Sprite = new Sprite();
    public static var GAME_BACKGROUND:Sprite = new Sprite();
    public static var GAME_LAYER_PLATFORM:Sprite = new Sprite();
    public static var TAP_COUNT:uint = 0;

    public static var isJumping:Boolean, isDoubleJumping:Boolean, isFalling:Boolean, onPlatform:Boolean;

    public static var currentAnimationState:String = "";

    public static const TILE_DIMENSIONS:uint = 64 * Settings.SCALE_FACTOR;
    public static const STEPS:Number = 1/60;

    public static var wallCollisionType:CbType = new CbType();
    public static var heroCollisionType:CbType = new CbType();
    public static var platformCollisionType:CbType = new CbType();

    public static var LEFT:Boolean, RIGHT:Boolean;

    }
}
