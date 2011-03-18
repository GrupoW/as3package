
/**
 * 
 * GrupoW ColorUtils
 * GrupoW
 *  
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/
 
package com.grupow.utils 
{

	public class ColorUtils 
	{
		public static function stringToHex(string:String):Number 
		{
			string = string.substr(-6, 6);
			return parseInt(string, 16);
		}

		public static function mixColors(color1:Number, color2:Number, ratio:Number = 0):Number
		{
			var c1:Object = {r:color1 >> 16, g:(color1 >> 8) & 0xFF, b:color1 & 0xFF};
			var c2:Object = {r:color2 >> 16, g:(color2 >> 8) & 0xFF, b:color2 & 0xFF};
			return (c1.r + (c2.r - c1.r) * ratio) << 16 | (c1.g + (c2.g - c1.g) * ratio) << 8 | (c1.b + (c2.b - c1.b) * ratio);
		}

		public static function mixColorPairs(colors:Array,ratio:Number = 0):Number 
		{
			
			if (colors.length == 0) {
				return 0;
			}
			
			var i:uint;
			var _pairColors:Array = new Array();
			
			for (i = 0;i < colors.length;i++) {
				if (colors[i + 1] != null) {
					_pairColors.push([colors[i],colors[i + 1]]);
				}
			}

			var pair:Array;
						
			if(ratio == 0) {
				pair = _pairColors[0];
				return  ColorUtils.mixColors(pair[0], pair[1], ratio);
			}else if (ratio == 1) {
				pair = _pairColors[_pairColors.length - 1];
				return  ColorUtils.mixColors(pair[0], pair[1], ratio);
			}
			
			var tLength:Number = ratio * _pairColors.length;
			var currLength:Number = 0;
			var lasLength:Number = 0;
			var n:Number = _pairColors.length;
			
			for (i = 0;i < n;i++) {
				pair = _pairColors[i];
				//brincamos un segmento a la vez
				currLength += 1; //currLength += seg.length;
				if(tLength <= currLength) {
					return ColorUtils.mixColors(pair[0], pair[1], tLength - lasLength); //(tLength-lasLength)/seg.length;
				}
				
				lasLength = currLength;
			}
		}

		public static function rgbToHex(r:Number, g:Number, b:Number):uint
		{
			return (r << 16 | g << 8 | b);
		}

		public static function hexToRGB(hex:uint):Object
		{
			var red:uint = hex >> 16;
			var grnBlu:uint = hex - (red << 16);
			var grn:uint = grnBlu >> 8;
			var blu:uint = grnBlu - (grn << 8);
			return ({r : red, g : grn, b : blu});
		}
	}
}