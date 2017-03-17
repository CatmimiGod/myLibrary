package SJL.utils
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	
	/**
	 * ...2015/1/20 15:26
	 * @author CatmimiGod
	 */
	public class  SoundPlay extends LocalSound
	{
		/**是否使用声音渐变*/
		private var _gradualchange:Boolean = false;
		
		/**指示当前声音变大变小 true变大 false变小*/
		private var _largeorsmall:Boolean;
		
		/**指示当前是暂停还是停止 true暂停 false停止*/
		private var _pauseorstop:Boolean;
		
		/**当前的声音*/
		private var _currentVolume:Number = 1;
		
		private var _time:Timer;
		private var _ttween:Number = 60;
		private var _stween:Number = 0.05;
		
		public function SoundPlay(url:String = null):void
		{
			super(url);
			_time = new Timer(_ttween);
			_time.addEventListener(TimerEvent.TIMER , gradualchange);
		}
		
		/**
		 * 重写开始播放声音
		 */
		override public function play():void
		{
			if (!_soundPlaying)
			{
				_currentVolume = this.volume;
				_soundChannelData = _soundData.play(_soundPosition);
				_soundChannelData.addEventListener(Event.SOUND_COMPLETE, onSoundover);
				_soundPlaying = true;
				this.volume = _currentVolume;
				if (_gradualchange)
				{
					if (!_time.running)
					{
						this.volume = 0;
						_largeorsmall = true;
						_time.start();
					}
				}
			}
		}
		
		/**
		 * 重写暂停播放声音
		 */
		override public function pause():void
		{
			if (_soundPlaying)
			{
				if (_gradualchange)
				{
					if (!_time.running)
					{
						_currentVolume = this.volume;
						_largeorsmall = false;
						_pauseorstop = true;
						_time.start();
					}
				}
				else
				{
					_currentVolume = this.volume;
					soundpause();
				}
			}
		}
		
		/**
		 * 重写停止播放声音
		 */
		override public function stop():void
		{
			if (_soundPlaying)
			{
				if (_gradualchange)
				{
					if (!_time.running)
					{
						_currentVolume = this.volume;
						_largeorsmall = false;
						_pauseorstop = false;
						_time.start();
					}
				}
				else
				{
					_currentVolume = this.volume;
					soundstop();
				}
			}
			
		}
		
		/**
		 * 通过_largeosmall来判断使得声音变大还是变小
		 * @param	e
		 */
		public function gradualchange(e:TimerEvent):void
		{
			_largeorsmall ? gradualchangelarge(): gradualchangesmall();
		}
		
		/**
		 * 声音逐渐变大
		 */
		public function gradualchangelarge():void
		{
			//trace(this.volume)
			this.volume += _stween;
			if (this.volume >= _currentVolume)
			{
				//trace("声音变大时的声音",this.volume);
				_time.reset();
			}
		}
		
		/**
		 * 声音逐渐变小
		 */
		public function gradualchangesmall():void
		{
			//trace(this.volume)
			this.volume -= _stween;
			if (this.volume <= 0)
			{
				_pauseorstop ? soundpause() : soundstop();
				_time.reset();
				//trace("声音变小时的声音最后",this.volume);
				this.volume = _currentVolume;
				//trace("声音变小时更改的声音",this.volume);
			}
		}
		
		/**
		 * 声音暂停
		 */
		protected function soundpause():void
		{
			trace(_soundPosition)
			_soundPosition = _soundChannelData.position;
			_soundPlaying = false;
			_soundChannelData.stop();
			_soundChannelData.removeEventListener(Event.SOUND_COMPLETE, onSoundover);
		}
		/**
		 * 声音停止
		 */
		protected function soundstop():void
		{
			_soundPlaying = false;
			_soundPosition = 0;
			_soundChannelData.stop();
			_soundChannelData.removeEventListener(Event.SOUND_COMPLETE, onSoundover);
		}
		
		/**
		 * 获取和设置是否启用声音渐变
		 */
		public function get GradualChange():Boolean { return _gradualchange; }
		public function set GradualChange(value:Boolean):void
		{
			_gradualchange = value;
		}
		/**
		 * 获取和设置每次声音变化的大小
		 */
		public function get SoundChange():Number { return _stween; }
		public function set SoundChange(value:Number):void { _stween = value; }
		/**
		 * 获取和设置多少毫秒改变一次声音
		 */
		public function get SoundChangeTime():Number { return _ttween; }
		public function set SoundChangeTime(value:Number):void 
		{	
			_time.stop();
			_time.removeEventListener(TimerEvent.TIMER , gradualchange);
			_ttween = value;
			//trace(_ttween,"新的")
			_time = new Timer(_ttween);
			_time.addEventListener(TimerEvent.TIMER , gradualchange);
		}
	}
	
}