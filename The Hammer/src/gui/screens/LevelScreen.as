/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 1/15/14
 * Time: 10:54 AM
 * To change this template use File | Settings | File Templates.
 */
package gui.screens {
import feathers.controls.Button;
import feathers.controls.List;
import feathers.controls.PageIndicator;
import feathers.controls.PanelScreen;
import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.controls.renderers.IListItemRenderer;
import feathers.data.ListCollection;
import feathers.events.FeathersEventType;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.layout.TiledRowsLayout;
import feathers.text.BitmapFontTextFormat;

import gui.Constant;

import starling.display.Image;

import starling.events.Event;

import utils.Settings;
import utils.WriteTheFile;

public class LevelScreen extends PanelScreen {

    private var backBtn:Button;
    private var _list:List;
    private var _pageIndicator:PageIndicator;

    public function LevelScreen() {

        super();

        this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);

    }

    protected function initializeHandler(event:Event):void
    {
        this.layout = new AnchorLayout();

        addTheList();

        backBtn = Constant.getBackButton();

        const backLayoutData:AnchorLayoutData = new AnchorLayoutData();
        backLayoutData.horizontalCenter = 0;
        backLayoutData.top = Constant.MARGIN * Settings.SCALE_FACTOR;
        backBtn.addEventListener(Event.TRIGGERED, triggeredHandler);

        this.backBtn.layoutData = backLayoutData;
        this.addChild(backBtn);

    }

    private function triggeredHandler( event:Event ):void
    {

        this.dispatchEventWith("complete");

    }

    protected function addTheList():void
    {

        const listLayout:TiledRowsLayout = new TiledRowsLayout();
        listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
        listLayout.useSquareTiles = false;
        listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
        listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
        listLayout.manageVisibility = true;

        this._list = new List();
        this._list.dataProvider = new ListCollection();
        this._list.layout = listLayout;
        this._list.snapToPages = true;
        this._list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
        this._list.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
        this._list.itemRendererFactory = tileListItemRendererFactory;
        this._list.addEventListener(Event.SCROLL, list_scrollHandler);
        this._list.addEventListener(Event.CHANGE, list_changeHandler);
        this.addChild(this._list);

        this._pageIndicator = new PageIndicator();
        this._pageIndicator.normalSymbolFactory = function():Image
        {
            return new Image(Constant.NORMAL_SYMBOL);
        };

        this._pageIndicator.selectedSymbolFactory = function():Image
        {
            return new Image(Constant.SELECTED_SYMBOL);
        };

        this._pageIndicator.direction = PageIndicator.DIRECTION_HORIZONTAL;
        this._pageIndicator.pageCount = 1;
        this._pageIndicator.gap = 3;
        this._pageIndicator.paddingTop = this._pageIndicator.paddingRight = this._pageIndicator.paddingBottom = this._pageIndicator.paddingLeft = 2;
        this._pageIndicator.addEventListener(Event.CHANGE, pageIndicator_changeHandler);
        this.addChild(this._pageIndicator);

        populateTheList();

        this.layoutME();
    }

    protected function populateTheList():void {

        for(var i:uint=0; i<10; i++) {

            const str:String = WriteTheFile.getInstance().worldsRoomsXML.world[Settings.WORLD].room[i].@icon;

            this._list.dataProvider.addItem({label:(i + 1), texture: Constant[str]});
        }
    }

    protected function layoutME():void
    {
        this._pageIndicator.width = Constant.STAGE_WIDTH;
        this._pageIndicator.validate();
        this._pageIndicator.y = Constant.STAGE_HEIGHT * .95 - this._pageIndicator.height;

        const shorterSide:Number = Math.min(Constant.STAGE_WIDTH, Constant.STAGE_HEIGHT);
        const layout:TiledRowsLayout = TiledRowsLayout(this._list.layout);
        layout.paddingTop = shorterSide * 0.25;
        layout.paddingBottom = shorterSide * 0.06;
        layout.paddingRight =  layout.paddingLeft = shorterSide * 0.15;
        layout.gap = shorterSide * 0.06;

        this._list.itemRendererProperties.gap = shorterSide * 0.01;

        this._list.width = Constant.STAGE_WIDTH;
        this._list.height = this._pageIndicator.y;
        this._list.validate();

        this._pageIndicator.pageCount = this._list.horizontalPageCount;
    }

    protected function tileListItemRendererFactory():IListItemRenderer
    {
        const renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
        renderer.labelField = "label";
        //renderer.labelOffsetY = 20;
        renderer.iconSourceField = "texture";
        renderer.width = 120;
        renderer.height = 160;
        renderer.defaultSkin = new Image(Constant.ITEM_DEFAULT);
        renderer.downSkin = new Image(Constant.ITEM_DEFAULT);
        renderer.iconPosition = Button.ICON_POSITION_TOP;
        renderer.iconOffsetY = 20;
        renderer.defaultLabelProperties.textFormat = new BitmapFontTextFormat("whiteStriped", 30 * Settings.SCALE_FACTOR);
        return renderer;
    }

    protected function list_changeHandler(event:Event):void
    {

        const level:String = this._list.selectedItem.label as String;
        Settings.LEVEL = int(level);

        Game.GAME.selectTheScene("NapeExample");

        this.dispatchEventWith("showControls");

        this._list.removeEventListener(Event.CHANGE, list_changeHandler);
        this._list.selectedIndex = -1;

        this._list.addEventListener(Event.CHANGE, list_changeHandler);

    }

    protected function list_scrollHandler(event:Event):void
    {
        this._pageIndicator.selectedIndex = this._list.horizontalPageIndex;
    }

    protected function pageIndicator_changeHandler(event:Event):void
    {
        this._list.scrollToPageIndex(this._pageIndicator.selectedIndex, 0, this._list.pageThrowDuration);
    }
}
}
