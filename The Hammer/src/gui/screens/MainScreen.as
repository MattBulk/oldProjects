/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 1/13/14
 * Time: 7:27 PM
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

public class MainScreen extends PanelScreen {

    private var playBtn:Button;
    private var settingsBtn:Button;

    public function MainScreen() {

        super();

        this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
    }

    protected function initializeHandler(event:Event):void
    {
        this.layout = new AnchorLayout();

        playBtn = new Button();
        playBtn.defaultSkin = new Image(Constant.DEFAULT_SKIN);
        playBtn.downSkin = new Image(Constant.DOWN_SKIN);
        playBtn.name = "play";
        playBtn.addEventListener(Event.TRIGGERED, triggeredHandler);

        const rightBottomLayoutData:AnchorLayoutData = new AnchorLayoutData();
        rightBottomLayoutData.bottom = Constant.MARGIN * Settings.SCALE_FACTOR;
        rightBottomLayoutData.right = Constant.MARGIN * Settings.SCALE_FACTOR;
        this.playBtn.layoutData = rightBottomLayoutData;

        this.addChild(playBtn);

        settingsBtn = new Button();
        settingsBtn.defaultSkin = new Image(Constant.DEFAULT_SKIN);
        settingsBtn.downSkin = new Image(Constant.DOWN_SKIN);
        settingsBtn.name = "settings";
        settingsBtn.addEventListener(Event.TRIGGERED, triggeredHandler);

        const leftBottomLayoutData:AnchorLayoutData = new AnchorLayoutData();
        leftBottomLayoutData.bottom = Constant.MARGIN * Settings.SCALE_FACTOR;
        leftBottomLayoutData.left = Constant.MARGIN * Settings.SCALE_FACTOR;
        this.settingsBtn.layoutData = leftBottomLayoutData;

        this.addChild(settingsBtn);

    }

    private function triggeredHandler(evt:Event):void {

        const btn:Button = Button(evt.currentTarget);

        switch(btn.name) {
            case "play":
                this.dispatchEventWith("showWorld");
                break;
            case "settings":
                this.dispatchEventWith("showSetting");
                break;
        }

    }

}
}
