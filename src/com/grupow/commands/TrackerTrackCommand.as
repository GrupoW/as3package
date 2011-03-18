
/**
 * 
 * GrupoW TrackerTrackCommand
 * Copyright (c) 2003-2010 GrupoW
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.commands 
{
	import com.grupow.tracking.ITrackable;
	
	/**
	* ...
	* @author Raúl Uranga
	*/
	public class TrackerTrackCommand implements ICommand
	{
		private var tracker:ITrackable;
		private var _args:Array;
		
		public function TrackerTrackCommand(tracker:ITrackable,...rest) 
		{
			this.tracker = tracker;
			_args = rest;
		}
		
		/* INTERFACE com.grupow.commands.ICommand */
		
		public function execute():void
		{
			this.tracker.track.apply(this.tracker,_args);
		}
		
	}
}