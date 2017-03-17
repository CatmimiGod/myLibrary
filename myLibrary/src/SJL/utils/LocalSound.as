package SJL.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
	import flash.media.SoundTransform;
    import flash.net.URLRequest;
    import flash.display.Loader;
	
	/**
	 * 	当声音播放完成后发生。
	 */ 
	[Event(name="complete", type="flash.events.Event")]
	/**
	 *	LocalSound 本地加载声音对象
	 * 
	 * 	@example 示例：
	 * 	<listing version="3.0">
	 * 	var music:LocalSound = new LocalSound("XXX01.mp3");
	 * 	music.isAutoPlay = true;
	 * 	music.isLoopPlay = true;
	 * 	music.load("XXX02.mp3", false, true);
	 *  music.play();
	 * 	</listing>
	 */
	
	public class LocalSound extends EventDispatcher
	{
		/**
		 *	2013/10/18 15:20
		 *	@author CatmimiGod
		 */ 
		protected var _soundData:Sound;
		
		protected var _soundChannelData:SoundChannel = new SoundChannel();
		
		protected var _soundPosition:Number = 0;
		
		protected var _soundVolume:Number = 0.5;
		
		protected var _soundPercentage:uint;
		
		protected var _soundTime:Number;
		
		//protected var _soundtotalTime:Number;
		
		/*是否自动播放 @default true	*/
		private var _autoPlay:Boolean = true;
		
		/*是否循环播放 @default true	*/
		private var _loopPlay:Boolean = true;
		
		/*是否正在播放 @default false	*/
		protected var _soundPlaying:Boolean = false;
		
		/**
		 * 本地加载声音对象，可重复加载声音对象。
		 * @param	url:String 声音文件路径
		 */
		
		public function LocalSound(url:String = null)
		{
			if (url)
				load(url, _autoPlay, _loopPlay);
		}
		
		/**
		 * 从指定的 url 加载外部MP3文件。
		 * @param	url:String 声音文件路径
		 * @param	autoPlay:Boolean 自动播放
		 * @param	loopPlay:Boolean 自动重复播放
		 */
		public function load(url:String,autoPlay:Boolean = true,loopPlay:Boolean = true):void
		{
			_soundData = new Sound();
			_soundData.load(new URLRequest(url));
			_autoPlay = autoPlay;
			_loopPlay = loopPlay;
			_soundData.addEventListener(Event.COMPLETE, onLoadSoundHandler);
			_soundData.addEventListener(IOErrorEvent.IO_ERROR, onLoadSoundHandler);
			_soundData.addEventListener(ProgressEvent.PROGRESS, onLoadSoundHandler);
		}
		
		/**
		 * 加载声音事的事件处理
		 * @param	e 事件类型
		 */
		private function onLoadSoundHandler(e:Event):void
		{
			switch(e.type)
			{
				case Event.COMPLETE:
					//加载完成度 = Math.round(100 * (_soundData.bytesLoaded / _soundData.bytesTotal));
					_soundPosition = 0;
					_soundPlaying = false;
					_soundData.removeEventListener(Event.COMPLETE, onLoadSoundHandler);
					_soundData.removeEventListener(IOErrorEvent.IO_ERROR, onLoadSoundHandler);
					if (_autoPlay)
						play();
					break;
				case IOErrorEvent.IO_ERROR:
					_soundData.removeEventListener(Event.COMPLETE, onLoadSoundHandler);
					_soundData.removeEventListener(IOErrorEvent.IO_ERROR, onLoadSoundHandler);
					throw new ArgumentError("无法获取数据流");
					break;
				case ProgressEvent.PROGRESS:
					_soundPercentage = Math.round(100 * (_soundData.bytesLoaded / _soundData.bytesTotal));
					//trace("load:",_soundPercentage)
					break;
			}
		}
		
		/**
		 * 开始播放声音
		 */
		public function play():void
		{
			if (!_soundPlaying)
			{
				_soundChannelData = _soundData.play(_soundPosition,0,new SoundTransform(_soundVolume));
				_soundChannelData.addEventListener(Event.SOUND_COMPLETE, onSoundover);
				//_soundChannelData.soundTransform = new SoundTransform(value);
				//trace("播放这个音乐");
				_soundPlaying = true;
				//trace("这时的声音大小",_soundChannelData.soundTransform.volume)
			}
		}
		
		/**
		 * 暂停播放声音
		 */
		public function pause():void
		{
			if (_soundPlaying)
			{
				_soundPosition = _soundChannelData.position;
				_soundPlaying = false;
				_soundChannelData.stop();
				_soundChannelData.removeEventListener(Event.SOUND_COMPLETE, onSoundover);
				//trace("暂停这个音乐")
			}
		}
		
		/**
		 * 停止播放声音
		 */
		public function stop():void
		{
			if (_soundPlaying)
			{
				_soundPlaying = false;
				_soundPosition = 0;
				_soundChannelData.stop();
				_soundChannelData.removeEventListener(Event.SOUND_COMPLETE, onSoundover);
				//trace("停止这个音乐");
			}
		}
		
		/**
		 * 声音播放完成之后
		 * @param	event
		 */
		protected function onSoundover(event:Event):void
		{
			_soundPosition = 0;
			_soundPlaying = false;
			//_soundChannelData.stop();
			_soundChannelData.removeEventListener(Event.SOUND_COMPLETE, onSoundover);
			this.dispatchEvent(new Event(Event.COMPLETE));
			if (_loopPlay)
			{
				//trace("自动重复播放音乐");
				play();
			}
		}
		
		/**
		 * 声音的音量
		 */
		public function get volume():Number{	return _soundChannelData.soundTransform.volume;	}
		public function set volume(value:Number):void
		{
			_soundVolume = value;
			_soundChannelData.soundTransform = new SoundTransform(_soundVolume);
			//Single.getInstance().dispatchEvent(new SingleEvent(SingleEvent.CHANGEVOLUME, false , false , {volume:_soundVolume}));
			//trace("声音大小是:" + _soundChannelData.soundTransform.volume)
		}
		
		/**是否自动播放声音*/
		public function get autoPlay():Boolean {	return _autoPlay; }
		public function set autoPlay(autoPlay:Boolean):void{ _autoPlay = autoPlay; }
		/**是否自动重复播放声音*/
		public function get loopPlay():Boolean { 	return _loopPlay; }
		public function set loopPlay(loopPlay:Boolean):void { _loopPlay = loopPlay; }
		/**声音是否正在播放中*/
		public function get soundPlaying():Boolean { return _soundPlaying; }
		public function get SoundTime():Number { _soundTime = _soundData.length; return _soundTime ; }
		public function get SoundPercentage():uint { return _soundPercentage; }
		
	}

}