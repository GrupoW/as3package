
/**
 * 
 * GetURLCommand by GrupoW
 * Copyright (c) 2003-2010 GrupoW
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.commands 
{
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	* ...
	* @author Raúl Uranga
	*/
	public class GetURLCommand implements ICommand
	{
		private var url:String;
		private var window:String;
		
		public function GetURLCommand(url:String, window:String = "_blank")
		{
			this.url = url;
			this.window = window;
		}
		
		/* INTERFACE com.grupow.commands.ICommand */
		
		public function execute():void
		{
			navigateToURL(new URLRequest(url), window);
		}
		
	}
	
}