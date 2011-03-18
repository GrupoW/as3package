
/**
 * 
 * InputField by GrupoW
 * Copyright (c) 2003-2010 GrupoW
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.display 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * ...
	 * @author Raúl Uranga
	 */
	public class InputField extends MovieClip
	{
		public static var INPUT_TIME_OUT:uint = 1000;

		public static const INPUT_COMPLETE:String = "input_complete_event";
		public static const FOCUS_IN:String = "focus_in_event";
		public static const FOCUS_OUT:String = "focus_out_event";
		public static const CHANGE:String = "change_event";
		public static const RESET:String = "reset_event";

		
		public var showBorderAtError:Boolean = false;

		private var _isEmail:Boolean = false;
		private var _isRequired:Boolean = false;
		private var _isNumeric:Boolean = false;
		private var _isPassword:Boolean = false;

		protected var _field:TextField;
		protected var ini_str:String;

		public var errorMessage:String = "InputField is Not Valid";

		//public var focusIn_handler:Function = function (target:InputField):void { };
		//public var focusOut_handler:Function = function (target:InputField):void { };

		public var data:Object = new Object();

		private var _inputTimer:Number;

		public function InputField() 
		{
			build_field();
			
			_field.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_field.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_field.addEventListener(Event.CHANGE, onFieldChange);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved_handler);
			
			ini_str = _field.text;
		}

		protected function build_field():void 
		{
			_field = this.getChildAt(0) as TextField;
		}

		protected function onFieldChange(e:Event):void 
		{
			clearTimeout(_inputTimer);
		
			if (getText() != defaultText && getText().length > 0) {
				_inputTimer = setTimeout(dispatchEvent, InputField.INPUT_TIME_OUT, new Event(InputField.INPUT_COMPLETE));
			}
			
			this.dispatchEvent(new Event(InputField.CHANGE));
		}

		protected function onRemoved_handler(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved_handler);
			
			_field.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_field.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_field.removeEventListener(Event.CHANGE, onFieldChange);
		}

		protected function onFocusOut(e:FocusEvent):void 
		{
			if (!this.getText().length) {
				
				clearTimeout(_inputTimer);
				reset();
			}
			
			this.dispatchEvent(new Event(InputField.FOCUS_OUT));
		}

		protected function onFocusIn(e:FocusEvent):void 
		{
			hideBorder();
			
			if(this.getText() == this.ini_str) {
				this.clear();
				
				if (_isPassword) {
					this._field.displayAsPassword = true;
				}
			}
			
			this.dispatchEvent(new Event(InputField.FOCUS_IN));
		}
		
		protected function hideBorder():void
		{
			this._field.border = false;
		}
		
		protected function showBorder():void
		{
			this._field.border = true;
			this._field.borderColor = 0xff0000;
		}

		public function clear():void
		{
			setText("");
		}

		public function getText():String
		{
			return _field.text;
		}

		public function setText(value:String):void
		{
			_field.text = value;
		}

		public function set defaultText(value:String):void
		{
			this.ini_str = value;
			_field.text = value;
		}

		public function get defaultText():String
		{
			return this.ini_str;
		}

		public function get isValid():Boolean
		{
			if ((isRequired && !this.getText().length ) || (isRequired && this.getText() == this.ini_str))
				return false;
			
			if (isEmail) {
				
				if (getText().length < 5) { 
					return false; 
				}

				var iChars:String = "*|,\":<>[]{}`';()&$#%";
				var eLength:int = getText().length;

				for (var i:int = 0;i < eLength;i++) {
					if (iChars.indexOf(getText().charAt(i)) != -1) {
						return false;
					}
				}

				var atIndex:int = getText().lastIndexOf("@");
				if(atIndex < 1 || (atIndex == eLength - 1)) {
					return false;
				}
				
				var pIndex:int = getText().lastIndexOf(".");
				if(pIndex < 4 || (pIndex == eLength - 1)) {
					return false;
				}
				
				if(atIndex > pIndex) {
					return false;
				}
			}
			
			if (_isNumeric) {
				return !isNaN(Number(getText()));
			}
				
			return true;
		}

		public function validate():Boolean
		{
			if (!this.isValid) {
				
				if(showBorderAtError) {
					showBorder();
				}
				
				return false;
				//throw new Error(errorMessage);
			} else {
				hideBorder();
			}
			
			return true;
		}
		
		public function reset():void
		{
			this.setText(this.ini_str);
			this._field.displayAsPassword = false;
			this.dispatchEvent(new Event(InputField.RESET));
		}

		public function get isPassword():Boolean 
		{ 
			return _isPassword; 
		}

		public function set isPassword(value:Boolean):void 
		{
			this._isEmail = false;
			this._isNumeric = false;
			this._isPassword = value;
		}

		public function get isEmail():Boolean 
		{ 
			return _isEmail; 
		}

		public function set isEmail(value:Boolean):void 
		{
			this._isNumeric = false;
			this._isPassword = false;
			
			this._isEmail = value;
		}

		public function get isRequired():Boolean 
		{ 
			return _isRequired; 
		}

		public function set isRequired(value:Boolean):void 
		{
			_isRequired = value;
		}

		public function get isNumeric():Boolean 
		{ 
			return _isNumeric; 
		}

		public function set isNumeric(value:Boolean):void 
		{
			this._isEmail = false;
			this._isPassword = false;
			
			this._isNumeric = value;
		}

		public function get textField():TextField
		{
			return _field;
		}

		override public function get width():Number 
		{ 
			return _field.width; 
		}

		override public function set width(value:Number):void 
		{
			_field.width = value;
		}

		override public function get height():Number 
		{ 
			return _field.height; 
		}

		override public function set height(value:Number):void 
		{
			_field.height = value;
		}
	}
}