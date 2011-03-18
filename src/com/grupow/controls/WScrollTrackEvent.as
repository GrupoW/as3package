

/**
 * 
 * WScrollTrackEvent by GrupoW 
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
	import flash.events.Event;
	
	/**
	* ...
	* @author Raúl Uranga
	*/			 
	public class WScrollTrackEvent extends Event
	{
		public static const CHANGE:String = "change";
		public static const BEGIN_SCRUB:String = "begingScrub";
		public static const END_SCRUB:String = "endScrub";
		
		public var position:Number;
		
		public function WScrollTrackEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,position:Number = 0) {
			super(type, bubbles, cancelable);
			this.position = position;
		}
		
		public override function clone():Event {
            return new WScrollTrackEvent(type, bubbles, cancelable,this.position);
        }
		
	}
	
}