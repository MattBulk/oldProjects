/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/5/13
 * Time: 8:48 PM
 * To change this template use File | Settings | File Templates.
 */
package mutation.components {

import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureBase;
import mutation.display.M3Image;
import mutation.display.M3Texture;
import mutation.display.M9Image;
import mutation.display.M9Texture;
import mutation.utils.MConstant;

public class MSimpleButton extends GSprite {

    protected var _label:GTextureText;
    protected var _icon:GSprite;
    protected var _textureHeight:Number, _textureWidth:Number;
    protected var _isSelected:Boolean;
    protected var _event:String;

    private var _m3Img:M3Image;
    private var _m9Img:M9Image;

    public function MSimpleButton(p_node:GNode) {

        super(p_node);

        _label = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
        _label.textureAtlasId = MConstant.FONT_ATLAS;

        this.node.mouseEnabled = true;

        node.addChild(_label.node);

    }

    override public function set textureId(p_value:String):void {

        cTexture = GTextureBase.getTextureBaseById(p_value) as GTexture;

        _textureWidth = cTexture.width;
        _textureHeight = cTexture.height;

    }

    //************************************************** PRIVATE METHODS ***********************************************

    private function validatePositions():void {

        _label.node.transform.setPosition(-_label.width * .5, -_label.height * .5);

    }

    public function scale9(m9Texture:M9Texture, width:uint, height:uint):void {

        _m9Img = GNodeFactory.createNodeWithComponent(M9Image) as M9Image;
        _m9Img.scale9Image(m9Texture);

        _m9Img.width = width;
        _m9Img.height = height;

        this.node.addChild(_m9Img.node);

        this.node.putChildToBack(_m9Img.node);

        _m9Img.node.transform.setPosition(-_m9Img.width * .5, -_m9Img.height * .5);

        _textureWidth = _m9Img.width;
        _textureHeight = _m9Img.height;
    }

    /**
     * set the scale3
     * @param id
     */

    public function scale3(m3Texture:M3Texture, width:int, height:int):void {

        _m3Img = GNodeFactory.createNodeWithComponent(M3Image) as M3Image;
        _m3Img.scale3Image(m3Texture);

        _m3Img.width = width;
        _m3Img.height = height;

        this.node.addChild(_m3Img.node);

        this.node.putChildToBack(_m3Img.node);

        _m3Img.node.transform.setPosition(-_m3Img.node.getWorldBounds().width * .5, -_m3Img.node.getWorldBounds().height * .5);

        _textureWidth = _m3Img.node.getWorldBounds().width;
        _textureHeight = _m3Img.node.getWorldBounds().height;

    }

    //************************************************** SETTER AND GETTER METHODS ***********************************************

    public function set textureAtlasId(id:String):void {

        _label.textureAtlasId = id;
    }

    public function set text(text:String):void {

        _label.text = text;
        validatePositions();
    }

    public function get text():String {

        return _label.text;
    }

    public function set textScale(scale:Number):void {

        _label.node.transform.setScale(scale, scale);
        validatePositions();
    }

    public function set aling(value:int):void {

        _label.align = value;
    }


    public function set addIcon(id:String):void {

        _icon = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        _icon.textureId = id;
        this.node.addChild(_icon.node);

    }

    public function set iconFloat(position:uint):void {

        switch (position) {

            case 0:
                _icon.node.transform.x = -_textureWidth * .5 + _icon.getWorldBounds().width * .6;
                _label.node.transform.x = _icon.node.transform.x + _icon.getWorldBounds().width * .5;
                break;
            case 1:
                _icon.node.transform.x = _textureWidth * .5 - _icon.getWorldBounds().width * .6;
                _label.node.transform.x = -_icon.node.transform.x - _icon.getWorldBounds().width * .5;
                break;
            case 2:
                _icon.node.transform.y = -_textureHeight * .5 + _icon.getWorldBounds().height * .6;
                _label.node.transform.y = _icon.node.transform.y + _icon.getWorldBounds().height * .5;
                break;
            case 3:
                _icon.node.transform.y = _textureHeight * .5 - _icon.getWorldBounds().height * .6;
                _label.node.transform.y = -_icon.node.transform.y - _icon.getWorldBounds().height * .5;
                break;

        }
    }

    public function get isSelected():Boolean {
        return _isSelected;
    }

    public function set isSelected(value:Boolean):void {
        _isSelected = value;
    }

    public function get event():String {
        return _event;
    }

    public function set event(value:String):void {
        _event = value;
    }

    public function get textureHeight():Number {
        return _textureHeight;
    }

    public function get textureWidth():Number {
        return _textureWidth;
    }

    public function set labelPosition(value:uint):void {

        switch (value) {

            case 4:
                _label.node.transform.x += _textureWidth * .5;
                break;
            case 5:
                _label.node.transform.x -= _textureWidth * .5;
                break;
            case 6:
                _label.node.transform.y -= _textureHeight * .5 - _label.height;
                break;
            case 7:
                _label.node.transform.y += _textureHeight * .5 + _label.height;
                break;

        }
    }

}
}