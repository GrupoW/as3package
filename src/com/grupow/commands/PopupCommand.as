
/**
 * 
 * GrupoW PopupCommand
 * Copyright (c) 2003-2010 GrupoW
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.commands 
{
	import flash.external.ExternalInterface;
	
	/**
	* ...
	* @author Raúl Uranga
	*/
	public class PopupCommand implements ICommand
	{
		private var url:String;
		private var title:String;
		private var width:Number;
		private var height:Number;
		private var resizable:Number;
		private var scrollbars:Number;
		
		public function PopupCommand(url:String, title:String, width:Number, height:Number, resizable:Number, scrollbars:Number)
		{
			this.url = url;
			this.title = title;
			this.width = width;
			this.height = height;
			this.resizable = resizable;
			this.scrollbars = scrollbars;
		}
		
		/* INTERFACE com.grupow.commands.ICommand */
		
		public function execute():void
		{
			if (ExternalInterface.available) {
				ExternalInterface.call("popUp", this.url, this.title, this.width, this.height, this.resizable, this.scrollbars);
			}
		}
		
	}
	
}