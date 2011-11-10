
/**
 * 
 * FLVPlayerErrorEvent by GrupoW
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
	public class FLVPlayerErrorEvent extends Event
	{
	
		//ver la propiedad "info" de la clase NetStatusEvent en la ayuda ahi vienen todos los errores =D 

		public static const STREAM_NOT_FOUND:String = "streamNotFound";
		public static const INVALID_SEEK_TIME:String = "invalidSeekTime";
		
		//public static const PLAY_FAILED:String = "playfailed";
		//"NetStream.Play.StreamNotFound"
		//"NetStream.Play.Failed"
		//"NetStream.Seek.InvalidTime"
				
		public function FLVPlayerErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			//this.code = code;
		}
		
		public override function clone():Event {
            return new FLVPlayerErrorEvent(type, bubbles, cancelable);
        }
		
	}
	
}