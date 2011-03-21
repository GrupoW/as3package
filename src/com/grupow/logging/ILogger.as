﻿package com.grupow.logging
{
	import flash.events.IEventDispatcher;
	
	public interface ILogger extends IEventDispatcher
	{
		function get category():String;
		
		function log(level:int, message:String, ... rest):void;
		function debug(message:String, ... rest):void;
		function error(message:String, ... rest):void;
		function fatal(message:String, ... rest):void;
		function info(message:String, ... rest):void;
		function warn(message:String, ... rest):void;
		function memorySnapshot():String;
	}
	
}