package com.grupow.debug.targets
{
	
	public class WTraceTarget extends LineFormattedTarget
	{
		public function WTraceTarget()
		{
			super();
		}

		override public function internalLog(message:String):void
		{
			trace(message);
		}
	}
}