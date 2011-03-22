package com.grupow.controls 
{
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author Raul Uranga
	 */
	public class WRadioButtonGroup extends EventDispatcher
	{
		private var _name:String;		private var _selection:WRadioButton;
		private var _list:Array;

		public function WRadioButtonGroup(name:String) 
		{
			_name = name;
			_list = new Array();
		}
		
		public function getGroup(name:String):WRadioButtonGroup
		{
			return new WRadioButtonGroup("default");
		}
		
		public function getRadioButtonAt(index:int):WRadioButton
		{
			return new WRadioButton();
		}
		
		public function getRadioButtonIndex(radioButton:WRadioButton):int
		{
			return 0;
		}
		
		public function removeRadioButton(radioButton:WRadioButton):void
		{
			
		}
		
		public function addRadioButton(radioButton:WRadioButton):void 
		{
			radioButton.addEventListener(MouseEvent.CLICK, onClickRadioButton);
			_list.push(radioButton);
		}

		public function get name():String
		{
			return _name;
		}
		
		public function get numRadioButtons():int
		{
			return _list.length;
		}
		
		public function get selectedData():Object
		{
			return _selection.data;
		}

//		public function set selectedData(value:Object):void
//		{
//			_selectedData = value;
//		}
		
		public function get selection():WRadioButton
		{
			return _selection;
		}
		
		public function set selection(value:WRadioButton):void
		{
			if(_selection != null)
				_selection.selected = false;
				
			_selection = value;
			_selection.selected = true;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function onClickRadioButton(event:MouseEvent):void 
		{
			this.selection = event.target as WRadioButton;
		}
	}
}
