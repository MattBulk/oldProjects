/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/13/13
 * Time: 5:28 PM
 * To change this template use File | Settings | File Templates.
 */
package gui {

import com.genome2d.components.renderables.GSprite;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import com.genome2d.signals.GMouseSignal;

import flash.geom.Rectangle;

import mutation.components.MHeader;
import mutation.components.MSimpleButton;
import mutation.components.MTiledButton;
import mutation.display.M3Texture;
import mutation.display.M9Texture;
import mutation.events.MEvent;
import mutation.screens.MPanelScreen;
import mutation.utils.MConstant;


public class LevelScreen extends MPanelScreen {

    private var buttonGroup:MTiledButton;

    public function LevelScreen(p_node:GNode) {

        super(p_node);

        init();
    }

    private function init():void {

        var header:MHeader = GNodeFactory.createNodeWithComponent(MHeader) as MHeader;

        header.textureId = MConstant.FONT_ATLAS;
        header.setScale = MConstant.TEXT_MEDIUM;
        header.title = "SELECT THE LEVEL";

        this.node.addChild(header.node);

        //var mt:M3Texture = new M3Texture("GUI_level_btn", 25, 25, M3Texture.DIRECTION_HORIZONTAL);
        var mt:M9Texture = new M9Texture("GUI_level_btn",new Rectangle(25,25,100,100));

        buttonGroup = GNodeFactory.createNodeWithComponent(MTiledButton) as MTiledButton;

        buttonGroup.sendData = [

            {text:"1", textScale:MConstant.TEXT_LARGE},
            {text:"2", textScale:MConstant.TEXT_LARGE},
            {text:"3", textScale:MConstant.TEXT_LARGE},
            {text:"4", textScale:MConstant.TEXT_LARGE},
            {text:"5", textScale:MConstant.TEXT_LARGE},
            {text:"6", textScale:MConstant.TEXT_LARGE}

        ];

        buttonGroup.gap = 1.3;
        buttonGroup.init(MSimpleButton, 6, "GUI_level_btn", mt);
        buttonGroup.node.transform.setPosition(0 , -MConstant.STAGE_HEIGHT * .08);

        this.node.addChild(buttonGroup.node);

        var back:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        back.textureId = "GUI_back_btn";
        back.node.transform.setPosition(MConstant.STAGE_WIDTH * .5, MConstant.STAGE_HEIGHT * .9);
        node.addChild(back.node);

        back.node.mouseEnabled = true;
        back.node.onMouseClick.add(completeEvent);

    }


    private function completeEvent(evt:GMouseSignal):void {


        node.core.stage.dispatchEvent(new MEvent(MEvent.COMPLETE, {id:""}, true));
        AssetManager.disposeAtlasTexture("world");
        AssetManager.disposeBitmapTexture("tile");

    }

    protected function fl_TimerHandler():void
    {
        node.core.stage.dispatchEvent(new MEvent(MEvent.COMPLETE, {id:""}, true));
    }

    override public function onButtonTriggered(evt:MEvent):void
    {
        var btn:MSimpleButton = evt.params.id.getComponent(MSimpleButton) as MSimpleButton;

        if(btn.text == "EMPTY") return;

        Settings.LEVEL = uint(btn.text);

    }


}
}
