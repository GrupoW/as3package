
/**
 * 
 * FLVPlayer by GrupoW
 * Copyright (c) 2003-2010 GrupoW
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.video {
	
	import com.grupow.video.FLVPlayerMetadataEvent;
	import com.grupow.video.FLVPlayerEvent;
	import com.grupow.video.FLVPlayerProgressEvent;
	import flash.display.Sprite;
	
	import flash.utils.Timer;
	
	import flash.display.MovieClip;
	
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import flash.events.NetStatusEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	//import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	
	/**
	* ...
	* @author Raúl Uranga
	* @version 0.01
	*/
	
	// TODO escuchar al listeneer de REMOVE_FROM_STAGE???
	// TODO tomar las medidas de width/height del bg_mc si existe?¿
	// TODO meter el try catch en _vidStream.play();???
	// TODO darle bubble al NetStatusEvent.NET_STATUS y AsyncErrorEvent.ASYNC_ERROR
	 
	
	
	public class FLVPlayer extends Sprite
	{
		
		private var _video:Video;
		private var _vidConnection:NetConnection;
		private var _vidStream:NetStream;
		private var _infoClient:Object;
		private var _initializated:Boolean;
		private var _path:String;
		private var _playing:Boolean;
		private var _bufferTime:Number;
		private var _duration:Number;
		private var _volume:Number;
		private var _soundTrans:SoundTransform;
		private var _metaData:Object;
		private var _isSeeking:Boolean;
		private var _isPaused:Boolean;
		private var _loadertimer:Timer;
		private var _autoRewind:Boolean;
		private var _debugMode:Boolean;
		private var _playingTimer:Timer;
		private var _currentSeekTime:Number;
		private var _updateSeekTimeTimer:Timer;
		private var _isComplete:Boolean;
		private var _oTime:Number;//oldTime
		private var _cTime:Number;//currentTime
		
		private var _videoWidth:Number;
		private var _videoHeight:Number;
		private var _startPlayingEventFired:Boolean;
		private var _stopped:Boolean;
		
		private var _loop:Boolean;
		private var _initNS:Boolean;
		
		private var _targetWidth:Number;
		private var _targetHeight:Number;
		private var _background:Sprite;
		private var _video_mask:Sprite;
		private var _video_container:Sprite;
		private var _align:String;
		private var _scaleMode:String;
		private var _disposed:Boolean;
		private var _clearbg:Boolean;
		private var _isAdded:Boolean;
		
		public function FLVPlayer(width:int = 320, height:int = 240, initConn:Boolean = true )
		{
			debug("FLVPlayer Class");
			
			_video = new Video(width, height);
			_video.width = width
			_video.height = height;
			
			_videoWidth = -1;
			_videoHeight = -1;
			
			_align = FLVPlayerAlign.CENTER;
			_scaleMode = FLVPlayerScaleMode.EXACT_FIT;
			
			_clearbg = false;
			
			init();
			
			if(initConn)
				initConnection();
				
			this.addEventListener(Event.ADDED_TO_STAGE, added_handler, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removed_handler, false, 0, true);
			
		}
		
		private function removed_handler(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removed_handler);
			this.dispose();
		}
		
		private function added_handler(e:Event):void 
		{
			//trace("__added_handler__");
			//trace("_targetWidth: ", this.width);
			//trace("_targetHeight: ", this.height);
			//
			
			_isAdded = true;
			
			_targetWidth = this.width;
			_targetHeight = this.height;
			_video.width = _targetWidth
			_video.height = _targetHeight;
			//
			this.removeChildAt(0);
			
			_background = new Sprite();			
			_video_mask =  new Sprite();
						
			_video_container =  new Sprite();
			_video_container.addChild(_video);
				
			addChild(_background);
			addChild(_video_container);
			addChild(_video_mask);
			
			_video_container.mask = _video_mask;
			
			
			
			draw();
			
		
			removeEventListener(Event.ADDED_TO_STAGE, added_handler);
		}
		
		private function draw():void
		{	
			if(!_clearbg) {
				_background.graphics.clear();
				_background.graphics.beginFill(0, 1);
				_background.graphics.drawRect(0, 0, _targetWidth, _targetHeight);
				_background.graphics.endFill();
			}
			
			_video_mask.graphics.clear();
			_video_mask.graphics.beginFill(0x00ff00, 0.2);
			_video_mask.graphics.drawRect(0, 0, _targetWidth, _targetHeight);
			_video_mask.graphics.endFill();
		}
		
		private function init():void
		{	
			_loadertimer = new Timer(0);
			_loadertimer.addEventListener(TimerEvent.TIMER, onLoadProgress, false, 0, true);
			
			_playingTimer = new Timer(0);
			_playingTimer.addEventListener(TimerEvent.TIMER, updatePlayhead_handler, false, 0, true);
			
			_updateSeekTimeTimer = new Timer(0);
			_updateSeekTimeTimer.addEventListener(TimerEvent.TIMER, updateSeekTime_handler, false, 0, true);
									
			//_eventDispatcher = new EventDispatcher(this);
			
			_isSeeking = false;
			_isPaused = false;
			_autoRewind = false;
			_stopped = false;
			_duration = 0;
			_startPlayingEventFired = false;
			
			_oTime = -1;
			_cTime = -1;
			
			_soundTrans = new SoundTransform();
			
			_infoClient = new Object();
			_infoClient.onCuePoint = onCuePoint;
			_infoClient.onMetaData = onMetaData;
			
			
			loop = false;
		
		}
		
		private function updateSeekTime_handler(e:TimerEvent):void 
		{
			if (_currentSeekTime != _vidStream.time)
			{
				updatePlayhead_handler(null);
				_updateSeekTimeTimer.stop();
			}
		}
		
		private function updatePlayhead_handler(e:TimerEvent):void 
		{
			if (_oTime < 0 && _cTime < 0) {
				_oTime = _cTime = time;
			}
			
			_oTime = _cTime
			_cTime = time;
			
			//debug("_oTime: " + _oTime);
			//debug("_cTime: " + _cTime);
					
			if (_oTime != _cTime && (time * 10 > 1)) {
				dispatchEvent(new FLVPlayerEvent(FLVPlayerEvent.PLAYHEAD_UPDATE, false, false, this.time));
				
				if (!_startPlayingEventFired) {
					
					debug(">>_startPlayingEventFired");
					
					_startPlayingEventFired = true;
					
					dispatchEvent(new FLVPlayerEvent(FLVPlayerEvent.START_PLAYING, false, false, this.time));
				}
				
			}
		}
		

		public function dispose():void
		{	
			if (!_disposed) {
				
				_disposed = true;
				
				this.stop();
						
				_loadertimer.stop();
				_loadertimer.removeEventListener(TimerEvent.TIMER, onLoadProgress);
				_loadertimer = null;
				
				_playingTimer.stop();
				_playingTimer.removeEventListener(TimerEvent.TIMER, updatePlayhead_handler);
				_playingTimer = null;
				
				_updateSeekTimeTimer.stop();
				_updateSeekTimeTimer.removeEventListener(TimerEvent.TIMER, updateSeekTime_handler);
				_updateSeekTimeTimer = null;
				
				killConnection();
			}

		}
				
		public function killConnection():void
		{
			_video.clear();
			
			if (_vidConnection != null) {
				_vidConnection.close();
				_vidConnection.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus_handler);
				_vidConnection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError_handler);
				
				_vidConnection = null;
			}
			
			if (_vidStream != null) {
				_vidStream.close();
				_vidStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus_handler);
				_vidStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError_handler);
				
				_vidStream = null;
			}
			_video = null;
			
		}
		
		private function initConnection():void
		{
			debug("FLVPlayer.initConnection")
			
			_vidConnection = new NetConnection();
			_vidConnection.connect(null);
			_vidConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus_handler, false, 0, true);
			_vidConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError_handler, false, 0, true);
			
			_vidStream = new NetStream(_vidConnection);
			_vidStream.client = _infoClient;
			_vidStream.bufferTime = 5;
			_vidStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus_handler, false, 0, true);
			_vidStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError_handler, false, 0, true);
			
			
			_video.attachNetStream(_vidStream);
			
			debug("_soundTrans.volume: " + _soundTrans.volume);
			
			_vidStream.soundTransform = _soundTrans;		
			
			debug("_vidStream.soundTransform.volume: " + _vidStream.soundTransform.volume);
		}
		
		public function setNetStream(ns:NetStream, metadata:Object = null):void
		{
			if (!_initNS) {
						
				_initNS = true;
				
				_vidStream = ns;
				_vidStream.client = _infoClient;
				_vidStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus_handler, false, 0, true);
				_vidStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError_handler, false, 0, true);
				
				_video.attachNetStream(_vidStream);
				
				_vidStream.soundTransform = _soundTrans;
				
				if (metadata != null) {
					
					this._metaData = metadata;
					_duration = this._metaData.duration;
					
				}
			}
				
		}
		
		private function onAsyncError_handler(e:AsyncErrorEvent):void 
		{
			debug("onAsyncError_handler: " + e.text);
		}
		
		/*
		* NetStream.Buffer.Empty : Data is not being received quick enough to fill the buffer.
		* NetStream.Buffer.Full: The buffer is filled and the video is "good to go".
		* NetStream.Buffer.Flush: Video is finished and the buffer will be emptied.
		* NetStream.Play.Start : Video is playing.
		* NetStream.Play.Stop : The video is finished.
		* NetStream.Play.StreamNotFound : The video plunked into the stream can't be found.
		* NetStream.Seek.InvalidTime: The user is trying to "seek" or play beyond the end of the video or beyond what has downloaded so far.
		* NetStream.Seek.Notify: The seek operation is finished.
		*/
		
		private function onNetStatus_handler(e:NetStatusEvent):void 
		{
			debug("onNetStatus_handler");
			
			try 
			{	
		
				debug("level", e.info.level, " code: ", e.info.code);
				
				switch (e.info.code)
				{
					case "NetStream.Play.Start":
						
						//_playing = true;
						debug(">>NetStream.Play.Start");
						
						_playingTimer.start();
						this.dispatchEvent(new FLVPlayerEvent(FLVPlayerEvent.READY,false,false,this.time));
						
						break;
					
					case "NetStream.Play.StreamNotFound":
					case "NetStream.Play.Stop":
					
						_playing = false;
						_playingTimer.stop();
						_updateSeekTimeTimer.stop();
						_loadertimer.stop();
						
						debug("_autoRewind: " + _autoRewind);
						
						_oTime = _cTime = 0;
											
						if (_autoRewind && e.info.code == "NetStream.Play.Stop" ) {
							
							this.stop_handler();
							
							this.dispatchEvent(new FLVPlayerEvent(FLVPlayerEvent.AUTO_REWOUND,false,false,this.time));
							
														
						} if (!loop) {
							
							_isComplete = true;
							
							this.dispatchEvent(new FLVPlayerEvent(FLVPlayerEvent.COMPLETE,false,false,this.time));
												
						}else {
							
							this.seek(0);
							
						}
						
						if (e.info.code == "NetStream.Play.StreamNotFound") {
							this.dispatchEvent(new FLVPlayerErrorEvent(FLVPlayerErrorEvent.STREAM_NOT_FOUND,false,false));
						}
						
						break;
						
					case "NetStream.Seek.InvalidTime":
					case "NetStream.Seek.Notify":
						
						debug("Seek.Notify: " + this._vidStream.time);
												
						if (_isSeeking) {
							
							_isSeeking = false;
							//if (!_isPaused)
							//	this.resume();
						}
						
						if (_isPaused) {
							_updateSeekTimeTimer.start();
						}
						
						/*/
						if (!_isPaused) {
							
							//this.resume();
							
						}else{
							_updateSeekTimeTimer.start();
						}
						//*/
						
						if (e.info.code == "NetStream.Seek.InvalidTime") {
							this.dispatchEvent(new FLVPlayerErrorEvent(FLVPlayerErrorEvent.INVALID_SEEK_TIME,false,false));
						}
						
						break;
						
					case "NetStream.Buffer.Full":
						//continue playing
						_playing = true;
						_playingTimer.start();
						
						this.dispatchEvent(new FLVPlayerEvent(FLVPlayerEvent.BUFFER_COMPLETE, false, false, this.time));
						
						break; 
						
					case "NetStream.Buffer.Empty":
						
						//buffering
						
						debug("NetStream.Buffer.Empty");
						debug("_isComplete: ", _isComplete);
						
						
						if (!_isComplete) {
							_playing = false;
							_playingTimer.stop();
							this.dispatchEvent(new FLVPlayerEvent(FLVPlayerEvent.BUFFERING, false, false, this.time));
						}
						
						break; 
						
					case "NetStream.Buffer.Flush":
					
						break; 
				}

				
			}
			catch(error:TypeError)
			{
				//	Ignore any errors
			}
		}
		
		private function onMetaData(info:Object):void
		{
			//*/
			//debug(onCuePoint:);
			debug("-----------------------");
			debug("::onMetaData::");
			for (var name:String in info) {
				debug(name + ":" + info[name]);
			}
			debug("-----------------------");
			//*/
			
			/*/
			//resize(_background, info.width, info.height, _targetWidth, _targetHeight, "cropped_fit");
			resize(_video_container, info.width, info.height, _targetWidth, _targetHeight, "fit");
			
			//"fit"
			//"cropped_fit"
			//trace(_background.width);
			//trace(_background.height);
			//addChild(_background);
			//_background.x = _targetWidth/2 - _background.width/2;
			//_background.y = _targetHeight / 2 - _background.height / 2;
						
			_video_container.x = _targetWidth/2 - _video_container.width/2;
			_video_container.y = _targetHeight / 2 - _video_container.height / 2;
			
			//*/
			
			_duration = info.duration;
			_metaData = info;
			
			
			resize();
			
			this.dispatchEvent(new FLVPlayerMetadataEvent(FLVPlayerMetadataEvent.METADATA_RECEIVED,false,false,_metaData));
		}
		
		private function resize():void
		{
			var theVideoWidth:int = !isNaN(_metaData.width) ? int(_metaData.width) : _targetWidth;
			var theVideoHeight:int = !isNaN(_metaData.height) ? int(_metaData.height) : _targetHeight;
			 
			switch (_scaleMode) {
				case FLVPlayerScaleMode.NO_SCALE:
					
					this._video.width = theVideoWidth;
					this._video.height = theVideoHeight;
					
					break;
					
				case FLVPlayerScaleMode.EXACT_FIT:
					
					this._video.width = this._targetWidth;
					this._video.height = this._targetHeight;
					break;
					
				case FLVPlayerScaleMode.MAINTAIN_ASPECT_RATIO:
				default:
				
					var newWidth:int = int(theVideoWidth * _targetHeight / theVideoHeight);
					var newHeight:int = int(theVideoHeight * _targetWidth / theVideoWidth);
										
					if (newHeight < _targetHeight) {
						this._video.width = _targetWidth;
						this._video.height = newHeight;
					} else if (newWidth < _targetWidth) {
						this._video.width = newWidth;
						this._video.height = _targetHeight;
					} else {
						this._video.width = _targetWidth;
						this._video.height = _targetHeight;
					}

			}
				
			_video_container.x = _targetWidth / 2 - _video_container.width / 2;
			_video_container.y = _targetHeight / 2 - _video_container.height / 2;
		
		}
		 
		private function onCuePoint(info:Object):void
		{
			//*/
			//debug(onCuePoint:);
			debug("-----------------------");
			debug("::onCuePoint::");
			for (var name:String in info) {
				debug(name + ":" + info[name]);
			}
			debug("-----------------------");
			//*/
			
			this.dispatchEvent(new FLVPlayerMetadataEvent(FLVPlayerMetadataEvent.CUE_POINT,false,false,info));
		}
		
		private function startLoader():void
		{
			_loadertimer.stop();
			_loadertimer.start();
		}
		
		private function onLoadProgress(e:TimerEvent):void 
		{
			this.dispatchEvent(new FLVPlayerProgressEvent(FLVPlayerProgressEvent.PROGRESS, false, false, this.bytesLoaded, this.bytesTotal));
		
			if (this.bytesLoaded / this.bytesTotal == 1)
				_loadertimer.stop();
			
		}
		
		private function debug(...rest):void
		{
			if(this.debugMode)
				trace("[FLVPlayer] " + rest);
		}
		
		public function get contentPath():String 
		{
			return _path;
		}
		
		public function set contentPath(value:String):void 
		{
			_path = value;
		}
		
		public function get bufferTime():Number 
		{ 
			return _vidStream.bufferTime; 
		}
		
		public function set bufferTime(value:Number):void
		{
			_vidStream.bufferTime = value;
		}
		
		public function get bytesLoaded():Number
		{
			return this._vidStream.bytesLoaded;
		}
		
		public function get bytesTotal():Number
		{
			return this._vidStream.bytesTotal;
		}
		
		public function getPercentLoaded():Number
		{
			return this._vidStream.bytesLoaded / this._vidStream.bytesTotal;
		}
		
		public function get position():Number
		{
			return (this.duration != 0) ? (this.time / this.duration) : 0;
		}
			
		public function get time():Number
		{
			return this._vidStream.time;
		}
		
		public function get duration():Number { return _duration; }
		
		public function get volume():Number 
		{ 
			return _soundTrans.volume;
		}
		
		public function set volume(value:Number):void 
		{
			_soundTrans.volume = value;
			if (_vidStream)
			{
				_vidStream.soundTransform = _soundTrans;
			}
		}
		
		public function get metadata():Object
		{
			return _metaData;
		}
		
		public function get isPlaying():Boolean
		{
			return _playing;
		}
		
		public function get autoRewind():Boolean
		{ 
			return _autoRewind;
		}
		
		public function set autoRewind(value:Boolean):void 
		{
			_autoRewind = value;
		}
		
		public function get debugMode():Boolean 
		{ 
			return _debugMode;
		}
		
		public function set debugMode(value:Boolean):void 
		{
			_debugMode = value;
		}
		
		public function get videoWidth():Number
		{ 
			if(_videoWidth > 0)
				return _videoWidth;
				
			if (_metaData != null && !isNaN(_metaData.width) && !isNaN(_metaData.height)) {
				if (_metaData.width == _metaData.height) {
					return _video.videoWidth;
				} else {
					return int(_metaData.width);
				}
			}
			
			return -1;
		}
		
		/*/
		public function set videoWidth(value:Number):void 
		{
			this._video.width = this._targetWidth = value;
			this.draw();
			//this.resize();
		}
		//*/
	
		public function get videoHeight():Number
		{
			if(_videoHeight > 0)
				return _videoHeight;
				
			if (_metaData != null && !isNaN(_metaData.width) && !isNaN(_metaData.height)) {
				if (_metaData.width == _metaData.height) {
					return _video.videoHeight;
				} else {
					return int(_metaData.height);
				}
			}
			
			return -1;
			
		}
		
		/*/
		public function set videoHeight(value:Number):void 
		{
			this._video.height = this._targetHeight = value;
			this.draw();
			//this.resize();
		}
		//*/
		
		public function get loop():Boolean { return _loop; }
		
		//TODO sobreescribir autoRewind?? no deben de convivir las 2 no??
		public function set loop(value:Boolean):void 
		{
			this.autoRewind = false;
			_loop = value;
		}
		
		public function get scaleMode():String { return _scaleMode; }
		
		public function set scaleMode(value:String):void 
		{
			_scaleMode = value;
		}
			
		public function play(value:String = ""):void
		{
			if (value.length) {
				this.contentPath = value;
			}
			
			//killConnection();
			//initConnection();
			
			_oTime = -1;
			_cTime = -1;
			
			_isPaused = false;
			
			_stopped = false;
			
			_isComplete = false;
			
			_startPlayingEventFired = false;
			
			_playingTimer.stop();
			
			startLoader();
			
			_vidStream.play(contentPath);
			
			this.dispatchEvent(new FLVPlayerEvent(FLVPlayerEvent.BUFFERING,false,false,this.time));
		}
		
		public function pause():void
		{
			if (!_isPaused) {
				
				_isPaused = true; 
				//!_isPaused;
				_playing = false;
				_vidStream.pause();
				//togglePause();
				_playingTimer.stop();
				
				this.dispatchEvent(new FLVPlayerEvent(FLVPlayerEvent.PAUSED,false,false,this.time));
			}
		}
		
		public function resume():void
		{
			debug(">>>resume");
			
			//*/
			if (_isComplete) {
				//this.stop();
				_isComplete = false;
				_vidStream.seek(0);
			}
			//*/
			
			_isPaused = false;
			_stopped = false;
			_playing = true;
			
			_vidStream.resume();
			
			_playingTimer.start();
			
			this.dispatchEvent(new FLVPlayerEvent(FLVPlayerEvent.RESUME,false,false,this.time));
			//*/
		}
		
		public function fastForward(offset:Number = 5):void
		{
			seek(this.time + offset);
		}
		
		public function rewind(offset:Number = 5):void
		{
			seek(this.time - offset);
		}
		
		public function seek(offset:Number = 0):void
		{
			if (!_isSeeking)
			{
				var seekTime:Number = offset;
				
				
				if (seekTime < 0 )
				{
					seekTime = 0;
				}
				
				if (seekTime > this.duration)
				{
					seekTime = this.duration;
				}
				
				_isSeeking = true;
				_currentSeekTime = this.time;
				
				debug("seek currentTime", this._vidStream.time);
				debug("seek seekTime", seekTime);
				
				//this._vidStream.pause();
				
				this._playingTimer.stop();
				
				this._updateSeekTimeTimer.stop();
				
				_vidStream.seek(seekTime);
			}
		}
		
		private function stop_handler():void
		{
			_stopped = true;
			_isPaused = true;
			_isSeeking = false;
			_playing = false;
			_playingTimer.stop();
			_vidStream.pause();
			_vidStream.seek(0);
		}
		
		public function stop():void
		{
			if (!_stopped) {
				
				stop_handler();
				this.dispatchEvent(new FLVPlayerEvent(FLVPlayerEvent.STOPPED, false, false, this.time));
			}
		}
		
		public function clearBackGround():void
		{
			_clearbg = true;
			if(_isAdded)
				_background.graphics.clear();
		}
		
		public function clear():void
		{
			this._video.clear();
		}
		
		public function close():void
		{
			this._playingTimer.stop();
			this._loadertimer.stop();
			this._updateSeekTimeTimer.stop();
			
			this._vidConnection.close();
			this._vidStream.close();
		}
	
	}
		
	
}
