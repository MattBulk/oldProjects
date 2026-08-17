/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 1/14/14
 * Time: 7:46 PM
 * To change this template use File | Settings | File Templates.
 */
package gui.screens {
import feathers.controls.Button;
import feathers.controls.PanelScreen;
import feathers.events.FeathersEventType;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;

import gui.Constant;

import starling.events.Event;

import utils.Settings;

public class SettingScreen extends PanelScreen {

    private var backBtn:Button;

    public function SettingScreen() {

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
                break;
        }

    }
}
}
