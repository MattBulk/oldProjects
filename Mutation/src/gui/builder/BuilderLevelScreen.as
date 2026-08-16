/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/13/13
 * Time: 8:40 PM
 * To change this template use File | Settings | File Templates.
 */
package gui.builder {

import com.genome2d.components.renderables.GSprite;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import com.genome2d.signals.GMouseSignal;

import mutation.components.MActionButton;
import mutation.components.MHeader;
import mutation.components.MMovieButton;
import mutation.components.MTiledButton;
import mutation.display.M3Texture;
import mutation.events.MEvent;
import mutation.screens.MPanelScreen;
import mutation.utils.MConstant;


public class BuilderLevelScreen extends MPanelScreen {

    private var name:String;
    private var back:GSprite;
    private var deleteBtn:MMovieButton;
    private var buttonGroup:MTiledButton;
    private var DELETE:Boolean;

    public function BuilderLevelScreen(p_node:GNode) {

        super(p_node);

        init();
    }

    private function init():void {

        const header:MHeader = GNodeFactory.createNodeWithComponent(MHeader) as MHeader;

        header.textureId = MConstant.FONT_ATLAS;
        header.setScale = MConstant.TEXT_LARGE;
        header.title = "TRACK BUILDER";

        var mt:M3Texture = new M3Texture("GUI_level_btn", 25, 25, M3Texture.DIRECTION_HORIZONTAL);


        this.node.addChild(header.node);

        buttonGroup = GNodeFactory.createNodeWithComponent(MTiledButton) as MTiledButton;

        buttonGroup.sendData = [

            {text:"1", textScale:MConstant.TEXT_MEDIUM, actionId:"BUILDER_delete_x"},
            {text:"2", textScale:MConstant.TEXT_MEDIUM, actionId:"BUILDER_delete_x"},
            {text:"3", textScale:MConstant.TEXT_MEDIUM, actionId:"BUILDER_delete_x"},
            {text:"4", textScale:MConstant.TEXT_MEDIUM, actionId:"BUILDER_delete_x"},
            {text:"5", textScale:MConstant.TEXT_MEDIUM, actionId:"BUILDER_delete_x"},
            {text:"6", textScale:MConstant.TEXT_MEDIUM, actionId:"BUILDER_delete_x"},
            {text:"7", textScale:MConstant.TEXT_MEDIUM, actionId:"BUILDER_delete_x"},
            {text:"8", textScale:MConstant.TEXT_MEDIUM, actionId:"BUILDER_delete_x"},
            {text:"9", textScale:MConstant.TEXT_MEDIUM, actionId:"BUILDER_delete_x"}

        ];

        buttonGroup.gap = 1.3;
        buttonGroup.init(MActionButton, 9, "", mt);

        buttonGroup.node.transform.y = -MConstant.STAGE_HEIGHT * .07;

        this.node.addChild(buttonGroup.node);

        back = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        back.textureId = "GUI_back_btn";
        back.node.transform.setPosition(MConstant.STAGE_WIDTH * .5, MConstant.STAGE_HEIGHT * .9);
        node.addChild(back.node);

        back.node.mouseEnabled = true;
        back.node.name = "back";
        back.node.onMouseClick.add(onSignalEvent);

        deleteBtn = GNodeFactory.createNodeWithComponent(MMovieButton) as MMovieButton;
        deleteBtn.frames = ["BUILDER_delete", "BUILDER_ok_btn"];
        deleteBtn.textureId = "BUILDER_delete";
        deleteBtn.node.name = "delete";
        deleteBtn.node.transform.setPosition(MConstant.STAGE_WIDTH * .5, MConstant.STAGE_HEIGHT * .8);
        node.addChild(deleteBtn.node);

        deleteBtn.node.onMouseClick.add(onSignalEvent);

    }

    private function onSignalEvent(evt:GMouseSignal):void {

        name = evt.target.name;

        switch (name) {

            case "back":
                node.core.stage.dispatchEvent(new MEvent(MEvent.COMPLETE, {id:""}, true));
                break;
            case "delete":
                if(deleteBtn.currentFrame == 0) {
                    back.node.active = false;
                    deletePhase(true);
                }
                else {
                    back.node.active = true;
                    deletePhase(false);
                }
                deleteBtn.next();
                break;

        }

    }

    private function deletePhase(b:Boolean):void {

        for(var i:uint=0; i<=buttonGroup.groupVec.length-1; i++) {

            if(buttonGroup.groupVec[i].text != "NEW") {

                buttonGroup.groupVec[i].actionBtn.node.active = b;
                buttonGroup.groupVec[i].actionMode = b;
            }
        }

        DELETE = b;
    }

    private function setTheLabels():void {

        for(var i:uint=0; i<=buttonGroup.groupVec.length-1; i++) {



        }
    }

    override public function onFunctionTrigger(evt:MEvent):void {

        this[evt.params.id]();
    }

    override public function onButtonTriggered(evt:MEvent):void
    {
        const btn:MActionButton = evt.params.id.getComponent(MActionButton) as MActionButton;
    }

    override public function onActionTriggered(evt:MEvent):void
    {
        //SET THE BUTTON LIKE FEATHERS AND GET THE INFO YOU NEED
        var btn:GSprite = evt.params.id.getComponent(GSprite) as GSprite;

        btn.node.active = false;

        //SET THE NUMBER AS STRING VARIABLE AND DELETE THE TRACK
        var number:String = (btn.node.parent.getComponent(MActionButton) as MActionButton).text;

        //SET BUTTON PROPERTIES
        (btn.node.parent.getComponent(MActionButton) as MActionButton).textScale = MConstant.TEXT_MEDIUM;
        (btn.node.parent.getComponent(MActionButton) as MActionButton).text = "NEW";
        (btn.node.parent.getComponent(MActionButton) as MActionButton).actionMode = false;
        (btn.node.parent.getComponent(MActionButton) as MActionButton).node.name = "NEW";


    }
}
}
