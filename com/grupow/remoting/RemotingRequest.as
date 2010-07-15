package com.grupow.remoting 
{
	import com.dannypatterson.remoting.ServiceProxyEvent;
	import com.dannypatterson.remoting.ResultEvent;
	import com.dannypatterson.remoting.FaultEvent;
	import flash.events.EventDispatcher;

	/**
	 * @author Raul Uranga
	 */
	public class RemotingRequest extends EventDispatcher implements IRemotingRequest
	{
		private var ourRequestVars:Array;
		private var _remoteCallName:String;

		public function RemotingRequest(remoteCallName:String = "ABSTRACT")
		{
			this._remoteCallName = remoteCallName;
			this.ourRequestVars = new Array();
		}
		
		public function onRemoteCall(event:ServiceProxyEvent):void
		{
			//trace("RemotingRequest.onRemoteCall: "+remoteCallName);
			dispatchEvent(new ServiceProxyEvent(ServiceProxyEvent.CALL, true, true));
		}

		public function onTimeout(event:FaultEvent):void 
		{
			//trace("RemotingRequest.onTimeout: "+remoteCallName);
			dispatchEvent(new FaultEvent(event.type, event.bubbles, event.cancelable, event.fault));
		}

		public function onFault(event:FaultEvent):void 
		{
			//trace("RemotingRequest.onFault: "+remoteCallName);
			dispatchEvent(new FaultEvent(event.type, event.bubbles, event.cancelable, event.fault));
		}

		public function onResult(event:ResultEvent):void 
		{
			//trace("RemotingRequest.onResult: "+remoteCallName);
			dispatchEvent(new ResultEvent(event.type, event.bubbles, event.cancelable, event.result));
		}

		public function get remoteCallName():String
		{
			return _remoteCallName;
		}

		public function set requestVars( myVars:Array ):void
		{
			ourRequestVars = myVars;
		}

		public function get requestVars():Array
		{
			return ourRequestVars;
		}
	}
}
