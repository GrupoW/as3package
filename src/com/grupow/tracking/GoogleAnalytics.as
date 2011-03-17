
/**
 * 
 * Grupow GoogleAnalytics
 * Copyright (c) 2010 ruranga@grupow.com
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
	
	import flash.external.ExternalInterface;
	
	public class GoogleAnalytics implements ITrackable {
		
		public function GoogleAnalytics() {
			
		}
		
		public function track(... rest):void
		{
			if (ExternalInterface.available) {
				
				//Old Google Analytics Code
				//ExternalInterface.call("urchinTracker",action);
				
				//New Google Analytics Code
				ExternalInterface.call("pageTracker._trackPageview",rest[0]);
				
				trace("Google Analytics Tracking: " + rest[0]);
				
			}else {
				
				trace("External interface is not available for this container.");
				
			}
		}
		
	}
	
}