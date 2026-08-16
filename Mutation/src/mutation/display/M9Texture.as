/**
 * Code by rodrigolopezpeker (aka 7interactive™) on 12/29/13 2:15 PM.
 */
package mutation.display {

import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureAtlas;

import flash.geom.Rectangle;

public class M9Texture {

    public var scale9Grid:Rectangle;

    public var texture:GTexture;

    public var topRight:GTexture;
    public var topCenter:GTexture;
    public var topLeft:GTexture;
    public var middleRight:GTexture;
    public var middleCenter:GTexture;
    public var middleLeft:GTexture;
    public var bottomRight:GTexture;
    public var bottomCenter:GTexture;
    public var bottomLeft:GTexture;

    private static var textureCounter:uint=0;
    private var _id:String ;
    private var _atlas:GTextureAtlas;

    public function M9Texture(id:String, pScale9Grid:Rectangle):void {

        _id = id ;
        texture = GTexture.getTextureById(_id);
        scale9Grid = pScale9Grid ;
        init();
    }

    private function init():void {

        var region:Rectangle = texture.region;
        _atlas = texture.parent;

        // adjust scale9grid if negative.
        if(scale9Grid.width < 0 ) scale9Grid.width += region.width;
        if(scale9Grid.height < 0 ) scale9Grid.height += region.height;

        var r:Rectangle = new Rectangle();
        var topH:int = scale9Grid.y;
        var bottomH:int = region.height - scale9Grid.height;
        var middleH:int = region.height - scale9Grid.y - bottomH;
        var centerW:int = region.width - scale9Grid.x - ( region.width - scale9Grid.width );
        var leftW:int = scale9Grid.x;
        var rightW:int = region.width - scale9Grid.width;

        // top right.
        r.x = region.x;
        r.y = region.y;
        r.width = leftW;
        r.height = topH;
        topLeft = getSubTexture(r);

        // top center
        r.x = region.x + leftW;
        r.width = centerW;
        topCenter = getSubTexture(r);

        // top right
        r.x = region.x + scale9Grid.width;
        r.width = rightW;
        topRight = getSubTexture(r);

        // middle left
        r.x = region.x;
        r.y = region.y + topH;
        r.width = leftW;
        r.height = middleH;
        middleLeft = getSubTexture(r);

        // middle center
        r.x = region.x + leftW;
        r.width = centerW;
        middleCenter = getSubTexture(r);

        // middle right.
        r.x = region.x + scale9Grid.width;
        r.width = rightW;
        middleRight = getSubTexture(r);

        // bottom left
        r.x = region.x;
        r.y = region.y + scale9Grid.height;
        r.width = leftW;
        r.height = bottomH;
        bottomLeft = getSubTexture(r);

        // bottom center
        r.x = region.x + leftW;
        r.width = centerW;
        bottomCenter = getSubTexture(r);

        // bottom right.
        r.x = region.x + scale9Grid.width;
        r.width = rightW;
        bottomRight = getSubTexture(r);
    }

    private function getSubTexture( r:Rectangle ):GTexture {

        var pivotX:Number = -r.width/2;
        var pivotY:Number = -r.height/2;
        var subId:String = _id + '_' + textureCounter++;

        return _atlas.addSubTexture( subId, r.clone(), pivotX, pivotY );
    }
}
}
