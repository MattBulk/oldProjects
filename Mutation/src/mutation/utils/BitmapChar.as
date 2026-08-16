/**
 * Created by rodrigo on 12/14/13.
 */
package mutation.utils {
import com.genome2d.textures.GTexture;

import flash.utils.Dictionary;

public class BitmapChar {

	public var texture:GTexture;
	private var _charId:int;
	private var _xOffset:int;
	private var _yOffset:int;
	private var _xAdvance:int;
	private var _kernings:Dictionary;

	public function BitmapChar(pId:int, pTexture:GTexture, pxOffset:Number, pyOffset:Number, pxAdvance:Number) {
		_charId = pId;
		texture = pTexture ;
		_xOffset = pxOffset;
		_yOffset = pyOffset;
		_xAdvance = pxAdvance;
	}

	public function addKerning(pCharId:int, pKerning:Number):void {
		if (_kernings == null) _kernings = new Dictionary(true);
		_kernings[pCharId] = pKerning;
	}

	public function getKerning(pCharId:int):Number {
		if (!_kernings || !_kernings[pCharId]) return 0;
		return _kernings[pCharId];
	}

	public function get xOffset():int {
		return _xOffset;
	}

	public function get yOffset():int {
		return _yOffset;
	}

	public function get xAdvance():int {
		return _xAdvance;
	}

	public function get charId():int {
		return _charId;
	}
}
}
