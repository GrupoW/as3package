
/**
 * 
 * GrupoW NullLayoutManager
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

	import flash.display.Sprite;

	public class NullLayoutManager implements ILayoutManager
	{

		
		public function NullLayoutManager() 
		{
			//super()
		}
		
		/* INTERFACE com.grupow.display.ILayoutManager */
		
		public function initialize(stageObj:Stage, minStageWidth:Number, minStageHeight:Number):void
		{
			
		}
		
		public function update():void
		{
		}

		public function registerItem(item:IResizeable):void
		{
		}

		public function getItem(index:Number):IResizeable
		{
			return new LayoutItem(new Sprite(), LayoutOptions.CENTER);
		}

		public function removeItem(item:IResizeable):void
		{
			
		}

		public function get stageWidth():Number 
		{ 
			return 0; 
		}

		public function get stageHeight():Number 
		{ 
			return 0; 
		}
	}
}