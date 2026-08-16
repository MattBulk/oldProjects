/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/13/13
 * Time: 7:52 PM
 * To change this template use File | Settings | File Templates.
 */
package gui.builder {

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


public class BuilderScreen extends MPanelScreen {

    private var name:String;

    public function BuilderScreen(p_node:GNode) {

        super(p_node);

        init();
    }

    private function init():void {

        const header:MHeader = GNodeFactory.createNodeWithComponent(MHeader) as MHeader;

        header.textureId = "ATLAS_FONT";
        header.setScale = MConstant.TEXT_MEDIUM;
        header.title = "TRACK BUILDER";

        this.node.addChild(header.node);

        const buttonGroup:MGroupButton = GNodeFactory.createNodeWithComponent(MGroupButton) as MGroupButton;

        buttonGroup.sendData = [

            {frames:["BUILDER_mountain_btn", "BUILDER_city_btn", "BUILDER_sea_btn"], text:"AREA", textScale:MConstant.TEXT_LARGE, event:"area", labelPosition:MConstant.LABEL_BOTTOM},
            {frames:["BUILDER_small", "BUILDER_medium", "BUILDER_large"], text:"SIZE", textScale:MConstant.TEXT_LARGE, event:"mode", labelPosition:MConstant.LABEL_BOTTOM}
        ];

        buttonGroup.direction = MConstant.HORIZONTAL_LAYOUT;
        buttonGroup.gap = 2.5;
        buttonGroup.init(MMovieButton, 2, "GUI_mountain_btn", null);
        buttonGroup.node.transform.y = -MConstant.STAGE_HEIGHT * .15;

        this.node.addChild(buttonGroup.node);

        const back:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        back.textureId = "GUI_back_btn";
        back.node.transform.setPosition(MConstant.STAGE_WIDTH * .5, MConstant.STAGE_HEIGHT * .9);
        node.addChild(back.node);

        const buildBtn:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        buildBtn.textureId = "BUILDER_build";
        buildBtn.node.transform.setPosition(MConstant.STAGE_WIDTH * .5, MConstant.STAGE_HEIGHT * .8);
        node.addChild(buildBtn.node);

        back.node.mouseEnabled = true;
        back.node.name = "back";
        back.node.onMouseClick.add(onSignalEvent);

        buildBtn.node.mouseEnabled = true;
        buildBtn.node.name = "build";
        buildBtn.node.onMouseClick.add(onSignalEvent);

        Settings.AREA = Settings.SIZE = 0;

    }

    private function onSignalEvent(evt:GMouseSignal):void {

        name = evt.target.name;

        switch (name) {

            case "build":
                node.core.stage.dispatchEvent(new MEvent(MEvent.CHANGE_SCREEN, {id: "builder_levelScreen"}, true));
                node.core.stage.dispatchEvent(new MEvent(MEvent.FUNCTION, {id: "setTheLabels"}, true));
                break;
            case "back":
                node.core.stage.dispatchEvent(new MEvent(MEvent.COMPLETE, {id:""}, true));
                break;
        }
    }


    override public function onButtonTriggered(evt:MEvent):void
    {
        const btn:MMovieButton = evt.params.id.getComponent(MMovieButton) as MMovieButton;

        btn.next();

        switch (btn.event) {

            case "area" :
                Settings.AREA = btn.currentFrame;
                break;
            case "mode" :
                Settings.SIZE = btn.currentFrame;
                break;

        }

    }

}
}
