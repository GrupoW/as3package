
/**
 * 
 * WRadioButton by GrupoW 
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
	public class WRadioButton extends WLabelButton
	{
		private var _isSelected:Boolean;		private var _groupName:String;		private var _group:WRadioButtonGroup;

		public function WRadioButton() 
		{
			super();
			_isSelected = false;
		}

//		override protected function click_handler(e:MouseEvent):void 
//		{
//			if(_group != null) {
//				_group.selection = this;
//			}
//			toggleActive();
//			super.click_handler(e);
//		}
		
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

//		private function toggleActive():void 
//		{
//			_isSelected = !_isSelected;
//			if(_isSelected) {
//				this.gotoAndPlay("active");
//			} else {
//				this.gotoAndPlay("deactive");
//			}
//		}

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
		
		public function get group():WRadioButtonGroup
		{
			return _group;
		}
		
		public function set group(group:WRadioButtonGroup):void
		{
			_group = group;
			_group.addRadioButton(this);
		}
		
		public function get groupName():String
		{
			return _group.name;
		}
		
//		public function set groupName(groupName:String):void
//		{
//			_groupName = groupName;
//		}
	}	
}