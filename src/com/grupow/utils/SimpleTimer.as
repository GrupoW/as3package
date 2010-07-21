
/**
 * 
 * GrupoW SimpleTimer
 * Copyright (c) 2009 GrupoW
 *  
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/
 
package com.grupow.utils 
{
	import flash.utils.getTimer;

	public class SimpleTimer
	{
		private var _pauseTime:Number;
		private var _startTime:Number;

		public function SimpleTimer(start:Boolean = false)
		{
			_pauseTime = 0;
			_startTime = 0;
			this.reset(start);
		}

		public function start():void
		{
			if (this._pauseTime) {
				this._startTime += getTimer() - this._pauseTime;
				this._pauseTime = 0;
			} else {
				this.reset(true);
			}
		}

		public function stop():void
		{
			if (!this._pauseTime) this._pauseTime = getTimer();
		}

		public function reset(restart:Boolean = false):void
		{
			
			this._startTime = getTimer();
			
			if (!this._startTime) 
				this._startTime = 1;
				
			if (restart) 
				this._pauseTime = 0;
			else 
				this._pauseTime = this._startTime;
		}

		/**
		 * get's the elapsed time in milisecons
		 */
		public function get time():Number
		{
			if (this._pauseTime) 
				return this._pauseTime - this._startTime;
			
			var gotTime:int = getTimer();
			
			if (!gotTime)
				gotTime = 1;
				
			return gotTime - this._startTime;
		}

		/**
		 * set's the elapsed time in milisecons
		 */
		public function set time(t:Number):void
		{
			this._startTime = getTimer() - t;
		}

		public function get paused():Boolean
		{
			return (this._pauseTime) ? true : false;
		}

		public function set paused(p:Boolean):void
		{
			if (p && !Boolean(this._pauseTime)) 
				this.stop();
			else 
				this.start();
		}
	}
}
