
/**
 * 
 * GrupoW TextFieldUtils
 * GrupoW
 *  
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/
 
package com.grupow.utils
{
	import flash.text.TextField;
	import flash.utils.setTimeout;

	public class TextFieldUtils
	{
		function TextFieldUtils() 
		{
			
		}

		static public function setTabIndex(from:Number, collection:Array):void
		{
			from--;
			for (var i:int = 0;i < collection.length;i++) {
				TextField(collection[i]).tabIndex = ++from;
			}
		}

		static public function  clearAfterTimeOut(txt:TextField, ms:Number):Number
		{
			var scope:TextField = txt;
			
			var  __int:Number = setTimeout(function ():void {
													scope.text = "";	
												}, ms);
			return __int;
		}
	}
}
