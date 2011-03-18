
/**
 * 
 * IStateMachine by GrupoW
 * Copyright (c) 2003-2010 GrupoW
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.core 
{
	import flash.events.IEventDispatcher;

	/**
	 * @author Raul Uranga
	 */
	public interface IStateMachine extends IEventDispatcher
	{
		function getCurrentState():IState;
		function setNextState(state:IState):void;
		function getNextState():IState;
		function setPreviousState(state:IState):void;
		function getPreviousState():IState;
		function setState(state:IState):void;
		function gotoNextState():void;
		function gotoPreviousState():void;
	}
}
