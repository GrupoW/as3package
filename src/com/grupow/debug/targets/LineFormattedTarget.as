package com.grupow.debug.targets
{
	import com.grupow.debug.AbstractTarget;
	import com.grupow.debug.ILogger;
	import com.grupow.debug.LogEvent;
	
	public class LineFormattedTarget extends AbstractTarget
	{
		public var fieldSeparator:String = " ";
		public var includeCategory:Boolean;
		public var includeDate:Boolean;
		public var includeLevel:Boolean;
		public var includeTime:Boolean;

		
		public function LineFormattedTarget()
		{
			super();

			includeTime = false;
			includeDate = false;
			includeCategory = false;
			includeLevel = false;
		}
		
		override public function logEvent(event:LogEvent):void
		{
			var date:String = "";
			if (includeDate || includeTime)
			{
				var d:Date = new Date();
				if (includeDate)
				{
					date = Number(d.getMonth() + 1).toString() + "/" +
						   d.getDate().toString() + "/" + 
						   d.getFullYear() + fieldSeparator;
				}   
				if (includeTime)
				{
					date += padTime(d.getHours()) + ":" +
							padTime(d.getMinutes()) + ":" +
							padTime(d.getSeconds()) + "." +
							padTime(d.getMilliseconds(), true) + fieldSeparator;
				}
			}
			
			var level:String = "";
			if (includeLevel)
			{
				level = "[" + LogEvent.getLevelString(event.level) +
						"]" + fieldSeparator;
			}

			var category:String = includeCategory ?
								  ILogger(event.target).category + fieldSeparator :
								  "";

			internalLog(date + level + category + event.message);
		}
		
		private function padTime(num:Number, millis:Boolean = false):String
		{
			if (millis)
			{
				if (num < 10)
					return "00" + num.toString();
				else if (num < 100)
					return "0" + num.toString();
				else 
					return num.toString();
			}
			else
			{
				return num > 9 ? num.toString() : "0" + num.toString();
			}
		}
		
		public function internalLog(message:String):void
		{
			// override this method to perform the redirection to the desired output
		}
		
		
		
	}
	
}