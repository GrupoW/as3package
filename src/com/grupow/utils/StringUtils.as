
/**
 * 
 * GrupoW StringUtils
 * GrupoW
 *  
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/
 
package com.grupow.utils 
{

	/**
	 * ...
	 * @author Raúl Uranga
	 */
	public class StringUtils 
	{

		public function StringUtils() 
		{
		}

		static public function has(str:String,c:String):Boolean
		{
			return (str.indexOf(c) != -1);
		}

		static public function replaceChar(str:String, searchValue:String, replaceValue:String):String 
		{
			return str.split(searchValue).join(replaceValue);
		}

		static public function replaceChars(_str:String, keys:Array, chars:Array):String
		{
			var temp:String = _str;
			for (var i:int = 0;i < keys.length;i++) {
				temp = StringUtils.replaceChar(temp, keys[i], chars[i]);
			}
			return temp;
		}

		static public function isEmail(str:String):Boolean
		{
			if (str.length < 5) { 
				return false; 
			}

			var iChars:String = "*|,\":<>[]{}`';()&$#%";
			var eLength:int = str.length;

			for (var i:int = 0;i < eLength;i++) {
				if (iChars.indexOf(str.charAt(i)) != -1) {
					return false;
				}
			}

			var atIndex:int = str.lastIndexOf("@");

			if (atIndex < 1 || (atIndex == eLength - 1)) {
				return false;
			}
			
			var pIndex:int = str.lastIndexOf(".");

			if (pIndex < 4 || (pIndex == eLength - 1)) {
				return false;
			}
			
			if (atIndex > pIndex) {
				return false;
			}
			
			return true;
		};

		static public function dosDigit(n:Number):String 
		{
			return String((n < 10) ? "0" + n : n);
		}

		static public function insertAt(str:String, val:String, pos:Number):String
		{
			return str.substring(0, pos - 1) + val + str.substr(pos);
		}

		static public function cropAt(str:String,pos:Number, suffix:String=""):String
		{
			return str.substring(0, pos) + suffix;
		}

		static public function repeat(str:String,many:Number):String
		{
			var s:String = ""; 
			var t:String = str.toString();
			
			while (--many >= 0) {
				s += t;
			}
			return s;
		};

		static public function addZero(str:String,many:Number):String
		{
			var s:String = "0";
			return (repeat(s, many) + str.toString()).substring((repeat(s, many) + str.toString()).length - (many + 1));
		};

		static public function trim(str:String):String
		{
			var s:String = str.toString();
			return lTrim(rTrim(s));
		};

		static public function  formatTime(milliseconds:Number):String
		{
			var centiseconds:Number = Math.floor(milliseconds / 10);
			var seconds:Number = Math.floor(centiseconds / 100);
			var minutes:Number = Math.floor(seconds / 60);
			var hours:Number = Math.floor(minutes / 60);

			centiseconds %= 100;
			seconds %= 60;
			minutes %= 60;
			hours %= 24;

			return	dosDigit(hours) + ":" + dosDigit(minutes) + ":" + dosDigit(seconds) + ":" + dosDigit(centiseconds);
		}

		static public function formatNumber(number:Number, maxDecimals:int = 0):String 
		{
			var str:String = number.toFixed(maxDecimals).toString();

			var hasSep:Boolean = str.indexOf(".") == -1;
			var sep:int = hasSep ? str.length : str.indexOf(".");

			var ret:String = (hasSep ? "" : ".") + str.substr(sep + 1);
			var i:int = 0;

			while (i + 3 < (str.substr(0, 1) == "-" ? sep - 1 : sep)) {
				ret = "," + str.substr(sep - (i += 3), 3) + ret;
			}
			return str.substr(0, sep - i) + ret;
		}

		static private var TAB:int = 9;
		static private var LINEFEED:int = 10;
		static private var CARRIAGE:int = 13;
		static private var SPACE:int = 32;

		static private function lTrim(str:String):String 
		{
			var s:String = str.toString();
			var i:int = 0;
			while (s.charCodeAt(i) == SPACE || s.charCodeAt(i) == CARRIAGE || s.charCodeAt(i) == LINEFEED || s.charCodeAt(i) == TAB) {
				i++;
			}
			return s.substring(i, s.length);
		};

		static private function rTrim(str:String):String
		{
			var s:String = str.toString();
			var i:int = s.length - 1;
			while (s.charCodeAt(i) == SPACE || s.charCodeAt(i) == CARRIAGE || s.charCodeAt(i) == LINEFEED || s.charCodeAt(i) == TAB) {
				i--;
			}
			return s.substring(0, i + 1);
		};		
	}
}