
/**
 * 
 * Grupow OpenViewCommand
 * Copyright (c) 2010 ruranga@grupow.com
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.commands 
{
	import com.grupow.display.IView;
	
	/**
	 * ...
	 * @author Raúl Uranga
	 */
	public class OpenViewCommand implements ICommand
	{
		private var view:IView;
		public function OpenViewCommand(view:IView) 
		{
			this.view = view;
		}
		
		/* INTERFACE com.grupow.commands.ICommand */
		
		public function execute():void
		{
			view.open();
		}
		
	}
	
}