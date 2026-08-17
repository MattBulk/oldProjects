/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 1/14/14
 * Time: 9:53 AM
 * To change this template use File | Settings | File Templates.
 */
package gui.screens {
import feathers.controls.Button;
import feathers.controls.PanelScreen;
import feathers.events.FeathersEventType;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;

import gui.Constant;

import starling.display.Image;

import starling.events.Event;

import utils.Settings;

public class ManualScreen extends PanelScreen {

    private var playBtn:Button;

    public function ManualScreen() {

        super();

        this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
    }

    protected function initializeHandler(event:Event):void
    {
        this.layout = new AnchorLayout();

        playBtn = new Button();
        playBtn.defaultSkin = new Image(Constant.DEFAULT_SKIN);
        playBtn.downSkin = new Image(Constant.DOWN_SKIN);
        playBtn.name = "back";
        playBtn.addEventListener(Event.TRIGGERED, triggeredHandler);

        const rightBottomLayoutData:AnchorLayoutData = new AnchorLayoutData();
        rightBottomLayoutData.bottom = Constant.MARGIN * Settings.SCALE_FACTOR;
        rightBottomLayoutData.right = Constant.MARGIN * Settings.SCALE_FACTOR;
        this.playBtn.layoutData = rightBottomLayoutData;

        this.addChild(playBtn);

    }

    private function triggeredHandler(evt:Event):void {

        const btn:Button = Button(evt.currentTarget);

        switch(btn.name) {
            case "back":
                this.dispatchEventWith("complete");
                break;
            case "settings":
                this.dispatchEventWith("showSetting");
                break;
        }

    }
}
}
