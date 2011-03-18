
/**
 * 
 * LayoutManager by GrupoW
 * Copyright (c) 2003-2010 GrupoW
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.display
{
	
	/**
	 * ...
	 * @author Raúl Uranga
	 */
	import com.grupow.display.IResizeable;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class LayoutManager extends EventDispatcher implements ILayoutManager
	{
		private static var _instance:LayoutManager;
		private static var _allowInstantiation:Boolean;

		private var _items:Array;
		private var _stage:Stage;

		private var iniStageWidth:Number;
		private var iniStageHeight:Number;

		private var _stageWidth:Number;
		private var _stageHeight:Number;

		private static var _initializated:Boolean = false;
		private var _worker:Sprite;

		public function LayoutManager() 
		{
			if (!_allowInstantiation) {
				throw new Error("Instantiation failed: Use LayoutManager.getInstance() instead of new.");
				return;
			}
			
			_items = new Array();
		}
		
		public static function getInstance():LayoutManager
		{
			if (_instance == null) {
				_allowInstantiation = true;
				_instance = new LayoutManager();
				_allowInstantiation = false;
			}
			
			return _instance;
		}
		
		private function resizeHandler(e:Event = null):void 
		{
			if (_stage == null)
				return;
				
			_stageWidth = _stage.stageWidth;
			_stageHeight = _stage.stageHeight;

			if (_stageWidth < iniStageWidth) {
				_stageWidth = iniStageWidth;
			}
			//
			if (_stageHeight < iniStageHeight) {
				_stageHeight = iniStageHeight;
			}
			
			for each (var item:IResizeable in _items) {
				item.resizeTo(_stageWidth, _stageHeight);
			}
			
			this.dispatchEvent(new Event(Event.CHANGE));
		}

		private function invalidate():void
		{
			_worker.addEventListener(Event.ENTER_FRAME, onInvalidate);
		}

		private function onInvalidate(e:Event):void 
		{
			_worker.removeEventListener(Event.ENTER_FRAME, onInvalidate);
			this.update();
		}
		
		
		/* INTERFACE com.grupow.display.ILayoutManager */
		
		public function initialize(stageObj:Stage,minStageWidth:Number,minStageHeight:Number):void
		{
			if (_initializated)
				return;
			
			_worker = new Sprite();
			
			_initializated = true;
				
			_stage = stageObj;
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			_stage.align = StageAlign.TOP_LEFT;
			_stage.displayState = StageDisplayState.NORMAL;
			_stage.addEventListener(Event.RESIZE, resizeHandler);
						
			iniStageWidth = minStageWidth;
			iniStageHeight = minStageHeight;
			
			_stageWidth = _stage.stageWidth;
			_stageHeight = _stage.stageHeight;
		}

		public function update():void
		{
			resizeHandler();
		}

		public function registerItem(item:IResizeable):void
		{
			_items.push(item);
			
			invalidate();
		}

		public function getItem(index:Number):IResizeable
		{
			return IResizeable(_items[index]);
		}

		public function removeItem(item:IResizeable):void
		{
			for (var i:Number = 0;i < _items.length;i++) {
				if (_items[i] == item) {
					_items.splice(i, 1);
					break;
				}
			}
		}

		public function get stageWidth():Number 
		{ 
			return _stageWidth; 
		}

		public function get stageHeight():Number 
		{ 
			return _stageHeight; 
		}
	}
}