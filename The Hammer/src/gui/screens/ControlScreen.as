/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 1/17/14
 * Time: 12:53 PM
 * To change this template use File | Settings | File Templates.
 */
package gui.screens {

import events.ControlsEvent;

import feathers.controls.Button;
import feathers.controls.ButtonGroup;
import feathers.controls.PanelScreen;
import feathers.data.ListCollection;
import feathers.events.FeathersEventType;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;

import gui.Constant;
import starling.display.Image;

import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import utils.Settings;

    public class ControlScreen extends PanelScreen {

        private var _rightControls:ButtonGroup, _leftControls:ButtonGroup;
        private var _touch:Touch;

        private var _command:String;

    public function ControlScreen() {

        super();

        this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
    }

    protected function initializeHandler(event:Event):void
    {

        this.layout = new AnchorLayout();

        /// RIGHT BUTTON GROUP
        this._rightControls = new ButtonGroup();
        this._rightControls.gap = Constant.MARGIN;
        this._rightControls.dataProvider = new ListCollection(
                [
                    { label: "ATTACK", triggered: triggeredHandler, defaultIcon: new Image(Constant.HAMMER_0) },
                    { label: "JUMP", triggered: triggeredHandler, defaultIcon: new Image(Constant.HAMMER_0) }

                ]);

        const rightBottomLayoutData:AnchorLayoutData = new AnchorLayoutData();
        rightBottomLayoutData.bottom = Constant.MARGIN * Settings.SCALE_FACTOR;
        rightBottomLayoutData.right = Constant.MARGIN * Settings.SCALE_FACTOR;

        this._rightControls.layoutData = rightBottomLayoutData;
        this._rightControls.direction = ButtonGroup.DIRECTION_HORIZONTAL;
        this._rightControls.buttonFactory = createButtons;


        this.addChild(_rightControls);

        /// RIGHT BUTTON GROUP
        this._leftControls = new ButtonGroup();
        this._leftControls.gap = Constant.MARGIN;
        this._leftControls.dataProvider = new ListCollection(
                [
                    { label: "LEFT", defaultIcon: new Image(Constant.HAMMER_0) },
                    { label: "RIGHT", defaultIcon: new Image(Constant.HAMMER_0) }

                ]);

        const leftBottomLayoutData:AnchorLayoutData = new AnchorLayoutData();
        leftBottomLayoutData.bottom = Constant.MARGIN * Settings.SCALE_FACTOR;
        leftBottomLayoutData.left = Constant.MARGIN * Settings.SCALE_FACTOR;

        this._leftControls.layoutData = leftBottomLayoutData;
        this._leftControls.direction = ButtonGroup.DIRECTION_HORIZONTAL;
        this._leftControls.buttonFactory = createButtons;

        this.addChild(_leftControls);

        //rightControls.addEventListener(TouchEvent.TOUCH, onTouch);
        _leftControls.addEventListener(TouchEvent.TOUCH, onTouch);

    }

    private static function createButtons():Button {

        const button:Button = new Button();
        button.defaultSkin = new Image(Constant.DEFAULT_SKIN);
        button.downSkin = new Image(Constant.DOWN_SKIN);
        button.scaleX = .8;
        return button;

    }

    public function onTouch(e:TouchEvent):void
    {
        _touch = e.getTouch(stage);

        if(_touch) {

            const btn:Button = Button(e.target);

            _command = btn.label;

            switch(_touch.phase) {
                case TouchPhase.BEGAN:
                    this.dispatchEvent(new ControlsEvent(ControlsEvent.SET_CONTROL, _command, true));

                    break;
                case TouchPhase.ENDED:
                    this.dispatchEvent(new ControlsEvent(ControlsEvent.SET_CONTROL, _command, true));

                    break;
            }
        }

    }

    private function triggeredHandler(evt:Event):void
    {

        const btn:Button = Button(evt.target);

        _command = btn.label;

        this.dispatchEvent(new ControlsEvent(ControlsEvent.SET_CONTROL, _command, true));

    }

    }
}
