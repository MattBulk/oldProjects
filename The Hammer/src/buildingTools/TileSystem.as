/**
 * Created by 22BoX on 2/3/14.
 */
package buildingTools {

import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;

import starling.display.Image;

public class TileSystem {

    private var _rows:uint, _columns:uint, _num:uint;
    private var _foregroundArr:Array, _backgroundArr:Array, _physicArr:Array;
    private static const _tileDimension:uint = InGameVars.TILE_DIMENSIONS;

    public function TileSystem(xml:XML):void {

        _rows = xml.room.rows;
        _columns = xml.room.columns;

        var portableStr:String = xml.room.foregroundType;

        _foregroundArr = portableStr.split(",");

        portableStr = xml.room.backgroundType;

        _backgroundArr = portableStr.split(",");

        portableStr = xml.room.physicType;

        _physicArr = portableStr.split(",");

    }

    public function createPlatformElements():void {

        // constructor code
        _num = 0;

        for (var X:uint=0; X<_rows; X++)
        {
            for (var Y:uint=0; Y<_columns; Y++)
            {

                if(_foregroundArr[_num] != 0) createImage(X, Y, _num, "foreground");

                _num++;

            }
        }

    }

    public function setUpPhysicEngine():void {

        _num = 0;

        for (var X:uint=0; X<_rows; X++)
        {
            for (var Y:uint=0; Y<_columns; Y++)
            {

                if(_physicArr[_num] != 0) decodeString(X, Y, _physicArr[_num]);

                _num++;

            }
        }
    }

    public function createBackground():void {

        _num = 0;

        for (var X:uint=0; X<_rows; X++)
        {
            for (var Y:uint=0; Y<_columns; Y++)
            {

                createImage(X, Y, _num, "background");

                _num++;

            }
        }
    }

    private function createImage(pX:uint, pY:uint, num:uint, layer:String):void {

        var image:Image;

        if(layer == "foreground") {

            image = new Image(TheAtlasLoader.getInstance().assets.getTexture(_foregroundArr[num]));

            InGameVars.GAME_LAYER_PLATFORM.addChild(image);

        }

        else {

            image = new Image(TheAtlasLoader.getInstance().assets.getTexture(_backgroundArr[num]));

            InGameVars.GAME_BACKGROUND.addChild(image);
        }

        image.x = pX * _tileDimension;
        image.y = pY * _tileDimension;

    }

    private static function decodeString(pX:uint, pY:uint, str:Object):void {

        const cbType:String = str.charAt(str.length - 1);
        const direct:String = str.charAt(str.length - 2);
        const bodyLength:String = str.slice(0, str.length - 2);

        switch (cbType) {

            case "p":
                addPlatform(pX, pY, uint(bodyLength));
                break;
            case "w":
                addWall(pX, pY, uint(bodyLength), direct);
                break;
        }
    }

    private static function addPlatform(pX:uint, pY:uint, num:uint):void {

        const napeBody:Body = new Body(BodyType.STATIC);
        napeBody.position.setxy(pX * _tileDimension + _tileDimension * num * .5, pY * _tileDimension + _tileDimension * .5);

        const polygon:Polygon = new Polygon(Polygon.box(_tileDimension * num, _tileDimension));
        polygon.material = Material.wood();

        napeBody.shapes.add(polygon);
        napeBody.space = InGameVars.NAPE_SPACE;
        napeBody.cbTypes.add(InGameVars.platformCollisionType);

    }

    private static function addWall(pX:uint, pY:uint, num:uint, direct:String):void {

        const napeBody:Body = new Body(BodyType.STATIC);

        var polygon:Polygon;

        if(direct == "H") {
            polygon = new Polygon(Polygon.box(_tileDimension * num, _tileDimension));
            napeBody.position.setxy(pX * _tileDimension + _tileDimension * num * .5, pY * _tileDimension + _tileDimension * .5);

        }
        else {
            polygon = new Polygon(Polygon.box(_tileDimension, _tileDimension * num));
            napeBody.position.setxy(pX * _tileDimension + _tileDimension * .5, pY * _tileDimension + _tileDimension * num * .5);

        }

        polygon.material = Material.wood(); //new Material(99999, .03, .1, .9, .001);

        napeBody.shapes.add(polygon);
        napeBody.space = InGameVars.NAPE_SPACE;
        napeBody.cbTypes.add(InGameVars.wallCollisionType);
    }
}
}
