
/**
 * 
 * FLVPlayerCaptions by GrupoW
 * Copyright (c) 2003-2010 GrupoW
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.video
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * creates Captions Data for the FLVPlayer Class
	 * not support for Styles directly on the TimeText XML file 
	 * @author Raúl Uranga	
	 * @version 0.01
	 */
	
	public class FLVPlayerCaptions extends Sprite
	{
		private var _source:String
		private var xml_loader:URLLoader;
		private var _tt_xml:XML;
		private var _player:FLVPlayer;
		private var captions:Array;
		
		public function FLVPlayerCaptions():void {
			
			captions = [];
			xml_loader = new URLLoader();
			xml_loader.addEventListener(Event.COMPLETE, xmlLoaded, false, 0, true);
					
			output_txt.autoSize = TextFieldAutoSize.CENTER;
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
		}
		
		private function xmlLoaded(e:Event):void
		{
			_tt_xml = new XML(xml_loader.data);
	
			captions = TimedTextParser.parseCaptions(_tt_xml);		
		}
		
		public function get player():FLVPlayer { return _player; }
		
		public function set player(value:FLVPlayer):void 
		{
			_player = value;
			_player.addEventListener(FLVPlayerEvent.PLAYHEAD_UPDATE, update_handler, false, 0, true);
			_player.addEventListener(FLVPlayerEvent.COMPLETE, complete_handler, false, 0, true);
			
			this.x = player.x;
			this.y = this.player.y + this.player.height - (this.height + 5);
			//trace(this.player.y , this.player.height , (this.height + 5));
		}
			
		public function get source():String { return _source; }
		
		public function set source(value:String):void 
		{
			_source = value;
			xml_loader.load(new URLRequest(_source));
		}
		
		private function complete_handler(e:FLVPlayerEvent):void 
		{
			setCaption("");
		}
		
		private function update_handler(e:FLVPlayerEvent):void 
		{
			var current:int = -1;
			
			for (var i:int = 0; i < captions.length; i++) {
				var caption:CaptionData = captions[i] as CaptionData
				if (caption.begin < e.time && caption.end > e.time) {
					current = i;
					break;
				}
			}
			
			if (current == -1) {
				setCaption("");
			}else {
				setCaption(captions[i].text);
			}
		}
		
		private function setCaption(text:String):void
		{
			output_txt.htmlText = text;
			output_txt.width = this.player.width;
			this.y = this.player.y + this.player.height - (this.height + 5);
		}
		
		public function dispose():void
		{
			try {
				xml_loader.close();
			}catch (e:*) {
				
			}
			
			xml_loader.removeEventListener(Event.COMPLETE, xmlLoaded);
			
			_player.removeEventListener(FLVPlayerEvent.PLAYHEAD_UPDATE, update_handler);
			_player.removeEventListener(FLVPlayerEvent.COMPLETE, complete_handler);
			_player = null;
		}
	}
}