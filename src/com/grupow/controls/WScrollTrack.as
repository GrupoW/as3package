
/**
 * 
 * Grupow WScrollTrack 
 * Copybottom (c) 2009 ruranga@grupow.com
 * 
 * this file is part of com.grupow.controls package
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.controls 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.grupow.controls.WScrollTrackEvent;
	
	/**
	* ...
	* @author Raúl Uranga
	*/
	public class WScrollTrack extends WAbstractControl
	{
		private var bounds:Object;
		private var _currentY:Number;
		private var _lastY:Number;
		private var _isDragging:Boolean;
		private var offset:Number;
		private var oldy:Number;
		private var _max:Number;
		private var _min:Number;
			
		public function WScrollTrack() 
		{
			super();
		}
			
		public function get max():Number
		{ 
			return _max;
		}
		
		public function set max(value:Number):void 
		{
			_max = value;
		}
		
		public function get min():Number
		{ 
			return _min;
		}
		
		public function set min(value:Number):void 
		{
			_min = value;
		}
		
		public function set position(value:Number):void 
		{
			slider_btn.y =  map(value, min, max, bounds.top, bounds.bottom);
		}
		
		public function get position():Number 
		{ 
			return map(slider_btn.y, bounds.top, bounds.bottom, min, max);
		}
		
		
		protected override function init():void
		{
			bounds = { top:0, bottom:track.height - slider_btn.height };
			
			_currentY = slider_btn.y;
			_lastY = slider_btn.y;
			_isDragging = false;
			_min = 0;
			_max = 1;		
			
			slider_btn.addEventListener(MouseEvent.MOUSE_DOWN, onDown_handler, false, 0, true);	
		
		}
		
		protected override function destroy ():void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp_handler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove_handler);
			
			slider_btn.removeEventListener(MouseEvent.MOUSE_DOWN, onDown_handler);
		}
		
		private function normalize(value:Number, minimum:Number, maximum:Number):Number 
		{
			return (value - minimum) / (maximum - minimum);
		}

		private function interpolate(normValue:Number, minimum:Number, maximum:Number):Number 
		{
			return minimum + (maximum - minimum) * normValue;
		}

		private function map(value:Number, min1:Number, max1:Number, min2:Number, max2:Number):Number 
		{
			return interpolate(normalize(value, min1, max1), min2, max2);
		}
		
		private function onDown_handler(e:MouseEvent):void
		{
			_isDragging = true;
			offset = slider_btn.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove_handler);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp_handler, false, 0, true);
			this.dispatchEvent(new WScrollTrackEvent(WScrollTrackEvent.BEGIN_SCRUB, false, false, position));
		}

		private function onUp_handler(e:MouseEvent):void
		{
			_isDragging = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove_handler, false);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp_handler);
			this.dispatchEvent(new WScrollTrackEvent(WScrollTrackEvent.END_SCRUB, false, false, position));
			
		}

		private function onMove_handler(e:MouseEvent):void
		{
			oldy = slider_btn.y;
			slider_btn.y = mouseY - offset;
			
			if (slider_btn.y <= bounds.top)
				slider_btn.y = bounds.top;
			else if (slider_btn.y >= bounds.bottom)
				slider_btn.y = bounds.bottom;
			
			if (oldy != slider_btn.y) 
				this.dispatchEvent(new WScrollTrackEvent(WScrollTrackEvent.CHANGE,false,false,position));
							
			e.updateAfterEvent();
		}
		
	}
}
