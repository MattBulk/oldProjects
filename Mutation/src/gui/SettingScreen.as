/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/8/13
 * Time: 5:10 PM
 * To change this template use File | Settings | File Templates.
 */
package gui {

import com.genome2d.components.renderables.GSprite;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import com.genome2d.signals.GMouseSignal;
import mutation.components.MGroupButton;
import mutation.components.MHeader;
import mutation.components.MMovieButton;
import mutation.events.MEvent;
import mutation.screens.MPanelScreen;
import mutation.utils.MConstant;

public class SettingScreen extends MPanelScreen {

    public function SettingScreen(p_node:GNode) {

        super(p_node);

        init();

    }

    private function init():void {

        const header:MHeader = GNodeFactory.createNodeWithComponent(MHeader) as MHeader;

        header.textureId = "ATLAS_FONT";
        header.title = "SETTINGS";

        this.node.addChild(header.node);

        const buttonGroup:MGroupButton = GNodeFactory.createNodeWithComponent(MGroupButton) as MGroupButton;

        buttonGroup.sendData = [

            {frames:["GUI_level_01", "GUI_level_02", "GUI_level_03"], text:"", event:"level"},
            {frames:["GUI_mode_01", "GUI_mode_02"], text:"", event:"mode"},
            {frames:["GUI_sound_on", "GUI_sound_off"], text:"", event:"sound"}
        ];

        buttonGroup.direction = MConstant.VERTICAL_LAYOUT;
        buttonGroup.gap = 1.5;
        buttonGroup.init(MMovieButton, 3, "GUI_level_01");

        this.node.addChild(buttonGroup.node);

        const back:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        back.textureId = "GUI_back_btn";
        back.node.transform.setPosition(MConstant.STAGE_WIDTH * .5, MConstant.STAGE_HEIGHT * .9);
        node.addChild(back.node);

        back.node.mouseEnabled = true;
        back.node.onMouseClick.add(completeEvent);

        buttonGroup.groupVec[0].gotoFrame(1);

        Settings.DIFFICULTY = buttonGroup.groupVec[0].currentFrame;
        Settings.MODE = buttonGroup.groupVec[1].currentFrame;

    }

    private function completeEvent(evt:GMouseSignal):void {

        node.core.stage.dispatchEvent(new MEvent(MEvent.COMPLETE, {id:""}, true));

    }

    override public function onButtonTriggered(evt:MEvent):void
    {
        const btn:MMovieButton = evt.params.id.getComponent(MMovieButton) as MMovieButton;

        btn.next();

    }
}
}
