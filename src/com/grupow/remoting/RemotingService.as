
/**
 * 
 * RemotingService by GrupoW
 * GrupoW
 *  
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/
 
package com.grupow.remoting
{
	import com.dannypatterson.remoting.ServiceProxyEvent;
	import com.dannypatterson.remoting.FaultEvent;
	import com.dannypatterson.remoting.ResultEvent;
	import com.dannypatterson.remoting.Operation;
	import com.dannypatterson.remoting.ServiceProxy;

	/**
	* ...
	* @author Raúl Uranga
	*/
	public class RemotingService extends ServiceProxy implements IRemotingService
	{
		public function RemotingService(gateway:String, service:String, useOperationPooling:Boolean = true)
		{
			super(gateway, service, useOperationPooling);
		}
		
		public function request(value:IRemotingRequest):IRemotingRequest {
			
			var operation:Operation = this.call(value.remoteCallName,value.requestVars);
			
			operation.addEventListener(ResultEvent.RESULT, value.onResult, false, 0, false);
			operation.addEventListener(FaultEvent.FAULT, value.onFault, false, 0, false);
			operation.addEventListener(FaultEvent.CONNECTION_ERROR, value.onTimeout, false, 0, false);
			operation.addEventListener(ServiceProxyEvent.CALL, value.onRemoteCall, false, 0, false);
			
			return value;
		}

	}
	
}