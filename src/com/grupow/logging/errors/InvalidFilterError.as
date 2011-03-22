package com.grupow.logging.errors
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