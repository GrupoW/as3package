
/**
 * 
 * Grupow WScrollPane 
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
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import com.grupow.controls.WScrollTrackEvent;

	/**
	 * ...
	 * @author Raúl Uranga
	 */
	public class WScrollPane extends WAbstractControl
	{
		public var easefunc:Function = Cubic.easeOut;
		public var easeduration:Number = 0.4;
		private var _content:DisplayObject;

		public function WScrollPane() 
		{
			super();
		}

		public function set content(target:DisplayObject):void 
		{
			
			_content = target;
			_content.x = 0;
			_content.y = 0;
			
			this.holder_mc.addChild(target);
				
			if (mask_mc.height - holder_mc.height > 0) {
				scrollTrack_mc.visible = false;
			}
		}

		public function get content():DisplayObject
		{
			return _content;
		}

		protected override function init():void 
		{
			scrollTrack_mc.min = 0;
			scrollTrack_mc.max = 1;
			scrollTrack_mc.addEventListener(WScrollTrackEvent.CHANGE, change_handler, false, 0, true);	
		}

		protected override function destroy():void 
		{
			scrollTrack_mc.removeEventListener(WScrollTrackEvent.CHANGE, change_handler);
		}

		protected function change_handler(e:WScrollTrackEvent):void 
		{
			TweenLite.to(holder_mc, easeduration, { y: (mask_mc.height - holder_mc.height) * e.position, ease:easefunc });
			
			//TODO bubbles event 
			//dispatchEvent (e);
		}
		
		// TODO implement functions
		/*/
		
		public function get vScrollPolicy() : Boolean
		{
			
		}
		
		public function set vScrollPolicy (foo : Boolean)
		{
			
		}
		public function get enabled () : Boolean
		{
			
		}
		public function set enabled (foo : Boolean)
		{
			
		}
		public function get max () : Number
		{
			
		}
		public function set max (foo : Number)
		{
			
		}
		public function get min () : Number
		{
			
		}
		public function set min (foo : Number)
		{
		
		}
		public function get scrollPosition () : Number
		{
			
		}
		public function set scrollPosition (foo : Number)
		{
			
		}
		//*/
	}
}