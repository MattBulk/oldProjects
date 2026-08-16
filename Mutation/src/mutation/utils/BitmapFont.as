/**
 * Created by rodrigo on 12/14/13.
 */
package mutation.utils {
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureAtlas;
import com.genome2d.textures.GTextureSourceType;
import com.genome2d.textures.GTextureUtils;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

public class BitmapFont {

	public static const NATIVE_SIZE:int = -1;
	public static const CHAR_SPACE:int = 32;
	public static const CHAR_TAB:int = 9;
	public static const CHAR_NEWLINE:int = 10;
	public static const CHAR_RETURN:int = 13;
	public static const UNKNOWN_NAME:String = 'unknown';

	private var _atlas:GTextureAtlas;
	private var _bitmap:BitmapData;
	private var _fontData:XML;
	private var _chars:Dictionary;
	private var _name:String;
	private var _size:Number;
	private var _lineHeight:Number;

	/**
	 * Constructor.
	 * @param pAtlas
	 * @param pFontData
	 */
	public function BitmapFont(pBitmap:BitmapData, pFontData:XML) {

        _bitmap = pBitmap;
		_fontData = pFontData;
		_name = UNKNOWN_NAME;
		_lineHeight = _size = 14;
		_chars = new Dictionary(true);

        parseFontXML(pFontData);
	}

	private function parseFontXML(pFontData:XML):void {
		_name = pFontData.info.@face;
		_size = parseFloat(pFontData.info.@size);
		_lineHeight = parseFloat(pFontData.info.@lineHeight);
		if (isNaN(_lineHeight)) {
			_lineHeight = parseFloat(pFontData.common.@lineHeight);
		}
		if (_size <= 0) {
			trace('[Genome2D] Warning: invalid font size in "' + _name + '" font.');
			_size = _size == 0 ? 16 : _size *= -1;
		}
		var region:Rectangle;
		var atlasId:String = _name.toLowerCase().split(' ').join('-') + '-' + size;

		_atlas = new GTextureAtlas(atlasId, GTextureSourceType.BITMAPDATA, _bitmap.width, _bitmap.height, _bitmap, GTextureUtils.isBitmapDataTransparent(_bitmap), null);

		for each(var node:XML in pFontData.chars.char) {
			var id:int = node.@id;
			var xOffset:Number = node.@xoffset;
			var yOffset:Number = node.@yoffset;
			var xAdvance:Number = node.@xadvance;
			region = new Rectangle(int(node.@x), int(node.@y), int(node.@width), int(node.@height));
			var pivotX:Number = -region.width / 2;
			var pivotY:Number = -region.height / 2;
			var charTexture:GTexture = _atlas.addSubTexture(String(id), region, pivotX, pivotY);
			addChar(id, new BitmapChar(id, charTexture, xOffset, yOffset, xAdvance));
		}

		// add kernings.
		for each(node in pFontData.kernings.kerning) {
			var first:int = int(node.@first);
			var second:int = int(node.@second);
			var amount:int = int(node.@amount);
			if (second in _chars) getChar(second).addKerning(first, amount);
		}
		_atlas.invalidate();
	}

	public function getChar(pCharId:int):BitmapChar {
		return _chars[pCharId];
	}

	public function addChar(pId:int, pBitmapChar:BitmapChar):void {
		_chars[pId] = pBitmapChar;
	}

	public function get atlas():GTextureAtlas {
		return _atlas;
	}

	public function get fontData():XML {
		return _fontData;
	}

	public function get name():String {
		return _name;
	}

	public function get size():Number {
		return _size;
	}

	public function get lineHeight():Number {
		return _lineHeight;
	}

}
}
