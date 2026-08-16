/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 12/22/13
 * Time: 11:45 AM
 * To change this template use File | Settings | File Templates.
 */
package mutation.display {
import com.genome2d.components.renderables.GSimpleShape;
import com.genome2d.core.GNodeFactory;
import com.genome2d.g2d;
import com.genome2d.textures.GTexture;

import flash.geom.Rectangle;

use namespace g2d ;

public class MScale3 {

    private var _vertices:Vector.<Number>;
    private var _uvs:Vector.<Number>;
    private var _shape:GSimpleShape;

    private var _texture:GTexture ;
    private var _textureW:int ;
    private var _textureH:int ;

    private var _width:int ;
    private var _height:int ;

    public static const SLICE_3_HORIZONTAL: int = 0 ;
    public static const SLICE_3_VERTICAL: int = 1 ;
    private var _slice3Direction: int = 1 ;

    private var _sliceRect: Rectangle;
    private var _isInvalidated: Boolean;

    public function setSlice3(pDirection: int, pPaddingA: int, pPaddingB:int = 0): void {

        _sliceRect = new Rectangle();
        _vertices = new Vector.<Number>() ;
        _uvs = new Vector.<Number>() ;
        _shape = GNodeFactory.createNodeWithComponent(GSimpleShape) as GSimpleShape ;
        _sliceRect.setEmpty();
        _sliceRect.x = pPaddingA ;
        _slice3Direction = pDirection ;
        _sliceRect.y = pPaddingB==0 ? pPaddingA : pPaddingB<0 ? -pPaddingB : pPaddingB ;
        //buildMesh() ;
    }

    public function setTexture(pTexture:GTexture):void {
        _texture = pTexture;
        if(!_texture) return ;
        _textureW = _texture.width ;
        _textureH = _texture.height ;
        _height = _textureH ;
        _width = _textureW ;
        _shape.setTexture(_texture)
    }

    public function buildMesh(pW:int, pH:int):GSimpleShape {
        _vertices.length = 0 ;
        _uvs.length = 0 ;
        _width = pW ;
        _height = pH ;
        var isHorizontal:Boolean = _slice3Direction == SLICE_3_HORIZONTAL ;
        var pad1:int = _sliceRect.x ;
        var pad2:int = isHorizontal ? _width - _sliceRect.y : _height - _sliceRect.y ;
        if(isHorizontal){
            defPoly( 0,0, pad1,_height );
            defPoly( pad1, 0, pad2, _height);
            defPoly( pad2, 0, _width, _height );
        } else {
            defPoly( 0, 0, _width, pad1 );
            defPoly( 0, pad1, _width, pad2 );
            defPoly( 0, pad2, _width, _height );
        }
        _shape.init(_vertices, _uvs);


        return _shape;
    }

    private function defPoly(x: int, y: int, w: int, h: int): void {
        var ux:Number = x / _textureW ;
        var uy:Number = y / _textureH ;
        var uw:Number = w / _textureW ;
        var uh:Number = h / _textureH ;

        _vertices.push( x,y, w,y, x,h );
        _vertices.push( w,y, w,h, x,h );
        _uvs.push(ux,uy, uw,uy, ux,uh );
        _uvs.push(uw,uy, uw,uh, ux,uh );
    }

    public function setSize(pW:int, pH:int):void {
        _width = pW ;
        _height = pH ;
        _isInvalidated = true ;
    }

    private final function draw(): void {

        var isHorizontal:Boolean = _slice3Direction==SLICE_3_HORIZONTAL ;
        var pad1:int = _sliceRect.x ;
        var pad2:int = isHorizontal ? _width - _sliceRect.y : _height - _sliceRect.y ;
        if(isHorizontal){
            resizePoly(0, 0,0, pad1, _height);
            resizePoly(1, pad1, 0, pad2, _height);
            resizePoly(2, pad2, 0, _width, _height);
        } else {
            resizePoly(0, 0, 0, _width, pad1 );
            resizePoly(1, 0, pad1, _width, pad2 );
            resizePoly(2, 0, pad2, _width, _height );
        }

    }

    [Inline]
    private final function resizePoly(pIndex: int, x: int, y: int, w: int, h: int): void {
        var ci:uint = pIndex * 12 ;
        var values:Array= [ x,y, w,y, x,h, w,y, w,h, x,h ] ;
        for (var i:uint = 0; i < 12; i++, ci++) _vertices[ci] = values[i];
    }
}
}
