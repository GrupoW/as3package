
/**
 * 
 * FLVPlayerMetadataEvent by GrupoW
 * Copyright (c) 2003-2010 GrupoW
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.video 
{
	import flash.events.Event;
	/**
	* ...
	* @author Raúl Uranga
	*/
	public class FLVPlayerMetadataEvent  extends Event
	{
		
		public static const METADATA_RECEIVED:String = "onMetadata";
		public static const CUE_POINT:String = "onCuePoint";
		public var info:Object;
		
		public function FLVPlayerMetadataEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,info:Object = null) {
			
			super(type, bubbles, cancelable);
			
			this.info = info;
		}
		
		public override function clone():Event {
            return new FLVPlayerMetadataEvent(type, bubbles, cancelable,info);
        }
		
	}
	
}