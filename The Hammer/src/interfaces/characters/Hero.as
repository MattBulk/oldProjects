/**
 * Created by 22BoX on 2/7/14.
 */
package interfaces.characters {

import buildingTools.InGameVars;

import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.ArmatureEvent;
import dragonBones.factorys.StarlingFactory;

import interfaces.ICharacters;

import nape.dynamics.InteractionGroup;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Polygon;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import flash.events.Event;

import utils.Settings;

public class Hero implements ICharacters {

    private var _currentTime:Number, _oldTime:Number;
    private var _str:String;

    private var _factory:StarlingFactory;
    private var _armature:Armature;
    private var _armatureClip:Sprite = new Sprite();

    public function Hero() {

        super();
    }

    public function textures():void {

        _factory = new StarlingFactory();
        //_factory.scaleForTexture = .6;

        _factory.parseData(TheAtlasLoader.getInstance().assets.getByteArray("Hero"));

        _factory.addEventListener(Event.COMPLETE, textureCompleteHandler);
    }

    public function createPhysicBody():Body {

        const body:Body = new Body(BodyType.DYNAMIC);
        body.position.setxy(150, 1250 - 64);
        body.cbTypes.add(InGameVars.heroCollisionType);

        //var box:Polygon = new Polygon(Polygon.box(90 * Settings.SCALE_FACTOR, 90 * Settings.SCALE_FACTOR));
        const box:Circle = new Circle(45);

        //body.group = new InteractionGroup(true);

        box.material.elasticity = 0;
        box.material.density = .04 / Settings.SCALE_FACTOR;

        body.allowRotation = false;
        body.gravMass = 2;

        body.shapes.add(box);

        body.space = InGameVars.NAPE_SPACE;

        return body;
    }

    public function jump():String {

        if(InGameVars.isDoubleJumping) return _str = "NULL";

        _currentTime = Starling.juggler.elapsedTime;

        InGameVars.TAP_COUNT++;

        InGameVars.onPlatform = false;

        if(InGameVars.TAP_COUNT == 1) {

            _oldTime = _currentTime;
            jumpMovie();
        }
        if(InGameVars.TAP_COUNT == 2) {

            const checkTiming:Number = _currentTime - _oldTime;

            if(checkTiming <= .3) {

                InGameVars.isDoubleJumping = true;
                InGameVars.isJumping = false;
                _str = "DOUBLE_JUMP";
            }

            InGameVars.TAP_COUNT = 0;

        }

        else _str = "JUMP";

        return _str;
    }

    public function die():void {

        //goto die frame
    }

    public function attack():void {

        _armature.animation.gotoAndPlay("attack");
    }

    public function get movie():Sprite {

        return _armatureClip;
    }

    public function move():void {

        _armature.animation.gotoAndPlay("walk");
    }

    public function idle():void {

        _armature.animation.gotoAndPlay("idle");
    }

    public function landing():void {

        _armature.animation.gotoAndPlay("land");
    }

    public function falling():void {

        _armature.animation.gotoAndPlay("fall");
    }

    public function jumpMovie():void {

        _armature.animation.gotoAndPlay("jump");
    }

    private function textureCompleteHandler(evt:Event):void
    {
        _armature = _factory.buildArmature("Hero");
        _armature.addEventListener(dragonBones.events.AnimationEvent.COMPLETE, whichCompleted, false, 0, true);
        _armature.addEventListener(dragonBones.events.AnimationEvent.START, whichStarted, false, 0, true);
        _armatureClip = _armature.display as Sprite;

        _armatureClip.scaleX = _armatureClip.scaleY = .6;

        _armature.display.pivotY = -_armature.display.height * .65;
        _armature.display.x = 150;
        _armature.display.y = 1250 - 64;

        InGameVars.GAME_CONT.addChild(_armatureClip);
        WorldClock.clock.add(_armature);

        InGameVars.GAME_CONT.dispatchEventWith("heroLoaded");

        InGameVars.GAME_CONT.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrameHandler);

    }

    private function onEnterFrameHandler(e:EnterFrameEvent):void
    {
        WorldClock.clock.advanceTime(-1);

    }

    private function whichCompleted(evt:dragonBones.events.AnimationEvent):void {

        if(evt.animationState.name == "land") {

            _armature.animation.gotoAndPlay("idle");



        }

    }

    private function whichStarted(evt:dragonBones.events.AnimationEvent):void {

        InGameVars.currentAnimationState = evt.animationState.name;

        //trace(evt.animationState.name);

        if(InGameVars.currentAnimationState == "land" || InGameVars.currentAnimationState == "walk" ) {

            InGameVars.onPlatform = true;
            trace("SI")
        }

    }


}
}
