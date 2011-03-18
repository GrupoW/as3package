package com.grupow.debug
{
	import flash.events.Event;

	public class LogEvent extends Event 
	{
		public static const LOG:String = "log";

		public var message:String;
		public var level:int;

		
		public function LogEvent(message:String = "", level:int = 0 /* WLogEventLevel.ALL */)
		{
			super(LogEvent.LOG, false, false);

			this.message = message;
			this.level = level;
		}

		override public function clone():Event
		{
			return new LogEvent(message, /*type,*/ level);
		}

		
		public static function getLevelString(value:uint):String
		{
			switch (value) {
				case LogEventLevel.INFO:
					{
					return "INFO";
				}

				case LogEventLevel.DEBUG:
				{
					return "DEBUG";
				}

				case LogEventLevel.ERROR:
				{
					return "ERROR";
				}

				case LogEventLevel.WARN:
				{
					return "WARN";
				}

				case LogEventLevel.FATAL:
				{
					return "FATAL";
				}

				case LogEventLevel.ALL:
				{
					return "ALL";
				}
			}

			return "UNKNOWN";
		}
	}
}