
/**
 * 
 * Grupow WList 
 * Copyleft (c) 2009 ruranga@grupow.com
 * 
 * this file is part of com.grupow.controls package
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.controls 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	* ...
	* @author Raúl Uranga
	*/
	public class WList extends WAbstractControl
	{
		private var container_mc:Sprite;
		private var mask_mc:Sprite;
		private var border_mc:Sprite;
		private var bgContainer:Sprite;
		private var itemsContainer:Sprite;
		private var _items:Array;
		
		private var dy:Number = 0;
		private var _borderColor:uint = 0x000000;
		
		private var scrollEnabled:Boolean = true;
		private var _selectedItem:WButton;
		
		private var _showBorder:Boolean = true;
		
		public var boundsRect:Rectangle;
		
		private var _rowCount:uint = 5;
		private var _background:DisplayObject;
	
		public function WList() 
		{
			super();
		
			_width = 120;
			_height = 100;
			
		
			_items = new Array();
				
			this.removeChildAt(0)
		}
		
		protected override function init():void
		{	
			buildSprites();
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (e.target is WButton) {
				_selectedItem = WButton(e.target);
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		protected override function destroy():void 
		{
			removeEventListener(MouseEvent.CLICK, onClick);
			
			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME, enterframe_handler);
		}
		
		private function buildSprites():void
		{
			container_mc = new Sprite();
			
			mask_mc = new Sprite();
			border_mc = new Sprite();
			bgContainer = new Sprite();
			itemsContainer = new Sprite();
			
			addChild(container_mc);
			addChild(mask_mc);
			addChild(border_mc);
				
			container_mc.addChild(bgContainer);
			container_mc.addChild(itemsContainer);
			
			container_mc.mask = mask_mc;
		}
		
		private function enterframe_handler(e:Event):void 
		{
			if (!inBounds()) { return; }
			
			dy += ( _height/2 - this.mouseY) / 10;
			
			if (dy > 0)
				dy = 0;
			
			//if (dy < (_height - this._items.length * 16))
			//	dy = (_height - this._items.length * 16);
			
			if (dy < (_height - itemsContainer.height))
				dy = (_height - itemsContainer.height);
			
			
			this.itemsContainer.y = dy; 
		}
		
		private function inBounds():Boolean
		{
			if (boundsRect != null) {
				//return this.boundsRect.containsPoint(new Point(this.mouseX, this.mouseY));
				return this.mouseX > boundsRect.x && this.mouseX < this.boundsRect.width && this.mouseY > boundsRect.y && this.mouseY < boundsRect.height;
			}
			return (this.mouseX > 0 && this.mouseX < this.width && this.mouseY > 0 && this.mouseY < this.height);
		}
		
		override protected function draw():void
		{
			var defaultHeight:Number = 20;
			
			if (this.getItemAt(0) != null) {
				defaultHeight = this.getItemAt(0).height;	
			}
			
			_height = _rowCount > this._items.length ? this._items.length * defaultHeight :  _rowCount * defaultHeight;
			
			drawMask(_width, _height);
			
			this.border_mc.graphics.clear();
			
			if(showBorder) {
				drawBorder(_width, _height);
			}
			
			arrangeItems();
			
			if (this.hasEventListener(Event.ENTER_FRAME)) {
				removeEventListener(Event.ENTER_FRAME, enterframe_handler);			
			}
			
			if(scrollEnabled && _height < this.itemsContainer.height) {
				addEventListener(Event.ENTER_FRAME, enterframe_handler);
			}
			
			super.draw();
		}
		
		private function drawMask(width:Number = 200, height:Number = 250):void
		{
			mask_mc.graphics.clear();
			mask_mc.graphics.lineStyle(1, 0x00FF00, 0.1);
			mask_mc.graphics.beginFill(0x00FF00, 0.5);
			mask_mc.graphics.drawRect(0, 0, width, height);
			mask_mc.graphics.endFill();
		}
		
		private function drawBorder(width:Number = 200, height:Number = 250):void
		{
			
			border_mc.graphics.clear();
			border_mc.graphics.lineStyle(1, _borderColor, 100);
			border_mc.graphics.drawRect(0, 0, width, height);
			
		}
		
		private function arrangeItems():void
		{
			var i:int = 0;
			var prevItem:WButton;
			for each(var item:WButton in _items) {
				item.x = 0;
				item.y = i * (prevItem != null ? prevItem.height : 0);
				//item.width = this._width;
				prevItem = item;
				i++;
			}
		}
			
		public function get selectedItem():WButton { return _selectedItem; }
		
		public function get borderColor():uint { return _borderColor; }
		
		public function set borderColor(value:uint):void 
		{
			_borderColor = value;
			this.invalidate();
		}
		
		public function get showBorder():Boolean { return _showBorder; }
		
		public function set showBorder(value:Boolean):void 
		{
			_showBorder = value;
			this.invalidate();
		}
		
		public function set background(value:DisplayObject):void
		{
			if ( _background != null) {
				this.container_mc.removeChild(_background);
			}
			
			_background = value;
			
			this.container_mc.addChildAt(_background, 0);
		}
		
		public function get length():uint { return _items.length; }
		
		public function get rowCount():uint { return _rowCount; }
		
		public function set rowCount(value:uint):void 
		{
			_rowCount = value;
			dispatchEvent(new Event(Event.RESIZE));
		}
	
		public function addItem(item:WButton):void 
		{
			this.itemsContainer.addChild(item);
			_items.push(item);
			invalidate();
		}
		
		public function getItemAt(index:uint):WButton
		{
			return WButton(_items[index]);
		}
		
		public function removeItemAt(index:uint):void
		{
			_items.splice(index,1);
			invalidate();
		}
		
		public function removeAllItems():void
		{
			_items = new Array();
			while (itemsContainer.numChildren > 0) 
			{
				itemsContainer.removeChildAt(0);
			}
		}
		
		public function set scrollPosition(value:Number):void
		{
			dy = value;
		}
		
		public function get scrollPosition():Number
		{
			return dy;
		}
	}
	
}