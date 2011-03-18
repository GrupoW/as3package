
/**
 * 
 * Grupow WComboBox 
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
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * ...
	 * @author Raúl Uranga
	 */
	public class WComboBox extends WAbstractControl
	{
		private var _list:WList;
		private var _isOpen:Boolean;
		private var cb_btn:WButton;
		private var listContainer:Sprite;

		public function WComboBox() 
		{
			super();
			
			_list = new WList();
			
			cb_btn = WButton(this.getChildAt(0));
			
			this.width = WButton(cb_btn).width;
			this.height = cb_btn.height;
						
			_list.x = this.width + 20;
			_list.showBorder = false;
			_list.addEventListener(Event.CHANGE, onListChange);		
			_list.addEventListener(WAbstractControl.DRAW, onListDraw_handler);
			
			cb_btn.addEventListener(MouseEvent.CLICK, click_handler);
			
			listContainer = new Sprite();
			
			listContainer.y = WButton(cb_btn).height;
			listContainer.addChild(_list);
			
			trace("listContainer " + listContainer.y)
			
			addChildAt(listContainer, 0);
		}

		private function onListDraw_handler(e:Event):void 
		{
			this.draw();
		}

		private function click_handler(e:MouseEvent):void 
		{
			this.open();
		}

		private function onListChange(e:Event):void 
		{
			cb_btn.label = WList(e.target).selectedItem.label;
			this.close();
			this.dispatchEvent(e);
		}

		protected override function init():void
		{	
		}

		protected override function destroy():void 
		{
			_list.removeEventListener(Event.CHANGE, onListChange);		
			_list.removeEventListener(WAbstractControl.DRAW, onListDraw_handler);
			cb_btn.removeEventListener(MouseEvent.CLICK, click_handler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, checkBounds_handler);
		}

		private function opened_handler():void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, checkBounds_handler);
		}

		private function checkBounds_handler(e:Event):void 
		{
			//if (boundsRect != null) {
			//return this.boundsRect.containsPoint(new Point(this.mouseX, this.mouseY));
			//	return this.mouseX > boundsRect.x && this.mouseX < this.boundsRect.width && this.mouseY > boundsRect.y && this.mouseY < boundsRect.height;
			//}
			//*/
			var offset:uint = 50;
			
			var inBounds:Boolean = (this.mouseX > -offset && this.mouseX < this.width + offset && this.mouseY > -offset && this.mouseY < this.height + _list.height + offset);
				
			if (!inBounds) {
				this.removeEventListener(MouseEvent.MOUSE_MOVE, checkBounds_handler);
				this.close();
			}
			//*/
		}

		public function open():void
		{
			if (!_isOpen) {
				
				cb_btn.setEnabled(false);
				cb_btn.gotoAndPlay("open");
				_isOpen = true;
				_list.y = -_list.height;
				_list.x = 0;
				_list.scrollPosition = 0;
				TweenLite.to(_list, 0.8, { y:0, ease:Cubic.easeOut, onComplete:opened_handler});
			}
		}

		public function close():void
		{
			if (_isOpen) {
				cb_btn.setEnabled(true);
				cb_btn.gotoAndPlay("close");
				_isOpen = false;
				TweenLite.to(_list, 0.8, { y: -_list.height, ease:Cubic.easeOut});
			}
		}

		override public function set width(value:Number):void 
		{
			super.width = cb_btn.width;
		}

		override public function set height(value:Number):void 
		{
			super.height = cb_btn.height;
		}

		override protected function draw():void 
		{
			listContainer.scrollRect = new Rectangle(0, 0, _width, _list.height);
			//this.scrollRect = new Rectangle(0, 0, _width, cb_btn.height + _list.height);
			super.draw();
		}

		public function set showBorder(value:Boolean):void 
		{
			_list.showBorder = value;
		}

		public function get label():String 
		{ 
			return cb_btn.label; 
		}

		public function set label(value:String):void 
		{
			cb_btn.label = value;
		}

		public function get rowCount():uint
		{
			return _list.rowCount;
		}

		public function set rowCount(value:uint):void
		{
			_list.rowCount = value;
		}

		public function get length():uint
		{
			return _list.length;
		}

		public function get selectedItem():WButton
		{
			return _list.selectedItem;
		}

		public function addItem(value:WButton):void
		{
			_list.addItem(value);
		}

		public function getItemAt(index:uint):void
		{
			_list.getItemAt(index);
		}

		public function removeItemAt(index:uint):void
		{
			_list.removeItemAt(index);
		}

		public function removeAllItems():void
		{
			_list.removeAllItems();
		}

		public function set listBackground(value:DisplayObject):void
		{
			_list.background = value;
		}
	}
}