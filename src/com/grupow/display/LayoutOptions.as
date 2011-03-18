
/**
 * 
 * LayoutOptions by GrupoW
 * Copyright (c) 2003-2010 GrupoW
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.display 
{

	/**
	 * @author Raul Uranga
	 */
	public class LayoutOptions 
	{
		static public const TOP:uint = 1 << 0;
		static public const LEFT:uint = 1 << 1;
		static public const RIGHT:uint = 1 << 2;
		static public const BUTTOM:uint = 1 << 3;
		static public const CENTER:uint = 1 << 4;

		static public const HORIZONTAL_CENTER:uint = 1 << 5;
		static public const VERTICAL_CENTER:uint = 1 << 6;

		static public const MATCH_STAGEHEIGHT:uint = 1 << 7;
		static public const MATCH_STAGEWIDTH:uint = 1 << 8;

		static public const PERCENT_HORIZONTAL_CENTER:uint = 1 << 9;
		static public const PERCENT_VERTICAL_CENTER:uint = 1 << 10;
	}
}
