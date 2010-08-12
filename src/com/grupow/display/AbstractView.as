
/**
 * 
 * Grupow AbstractView
 * Copyright (c) 2010 ruranga@grupow.com
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.display
{
	import flash.events.Event;

	import com.grupow.events.ViewEvent;
	import flash.display.MovieClip;

	/**
	 * ...
	 * @author Raúl Uranga
	 */

	public class AbstractView extends MovieClip implements IView
	{
		private var _isOpen:Boolean;
		
		public function AbstractView()
		{
			super();
			
			_isOpen = false;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
			
		}

		private function onRemovedFromStage(e:Event):void 
		{
			removedFromStage_handler();
		}

		private function onAddedToStage(e:Event):void 
		{
			addedToStage_handler();
		}
		
		protected function removedFromStage_handler():void 
		{
			dispose();
		}

		protected function addedToStage_handler():void 
		{
			
		}

		protected function opened_handler():void
		{
			this.dispatchEvent(new ViewEvent(ViewEvent.OPENED));
		}
		
		protected function closed_handler():void
		{
			this.dispatchEvent(new ViewEvent(ViewEvent.CLOSED));
		}
		
		protected function open_hook():void
		{
			gotoAndPlay("open");
		}
		
		protected function close_hook():void
		{
			gotoAndPlay("close");
		}
			
		public function getIsOpen():Boolean
		{
			return _isOpen;
		}
		
		public function open():void
		{			
			if (!_isOpen) {
				_isOpen = true;
				open_hook();
				this.dispatchEvent(new ViewEvent(ViewEvent.OPEN));
			}
		}
		
		public function close():void
		{
			if (_isOpen) {
				_isOpen = false;
				close_hook();
				this.dispatchEvent(new ViewEvent(ViewEvent.CLOSE));
			}
		}
		
		public function dispose():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
	}
}