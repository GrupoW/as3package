
/**
 * 
 * Grupow MacroCommand
 * Copyright (c) 2010 ruranga@grupow.com
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.commands
{
	/**
	* ...
	* @author Raúl Uranga
	*/
	public class MacroCommand implements ICommand
	{
		private var _commands:Array;
		public function MacroCommand(commands:Array) {
			_commands = commands;
		}
		
		/* INTERFACE com.grupow.commands.ICommand */
		
		public function execute():void
		{
			for each (var item:ICommand in _commands) {
				item.execute();
			}
		}
		
	}
}