
/**
 * 
 * LayoutItem by GrupoW
 * Copyright (c) 2003-2010 GrupoW
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.display
{
	import flash.display.DisplayObject;

	/**
	 * ...
	 * @author Raúl Uranga
	 */
	public class LayoutItem implements IResizeable
	{
		public var width:Number;
		public var height:Number;

		public var xoffset:Number;
		public var yoffset:Number;

		public var percentHorizontalCenter:Number;
		public var percentVerticalCenter:Number;

		public var absolutePosition:Boolean = false;

		private var target:DisplayObject;
		private var _flags:uint;

		private var _items:Array;

		public function LayoutItem(target:DisplayObject,flags:uint) 
		{
			this.target = target;
			
			this.width = this.target.width;
			this.height = this.target.height;
			
			xoffset = 0;
			yoffset = 0;
			
			percentHorizontalCenter = 0;
			percentVerticalCenter = 0;
			
			this._items = new Array();
			
			_flags = flags;
		}

		public function registerItem(item:IResizeable):void
		{
			_items.push(item);
		}

		/* INTERFACE com.grupow.display.IResizeable */

		public function resizeTo(tWidth:Number, tHeight:Number):void
		{
			var xpos:Number = this.target.x;
			var ypos:Number = this.target.y;
			
			
			if (_flags & LayoutOptions.LEFT) {
				xpos = this.xoffset;
			}else if (_flags & LayoutOptions.RIGHT) {
				xpos = tWidth - this.width + this.xoffset;
			}
			
			if (_flags & LayoutOptions.TOP) {
				ypos = this.yoffset;
			}else if (_flags & LayoutOptions.BUTTOM) {
				ypos = tHeight - this.height + this.yoffset;
			}
			
			if (_flags & LayoutOptions.MATCH_STAGEHEIGHT) {
				this.target.height = tHeight;
			}
			
			if (_flags & LayoutOptions.MATCH_STAGEWIDTH) {
				this.target.width = tWidth;
			}
			
			if (_flags & LayoutOptions.HORIZONTAL_CENTER) {
				xpos = (tWidth * 0.5) - (this.width * 0.5) + this.xoffset;
			}
			
			if (_flags & LayoutOptions.VERTICAL_CENTER) {
				ypos = (tHeight * 0.5) - (this.height * 0.5) + this.yoffset;
			}
			
			if (_flags & LayoutOptions.PERCENT_HORIZONTAL_CENTER) {
				xpos = (tWidth * percentHorizontalCenter) - (this.width * 0.5) + this.xoffset;
			}
			
			if (_flags & LayoutOptions.PERCENT_VERTICAL_CENTER) {
				ypos = (tHeight * percentVerticalCenter) - (this.height * 0.5) + this.yoffset;
			}
			
			if (_flags & LayoutOptions.CENTER) {
				xpos = (tWidth * 0.5) - (this.width * 0.5) + this.xoffset;
				ypos = (tHeight * 0.5) - (this.height * 0.5) + this.yoffset;
			}
			
			if (absolutePosition) {
				
				this.target.x = Math.floor(xpos);
				this.target.y = Math.floor(ypos);
			} else {
			
				this.target.x = xpos;
				this.target.y = ypos;
			}
			
			for each(var item:IResizeable in _items) {
				item.resizeTo(this.width, this.height);
			}
		}
	}
}