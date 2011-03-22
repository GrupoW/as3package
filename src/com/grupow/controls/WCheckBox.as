
/**
 * 
 * WCheckBox by GrupoW 
 * Copyright (c) 2003-2010 GrupoW
 * 
 * this file is part of com.grupow.controls package
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.controls 
{
	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author Raúl Uranga
	 */
	public class WCheckBox extends WLabelButton
	{
		private var _isSelected:Boolean;

		public function WCheckBox() 
		{
			super();
			_isSelected = false;
		}

		override protected function click_handler(e:MouseEvent):void 
		{
			toggleActive();
			super.click_handler(e);
		}
		
		override protected function rollOver_handler(e:MouseEvent):void
		{
			if(!_isSelected)
				this.gotoAndPlay("over");
		}

		override protected function rollOut_handler(e:MouseEvent):void
		{
			if(!_isSelected)
				this.gotoAndPlay("out");
		}

		private function toggleActive():void 
		{
			_isSelected = !_isSelected;
			if(_isSelected) {
				this.gotoAndPlay("active");
			} else {
				this.gotoAndPlay("deactive");
			}
		}

		public function get selected():Boolean
		{
			return _isSelected;
		}

		public function set selected(value:Boolean):void
		{
			if(value && !_isSelected) {
				_isSelected = true;
				this.gotoAndPlay("active");
			} else if(!value && _isSelected) {
				_isSelected = false;
				this.gotoAndPlay("deactive");
			}
		}
	}	
}