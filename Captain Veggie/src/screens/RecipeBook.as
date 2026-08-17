package screens
{
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.Scroller;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.core.*;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.textures.Texture;
	import events.NavigationEvent;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class RecipeBook extends Sprite
	{	
		private var bg:starling.display.Image;
		private var backBtn:Button;
		private var _list:List;
		private var _pageIndicator:PageIndicator;
		private var textTitle:TextField;
		
		public static var RECIPEBOOK:Sprite;
		
		
		public function RecipeBook()
		{
			super();
			RECIPEBOOK = this;
			
			TheLoader.getInstance().initTheLoader("bookImg/imgList.txt");
			
			this.addEventListener(Event.ENTER_FRAME, checkLoaded);
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler );
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
		}
		
		public function initialize():void
		{
			this.visible = true;
		}
		
		private function checkLoaded(evt:Event):void
		{
			if(TheLoader.getInstance()._allLoaded) {
				
				init();
				removeChild(textTitle,true);
				this.removeEventListener(Event.ENTER_FRAME, checkLoaded);
				
			}
		}
		
		private function init():void {
			
			const collection:ListCollection = new ListCollection(
				[
					{ label: "Zucchini's Pizza", texture: TheLoader.getTexture(36) },
					{ label: "Eggrooms", texture: TheLoader.getTexture(35) },
					{ label: "Croquettes", texture: TheLoader.getTexture(34) },
					{ label: "Coming Soon", texture: TheLoader.getTexture(33) },
				]);
			
			const listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout.useSquareTiles = false;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			
			this._list = new List();
			this._list.dataProvider = collection;
			this._list.layout = listLayout;
			this._list.scrollerProperties.snapToPages = true;
			this._list.scrollerProperties.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_NONE;
			this._list.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			this._list.itemRendererFactory = tileListItemRendererFactory;
			this._list.addEventListener(Event.SCROLL, list_scrollHandler);
			this._list.addEventListener( Event.CHANGE, list_changeHandler );
			
			this.addChild(this._list);
			
			const normalSymbolTexture:Texture = Assets.getBackgroundAtlas().getTexture("normal-page-symbol")
			const selectedSymbolTexture:Texture = Assets.getBackgroundAtlas().getTexture("selected-page-symbol");
			this._pageIndicator = new PageIndicator();
			this._pageIndicator.normalSymbolFactory = function():Image
			{
				return new Image(normalSymbolTexture);
			}
			this._pageIndicator.selectedSymbolFactory = function():Image
			{
				return new Image(selectedSymbolTexture);
			}
			this._pageIndicator.direction = PageIndicator.DIRECTION_HORIZONTAL;
			this._pageIndicator.pageCount = 1;
			this._pageIndicator.gap = 3;
			this._pageIndicator.paddingTop = this._pageIndicator.paddingRight = this._pageIndicator.paddingBottom = this._pageIndicator.paddingLeft = 6;
			this._pageIndicator.addEventListener(Event.CHANGE, pageIndicator_changeHandler);
			this.addChild(this._pageIndicator);
			
			this.layout();
			
			backBtn = new Button();
			this.backBtn.defaultSkin = new Image(Assets.getBackgroundAtlas().getTexture("back_btn"));
			this.backBtn.downSkin = new Image(Assets.getBackgroundAtlas().getTexture("back_btn"));
			backBtn.scaleX = backBtn.scaleY = 0.7;
			backBtn.x = 25;
			backBtn.y = stage.stageHeight - 75;
			this.backBtn.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			this.addChild(backBtn);
			this.backBtn.validate();
		}
		
		
		protected function layout():void
		{
			
			this._pageIndicator.width = this.stage.stageWidth;
			this._pageIndicator.validate();
			this._pageIndicator.y = this.stage.stageHeight - this._pageIndicator.height;
			
			const shorterSide:Number = Math.min(this.stage.stageWidth, this.stage.stageHeight);
			const layout:TiledRowsLayout = TiledRowsLayout(this._list.layout);
			layout.paddingTop = layout.paddingRight = layout.paddingBottom = layout.paddingLeft = shorterSide * 0.06;
			layout.gap = shorterSide * 0.04;
			
			this._list.itemRendererProperties.gap = shorterSide * 0.01;
			
			this._list.width = this.stage.stageWidth;
			this._list.height = this._pageIndicator.y;
			this._list.validate();
			
			this._pageIndicator.pageCount = Math.ceil(this._list.maxHorizontalScrollPosition / this._list.width) + 1;
		}		
		
		
		private function addedToStageHandler( event:Event ):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			
			bg = new starling.display.Image(Assets.getBackgroundAtlas().getTexture("background01"));
			this.addChild(bg);
			
			textTitle = new TextField(450, 150, "Loading...", Assets.getFont().name, 60, 0xffffff);
			textTitle.hAlign = HAlign.CENTER;
			textTitle.vAlign = VAlign.TOP;
			textTitle.x = stage.stageWidth/2 - textTitle.width/2;
			textTitle.y = stage.stageHeight/2 - textTitle.height/2;
			this.addChild(textTitle);
			
		}
		
		protected function button_triggeredHandler(event:Event):void
		{
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "mainFromCookBook"}, true));
		}
		
		
		protected function list_changeHandler(event:Event):void
		{
			const eventType:String = _list.selectedItem.label as String;
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: eventType}, true));
		}
		
		protected function tileListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.labelField = "label";
			renderer.iconSourceField = "texture";
			renderer.iconPosition = Button.ICON_POSITION_TOP;
			renderer.defaultLabelProperties.textFormat = new BitmapFontTextFormat(Assets.getFont().name, 45);
			return renderer;
		}
		
		protected function list_scrollHandler(event:Event):void
		{
			this._pageIndicator.selectedIndex = this._list.horizontalPageIndex;
		}
		
		protected function pageIndicator_changeHandler(event:Event):void
		{
			this._list.scrollToPageIndex(this._pageIndicator.selectedIndex, 0, 0.25);
		}
		
		protected function stage_resizeHandler(event:ResizeEvent):void
		{
			this.layout();
		}   
	}
}