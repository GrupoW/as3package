
/**
 * 
 * CaptionData by GrupoW
 * Copyright (c) 2003-2010 GrupoW
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.video 
{
	
	/**
	* ...
	* @author Raúl Uranga
	*/
	public class CaptionData 
	{
		public var text:String;
		public var begin:Number;
		public var end:Number;
		
		public function CaptionData(begin:Number = 0, end:Number = 0, text:String = "") {
			this.begin = begin;
			this.end = end;
			this.text = text;
		}
		
	}
	
}