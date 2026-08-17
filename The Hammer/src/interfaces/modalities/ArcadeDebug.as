/**
 * Created by 22BoX on 2/4/14.
 */
package interfaces.modalities {

import buildingTools.Camera;
import buildingTools.InGameVars;
import buildingTools.TileSystem;

import flash.display.Sprite;
import flash.display3D.IndexBuffer3D;
import flash.geom.Point;
import flash.geom.Rectangle;

import gui.Constant;

import interfaces.ICharacters;

import interfaces.IModality;
import interfaces.characters.Hero;

import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;

import nape.callbacks.InteractionType;
import nape.callbacks.PreCallback;
import nape.callbacks.PreFlag;
import nape.callbacks.PreListener;
import nape.dynamics.Arbiter;
import nape.dynamics.ArbiterList;
import nape.dynamics.CollisionArbiter;
import nape.geom.Mat23;

import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.shape.Shape;

import nape.space.Space;
import nape.util.ShapeDebug;

import starling.core.Starling;
import starling.display.DisplayObject;


import starling.display.Sprite;
import starling.events.Event;
import starling.events.KeyboardEvent;

import utils.Settings;

import utils.WriteTheFile;

public class ArcadeDebug extends starling.display.Sprite implements IModality {

    private var _tileSystem:TileSystem;
    private var _debug:ShapeDebug = new ShapeDebug(Constant.STAGE_WIDTH, Constant.STAGE_HEIGHT);
    private var _napeDebugSprite:flash.display.Sprite = new flash.display.Sprite();

    private var _intWallBegin:InteractionListener, _intPlatEnd:InteractionListener;
    private var _prePlatBegin:PreListener;
    //HERO
    private var iCharacter:ICharacters;
    private var _theHero:Body;

    private var _jumpImpulse:Vec2;

    private var _jumpDirection:int = 0, _currentID:uint;


    private var _camera:Camera;

    private var _heroPos:Point;

    private var count:uint = 0;


    public function ArcadeDebug() {

        super();
    }

    public function loadTheLevel():void {

        WriteTheFile.getInstance().loadSceneXML("db/1-1.xml");

        _tileSystem = new TileSystem(WriteTheFile.getInstance().loadedCurrentRoom);

        _debug.drawCollisionArbiters = true;

    }

    public function init():void {

        InGameVars.NAPE_SPACE = new Space(new Vec2(0, 400));

        Starling.current.nativeOverlay.addChild(_napeDebugSprite);

        _napeDebugSprite.addChild(_debug.display);

        _napeDebugSprite.alpha = 1;

        _tileSystem.createBackground();

        _tileSystem.createPlatformElements();

        _tileSystem.setUpPhysicEngine();

        _camera = new Camera();

        this.addChild(InGameVars.GAME_BACKGROUND);

        InGameVars.GAME_BACKGROUND.pivotY = InGameVars.GAME_BACKGROUND.height;
        InGameVars.GAME_BACKGROUND.y = Constant.STAGE_HEIGHT - InGameVars.TILE_DIMENSIONS;

        InGameVars.GAME_BACKGROUND.flatten();
        InGameVars.GAME_BACKGROUND.touchable = false;

        InGameVars.GAME_CONT.addChild(InGameVars.GAME_LAYER_PLATFORM);

        InGameVars.GAME_LAYER_PLATFORM.flatten();
        InGameVars.GAME_LAYER_PLATFORM.touchable = false;

        this.addChild(InGameVars.GAME_CONT);

        InGameVars.GAME_CONT.pivotY = InGameVars.GAME_CONT.height;
        InGameVars.GAME_CONT.y = Constant.STAGE_HEIGHT - (InGameVars.TILE_DIMENSIONS * 2);
        InGameVars.GAME_CONT.touchable = false;

        InGameVars.GAME_CONT.addEventListener("heroLoaded", startTheEngine);

        addHero();

        _debug.transform = Mat23.fromMatrix(InGameVars.GAME_CONT.transformationMatrix);

        _intWallBegin = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, InGameVars.wallCollisionType, InGameVars.heroCollisionType, heroToWall);
        _intPlatEnd = new InteractionListener(CbEvent.END, InteractionType.COLLISION, InGameVars.platformCollisionType, InGameVars.heroCollisionType, heroLeavingPlat);

        _prePlatBegin = new PreListener(InteractionType.COLLISION, InGameVars.platformCollisionType, InGameVars.heroCollisionType, heroToPlatform, 0, false);

        InGameVars.NAPE_SPACE.listeners.add(_intWallBegin);
        InGameVars.NAPE_SPACE.listeners.add(_prePlatBegin);
        InGameVars.NAPE_SPACE.listeners.add(_intPlatEnd);

        this.addEventListener(KeyboardEvent.KEY_DOWN, downKey);
        this.addEventListener(KeyboardEvent.KEY_UP, upKey);

    }

    private function downKey(evt:KeyboardEvent):void {


        if(evt.keyCode == 32) iCharacter.attack();
        if(evt.keyCode == 39) {

            if(!InGameVars.RIGHT) iCharacter.move();

            InGameVars.RIGHT = true;
            iCharacter.movie.scaleX = .6;

        }

        if(evt.keyCode == 37) {

            if(!InGameVars.LEFT) iCharacter.move();

            InGameVars.LEFT = true;
            iCharacter.movie.scaleX = -.6;

        }

        if(evt.keyCode == 38) {

            if(iCharacter.jump() == "JUMP" && !InGameVars.isFalling) jump(250 * Settings.SCALE_FACTOR);
            else jump(150 * Settings.SCALE_FACTOR);
        }
    }

    private function upKey(evt:KeyboardEvent):void {

        if(evt.keyCode == 39) {

            InGameVars.RIGHT = false;
            if(!InGameVars.isFalling) iCharacter.idle();
        }

        if(evt.keyCode == 37) {

            InGameVars.LEFT = false;
            if(!InGameVars.isFalling) iCharacter.idle();
        }

        //if(evt.keyCode == 38) {  }


    }

    public function receiveDirections(action:Object):void {


    }

    private function startTheEngine():void {

        _theHero.userData.sprite = iCharacter.movie;

        this.addEventListener(Event.ENTER_FRAME, update);
    }


    private function jump(power:int):void {

        if(InGameVars.isJumping) return;
        else InGameVars.isJumping = true;

        if(InGameVars.RIGHT) _jumpDirection = 30 * Settings.SCALE_FACTOR;
        else if(InGameVars.LEFT) _jumpDirection = -30 * Settings.SCALE_FACTOR;
        else _jumpDirection = 0;

        _jumpImpulse = Vec2.weak(_jumpDirection, -500 * Settings.SCALE_FACTOR);

        _jumpImpulse.length = power;

        _theHero.applyImpulse(_jumpImpulse);
    }

    private function addHero():void {

        iCharacter = new Hero();
        iCharacter.textures();

        _theHero = iCharacter.createPhysicBody();

        _heroPos = new Point(150, 1250 - 64);
    }

    private function update(e:Event):void {

        InGameVars.NAPE_SPACE.step(InGameVars.STEPS, 10, 10);

        _debug.clear();
        _debug.draw(InGameVars.NAPE_SPACE);
        _debug.flush();

        updateGraphics(_theHero);

        _heroPos.setTo(iCharacter.movie.x, iCharacter.movie.y);
        _heroPos = iCharacter.movie.parent.localToGlobal(_heroPos);

        _camera.update(_heroPos, _theHero.velocity.y);

        if(InGameVars.RIGHT) _theHero.position.x += 2;
        if(InGameVars.LEFT) _theHero.position.x -= 2;

        _debug.transform = Mat23.fromMatrix(InGameVars.GAME_CONT.transformationMatrix);
    }

    private function updateGraphics(b:Body):void {

        var graphic:DisplayObject = b.userData.sprite;
        graphic.x = b.position.x;
        graphic.y = b.position.y;

    }

    private function heroToWall(cb:InteractionCallback):void {

        InGameVars.RIGHT = InGameVars.LEFT = false;

        if(!InGameVars.isJumping && !InGameVars.isDoubleJumping) _theHero.applyImpulse(Vec2.weak(100, 0));

    }

    private function heroLeavingPlat(cb:InteractionCallback):void {

        var arbiterList:ArbiterList = cb.arbiters;



        if(cb.int2.castBody.position.y < cb.int1.castBody.position.y) {

          if(InGameVars.onPlatform && !InGameVars.isFalling && (InGameVars.currentAnimationState == "walk" || InGameVars.currentAnimationState == "idle")) {


              iCharacter.falling();

              InGameVars.isFalling = true;
              InGameVars.onPlatform = false;

              _jumpImpulse = Vec2.weak(iCharacter.movie.scaleX * 15 * Settings.SCALE_FACTOR, -50);

              _jumpImpulse.length = 120;

              _theHero.applyImpulse(_jumpImpulse);

          }

        }
    }

    private function heroToPlatform(cb:PreCallback):PreFlag {

        var colArb:CollisionArbiter = cb.arbiter.collisionArbiter;

        if ((colArb.normal.y > 0) != cb.swapped) {

            return PreFlag.IGNORE;

        }

        else {

            InGameVars.TAP_COUNT = 0;

            if(InGameVars.isJumping == true || InGameVars.isDoubleJumping == true) {

                iCharacter.landing();

                InGameVars.RIGHT = InGameVars.LEFT = false;
                InGameVars.isJumping = InGameVars.isDoubleJumping = InGameVars.isFalling = false;

                _currentID = cb.int1.id;


            }

            if(InGameVars.isFalling && cb.int1.id != _currentID) {

                iCharacter.landing();
                InGameVars.isFalling = false;

            }

            return PreFlag.ACCEPT;
        }



    }
}
}
