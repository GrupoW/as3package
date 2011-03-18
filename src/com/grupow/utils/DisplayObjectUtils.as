
/**
 * 
 * GrupoW DisplayObjectUtils
 * GrupoW
 *  
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/
 
package com.grupow.utils 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	/**
	 * ...
	 * @author Raúl Uranga
	 */
	public class DisplayObjectUtils 
	{

		private static var DEEP:int = 0;

		public function DisplayObjectUtils() 
		{
		}

		static public function stopAllChildren(target:DisplayObjectContainer,recursive:Boolean = true):void 
		{
				
			for (var i:int = 0;i < target.numChildren ;i++) { 
				
				if (target.getChildAt(i) is MovieClip) {
					
					var child:MovieClip = MovieClip(target.getChildAt(i));
					child.stop();
					
					if (recursive) {
						
						//TODO manage MAX recursice steps;
						DisplayObjectUtils.DEEP++;
						
						stopAllChildren(child);
						
						DisplayObjectUtils.DEEP--;
					}
				}
			}
		}

		static public function playAllChildren(target:DisplayObjectContainer,recursive:Boolean = true):void 
		{
				
			for (var i:int = 0;i < target.numChildren ;i++) { 
				
				if (target.getChildAt(i) is MovieClip) {
					
					var child:MovieClip = MovieClip(target.getChildAt(i));
					child.play();
					
					if (recursive) {
						
						//TODO manage MAX recursice steps;

						DisplayObjectUtils.DEEP++;
						
						playAllChildren(child);
						
						DisplayObjectUtils.DEEP--;
					}
				}
			}
		}

		public static function removeAllChildren(target:DisplayObjectContainer):Boolean
		{
			while(target.numChildren) {
				target.removeChildAt(0);
			}
			
			return target.numChildren == 0;
		}
	}
}