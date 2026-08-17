/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 1/14/14
 * Time: 4:09 PM
 * To change this template use File | Settings | File Templates.
 */
package gui {

import feathers.controls.IScreen;
import feathers.controls.ScreenNavigator;

import flash.utils.getQualifiedClassName;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;

public class ScreenSlidingDirectionsStackTransitionManager {

    public function ScreenSlidingDirectionsStackTransitionManager(navigator:ScreenNavigator, quickStackScreenClass:Class = null, quickStackScreenID:String = null) {

        if(!navigator)
        {
            throw new ArgumentError("ScreenNavigator cannot be null.");
        }

        this.navigator = navigator;

        var quickStack:String;
        if(quickStackScreenClass)
        {
            quickStack = getQualifiedClassName(quickStackScreenClass);
        }

        if(quickStack && quickStackScreenID)
        {
            quickStack += "~" + quickStackScreenID;
        }

        if(quickStack)
        {
            this._stack.push(quickStack);
        }
        this.navigator.transition = this.onTransition;

        //this.navigator.

    }

    /**
     * The <code>ScreenNavigator</code> being managed.
     */
    protected var navigator:ScreenNavigator;

    /**
     * @private
     */
    protected var _stack:Vector.<String> = new <String>[];

    /**
     * @private
     */
    protected var _activeTransition:Tween;

    /**
     * @private
     */
    protected var _savedOtherTarget:DisplayObject;

    /**
     * @private
     */
    protected var _savedCompleteHandler:Function;

    /**
     * @setTheDirections
     */
    public var directions:Vector.<Object> = new <Object>[];

    /**
     * The duration of the transition, in seconds.
     *
     * @default 0.25
     */
    public var duration:Number = 0.25;

    /**
     * A delay before the transition starts, measured in seconds. This may
     * be required on low-end systems that will slow down for a short time
     * after heavy texture uploads.
     *
     * @default 0.1
     */
    public var delay:Number = 0.1;

    /**
     * The easing function to use.
     *
     * @default starling.animation.Transitions.EASE_OUT
     */
    public var ease:Object = Transitions.EASE_OUT;

    /**
     * Determines if the next transition should be skipped. After the
     * transition, this value returns to <code>false</code>.
     *
     * @default false
     */
    public var skipNextTransition:Boolean = false;

    /**
     * Removes all saved classes from the stack that are used to determine
     * which side of the <code>ScreenNavigator</code> the new screen will
     * slide in from.
     */
    public function clearStack():void
    {
        this._stack.length = 0;
    }

    /**
     * The function passed to the <code>transition</code> property of the
     * <code>ScreenNavigator</code>.
     */
    protected function onTransition(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
    {
        if(this._activeTransition)
        {
            this._savedOtherTarget = null;
            Starling.juggler.remove(this._activeTransition);
            this._activeTransition = null;
        }

        if(!oldScreen || !newScreen || this.skipNextTransition)
        {
            this.skipNextTransition = false;
            this._savedCompleteHandler = null;
            if(newScreen)
            {
                newScreen.x = 0;
            }
            if(oldScreen)
            {
                oldScreen.x = 0;
            }
            if(onComplete != null)
            {
                onComplete();
            }
            return;
        }

        this._savedCompleteHandler = onComplete;

        var newScreenClassAndID:String = getQualifiedClassName(newScreen);
        if(newScreen is IScreen)
        {
            newScreenClassAndID += "~" + IScreen(newScreen).screenID;
            checkId(IScreen(newScreen).screenID);
        }
        var stackIndex:int = this._stack.indexOf(newScreenClassAndID);

        var activeTransition_onUpdate:Function;
        if(stackIndex < 0)
        {
            var oldScreenClassAndID:String = getQualifiedClassName(oldScreen);
            if(oldScreen is IScreen)
            {
                oldScreenClassAndID += "~" + IScreen(oldScreen).screenID;
            }
            this._stack.push(oldScreenClassAndID);
            if(_direction == 0) {

                oldScreen.x = 0;
                newScreen.x = this.navigator.width;
                _dirString = "x";

            }
            else {

                oldScreen.y = 0;
                newScreen.y = this.navigator.height;
                _dirString = "y";

            }

            activeTransition_onUpdate = this.activeTransitionPush_onUpdate;
        }
        else
        {
            this._stack.length = stackIndex;
            if(_direction == 0) {

                oldScreen.x = 0;
                newScreen.x = -this.navigator.width;
                _dirString = "x";

            }
            else {

                oldScreen.y = 0;
                newScreen.y = -this.navigator.height;
                _dirString = "y";

            }
            activeTransition_onUpdate = this.activeTransitionPop_onUpdate;
        }
        this._savedOtherTarget = oldScreen;
        if(newScreen)
        {
            newScreen.alpha = 0;
            if(oldScreen) //oldScreen can be null, that's okay
            {
                oldScreen.alpha = 1;
            }
            this._savedOtherTarget = oldScreen;
            this._activeTransition = new Tween(newScreen, this.duration, this.ease);
            this._activeTransition.animate(_dirString, 0);
            this._activeTransition.fadeTo(1);
            this._activeTransition.delay = this.delay;
            this._activeTransition.onUpdate = activeTransition_onUpdate;
            this._activeTransition.onComplete = activeTransition_onComplete;
        }
        else //we only have the old screen
        {
            oldScreen.alpha = 1;
            this._activeTransition = new Tween(oldScreen, this.duration, this.ease);
            this._activeTransition.animate(_dirString, 0);
            this._activeTransition.fadeTo(0);
            this._activeTransition.delay = this.delay;
            this._activeTransition.onComplete = activeTransition_onComplete;
        }

        Starling.juggler.add(this._activeTransition);
    }

    /**
     * @private
     */
    protected function activeTransitionPush_onUpdate():void
    {
        if(this._savedOtherTarget)
        {
            const newScreen:DisplayObject = DisplayObject(this._activeTransition.target);
            if(_direction == 1) this._savedOtherTarget.y = newScreen.y - this.navigator.height;
            else this._savedOtherTarget.x = newScreen.x - this.navigator.width;
            this._savedOtherTarget.alpha = 1 - newScreen.alpha;
        }
    }

    /**
     * @private
     */
    protected function activeTransitionPop_onUpdate():void
    {
        if(this._savedOtherTarget)
        {
            const newScreen:DisplayObject = DisplayObject(this._activeTransition.target);
            if(_direction == 1) this._savedOtherTarget.y = newScreen.y + this.navigator.height;
            else this._savedOtherTarget.x = newScreen.x + this.navigator.width;
            this._savedOtherTarget.alpha = 1 - newScreen.alpha;
        }
    }

    /**
     * @private
     */
    protected function activeTransition_onComplete():void
    {
        this._activeTransition = null;
        this._savedOtherTarget = null;
        if(this._savedCompleteHandler != null)
        {
            this._savedCompleteHandler();
        }
    }

    /**
     * @vertical or horizontal
     */
    private var _direction:uint;
    private var _dirString:String;

    /**
     * @checkTheIds
     */
    protected function checkId(id:String):void {

       for(var i:uint=0; i<=directions.length-1; i++) {

           if(directions[i].id == id) _direction = directions[i].direction;
       }
    }
}
}
