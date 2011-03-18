package com.grupow.debug
{
	import flash.events.EventDispatcher;
	import flash.system.System;

	public class Logger extends EventDispatcher implements ILogger
	{
		private var _category:String;
		
		public function Logger(category:String)
		{
			super();
			
			_category = category;
		}
		
		public function get category():String
		{
			return _category;
		}
		
		public function log(level:int, msg:String, ... rest):void
		{
			// we don't want to allow people to log messages at the 
			// Log.Level.ALL level, so throw a RTE if they do
			if (level < LogEventLevel.DEBUG)
			{
				var message:String ="logging" + "levelLimit";
				throw new ArgumentError(message);
			}
				
			if (hasEventListener(LogEvent.LOG))
			{
				// replace all of the parameters in the msg string
				for (var i:int = 0; i < rest.length; i++)
				{
					msg = msg.replace(new RegExp("\\{"+i+"\\}", "g"), rest[i]);
				}

				dispatchEvent(new LogEvent(msg, level));
			}
		}
		
		public function debug(msg:String, ... rest):void
		{
			if (hasEventListener(LogEvent.LOG))
			{
				// replace all of the parameters in the msg string
				for (var i:int = 0; i < rest.length; i++)
				{
					msg = msg.replace(new RegExp("\\{"+i+"\\}", "g"), rest[i]);
				}

				dispatchEvent(new LogEvent(msg, LogEventLevel.DEBUG));
			}
		}
		
		public function error(msg:String, ... rest):void
		{
			if (hasEventListener(LogEvent.LOG))
			{
				// replace all of the parameters in the msg string
				for (var i:int = 0; i < rest.length; i++)
				{
					msg = msg.replace(new RegExp("\\{"+i+"\\}", "g"), rest[i]);
				}

				dispatchEvent(new LogEvent(msg, LogEventLevel.ERROR));
			}
		}
		
		public function fatal(msg:String, ... rest):void
		{
			if (hasEventListener(LogEvent.LOG))
			{
				// replace all of the parameters in the msg string
				for (var i:int = 0; i < rest.length; i++)
				{
					msg = msg.replace(new RegExp("\\{"+i+"\\}", "g"), rest[i]);
				}

				dispatchEvent(new LogEvent(msg, LogEventLevel.FATAL));
			}
		}

		public function info(msg:String, ... rest):void
		{
			if (hasEventListener(LogEvent.LOG))
			{
				// replace all of the parameters in the msg string
				for (var i:int = 0; i < rest.length; i++)
				{
					msg = msg.replace(new RegExp("\\{"+i+"\\}", "g"), rest[i]);
				}

				dispatchEvent(new LogEvent(msg, LogEventLevel.INFO));
			}
		}

		public function warn(msg:String, ... rest):void
		{
			if (hasEventListener(LogEvent.LOG))
			{
				// replace all of the parameters in the msg string
				for (var i:int = 0; i < rest.length; i++)
				{
					msg = msg.replace(new RegExp("\\{"+i+"\\}", "g"), rest[i]);
				}

				dispatchEvent(new LogEvent(msg, LogEventLevel.WARN));
			}
		}
		
		//*////////////////////*///
		//// MEMORY SNAPSHOT /////
		///*///////////////////*//
		
		public function memorySnapshot():String
	    {
				var currentMemValue: uint = System.totalMemory;
				var message: String = 	"Memory Snapshot: " 
									+ Math.round(currentMemValue / 1024 / 1024 * 100) / 100 
									+ " MB (" 
									+ Math.round(currentMemValue / 1024) 
									+ " kb)";
					return message;
		}
		//*/
	}
	
}