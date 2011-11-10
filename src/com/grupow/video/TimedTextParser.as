
/**
 * 
 * TimedTextParser by GrupoW
 * Copyright (c) 2003-2010 GrupoW
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.video 
{
	
	/**
	* 
	* based on the TimedTextManager from adobe
	* XML is not validated, for example if you miss the "dur" attribute caption text will not appear
	* @author Raúl Uranga
	*/
	public class TimedTextParser 
	{
		
		private static var NS:Namespace;
		
		public function TimedTextParser() 
		{
			
		}
		
		public static function parseCaptions(ttXML:XML):Array
		{
			var xmlNamespace:Namespace;
			
			TimedTextParser.NS = ttXML.namespace();
			
			default xml namespace = TimedTextParser.NS
			
			var captions:Array = [];
			
			var items:XMLList = ttXML.body.div.p;
			for each(var item:XML in items) {
				captions.push(TimedTextParser.getCaption(item));
			}
			return captions;

		}

		public static function getCaption(xml:XML):Object
		{
			var captions:CaptionData = new CaptionData();
			captions.begin = TimedTextParser.parseTime(xml.@begin);
			captions.end = TimedTextParser.parseTime(xml.@begin) + TimedTextParser.parseTime(xml.@dur);
			captions.text = "";
			
			var children:XMLList = xml.children();
			var captionText:String = "";
			
			for (var i:int = 0; i < children.length(); i++) 
			{
				var child:XML = children[i];
				switch (child.nodeKind()) 
				{
					case "text":
						captionText += child.toString();
						break;
					case "element":
							switch (child.localName()) 
							{
								case "set":
								case "metadata":
								case "span":
									// ignore these tags
									break;
								case "br":
									captionText += "<br/>";
									break;
								default:
									captionText += child.toString();
									break;
							}
						break;
				}
			}
			
			captions.text = captionText;
			return captions;
		}
		
		private static function parseTime(timeStr:String):Number
		{
			// first check for clock format or partial clock format
			var theTime:Number, multiplier:Number;
			var results:Object = /^((\d+):)?(\d+):((\d+)(.\d+)?)$/.exec(timeStr);
			if (results != null) {
				theTime = 0;
				theTime += (uint(results[2]) * 60 * 60);
				theTime += (uint(results[3]) * 60);
				theTime += (Number(results[4]));
				return theTime;
			}

			// next check for offset time
			results = /^(\d+(.\d+)?)(h|m|s|ms)?$/.exec(timeStr);
			if (results != null) {
				switch (results[3]) {
				case "h": multiplier = 3600; break;
				case "m": multiplier = 60; break;
				case "ms": multiplier = .001; break;
				case "s":
				default:
					multiplier = 1;
					break;
				}
				theTime = Number(results[1]) * multiplier;
				return theTime;
			}
			// as a last ditch we treat a bare number as seconds
			theTime = Number(timeStr);
			if (isNaN(theTime) || theTime < 0) {
				return NaN;
			}
			return theTime;
		}
	}
}