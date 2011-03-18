
/**
 * 
 * GrupoW TrackingFactory
 * Copyright (c) 2003-2010 GrupoW
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.tracking {
	
	/**
	* @author Raúl Uranga
	* @version 0.1
	*/
	
	public class TrackingFactory {
		
		public static const GOOGLE_ANALYTICS:int = 1;
		//"GoogleAnalytics"
		
		public function TrackingFactory() {
			
		}
		
		public static function create(id:int):ITrackable
		{
			var temp:ITrackable;
			switch (id) {
				
				case GOOGLE_ANALYTICS:
										temp = new GoogleAnalytics();
										break;
			}
			
			return temp;
		}
		
	}
	
}