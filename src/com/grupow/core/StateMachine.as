
/**
 * 
 * StateMachine by GrupoW
 * Copyright (c) 2003-2010 GrupoW
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.core 
{
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Raúl Uranga
	 */
	public class StateMachine extends EventDispatcher implements IStateMachine
	{
		protected var nextState:IState = new NullState();
		protected var previousState:IState = new NullState();
		protected var currentState:IState = new NullState();
		
		public function StateMachine() 
		{
			
		}
				
		public function getCurrentState():IState
		{
			return currentState;
		}
		
		public function setNextState(state:IState):void
		{
			nextState = state;
		}
		
		public function getNextState():IState
		{
			return nextState;
		}
		
		public function setPreviousState(state:IState):void
		{
			previousState = state;
		}
		
		public function getPreviousState():IState
		{
			return previousState;
		}
		
		public function setState(state:IState):void
		{
			currentState.exit();
			previousState = currentState;
			currentState = state;
			currentState.enter();
		}
		
		public function gotoNextState():void
		{
			this.setState(this.nextState);
		}
		
		public function gotoPreviousState():void
		{
			this.setState(this.previousState);
		}
		
	}
}