
/**
 * 
 * GrupoW MathUtils
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
	public class MathUtils 
	{
		
		public function MathUtils() 
		{
			
		}
		
		public static function toRadians(degs:Number):Number
		{
			return degs*Math.PI/180;
		}
		
		public static function toDegrees(rads:Number):Number
		{
			return rads*180/Math.PI;
		}
	
		/**
		 * 
		 * @param	max
		 * @return	returns a random integer from 0 to max
		 */
		public static function random(max:int):int
		{
			return int(Math.round(Math.random() * max));
		}
		/**
		 * 
		 * @param	min
		 * @param	max
		 * @return	returns a random integer from min to max
		 */
		public static function randomRange(min:int,max:int):int
		{
			return min + MathUtils.random(max - min);
		}
		
		/**
		 * 
		 * @param	collection
		 * @return	returns a random Object from Array
		 */
		public static function randomList(collection:Array):Object
		{
			return collection[MathUtils.random(collection.length - 1)];
		}
		
		/**
		 * 
		 * @param	p specified the probability (0 to 1) that the random "event" occurs.
		 * @return	returns true if a random "event" occurs
		 */
		
		public static function chance(p:Number):Boolean
		{
			return (Math.random() <= p);
		}
	}
	
}