
/**
 * 
 * GrupoW IRemotingService
 * GrupoW
 *  
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/
 
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
