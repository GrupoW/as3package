package com.grupow.debug.errors
{
	
	public class InvalidCategoryError extends Error
	{
		public function InvalidCategoryError(message:String)
		{
			super(message);
		}
		
		public function toString():String
		{
			return String(message);
		}
			
	}
	
}