/**
 * Created by rodrigo on 12/14/13.
 */
package mutation.components {

import com.genome2d.components.GComponent;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.context.GBlendMode;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureAlignType;
import com.genome2d.textures.factories.GTextureFactory;
import mutation.utils.BitmapChar;
import mutation.utils.BitmapFont;
import org.osflash.signals.Signal;

public class MBitmapText extends GComponent {

	private var _font:BitmapFont;

	private var _w:int;
	private var _h:int;

	private static var _boxBorderTexture:GTexture;
	private var _borderContainer:GNode ;
	private var _backgroundSprite:GSprite;
	private var _borders:Vector.<GSprite>;

	private var _background:Boolean = false ;
	private var _border:Boolean = false ;
	private var _borderThickness:int = 1 ;
	private var _borderColor:uint = 0xFFFFFF ;
	private var _backgroundColor: uint = 0x0 ;
	private var _invalidateBorder:Boolean;
	private var _invalidateBackground:Boolean;
	private var _invalidateText:Boolean;
	private var _textNode:GNode;

	private var _text:String;
	private var _fontSize:Number;
	private var _fontColor:uint;
	private var _hAlign:String = 'center';
	private var _vAlign:String = 'center';
	private var _autoScale:Boolean;
	private var _kerning:Boolean;
	private var _letterSpacing:Number = 0 ;
	private var _leading:Number = 0;
	private var _invalidateAlign:Boolean;

    public var onTextDrawn:Signal;

	public function MBitmapText(pNode:GNode) {
		super(pNode);

        onTextDrawn = new Signal();

        _textNode = GNodeFactory.createNode();

        node.addChild(_textNode);

	}

	public function setBitmapFont(pBitmapFont:BitmapFont):void {

        _font = pBitmapFont;
		// invalidate.
	}

	public function setup(pWidth:int, pHeight:int, pText:String, fontSize:int=-1,
	                      color:uint=0xFFFFFF, hAlign:String='center', vAlign:String='center',
	                      autoScale:Boolean=true, kerning:Boolean=true):void {
		_w = pWidth ;
		_h = pHeight;
		_text = pText ;
		_fontColor = color ;
		_fontSize = fontSize ;
		_hAlign = hAlign ;
		_vAlign = vAlign ;
		_autoScale = autoScale;
		_kerning = kerning;
		// redraw text.
		if(_font){
			drawText() ;
		}
		if(_border)_invalidateBorder = true;
		if(_background)_invalidateBackground = true;
	}

	private function drawText():void {
		if( _fontSize == BitmapFont.NATIVE_SIZE ) _fontSize = _font.size;
		var finished:Boolean = false ;
		var lineNode:GNode;
		var lastCharNode:GNode;
		var lineHeight:int = _leading + _font.lineHeight ;
		_textNode.disposeChildren();
		if(_text=='') return ;
		while(!finished){
			var scale:Number = _fontSize/_font.size;
			var containerLineNode:GNode = GNodeFactory.createNode();
			if( lineHeight * scale <=_h){
				var containerWidth:Number = _w/scale;
				var containerHeight:Number = _h/scale;
				containerLineNode.transform.setScale(scale,scale);
				var lastWhitespace:int = -1;
				var lastCharId:int = -1;
				var currentX:Number = 0 ;
				var currentLineNode:GNode = GNodeFactory.createNode();
				var numChars:int = _text.length ;
				for (var i:int = 0; i < numChars; i++) {
					var lineFull:Boolean = false ;
					var charId:int = _text.charCodeAt(i);
					var charSprite:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite ;
					if(charId==10||charId==13){
						lineFull = true ;
					} else {
						var bitmapChar:BitmapChar = _font.getChar(charId);
						if(!bitmapChar){
							trace('[Genome2D] Missing character:' + charId);
							continue;
						}
						if(charId==BitmapFont.CHAR_SPACE || charId == BitmapFont.CHAR_TAB) lastWhitespace = i ;
						charSprite.setTexture(bitmapChar.texture);
						if(_kerning) currentX += bitmapChar.getKerning(lastCharId);
						currentX += _letterSpacing ;
						charSprite.node.transform.setPosition(currentX + bitmapChar.xOffset, bitmapChar.yOffset);
						charSprite.node.transform.color = _fontColor ;
						currentLineNode.addChild(charSprite.node);
						currentX += bitmapChar.xAdvance;
						lastCharId = charId;
						if(currentX>containerWidth){
							// remove characters and add them to the next line.
							var numCharsToRemove:int = lastWhitespace == -1 ? 1 : i-lastWhitespace;
							for (var r:int=0; r<numCharsToRemove; ++r)
								currentLineNode.removeChild(currentLineNode.lastChild);
							if(currentLineNode.numChildren==0) break ;
							lastCharNode = currentLineNode.lastChild;
							currentX = lastCharNode.transform.x + (lastCharNode.getComponent(GSprite) as GSprite).getTexture().width;
							i -= numCharsToRemove;
							lineFull = true ;
						}
					}
					if( i ==numChars-1){
						containerLineNode.addChild(currentLineNode);
						finished = true ;
					} else if( lineFull ){
						containerLineNode.addChild(currentLineNode);
						var nextLineY:Number = currentLineNode.transform.y + lineHeight ;
						if( nextLineY + lineHeight <= containerHeight ){
							currentLineNode = GNodeFactory.createNode();
							currentLineNode.transform.y = nextLineY;
							currentX = 0 ;
							lastWhitespace = -1;
							lastCharId = -1 ;
						} else {
							break ;
						}
					}
				} // for each char
			}
			if(_autoScale && !finished){
				_fontSize -= 1;
				containerLineNode.disposeChildren();
				//dispose!
			} else {
				finished = true ;
			}
			_textNode.addChild(containerLineNode);
		}// while finished
		drawAlign() ;
		onTextDrawn.dispatch();
	}

	private function drawAlign():void {
		var containerLineNode:GNode = _textNode.lastChild ;
		var lineNode:GNode ;
		var lineHeight: Number = _leading + _font.lineHeight ;
		var scale:Number = _fontSize/_font.size;
		// h align
		var containerWidth:Number = _w / scale;
		for (lineNode = containerLineNode.firstChild; lineNode != null; lineNode = lineNode.next) {
			var lastCharNode:GNode = lineNode.lastChild;
			var lineWidth:Number = lastCharNode.transform.x + (lastCharNode.getComponent(GSprite) as GSprite).getTexture().width;
			var widthDiff:Number = containerWidth - lineWidth;
			lineNode.transform.x = int(_hAlign == 'right' ? widthDiff : _hAlign == 'center' ? widthDiff / 2 : 0);
		}
		// v align
		var contentHeight:Number = containerLineNode.numChildren * lineHeight * scale;
		var heightDiff:Number = _h - contentHeight;
		containerLineNode.transform.y = int(_vAlign == 'bottom' ? heightDiff : _vAlign == 'center' ? heightDiff / 2 : 0);
	}


	//// ---- STYLE THINGS ------

	private function drawBorder():void {
		_borders[1].node.transform.scaleX = _borders[3].node.transform.scaleX = _borders[0].node.transform.scaleY = _borders[2].node.transform.scaleY = _borderThickness/2;
		_borders[0].node.transform.scaleX = _borders[2].node.transform.scaleX = _w/2;
		_borders[1].node.transform.scaleY = _borders[3].node.transform.scaleY = _h/2;
		_borders[1].node.transform.x = _w - _borderThickness ;
		_borders[2].node.transform.y = _h - _borderThickness ;
	}

	override public function update(p_deltaTime:Number):void {
		super.update(p_deltaTime);
		if( _invalidateBackground ) {
			_invalidateBackground = false;
			_backgroundSprite.node.transform.setScale(_w/2,_h/2);
		}
		if( _invalidateText && _font ) {
			_invalidateText = false ;
			drawText();
		} else if( _invalidateAlign ){
			_invalidateAlign = false ;
			drawAlign();
		}
		if( _invalidateBorder ){
			_invalidateBorder = false;
			drawBorder();
		}
	}


	public function get borderThickness():int {return _borderThickness;}
	public function set borderThickness(value:int):void {
		if(_borderThickness== value) return ;
		_borderThickness = value;
		if(_borderContainer)_invalidateBorder = true ;
	}

	public function get borderColor():uint {return _borderColor;}
	public function set borderColor(value:uint):void {
		if(_borderColor == value) return ;
		_borderColor = value;
		if( _borderContainer ) _borderContainer.transform.color = value ;
	}

	public function get border():Boolean {return _border;}
	public function set border(value:Boolean):void {
		if( _border == value ) return ;
		_border = value;
		if(!_border && _borderContainer ){
			node.removeChild(_borderContainer);
			_borderContainer.dispose();
			_borderContainer.disposeChildren();
			_borderContainer = null ;
		} else {
			initBorder() ;
			if( _borderColor != 0xffffff ) _borderContainer.transform.color = _borderColor ;
			_invalidateBorder = true ;
		}
		node.putChildToFront(_textNode);
	}

	private function initBorder():void {
		if(!_boxBorderTexture){
			_boxBorderTexture = GTextureFactory.createFromColor('box_border_outline', 0xFFFFFF, 2, 2);
			_boxBorderTexture.alignTexture(GTextureAlignType.TOP_LEFT);
		}
		_borderContainer = GNodeFactory.createNode();
		_borders = new Vector.<GSprite>() ;
		for (var i:int = 0; i < 4; i++) {
			var b:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite ;
			_borderContainer.addChild(b.node);
			b.blendMode = GBlendMode.NONE ;
			b.setTexture(_boxBorderTexture);
			_borders[i] = b ;
		}
		node.addChild(_borderContainer);
	}

	public function get background():Boolean {return _background;}
	public function set background(value:Boolean):void {
		if( _background == value ) return ;
		_background = value;
		if(!_background && _backgroundSprite ){
			node.removeChild(_backgroundSprite.node);
			_backgroundSprite = null ;
		} else {
			_backgroundSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite ;
			_backgroundSprite.setTexture(_boxBorderTexture);
			_backgroundSprite.node.transform.color = _backgroundColor ;
			_backgroundSprite.blendMode = GBlendMode.NONE ;
			node.addChild(_backgroundSprite.node);
			node.putChildToBack(_backgroundSprite.node);
			_invalidateBackground = true ;
		}
		node.putChildToFront(_textNode);
	}

	public function get backgroundColor():uint {return _backgroundColor;}
	public function set backgroundColor(value:uint):void {
		if( _backgroundColor == value ) return ;
		_backgroundColor = value;
		if(_backgroundSprite) _backgroundSprite.node.transform.color = _backgroundColor ;
	}

	public function get fontSize():Number {return _fontSize;}
	public function set fontSize(value:Number):void {
		if( _fontSize == value ) return ;
		_fontSize = value;
		_invalidateText = true ;
	}

	public function get text():String {return _text;}
	public function set text(value:String):void {
		if( _text == value ) return ;
		_text = value;
		_invalidateText = true ;
	}

	public function get autoScale():Boolean {return _autoScale;}
	public function set autoScale(value:Boolean):void {
		if( _autoScale == value ) return ;
		_autoScale = value;
		_invalidateText = true ;
	}

	public function get kerning():Boolean {return _kerning;}
	public function set kerning(value:Boolean):void {
		if( _kerning == value ) return ;
		_kerning = value;
		_invalidateText = true ;
	}

	public function get letterSpacing():Number {return _letterSpacing;}
	public function set letterSpacing(value:Number):void {
		if( _letterSpacing == value ) return ;
		_letterSpacing = value;
		_invalidateText = true ;
	}

	public function get leading():Number {return _leading;}
	public function set leading(value:Number):void {
		if( _leading == value ) return ;
		_leading = value;
		_invalidateText = true ;
	}

	public function get hAlign():String {return _hAlign;}
	public function set hAlign(value:String):void {
		if( _hAlign == value ) return ;
		_hAlign = value;
		_invalidateAlign = true ;
	}

	public function get vAlign():String {return _vAlign;}
	public function set vAlign(value:String):void {
		if( _vAlign == value ) return ;
		_vAlign = value;
		_invalidateAlign = true ;
	}
}
}
