
/**
 * 
 * WSimpleButton by GrupoW 
 * Copyright (c) 2003-2010 GrupoW
 * 
 * this file is part of com.grupow.controls package
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.controls
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * ...
	 * @author Raúl Uranga
	 */

	public class WButton extends WAbstractControl
	{
		protected var _output:String;
		protected var _enabled:Boolean;
		protected var output_txt:TextField;

		public function WButton()
		{
			super();
			
			_output = "label";
			_enabled = true;
			
			setHitArea();
			setOutputField();
			
			this.width = this.hitArea.width;
			this.height = this.hitArea.height;
		}

		protected function setOutputField():void 
		{
			var label_mc:MovieClip = getChildByName("label_mc") as MovieClip;
			output_txt = label_mc.getChildByName("output_txt") as TextField;
			output_txt.autoSize = TextFieldAutoSize.LEFT;
			output_txt.wordWrap = false;
		}

		protected function setHitArea():void 
		{
			var hit_mc:MovieClip = getChildByName("hit_mc") as MovieClip;
			hit_mc.visible = false;
			hit_mc.mouseEnabled = false;
			
			this.hitArea = hit_mc;
		}

		public function get label():String 
		{ 
			return _output; 
		}

		public function set label(value:String):void 
		{
			_output = value;
			output_txt.text = _output;
		}

		protected override function init():void
		{	
			this.buttonMode = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.CLICK, click_handler, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OVER, rollOver_handler, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOut_handler, false, 0, true);
		}

		protected override function destroy():void 
		{
			this.removeEventListener(MouseEvent.CLICK, click_handler, false);
			this.removeEventListener(MouseEvent.ROLL_OVER, rollOver_handler, false);
			this.removeEventListener(MouseEvent.ROLL_OUT, rollOut_handler, false);
		}

		public function getEnabled():Boolean 
		{ 
			return _enabled; 
		}

		public function setEnabled(value:Boolean):void 
		{
			_enabled = value;
			
			if (_enabled) {
				
				this.addEventListener(MouseEvent.CLICK, click_handler, false, 0, true);
				this.addEventListener(MouseEvent.ROLL_OVER, rollOver_handler, false, 0, true);
				this.addEventListener(MouseEvent.ROLL_OUT, rollOut_handler, false, 0, true);
			} else {
				
				this.removeEventListener(MouseEvent.CLICK, click_handler, false);
				this.removeEventListener(MouseEvent.ROLL_OVER, rollOver_handler, false);
				this.removeEventListener(MouseEvent.ROLL_OUT, rollOut_handler, false);
			}
			
			this.mouseEnabled = _enabled;
		}

		protected function click_handler(e:MouseEvent):void
		{
		}

		protected function rollOver_handler(e:MouseEvent):void
		{
			this.gotoAndPlay("over");
		}

		protected function rollOut_handler(e:MouseEvent):void
		{
			this.gotoAndPlay("out");
		}

		override protected function draw():void 
		{
//			this.hitArea.width = this.width;
//			this.hitArea.height = this.height;
		}
	}
}