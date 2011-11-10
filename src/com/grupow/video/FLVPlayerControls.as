
/**
 * 
 * FLVPlayerControls by GrupoW
 * Copyright (c) 2003-2010 GrupoW
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/


package com.grupow.video 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.SimpleButton
	import flash.events.MouseEvent;
	import flash.text.TextField;

	
	/**
	* ...
	* @author Raúl Uranga
	*/
	public class FLVPlayerControls extends MovieClip
	{
		private var _flvPlayer:FLVPlayer;
		
		private var _seeking:Boolean;
		private var _isPlaying:Boolean;
		
		protected var _seekBarControl:MovieClip;
		protected var _stopControl:DisplayObject;
		protected var _pauseResumeControl:MovieClip;
		protected var _audioControl:MovieClip;
		protected var _currentTimeOutput:TextField;
		
		private var worker:Sprite;
		
		
		public function FLVPlayerControls(flvPlayer:FLVPlayer = null) 
		{
			
			if (flvPlayer != null) {
				this._flvPlayer = flvPlayer;
				addPlayerListeners();
			}
			
			_isPlaying = false;
			
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, added_handler, false, 0, true);
		
		}
		
		private function added_handler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added_handler);
			
			worker = new Sprite();
			worker.addEventListener(Event.ENTER_FRAME, set_handler, false, 0, true);
		}
		
		private function set_handler(e:Event):void 
		{
			worker.removeEventListener(Event.ENTER_FRAME, set_handler);
			worker.removeEventListener(Event.ENTER_FRAME, set_handler);
			
			if(_seekBarControl != null) {
				_seekBarControl.addEventListener(SeekBarEvent.CHANGE, onChange, false, 0, true);
				_seekBarControl.addEventListener(SeekBarEvent.BEGIN_SCRUB, beginScrub_handler, false, 0, true);
				_seekBarControl.addEventListener(SeekBarEvent.END_SCRUB,endScrub_handler,false,0,true);
			}
			
			if(_stopControl != null) {
				_stopControl.addEventListener(MouseEvent.CLICK,stop_handler,false,0,true);
			}
			
			if(_pauseResumeControl != null) {
				_pauseResumeControl.addEventListener(MouseEvent.CLICK, playPause_handler, false, 0, true);
			}
						
			if(_audioControl != null) {
				_audioControl.buttonMode = true;
				_audioControl.addEventListener(MouseEvent.CLICK,sound_handler,false,0,true);
			}
			
		}
		
		private function stop_handler (e:Event):void 
		{
			_pauseResumeControl.gotoAndStop(1);
			stopVideo();	
		}

		private function sound_handler (e:Event):void
		{
			if(_audioControl.currentFrame == 1) {
				setVideoVolume(0);
				_audioControl.gotoAndStop(2);		
			}else {
				setVideoVolume(1);
				_audioControl.gotoAndStop(1);
			}
		}

		private function playPause_handler (e:Event):void
		{
			if(_pauseResumeControl.currentFrame == 2) {
				pauseVideo();
			}else {
				resumeVideo();
			}
		}
		
		private function endScrub_handler(e:SeekBarEvent):void 
		{
			_seeking = false;
			if (_isPlaying)
				this._flvPlayer.resume();
		}
		
		private function beginScrub_handler(e:SeekBarEvent):void 
		{
			_seeking = true;
			_isPlaying = this._flvPlayer.isPlaying;
			this._flvPlayer.pause();
		}
		
		private function onChange(e:SeekBarEvent):void 
		{
			this._flvPlayer.seek(_flvPlayer.duration * e.position);
		}
		
		private function flvPlayerErrorEvent_handler(e:Event):void
		{
			trace("FLVPlayerControls.flvPlayerErrorEvent_handler: " + e.type);
		}
		
		private function flvPlayerEvent_handler(e:Event):void
		{
			switch (e.type) 
			{
				case FLVPlayerEvent.PLAYHEAD_UPDATE :
													
						if(!_seeking)
							_seekBarControl.position = _flvPlayer.position;
					
						if(_currentTimeOutput != null)
							_currentTimeOutput.text = fixTime(_flvPlayer.time);	
						
						break;
				case FLVPlayerEvent.READY :
								
						_pauseResumeControl.gotoAndStop(2);
											
						break;
				case FLVPlayerEvent.STOPPED :
				
						trace("STOPPED");
						
						_pauseResumeControl.gotoAndStop(1);
						
						break;
				
				case FLVPlayerEvent.RESUME :
				
						trace("RESUME");
						
						_pauseResumeControl.gotoAndStop(2);
						
						break;
				
				case FLVPlayerEvent.PAUSED :
				
						trace("PAUSED");
						
						_pauseResumeControl.gotoAndStop(1);
						
						break;
						
				case FLVPlayerEvent.START_PLAYING :
				
						trace("START_PLAYING");
						
						break;		
					
				case FLVPlayerEvent.COMPLETE :
						
						_pauseResumeControl.gotoAndStop(1);
				
						break;
				case FLVPlayerEvent.BUFFERING :
				
						break;
				case FLVPlayerEvent.AUTO_REWOUND :
				
						this._seekBarControl.position = this._seekBarControl.min;
						_pauseResumeControl.gotoAndStop(1);
						
						break;	
				
				case FLVPlayerProgressEvent.PROGRESS :
						
						var evt:FLVPlayerProgressEvent = e as FLVPlayerProgressEvent;
						_seekBarControl.updateProgress(evt.bytesLoaded/evt.bytesTotal);
						
						break;
				case FLVPlayerMetadataEvent.METADATA_RECEIVED :
				
						/*/
						var evt:FLVPlayerMetadataEvent = e as FLVPlayerMetadataEvent;
						trace("-----------------------")
						trace("::onMetatada_handler::");
						//trace(ObjectUtil.toString(evt.info));
						for (var name:String in evt.info) {
							trace(name + ":" + evt.info[name]);
						}
						trace("-----------------------");
						//*/
						
						break;
				case FLVPlayerMetadataEvent.CUE_POINT :
				
						/*/
						var evt:FLVPlayerMetadataEvent = e as FLVPlayerMetadataEvent;
						trace("-----------------------")
						trace("::onCuePoint_handler::");
						//trace(ObjectUtil.toString(evt.info));
						for (var name:String in evt.info) {
							trace(name + ":" + evt.info[name]);
						}
						trace("-----------------------");
						//*/
						
						break;
			}
		}
		
		private function addPlayerListeners():void
		{
			_flvPlayer.addEventListener(FLVPlayerEvent.READY, flvPlayerEvent_handler, false, 0, true);
			_flvPlayer.addEventListener(FLVPlayerEvent.COMPLETE, flvPlayerEvent_handler , false, 0, true);
			_flvPlayer.addEventListener(FLVPlayerEvent.BUFFERING, flvPlayerEvent_handler, false, 0, true);
			_flvPlayer.addEventListener(FLVPlayerEvent.AUTO_REWOUND, flvPlayerEvent_handler, false, 0, true);
			_flvPlayer.addEventListener(FLVPlayerEvent.PLAYHEAD_UPDATE, flvPlayerEvent_handler, false, 0, true);
			
			_flvPlayer.addEventListener(FLVPlayerEvent.PAUSED, flvPlayerEvent_handler, false, 0, true);
			_flvPlayer.addEventListener(FLVPlayerEvent.START_PLAYING, flvPlayerEvent_handler , false, 0, true);
			_flvPlayer.addEventListener(FLVPlayerEvent.STOPPED, flvPlayerEvent_handler, false, 0, true);
			_flvPlayer.addEventListener(FLVPlayerEvent.RESUME, flvPlayerEvent_handler, false, 0, true);
			
			_flvPlayer.addEventListener(FLVPlayerProgressEvent.PROGRESS, flvPlayerEvent_handler , false, 0, true);
			_flvPlayer.addEventListener(FLVPlayerMetadataEvent.METADATA_RECEIVED, flvPlayerEvent_handler, false, 0, true);
			_flvPlayer.addEventListener(FLVPlayerMetadataEvent.CUE_POINT, flvPlayerEvent_handler, false, 0, true);
		}
		
		private function removePlayerListeners():void
		{
			_flvPlayer.removeEventListener(FLVPlayerEvent.READY, flvPlayerEvent_handler);
			_flvPlayer.removeEventListener(FLVPlayerEvent.COMPLETE, flvPlayerEvent_handler);
			_flvPlayer.removeEventListener(FLVPlayerEvent.BUFFERING, flvPlayerEvent_handler);
			_flvPlayer.removeEventListener(FLVPlayerEvent.AUTO_REWOUND, flvPlayerEvent_handler);
			_flvPlayer.removeEventListener(FLVPlayerEvent.PLAYHEAD_UPDATE, flvPlayerEvent_handler);
			
			_flvPlayer.removeEventListener(FLVPlayerEvent.PAUSED, flvPlayerEvent_handler);
			_flvPlayer.removeEventListener(FLVPlayerEvent.START_PLAYING, flvPlayerEvent_handler);
			_flvPlayer.removeEventListener(FLVPlayerEvent.STOPPED, flvPlayerEvent_handler);
			_flvPlayer.removeEventListener(FLVPlayerEvent.RESUME, flvPlayerEvent_handler);
			
			_flvPlayer.removeEventListener(FLVPlayerProgressEvent.PROGRESS, flvPlayerEvent_handler);
			_flvPlayer.removeEventListener(FLVPlayerMetadataEvent.METADATA_RECEIVED, flvPlayerEvent_handler);
			_flvPlayer.removeEventListener(FLVPlayerMetadataEvent.CUE_POINT, flvPlayerEvent_handler);
		}
		
		private function fixTime(ms:Number):String
		{
			var fixed:String = "00:00";
			if(ms > 0) {
				
				var minutes = Math.floor(ms/60);
				var seconds = Math.floor(ms%60);
			
				if (seconds<10) {
					seconds = "0"+seconds;
				}
			
				if (minutes<10) {
					minutes = "0"+minutes;
				}
				
				fixed = minutes + ":" + seconds;
			}
			
			return fixed;
		}
		
		private function stopVideo():void
		{
			this._flvPlayer.stop();
		}
		
		private function setVideoVolume(value:Number):void
		{
			this._flvPlayer.volume = value;
		}
		
		private function pauseVideo():void
		{
			this._flvPlayer.pause();
		}
		
		private function resumeVideo():void
		{
			this._flvPlayer.resume();
		}
		
		public function dispose():void
		{
			_stopControl.removeEventListener(MouseEvent.CLICK,stop_handler);
			_pauseResumeControl.removeEventListener(MouseEvent.CLICK,playPause_handler);
			_audioControl.removeEventListener(MouseEvent.CLICK,sound_handler);
			
			_seekBarControl.removeEventListener(SeekBarEvent.CHANGE, onChange);
			_seekBarControl.removeEventListener(SeekBarEvent.BEGIN_SCRUB, beginScrub_handler);
			_seekBarControl.removeEventListener(SeekBarEvent.END_SCRUB, endScrub_handler);
			
			removePlayerListeners();
		}
		
		public function get flvPlayer():FLVPlayer
		{ 
			return _flvPlayer;
		}
		
		public function set flvPlayer(value:FLVPlayer):void 
		{
			_flvPlayer = value;
			addPlayerListeners();
		}
		
		
	
	}
	
}