
/**
 * 
 * GrupoW ArrayUtils
 * Copyright (c) 2009 GrupoW
 *  
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/
 
package com.grupow.utils
{

	public class ArrayUtils
	{

		static public function isAdded(arra:Array,value:Object):Boolean 
		{
			for (var i:Number = 0;i <= arra.length;i++) {
				if (arra[i] == value) {
					return true;
				}
			}
			return false;
		}

		static public function copy(data:Array):Array
		{
			return data.slice();
		}

		static public function shuffle(data:Array):Array
		{
			var return_array:Array = new Array();
			var original_length:Number = data.length;
			for (var i:Number = 0;i < original_length;i++) {
				var random_number:int = Math.floor(Math.random() * (data.length));
				return_array[i] = data.splice(random_number, 1);
			}
			return return_array;
		}

		static public function  remove(data:Array,ref:*):Array
		{
			for(var i:Number = 0;i < data.length;i++) {
				if(data[i] == ref) {
					data.splice(i, 1);
				}else if(data[i].length > 0) {
					remove(data[i], ref);
				}
			}
			return data;
		}

		static public function getIndex(arra:Array,value:*):Number
		{
			var checktmp:Number = 1;
			for (var i:Number = 0;i <= arra.length;i++) {
				if (arra[i] == value)
					break;
				checktmp++;
			}
			return checktmp - 1;
		}

		static public function  checkExistence(arra:Array,value:*):Boolean 
		{
			var checktmp:Number = 0;
			for (var i:Number = 0;i <= arra.length;i++) {
				if (arra[i] == value) {
					checktmp++;
					break;
				}
			}
			if (checktmp > 0) {
				return true;
			} else {
				return false;
			}
		};

		static public function  removeDuplicates(arra:Array):Array 
		{
			var i:Number;
			var j:Number; 
			var temp:Array;
		
			temp = arra.slice();
			
			for (i = 0;i < temp.length;i++) {
				for (j = 0;j < temp.length;j++) {
					if (temp[j] == temp[i] && i != j) {
						temp.splice(j, 1);
						j--;
					}
				}
			}
			return temp;
		};
	}
}
