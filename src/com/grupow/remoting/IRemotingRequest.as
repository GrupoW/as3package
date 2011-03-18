
/**
 * 
 * GrupoW IRemotingRequest
 * GrupoW
 *  
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/
 
package com.grupow.remoting 
{
	import com.dannypatterson.remoting.ServiceProxyEvent;
	import com.dannypatterson.remoting.ResultEvent;
	import com.dannypatterson.remoting.FaultEvent;

	import flash.events.IEventDispatcher;
	
	/**
	 * @author Raul Uranga
	 */
	public interface IRemotingRequest extends IEventDispatcher 
	{
		function onRemoteCall(event:ServiceProxyEvent):void;
		function onTimeout(event:FaultEvent):void; 
		function onFault(event:FaultEvent):void;
		function onResult(event:ResultEvent):void;
		function get remoteCallName():String;
		function get requestVars():Array;
		function set requestVars( myVars:Array ):void;

	}
}
