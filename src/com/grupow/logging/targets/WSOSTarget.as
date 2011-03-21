package com.grupow.logging.targets
{
	import com.grupow.logging.ILogger;
	import com.grupow.logging.LogEvent;
	import com.grupow.logging.LogEventLevel;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.XMLSocket;

	public class WSOSTarget extends LineFormattedTarget
	{
		private var socket:XMLSocket;
		private var history:Array;
		private var _filters:Array = ["*"];

		public var server:String = "localhost";

		
		public function WSOSTarget()
		{
			//super();
			socket = new XMLSocket();
			history = new Array();
		}

		
		
		override public function logEvent(event:LogEvent):void
		{
			var log:Object = { message:event.message };
			if (includeDate || includeTime) {
				var d:Date = new Date();
				if (includeDate) {
					log.date = Number(d.getMonth() + 1).toString() + "/" + d.getDate().toString() + "/" + d.getFullYear();
				}   
				if (includeTime) {
					log.time = padTime(d.getHours()) + ":" + padTime(d.getMinutes()) + ":" + padTime(d.getSeconds()) + "." + padTime(d.getMilliseconds(), true);
				}
			}
	        
			if(includeLevel) {
				log.level = event.level;
			}
	
			log.category = includeCategory ? ILogger(event.target).category : "";
	
			if(socket.connected) {
				send(log);
			} else {
				if(!socket.hasEventListener("connect")) {
					socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
					socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
					socket.addEventListener(Event.CONNECT, onConnect);
				}
				socket.connect(server, 4444);
				history.push(log);
			}
		}

		private function onIOError(e:IOErrorEvent):void
		{
			trace("XMLSocket IOError");
		}

		private function onSecurityError(e:SecurityErrorEvent):void
		{
			trace("XMLSocket SecurityError");
		}

		private function onConnect(e:Event):void
		{
			this.clear();
			
			for each(var log:Object in history) {
				send(log);
			}
		}

		public function clear():void
		{
			if(socket.connected)	
				socket.send("!SOS<clear/>\n");	
		}

		private function send(o:Object):void
		{
			var msg:String = o.message;
			var lines:Array = msg.split("\n");
			var commandType:String = lines.length == 1 ? "showMessage" : "showFoldMessage";
			var key:String = getTypeByLogLevel(o.level);
			var xmlMessage:XML = <{commandType} key={key} />;
			
			if(lines.length > 1) {
				// set title with first line
				xmlMessage.title = lines[0];
				
				// remove title from message
				xmlMessage.message = msg.substr(msg.indexOf("\n") + 1, msg.length);
				
				if(o.date == null)
					xmlMessage.data = o.data;
				if(o.time == null)
					xmlMessage.time = o.time;
				if(o.category == null)
					xmlMessage.category = o.category;
			} else {
				var prefix:String = "";
				if(o.date != null)
					prefix += o.date + fieldSeparator;
				if(o.time != null)
					prefix += o.time + fieldSeparator;
				if(o.category != null)
					prefix += o.category + fieldSeparator;
					
				xmlMessage.appendChild(prefix + msg);
			}
			
			socket.send('!SOS' + xmlMessage.toXMLString() + '\n');
		}

		private function getTypeByLogLevel(level:int):String
		{
			switch(level) {
				case LogEventLevel.DEBUG :
					return "DEBUG";
				case LogEventLevel.INFO :
					return "INFO";
				case LogEventLevel.WARN :
					return "WARN";
				case LogEventLevel.ERROR :
					return "ERROR";
				case LogEventLevel.FATAL :
					return "FATAL";
				default:
					return "INFO";
			}
		}

		private function padTime(num:Number, millis:Boolean = false):String
		{
			if(millis) {
				if (num < 10)
	                return "00" + num.toString();
	            else if (num < 100)
	                return "0" + num.toString();
	            else 
	                return num.toString();
			} else {
				return num > 9 ? num.toString() : "0" + num.toString();
			}
		}

		override public function internalLog(message:String):void
		{
			trace("WSOSTarget: ", message);
		}
	}
}