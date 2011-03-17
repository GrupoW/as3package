
/**
 * 
 * Grupow MasterVolume
 * Copyright (c) 2011 ruranga@grupow.com
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/
 
package com.grupow.media 
{
	import com.greensock.TweenLite;

	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	/**
	 * ...
	 * @author Raúl Uranga
	 */
	public class MasterVolume 
	{
		private var _muteValue:Number;
		private var _soundTransform:SoundTransform;

		private static var _instance:MasterVolume;

		public function MasterVolume() 
		{
			_soundTransform = new SoundTransform();
			_muteValue = 1;
		}

		
		public function get soundVolume():Number
		{ 
			return _soundTransform.volume;
		}

		public function set soundVolume(value:Number):void 
		{
			_soundTransform.volume = value;
					
			try {
				SoundMixer.soundTransform = _soundTransform;
			}catch (e:*) {
				//trace("SoundItem Error: SoundChannel is not defined, you need to start playing");
			}
		}

		public static function getInstance():MasterVolume 
		{
			if (MasterVolume._instance == null) {
				MasterVolume._instance = new MasterVolume();
			}
			
			return MasterVolume._instance;
		}

		public function get isMuted():Boolean 
		{
			return Boolean(!_muteValue);
		}

		public function mute():void 
		{
			toggleMute();
		}
		
		public function toggleMute():void 
		{
			_muteValue = Number(!_muteValue);
			TweenLite.to(this, 1, {soundVolume:_muteValue});
		}
	}
}