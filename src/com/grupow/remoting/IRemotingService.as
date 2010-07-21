package com.grupow.remoting 
{

	/**
	 * @author Raul Uranga
	 */
	public interface IRemotingService 
	{
		function request(value:IRemotingRequest):IRemotingRequest;
	}
}
