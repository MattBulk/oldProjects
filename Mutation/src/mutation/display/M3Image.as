/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 12/30/13
 * Time: 7:51 PM
 * To change this template use File | Settings | File Templates.
 */
package mutation.display {
import com.genome2d.components.renderables.GSprite;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;

public class M3Image extends GSprite {

    private var _first:GSprite, _middle:GSprite, _last:GSprite;
    private var _direction:String;

    public function M3Image(p_node:GNode) {
        super(p_node);
    }

    public function scale3Image(textures:M3Texture):void {

        _direction = textures.direction;

        textures.first.alignTexture(2);
        textures.middle.alignTexture(2);
        textures.last.alignTexture(2);

        _first = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        _first.setTexture(textures.first);
        _first.node.transform.setPosition(0,0);
        this.node.addChild(_first.node);

        _middle = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        _middle.setTexture(textures.middle);

        if(_direction == M3Texture.DIRECTION_HORIZONTAL) _middle.node.transform.setPosition(textures.first.width, _first.node.transform.y);
        else _middle.node.transform.setPosition(_first.node.transform.x, textures.first.height);
        this.node.addChild(_middle.node);

        _last = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        _last.setTexture(textures.last);

        if(_direction == M3Texture.DIRECTION_HORIZONTAL) _last.node.transform.setPosition(_middle.node.transform.x + textures.middle.width, _first.node.transform.y);
        else _last.node.transform.setPosition(_first.node.transform.x ,_middle.node.transform.y + textures.middle.height);
        this.node.addChild(_last.node);

    }

    public function set width(scale:int):void {

        scale -= _first.cTexture.width + _last.cTexture.width;

        if(_direction == M3Texture.DIRECTION_HORIZONTAL) {

            _middle.node.transform.scaleX = scale;

            _last.node.transform.setPosition(_middle.node.transform.x + scale, _first.node.transform.y);
        }

        //else throw new Error("YOU CANNOT SET WIDTH");

    }

    public function set height(scale:int):void {

        scale -= _first.cTexture.height + _last.cTexture.height;

        if(_direction == M3Texture.DIRECTION_VERTICAL) {

            _middle.node.transform.scaleY = scale;

            _last.node.transform.setPosition(_first.node.transform.x, _middle.node.transform.y + scale);
        }

        //else throw new Error("YOU CANNOT SET HEIGHT");
    }

}
}
