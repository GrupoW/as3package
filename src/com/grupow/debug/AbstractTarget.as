package com.grupow.debug
{
	import com.grupow.debug.errors.InvalidFilterError;
	
	public class AbstractTarget implements ILoggingTarget
	{
		private var _loggerCount:uint = 0;
		private var _id:String;
		private var _level:int = LogEventLevel.ALL;
		private var _filters:Array = [ "*" ];
		
		public function AbstractTarget():void
		{
			super();	
		}
		

		//[Inspectable(category="General", arrayType="String")]
	  
		public function get filters():Array
		{
			return _filters;
		}
		
		public function set filters(value:Array):void
		{
			if (value && value.length > 0)
			{
				// a valid filter value will be fully qualified or have a wildcard
				// in it.  the wild card can only be located at the end of the
				// expression.  valid examples  xx*, xx.*,  *
				var filter:String;
				var index:int;
				var message:String;
				for (var i:uint = 0; i<value.length; i++)
				{
					filter = value[i];
					  // check for invalid characters
					if (FlexLog.hasIllegalCharacters(filter))
					{
						message = "logging" +  "charsInvalid";
						throw new InvalidFilterError(message);
					}

					index = filter.indexOf("*");
					if ((index >= 0) && (index != (filter.length -1)))
					{
						message = "logging" + "charPlacement";
						throw new InvalidFilterError(message);
					}
				} // for
			}
			else
			{
				// if null was specified then default to all
				value = ["*"];
			}

			if (_loggerCount > 0)
			{
				FlexLog.removeTarget(this);
				_filters = value;
				FlexLog.addTarget(this);
			}
			else
			{
				_filters = value;
			}
		}
		
		
		public function get id():String
		{
			return _id;
		}
		
		public function get level():int
		{
			return _level;
		}
		
		public function set level(value:int):void
		{
			//Log.removeTarget(this);
			_level = value;
			//Log.addTarget(this);        
		}
		
		public function addLogger(logger:ILogger):void
		{
			if (logger)
			{
				_loggerCount++;
				logger.addEventListener(LogEvent.LOG, logHandler);
			}
		}

		public function removeLogger(logger:ILogger):void
		{
			if (logger)
			{
				_loggerCount--;
				logger.removeEventListener(LogEvent.LOG, logHandler);
			}
		}
		
		public function initialized(document:Object, id:String):void
		{
			_id = id;
			FlexLog.addTarget(this);
		}

		public function logEvent(event:LogEvent):void
		{
			trace(event);
		}

		private function logHandler(event:LogEvent):void
		{
			if (event.level >= level)
				logEvent(event);
		}
		
		
	}
	
}