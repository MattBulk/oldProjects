/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 8/28/13
 * Time: 6:40 PM
 * To change this template use File | Settings | File Templates.
 */
package gui {

import feathers.controls.Button;
import feathers.display.Scale3Image;
import feathers.display.Scale9Image;
import feathers.textures.Scale3Textures;
import feathers.textures.Scale9Textures;

import flash.geom.Rectangle;

import starling.core.Starling;
import starling.display.Image;
import starling.textures.Texture;

import utils.Settings;

public class Constant {

    //STARLING
    public static const STAGE_WIDTH:uint = Starling.current.stage.stageWidth;
    public static const STAGE_HEIGHT:uint = Starling.current.stage.stageHeight;
    //FEATHER
    public static const DEFAULT_SKIN:Texture = TheAtlasLoader.getInstance().assets.getTexture("button");
    public static const DOWN_SKIN:Texture = TheAtlasLoader.getInstance().assets.getTexture("buttonDown");
    public static const BACK_ICON:Texture = TheAtlasLoader.getInstance().assets.getTexture("back_icon");
    public static const BIG_DEFAULT_SKIN:Texture = TheAtlasLoader.getInstance().assets.getTexture("bigBtn");
    public static const BIG_DOWN_SKIN:Texture = TheAtlasLoader.getInstance().assets.getTexture("bigBtnDown");
    public static const ITEM_DEFAULT:Texture = TheAtlasLoader.getInstance().assets.getTexture("item-default");
    public static const ITEM_DEFAULT_LOCKED:Texture = TheAtlasLoader.getInstance().assets.getTexture("item-default-locked");
    public static const HAMMER_0:Texture = TheAtlasLoader.getInstance().assets.getTexture("hammer-0");
    public static const HAMMER_1:Texture = TheAtlasLoader.getInstance().assets.getTexture("hammer-1");
    public static const NORMAL_SYMBOL:Texture = TheAtlasLoader.getInstance().assets.getTexture("normal-page-symbol");
    public static const SELECTED_SYMBOL:Texture = TheAtlasLoader.getInstance().assets.getTexture("selected-page-symbol");



    public static const MARGIN:int = 20 * Settings.SCALE_FACTOR;

    public static function scale3Image(texture:Texture):Scale3Image
    {
        var scale3:Scale3Textures = new Scale3Textures(texture, 10 * Settings.SCALE_FACTOR, -1 * Settings.SCALE_FACTOR);
        var img:Scale3Image = new Scale3Image(scale3);
        return img;
    }

    public static function getScaledImage(texture:Texture, valueX:Number, valueY:Number):Image {

        var img:Image = new Image(texture);
        img.scaleX = valueX;
        img.scaleY = valueY;
        return img;
    }

    public static function scale9Image(theTexture:Texture):Scale9Image
    {
        var rect:Rectangle = new Rectangle( 25 * Settings.SCALE_FACTOR, 25 * Settings.SCALE_FACTOR, 10 * Settings.SCALE_FACTOR, -1 * Settings.SCALE_FACTOR);
        var texture:Scale9Textures = new Scale9Textures(theTexture, rect);
        var img:Scale9Image = new Scale9Image(texture);
        return img;
    }

    public static function getBackButton():Button {

        var backBtn:Button = new Button();
        backBtn.defaultSkin = new Image(Constant.DEFAULT_SKIN);
        backBtn.downSkin = new Image(Constant.DOWN_SKIN);
        backBtn.defaultIcon = new Image(Constant.BACK_ICON);
        backBtn.name = "back";
        return backBtn;
    }
}
}
