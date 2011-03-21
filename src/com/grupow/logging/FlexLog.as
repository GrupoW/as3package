package com.grupow.logging
{
	import com.grupow.logging.errors.InvalidCategoryError;
	
	public class FlexLog 
	{
		private static var NONE:int = int.MAX_VALUE;
		private static var _targetLevel:int = NONE;
		private static var _loggers:Array;
		private static var _targets:Array = [];
		
		public static function isFatal():Boolean
		{

			return (_targetLevel <= LogEventLevel.FATAL) ? true : false;
		}
		
		public static function isError():Boolean
		{
			return (_targetLevel <= LogEventLevel.ERROR) ? true : false;
		}
	
		public static function isWarn():Boolean
		{
			return (_targetLevel <= LogEventLevel.WARN) ? true : false;
		}

		public static function isInfo():Boolean
		{
			return (_targetLevel <= LogEventLevel.INFO) ? true : false;
		}
		
		public static function isDebug():Boolean
		{
			return (_targetLevel <= LogEventLevel.DEBUG) ? true : false;
		}
		
		public static function addTarget(target:ILoggingTarget):void
		{
			if (target)
			{
				var filters:Array = target.filters;
				var logger:ILogger;
							
				for (var i:String in _loggers)
				{
					if (categoryMatchInFilterList(i, filters))
						target.addLogger(ILogger(_loggers[i]));
				}
				
				_targets.push(target);
				
				if (_targetLevel == NONE)
					_targetLevel = target.level
				else if (target.level < _targetLevel)
					_targetLevel = target.level;
			}
			else
			{
				var message:String = "logging" + " invalidTarget";
				throw new ArgumentError(message);
			}
		}
		
		public static function removeTarget(target:ILoggingTarget):void
		{
			if (target)
			{
				var filters:Array = target.filters;
				var logger:ILogger;
				
				for (var i:String in _loggers)
				{
					if (categoryMatchInFilterList(i, filters))
					{
						target.removeLogger(ILogger(_loggers[i]));
					}                
				}
				for (var j:int = 0; j<_targets.length; j++)
				{
					if (target == _targets[j])
					{
						_targets.splice(j, 1);
						j--;
					}
				}
				resetTargetLevel();
			}
			else
			{
				var message:String = "logging" + " invalidTarget";
				throw new ArgumentError(message);
			}
		}
		
		public static function getLogger(category:String):ILogger
		{
			checkCategory(category);
			if (!_loggers)
				_loggers = [];
				
				
			var result:ILogger = _loggers[category];
			
			//*/
			if (result == null)
			{
				result = new Logger(category);
				_loggers[category] = result;
		

				var target:ILoggingTarget;
				
				for (var i:int = 0; i < _targets.length; i++)
				{
					target = ILoggingTarget(_targets[i]);
					if (categoryMatchInFilterList(category, target.filters))
						target.addLogger(result);
				}

			
			}
			//*/
			
			return result;
		}
		
		public static function flush():void
		{
			_loggers = [];
			_targets = [];
			_targetLevel = NONE;
		}
		
		public static function hasIllegalCharacters(value:String):Boolean
		{
			return value.search(/[\[\]\~\$\^\&\\(\)\{\}\+\?\/=`!@#%,:;'"<>\s]/) != -1;
		}
		
		private static function categoryMatchInFilterList(category:String, filters:Array):Boolean
		{
			var filter:String;
			var index:int = -1;
			for (var i:uint = 0; i < filters.length; i++)
			{
				filter = filters[i];
				
				index = filter.indexOf("*");

				if (index == 0)
					return true;

				index = index < 0 ? index = category.length : index -1;

				if (category.substring(0, index) == filter.substring(0, index))
					return true;
			}
			return false;
		}
		
		private static function checkCategory(category:String):void
		{
			var message:String;
			
			if (category == null || category.length == 0)
			{
				message = "logging" +  "invalidLen";
				throw new InvalidCategoryError(message);
			}

			if (hasIllegalCharacters(category) || (category.indexOf("*") != -1))
			{
				message = "logging" + "invalidChars";
				throw new InvalidCategoryError(message);
			}
		}
		
		private static function resetTargetLevel():void
		{
			var minLevel:int = NONE;
			for (var i:int = 0; i < _targets.length; i++)
			{
				var target:ILoggingTarget = ILoggingTarget(_targets[i]);;
				if (minLevel == NONE || target.level < minLevel)
					minLevel = target.level;
			}
			_targetLevel = minLevel;
		}

			
	}
	
}