/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 12/22/13
 * Time: 5:47 PM
 * To change this template use File | Settings | File Templates.
 */
package mutation.display {

import com.genome2d.textures.GTexture;
import flash.geom.Rectangle;


public class M3Texture {

    /**
     * If the direction is horizontal, the layout will start on the left and continue to the right.
     */
    public static const DIRECTION_HORIZONTAL:String = "horizontal";

    /**
     * If the direction is vertical, the layout will start on the top and continue to the bottom.
     */
    public static const DIRECTION_VERTICAL:String = "vertical";

    /**
     * Constructor.
     */
    public function M3Texture(id:String, firstRegionSize:Number, lastRegionSize:Number, direct:String = DIRECTION_HORIZONTAL)
    {
        this._id = id;
        this._firstRegionSize = firstRegionSize;
        this._lastRegionSize = lastRegionSize;
        this._direction = direct;

        this.initialize();
    }

    /**
     * @private
     */
    private var _id:String;

    /**
     * @private
     */
    private var _firstRegionSize:Number;

    /**
     * The size of the first region, in pixels.
     */
    public function get firstRegionSize():Number
    {
        return this._firstRegionSize;
    }

    /**
     * @private
     */
    private var _lastRegionSize:Number;

    /**
     * The size of the second region, in pixels.
     */
    public function get lastRegionSize():Number
    {
        return this._lastRegionSize;
    }

    /**
     * @private
     */
    private var _direction:String;

    /**
     * The direction of the sub-texture layout.
     *
     * @default Scale3Textures.DIRECTION_HORIZONTAL
     *
     * @see #DIRECTION_HORIZONTAL
     * @see #DIRECTION_VERTICAL
     */
    public function get direction():String
    {
        return this._direction;
    }

    /**
     * @private
     */
    private var _first:GTexture;

    /**
     * The texture for the first region.
     */
    public function get first():GTexture
    {
        return this._first;
    }

    /**
     * @private
     */
    private var _last:GTexture;

    /**
     * The texture for the second region.
     */
    public function get last():GTexture
    {
        return this._last;
    }

    /**
     * @private
     */
    private var _middle:GTexture;

    /**
     * The texture for the middle region.
     */
    public function get middle():GTexture
    {
        return this._middle;
    }

    /**
     * @private
     */

    internal function initialize():void {

        var texture:GTexture = GTexture.getTextureById(_id);

        var rect_first:Rectangle, rect_last:Rectangle, rect_middle:Rectangle;

        if(_direction == M3Texture.DIRECTION_HORIZONTAL) {

            rect_first = new Rectangle(texture.region.x, texture.region.y, _firstRegionSize, texture.height);

            _first = texture.parent.addSubTexture(_id + "_first", rect_first);

            rect_last = new Rectangle(texture.region.x + (texture.width - _lastRegionSize), texture.region.y, _lastRegionSize, texture.height);

            _last = texture.parent.addSubTexture(_id + "_last", rect_last);

            rect_middle = new Rectangle(texture.region.x + _firstRegionSize, texture.region.y, 1, texture.height);

            _middle = texture.parent.addSubTexture(_id + "middle", rect_middle);
        }

        else {

            rect_first = new Rectangle(texture.region.x, texture.region.y, texture.width , _firstRegionSize);

            _first = texture.parent.addSubTexture(_id + "_first", rect_first);

            rect_last = new Rectangle(texture.region.x, texture.region.y + (texture.height - _firstRegionSize), texture.width, _lastRegionSize);

            _last = texture.parent.addSubTexture(_id + "_last", rect_last);

            rect_middle = new Rectangle(texture.region.x, texture.region.y + _firstRegionSize, texture.width , 1);

            _middle = texture.parent.addSubTexture(_id + "middle", rect_middle);
        }
    }

}
}
