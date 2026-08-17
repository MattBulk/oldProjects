/**
 * Created by 22BoX on 2/11/14.
 */
package interfaces.modalities {
import buildingTools.Camera;
import buildingTools.InGameVars;
import buildingTools.TileSystem;

import flash.geom.Point;

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
import nape.dynamics.CollisionArbiter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.space.Space;

import starling.core.Starling;

import starling.display.DisplayObject;

import starling.display.Sprite;
import starling.events.Event;

import utils.Settings;

import utils.WriteTheFile;

public class Arcade extends Sprite implements IModality {

    private var _tileSystem:TileSystem;

    private var _interactionListener:InteractionListener;
    private var _interactionPlatform:PreListener;
    //HERO
    private var iCharacter:ICharacters;
    private var _theHero:Body;

    private var _jumpImpulse:Vec2;

    private var jumpDirection:int = 0;

    private var _camera:Camera;

    private var _heroPos:Point;

    public function Arcade() {
        super();
    }

    public function loadTheLevel():void {

        WriteTheFile.getInstance().loadSceneXML("db/1-1.xml");

        _tileSystem = new TileSystem(WriteTheFile.getInstance().loadedCurrentRoom);

    }

    public function init():void {

        InGameVars.NAPE_SPACE = new Space(new Vec2(0, 400));

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
        InGameVars.GAME_CONT.y = Constant.STAGE_HEIGHT - 128;
        InGameVars.GAME_CONT.touchable = false;

        InGameVars.GAME_CONT.addEventListener("heroLoaded", startTheEngine);

        addHero();

        _interactionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, InGameVars.wallCollisionType, InGameVars.heroCollisionType, heroToWall);
        _interactionPlatform = new PreListener(InteractionType.COLLISION, InGameVars.platformCollisionType, InGameVars.heroCollisionType, heroToPlatform);

        InGameVars.NAPE_SPACE.listeners.add(_interactionListener);
        InGameVars.NAPE_SPACE.listeners.add(_interactionPlatform);

    }

    public function receiveDirections(action:Object):void {

        switch(action) {

            case "RIGHT":
                InGameVars.RIGHT = !InGameVars.RIGHT;
                if(InGameVars.RIGHT) {

                    iCharacter.move();
                    iCharacter.movie.scaleX = 1;
                }
                else iCharacter.idle();

                break;
            case "LEFT":
                InGameVars.LEFT = !InGameVars.LEFT;
                if(InGameVars.LEFT) {

                    iCharacter.move();
                    iCharacter.movie.scaleX = -1;
                }
                else iCharacter.idle();
                break;

            case "JUMP":
                if(iCharacter.jump() == "JUMP") jump(380 * Settings.SCALE_FACTOR);
                else jump(260 * Settings.SCALE_FACTOR);
                break;

            case "ATTACK":
                iCharacter.attack();
                break;

        }

    }

    private function startTheEngine():void {

        _theHero.userData.sprite = iCharacter.movie;
        this.addEventListener(Event.ENTER_FRAME, update);
    }

    private function jump(power:int):void {

        if(InGameVars.isJumping) return;
        else InGameVars.isJumping = true;

        if(InGameVars.RIGHT) jumpDirection = 30 * Settings.SCALE_FACTOR;
        else if(InGameVars.LEFT) jumpDirection = -30 * Settings.SCALE_FACTOR;
        else jumpDirection = 0;

        _jumpImpulse = Vec2.weak(jumpDirection, -500);

        _jumpImpulse.length = power;

        _theHero.applyImpulse(_jumpImpulse);
    }

    private function addHero():void {

        iCharacter = new Hero();
        iCharacter.textures();

        _theHero = iCharacter.createPhysicBody();

        _heroPos = new Point(150, 1280 - 64);
    }

    private function update(e:Event):void {

        InGameVars.NAPE_SPACE.step(InGameVars.STEPS, 10, 10);

        updateGraphics(_theHero);

        _heroPos.setTo(iCharacter.movie.x, iCharacter.movie.y);
        _heroPos = iCharacter.movie.parent.localToGlobal(_heroPos);

        _camera.update(_heroPos, _theHero.velocity.y);

        if(InGameVars.RIGHT) _theHero.position.x += 4;
        if(InGameVars.LEFT) _theHero.position.x -= 4;

    }

    private static function updateGraphics(b:Body):void {

        var graphic:DisplayObject = b.userData.sprite;
        graphic.x = b.position.x;
        graphic.y = b.position.y;

    }

    private function heroToWall(cb:InteractionCallback):void {

        InGameVars.RIGHT = InGameVars.LEFT = false;

        if(!InGameVars.isJumping && !InGameVars.isDoubleJumping) _theHero.applyImpulse(Vec2.weak(100, 0));

    }

    private static function heroToPlatform(cb:PreCallback):PreFlag {


        var colArb:CollisionArbiter = cb.arbiter.collisionArbiter;

        if ((colArb.normal.y > 0) != cb.swapped) {
            return PreFlag.IGNORE;
        }
        else {
            InGameVars.isJumping = InGameVars.isDoubleJumping = false;
            InGameVars.TAP_COUNT = 0;
            return PreFlag.ACCEPT;
        }

    }
}
}
