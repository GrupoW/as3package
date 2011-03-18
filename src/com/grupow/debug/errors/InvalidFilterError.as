package com.grupow.debug.errors
{
	
	public class InvalidFilterError extends Error
	{
		public function InvalidFilterError(message:String)
		{
			super(message);
		}
		
		public function toString():String
		{
			return String(message);
		}
			
	}
	
}