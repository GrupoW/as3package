
/**
 * 
 * FLVPlayerEvent by GrupoW
 * Copyright (c) 2003-2010 GrupoW
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.video {
	
	import flash.events.Event;
	
	/**
	* ...
	* @author Raúl Uranga
	*/
	public class FLVPlayerEvent extends Event
	{
		public static const PLAYHEAD_UPDATE:String = "playheadeUpdate";
		public static const READY:String = "ready";
		public static const BUFFERING:String = "buffering";
		public static const BUFFER_COMPLETE:String = "buffer_complete";
		public static const COMPLETE:String = "complete";
		public static const AUTO_REWOUND:String = "autoRewound";
		public static const STOPPED:String = "stoopped";
		public static const PAUSED:String = "paused";
		public static const START_PLAYING:String = "startplaying";
		public static const RESUME:String = "resume";
		
		
		public var time:Number;
		
		public function FLVPlayerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, playheadTime:Number = 0)
		{	
			super(type, bubbles, cancelable);
			time = playheadTime
		}
		
		public override function clone():Event {
            return new FLVPlayerEvent(type, bubbles, cancelable, time);
        }
		
	}
	
}