/**
 * Code by rodrigolopezpeker (aka 7interactive™) on 12/29/13 3:35 PM.
 */
package mutation.display {
import com.genome2d.components.GCamera;
import com.genome2d.components.GComponent;
import com.genome2d.components.GTransform;
import com.genome2d.context.GContext;
import com.genome2d.core.GNode;
import com.genome2d.g2d;
import com.genome2d.textures.GTexture;
import flash.geom.Rectangle;

use namespace g2d ;

public class M9Image extends GComponent {

    private var _width:Number;
    private var _height:Number;
    private var texture:M9Texture;
    private var _invalidate:Boolean;
    private var _slices:Vector.<GSlice>;
    private var _rotation:Number=0;

    // pivot to scale/rotate percentage 0-1.
    public var pivotX:Number = 0;
    public var pivotY:Number = 0;

    private var rotationCos:Number = 0;
    private var rotationSin:Number = 0;

    public function M9Image(pNode:GNode) {

        super(pNode);
        initLayout();
    }

    private function initLayout():void {
        _slices = new Vector.<GSlice>();
        for (var i:int = 0; i < 9; i++) _slices.push(new GSlice());
    }

    override public function render(p_context:GContext, p_camera:GCamera, p_maskRect:Rectangle):void {
        super.render(p_context, p_camera, p_maskRect);
        // render top left.
        if( !texture || _width<=0 || _height<=0 ) return;
        var t:GTransform = cNode.cTransform;
        if( _rotation != t.nWorldRotation ) {
            _rotation = t.nWorldRotation;
            _invalidate = true;
        }
        if( _invalidate ){

            _invalidate = false;
            rotationCos = Math.cos(_rotation);
            rotationSin = Math.sin(_rotation);
            drawLayout();
        }
        for (var i:int = 0; i < 9; i++) {
            var slice:GSlice = _slices[i];
            p_context.draw( slice.texture, slice.x + t.nWorldX, slice.y+ t.nWorldY, slice.scaleX* t.nWorldScaleX, slice.scaleY* t.nWorldScaleY, _rotation, t.nWorldRed, t.nWorldGreen, t.nWorldBlue, t.nWorldAlpha, 1, p_maskRect );
        }
    }

    private function drawLayout():void {

        var centerX:Number = _width * pivotX;
        var centerY:Number = _height * pivotY;

        var leftW:Number = _slices[0].ow ;
        var centerW:Number = _width - _slices[0].ow - _slices[2].ow ;
        var centerH:Number = _height - _slices[0].oh - _slices[2].oh ;
        var bottomY:Number = _height - _slices[6].h ;

        _slices[3].h = _slices[4].h = _slices[5].h = centerH ;
        _slices[3].scaleY = _slices[4].scaleY = _slices[5].scaleY = _slices[3].h / _slices[3].oh ;

        _slices[1].w = _slices[4].w = _slices[7].w = centerW ;
        _slices[1].scaleX = _slices[4].scaleX = _slices[7].scaleX = _slices[1].w / _slices[1].ow ;

        _slices[0].ox = _slices[3].ox = _slices[6].ox = 0 ;
        _slices[1].ox = _slices[4].ox = _slices[7].ox = leftW ;
        _slices[2].ox = _slices[5].ox = _slices[8].ox = leftW + centerW ;

        _slices[0].oy = _slices[1].oy = _slices[2].oy = 0 ;
        _slices[3].oy = _slices[4].oy = _slices[5].oy = _slices[0].h ;
        _slices[6].oy = _slices[7].oy = _slices[8].oy = bottomY;
        var i:int = 0 ;
        if(_rotation==0){
            for (i=0; i < 9; i++) {
                _slices[i].x = _slices[i].ox - centerX ;
                _slices[i].y = _slices[i].oy - centerY ;
            }
        } else {
            for (i=0; i < 9; i++) {
                var dx:Number = _slices[i].ox - centerX ;
                var dy:Number = _slices[i].oy - centerY ;
                _slices[i].x = dx * rotationCos - dy * rotationSin ;
                _slices[i].y = dy * rotationCos + dx * rotationSin;
            }
        }
    }

    public function scale9Image(pTexture:M9Texture):void {

        texture = pTexture;
        _width = texture.texture.width;
        _height = texture.texture.height;
        setSlice(0, texture.topLeft);
        setSlice(1, texture.topCenter);
        setSlice(2, texture.topRight);
        setSlice(3, texture.middleLeft);
        setSlice(4, texture.middleCenter);
        setSlice(5, texture.middleRight);
        setSlice(6, texture.bottomLeft);
        setSlice(7, texture.bottomCenter);
        setSlice(8, texture.bottomRight);
        _invalidate = true;
    }

    private function setSlice(pIndex:int, pTexture:GTexture):void {
        _slices[pIndex].texture = pTexture ;
        _slices[pIndex].w = _slices[pIndex].ow = pTexture.width;
        _slices[pIndex].h = _slices[pIndex].oh = pTexture.height;
    }

    public function get height():Number {
        return _height;
    }

    public function set height(value:Number):void {
        if(_height==value)return;
        _height = value;
        _invalidate = true ;
    }

    public function get width():Number {
        return _width;
    }

    public function set width(value:Number):void {
        if(_width==value)return;
        _width = value;
        _invalidate = true ;
    }

}


}

import com.genome2d.textures.GTexture;

class GSlice {

    // without rotation
    public var ox:Number=0;
    public var oy:Number=0;

    // w/rotation
    public var x:Number=0;
    public var y:Number=0;
    public var scaleX:Number=1;
    public var scaleY:Number=1;
    public var rotation:Number=0;
    public var texture:GTexture;
    public var w:Number=0;
    public var h:Number=0;
    public var ow:Number;
    public var oh:Number;

    public function GSlice():void {
    }

    public function toString():String{
        return 'GSlice [ x:' + x + ',y:' + y + ',texture:' + texture +
                ',scaleX:'+scaleX+',scaleY:' + scaleY + ', rotation:' + rotation ;
    }
}
