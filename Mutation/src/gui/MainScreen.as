/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/8/13
 * Time: 4:25 PM
 * To change this template use File | Settings | File Templates.
 */
package gui {

import com.genome2d.components.renderables.GSprite;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import com.genome2d.signals.GMouseSignal;
import mutation.components.MBitmapText;
import mutation.events.MEvent;
import mutation.screens.MPanelScreen;
import mutation.utils.MConstant;

public class MainScreen extends MPanelScreen  {

    private var name:String;

    public function MainScreen(p_node:GNode) {

        super(p_node);

        init();

    }

    private function init():void {

        const offset:Number = MConstant.STAGE_WIDTH - MConstant.MARGIN;

        const play:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        play.textureId = "GUI_play_btn";
        play.node.transform.setPosition(offset - play.cTexture.width/2, MConstant.STAGE_HEIGHT * .6);
        node.addChild(play.node);

        const trackBuilder:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        trackBuilder.textureId = "GUI_builder";
        trackBuilder.node.transform.setPosition(offset - trackBuilder.cTexture.width/2, MConstant.STAGE_HEIGHT * .75);
        node.addChild(trackBuilder.node);
        
        const settings:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        settings.textureId = "GUI_set_btn";
        settings.node.transform.setPosition(offset - settings.cTexture.width/2, MConstant.STAGE_HEIGHT * .9);
        node.addChild(settings.node);

        play.node.mouseEnabled = true;
        play.node.name = "play";
        play.node.onMouseClick.add(triggerEvent);
        
        settings.node.mouseEnabled = true;
        settings.node.name = "settings";
        settings.node.onMouseClick.add(triggerEvent);
       
        trackBuilder.node.mouseEnabled = true;
        trackBuilder.node.name = "tb";
        trackBuilder.node.onMouseClick.add(triggerEvent);

        var text:MBitmapText = GNodeFactory.createNodeWithComponent(MBitmapText) as MBitmapText;

        text.setBitmapFont(AssetManager.bitmapFont);

        text.setup(300, 300, "Im running over an issue, im trying to deploy my game on web, and im not able to use File Class ", 50);

        text.node.transform.setPosition(150, 50);
        this.node.addChild(text.node);

    }

    private function triggerEvent(evt:GMouseSignal):void
    {
        name = evt.target.name;

        if(name == "settings") {
            node.core.stage.dispatchEvent(new MEvent(MEvent.CHANGE_SCREEN, {id: "setting"}, true));

        }
        else if(name == "play") {
            node.core.stage.dispatchEvent(new MEvent(MEvent.CHANGE_SCREEN, {id: "player"}, true));

        }
        else if(name == "tb") {
            node.core.stage.dispatchEvent(new MEvent(MEvent.CHANGE_SCREEN, {id: "builder_menu"}, true));

        }

    }

}
}
