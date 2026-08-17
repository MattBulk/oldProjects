/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 1/14/14
 * Time: 9:52 AM
 * To change this template use File | Settings | File Templates.
 */
package gui.screens {

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

import utils.Settings;

public class WorldScreen extends PanelScreen {

    private var backBtn:Button;

    private var buttonGroup:ButtonGroup;

    public function WorldScreen() {

        super();

        this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);

    }

    protected function initializeHandler(event:Event):void
    {

        this.layout = new AnchorLayout();

        backBtn = Constant.getBackButton();
        backBtn.addEventListener(Event.TRIGGERED, triggeredHandler);

        const backLayoutData:AnchorLayoutData = new AnchorLayoutData();
        backLayoutData.horizontalCenter = 0;
        backLayoutData.top = Constant.MARGIN * Settings.SCALE_FACTOR;

        this.backBtn.layoutData = backLayoutData;
        this.addChild(backBtn);

        /// BUTTON GROUP
        this.buttonGroup = new ButtonGroup();
        this.buttonGroup.gap = Constant.MARGIN + Constant.STAGE_WIDTH * .05 * Settings.SCALE_FACTOR;
        this.buttonGroup.dataProvider = new ListCollection(
                [
                    { label: "0", triggered: triggeredHandler, defaultIcon: new Image(Constant.HAMMER_0) },
                    { label: "1", triggered: triggeredHandler, defaultIcon: new Image(Constant.HAMMER_0) },
                    { label: "2", triggered: triggeredHandler, defaultIcon: new Image(Constant.HAMMER_0) }

                ]);

        const buttonGroupLayoutData:AnchorLayoutData = new AnchorLayoutData();
        buttonGroupLayoutData.horizontalCenter = 0;
        buttonGroupLayoutData.verticalCenter = Constant.STAGE_HEIGHT * .1;

        this.buttonGroup.layoutData = buttonGroupLayoutData;
        this.buttonGroup.direction = ButtonGroup.DIRECTION_HORIZONTAL;

        buttonGroup.buttonFactory = function():Button
        {
            var button:Button = new Button();
            button.defaultSkin = Constant.getScaledImage(Constant.BIG_DEFAULT_SKIN, .64, 1.12);
            button.downSkin = Constant.getScaledImage(Constant.BIG_DOWN_SKIN, .64, 1.12);
            return button;
        };

        this.addChild(buttonGroup);

    }

    private function triggeredHandler(evt:Event):void
    {
        const btn:Button = Button(evt.currentTarget);

        switch(btn.name) {
            case "back":

                this.dispatchEventWith("complete");
                break;
            default :
                Settings.WORLD = uint(btn.label);
                this.dispatchEventWith("showScreen");
                break;
        }

    }
}
}
