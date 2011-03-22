

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
		public static const CHANGE:String = "WScrollTrackEvent_change";
		public static const BEGIN_SCRUB:String = "WScrollTrackEvent_begingScrub";
		public static const END_SCRUB:String = "WScrollTrackEvent_endScrub";

		public var position:Number;

		public function WScrollTrackEvent(type:String, position:Number = 0) 
		{
			super(type, false, false);
			this.position = position;
		}

		public override function clone():Event 
		{
			return new WScrollTrackEvent(type, this.position);
		}
	}
}