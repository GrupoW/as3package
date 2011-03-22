
/**
 * 
 * WSlider by GrupoW 
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
	import flash.geom.Rectangle;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.grupow.controls.WScrollTrackEvent;
	
	/**
	* ...
	* @author Raúl Uranga
	*/
	public class WSlider extends WAbstractControl
	{
		private var bounds:Rectangle;
		private var _currentX:Number;
		private var _lastX:Number;
		private var _isDragging:Boolean;
		private var offset:Number;
		private var xOld:Number;
		private var _max:Number;
		private var _min:Number;
		
		protected var track_btn:SimpleButton;
		protected var track_mc:MovieClip;
		protected var xPos:Number = 0;
			
		public function WSlider() 
		{
			super();
			
			track_btn = getChildByName("slider_btn") as SimpleButton;
			track_mc = getChildByName("track") as MovieClip;
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
			xPos = track_btn.x =  map(value, min, max, bounds.right, bounds.left);
		}
		
		public function get position():Number 
		{ 
			return map(xPos, bounds.right, bounds.left, min, max);
		}
		
		protected override function init():void
		{
			bounds = new Rectangle();
			bounds.right = 0;
			bounds.left = track_mc.width - track_btn.width;
			
			_currentX = track_btn.x;
			_lastX = track_btn.x;
			_isDragging = false;
			_min = 0;
			_max = 1;		
			
			track_btn.addEventListener(MouseEvent.MOUSE_DOWN, onDown_handler, false, 0, true);	
			
			stage.addEventListener(Event.REMOVED_FROM_STAGE, removed_handler, false, 0, true);
			
		}
		
		protected override function destroy ():void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp_handler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove_handler);
			
			track_btn.removeEventListener(MouseEvent.MOUSE_DOWN, onDown_handler);
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
			offset = track_btn.mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove_handler);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp_handler, false, 0, true);
			this.dispatchEvent(new WScrollTrackEvent(WScrollTrackEvent.BEGIN_SCRUB, position));
		}

		private function onUp_handler(e:MouseEvent):void
		{
			_isDragging = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove_handler, false);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp_handler);
			this.dispatchEvent(new WScrollTrackEvent(WScrollTrackEvent.END_SCRUB, position));
			
		}

		private function onMove_handler(e:MouseEvent):void
		{
			xOld = xPos;
			xPos = mouseX - offset;
			
			if (xPos <= bounds.right)
				xPos = bounds.right;
			else if (xPos >= bounds.left)
				xPos = bounds.left;
			
			if (xOld != xPos) 
				this.dispatchEvent(new WScrollTrackEvent(WScrollTrackEvent.CHANGE, position));
				
			track_btn.x = xPos;
							
			e.updateAfterEvent();
		}
		
	}
}
