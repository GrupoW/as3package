
/**
 * 
 * ILayoutManager by GrupoW
 * Copyright (c) 2003-2010 GrupoW
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.display
{
	import flash.display.Stage;
	
	/**
	* ...
	* @author Raúl Uranga
	*/
	
	import com.grupow.display.IResizeable;
	
	public interface ILayoutManager 
	{
		function initialize(stageObj:Stage,minStageWidth:Number,minStageHeight:Number):void;
		function update():void;
		function registerItem(item:IResizeable):void;
		function getItem(index:Number):IResizeable;
		function removeItem(item:IResizeable):void;
		function get stageWidth():Number;
		function get stageHeight():Number;
	}
	
}