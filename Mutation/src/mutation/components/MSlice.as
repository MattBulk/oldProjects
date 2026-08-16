/**
 * Created with IntelliJ IDEA.
 * User: rodrigo
 * Date: 12/6/13
 * Time: 8:23 PM
 */
package mutation.components {

    import com.genome2d.components.GComponent;
	import com.genome2d.components.renderables.GSimpleShape;
	import com.genome2d.core.GNode;
	import com.genome2d.core.GNodeFactory;
	import com.genome2d.g2d;
	import com.genome2d.textures.GTexture;

	import flash.geom.Rectangle;

	use namespace g2d ;

	public class MSlice extends GComponent {

		private var _vertices:Vector.<Number>;
		private var _uvs:Vector.<Number>;
		private var _shape:GSimpleShape;

		private var _texture:GTexture ;
		private var _textureW:int ;
		private var _textureH:int ;

		private var _width:int ;
		private var _height:int ;

		public static const SLICE_TYPE_3:int = 0 ;
		public static const SLICE_TYPE_9:int = 1 ;
		private var _sliceType:int ;

		public static const SLICE_3_HORIZONTAL: int = 0 ;
		public static const SLICE_3_VERTICAL: int = 1 ;
		private var _slice3Direction: int = 1 ;

		private var _sliceRect: Rectangle;
		private var _isInvalidated: Boolean;

		/**
		 * Constructor.
		 * @param pNode
		 */
		public function MSlice(pNode:GNode) {
			super(pNode);
			_sliceRect = new Rectangle();
			_vertices = new Vector.<Number>() ;
			_uvs = new Vector.<Number>() ;
			_shape = GNodeFactory.createNodeWithComponent(GSimpleShape) as GSimpleShape ;
			cNode.addChild(_shape.node);
		}

		public function setTexture(pTexture:GTexture):void {
			_texture = pTexture;
			if(!_texture) return ;
			_textureW = _texture.width ;
			_textureH = _texture.height ;
			_height = _textureH ;
			_width = _textureW ;
			_shape.cTexture = _texture ;
		}

		override public function update(p_deltaTime: Number): void {
			if( _isInvalidated ){
				_isInvalidated = false ;
				draw() ;
//				setSize( _width, _height );
			}
		}

		public function get textureId():String{ return _texture ? _texture.id : null ;}
		public function set textureId(pId:String):void{
			setTexture(GTexture.getTextureById(pId)) ;
		}


		public function setSlice3(pDirection: int, pPaddingA: int, pPaddingB:int = 0): void {
			_sliceType = SLICE_TYPE_3 ;
			_sliceRect.setEmpty();
			_sliceRect.x = pPaddingA ;
			_slice3Direction = pDirection ;
			_sliceRect.y = pPaddingB==0 ? pPaddingA : pPaddingB<0 ? -pPaddingB : pPaddingB ;
			buildMesh3() ;
		}

		private function buildMesh3(): void {
			_vertices.length = 0 ;
			_uvs.length = 0 ;
			var isHorizontal:Boolean = _slice3Direction==SLICE_3_HORIZONTAL ;
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
		}

		private function buildMesh9(): void {
			_vertices.length = 0 ;
			_uvs.length = 0 ;

			// define the areas.
			var pad:Rectangle = _sliceRect ;
			var py:int = 0 ;
			defPoly( 0, py, pad.x, pad.y );
			defPoly( pad.x, py, _width - pad.width, pad.y );
			defPoly( _width - pad.width, py, _width, pad.y );

			py = pad.y ;
			defPoly( 0, py, pad.x, _height - pad.height );
			defPoly( pad.x, py, _width - pad.width, _height - pad.height );
			defPoly( _width - pad.width, py, _width,_height - pad.height );

			py = _height-pad.height ;
			defPoly( 0, py, pad.x, _height );
			defPoly( pad.x, py, _width - pad.width, _height );
			defPoly( _width - pad.width, py, _width,_height );

			_shape.init(_vertices, _uvs);
		}

		[Inline]
		private final function draw(): void {
			if(_sliceType==SLICE_TYPE_9){
				var pad:Rectangle = _sliceRect ;
				var pw:int = _width - pad.width ;
				var ph:int = _height - pad.height ;
				resizePoly( 0, 0, 0, pad.x, pad.y );
				resizePoly( 1, pad.x, 0, pw, pad.y );
				resizePoly( 2, pw, 0, _width, pad.y );

				resizePoly( 3, 0, pad.y, pad.x, ph );
				resizePoly( 4, pad.x, pad.y, pw, ph );
				resizePoly( 5, pw, pad.y, _width, ph );

				resizePoly( 6, 0, ph, pad.x, _height );
				resizePoly( 7, pad.x, ph, pw, _height );
				resizePoly( 8, pw, ph, _width, _height );
			} else {
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
		}

		public function setSize(pW:int, pH:int):void {
			_width = pW ;
			_height = pH ;
			_isInvalidated = true ;
		}

		[Inline]
		private final function resizePoly(pIndex: int, x: int, y: int, w: int, h: int): void {
			var ci:uint = pIndex * 12 ;
			var values:Array= [ x,y, w,y, x,h, w,y, w,h, x,h ] ;
			for (var i:uint = 0; i < 12; i++, ci++) _vertices[ci] = values[i];
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

		public function get sliceRect(): Rectangle {return _sliceRect;}
		public function set sliceRect(value: Rectangle): void {
			_sliceRect = value;
		}

		public function get width(): int {return _width;}
		public function set width(value: int): void {
			if(value==_width)return ;
			_width = value;
			_isInvalidated = true ;
		}

		public function get height(): int {return _height;}
		public function set height(value: int): void {
			if(value==_height)return ;
			_height = value;
			_isInvalidated = true ;
		}

		public function setSlice9(pRect: Rectangle, pMargin: int = 0): void {
			if(pRect==null) _sliceRect.setTo(pMargin,pMargin,pMargin,pMargin);
			else _sliceRect.copyFrom(pRect);
			_sliceType = SLICE_TYPE_9 ;
			buildMesh9() ;
		}

	}
}