
/**
 * 
 * GrupoW TransitionEvent
 * Copyright (c) 2011 ruranga@grupow.com
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.events 
{
	import flash.events.Event;
	
	public class TransitionEvent extends Event
	{
		public static const COMPLETE:String = "TransitionEvent_Complete";
				
		public function TransitionEvent(type:String)
		{
			super(type, false, false);
		}
		
		public override function clone():Event 
		{
            return new TransitionEvent(type);
        }
	}
	
}