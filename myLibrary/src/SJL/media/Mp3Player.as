package SJL.media
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import SJL.utils.NumberSwitch;
	
	/**
	 * ...2015/1/22 14:37
	 * @author ...CatmimiGod
	 */
	public class Mp3Player
	{
		/**声音对象*/
		protected var _sound:Sound = new Sound;
		/**声音控制类*/
		protected var _soundChannel:SoundChannel = new SoundChannel;
		
		/**是否在播放中*/
		protected var _playing:Boolean = false;
		/**是否循环播放*/
		protected var _loop:Boolean = true;
		/**自动播放*/
		protected var _auto:Boolean = true;
		/**当前播放头位置*/
		protected var _position:Number = 0;
		
		public function Mp3Player(url:String = null):void
		{
			if(url != null)
				load(url);
		}
		
		/**
		 * 加载url地址的数据
		 * @param	url
		 * @param	soundTransform
		 */
		public function load(url:String):void
		{
			_sound = new Sound(new URLRequest(url));
			_sound.addEventListener(Event.OPEN, onLoadHandler);
			_sound.addEventListener(Event.COMPLETE , onLoadHandler);
			_sound.addEventListener(Event.ID3 , onLoadHandler);
			_sound.addEventListener(IOErrorEvent.IO_ERROR , onLoadHandler);
			_sound.addEventListener(ProgressEvent.PROGRESS , onLoadHandler);
		}
		
		/**
		 * 加载声音发生的事件
		 * @param	e
		 */
		protected function onLoadHandler(e:Event):void
		{
			switch(e.type)
			{
				case Event.OPEN:
					break;
				case ProgressEvent.PROGRESS:
					break;
				case Event.COMPLETE:
					_position = 0;
					if(_auto)
						play();
					break;
				case Event.ID3:					
					break;
			}
		}
		
		/**
		 * 播放声音
		 */
		public function play():void
		{
			if (!_playing)
			{
				_soundChannel = _sound.play(_position, 0, _soundChannel.soundTransform);
				_soundChannel.addEventListener(Event.SOUND_COMPLETE , onSoundChannelComplete);
				_playing = true;
			}
		}
		
		/**
		 * 暂停声音
		 */
		public function pause():void
		{
			if (_playing)
			{
				_position = _soundChannel.position;
				_soundChannel.stop();
				_playing = false;
			}
		}
		
		/**
		 * 重新播放
		 */
		public function replay():void
		{
			_playing = false;
			_position = 0;
			_soundChannel.stop();
			play();
		}
		
		/**
		 * 停止音乐
		 */
		public function stop():void
		{
			_playing = false;
			_position = 0;
			_soundChannel.stop();
			_soundChannel.removeEventListener(Event.SOUND_COMPLETE , onSoundChannelComplete);
		}
		
		/**
		 * 移动播放头
		 * @param	pos   以秒为参数
		 */
		public function seek(pos:Number):void
		{
			_soundChannel.stop();
			_soundChannel = _sound.play(pos * 1000, 0, _soundChannel.soundTransform);
			_soundChannel.addEventListener(Event.SOUND_COMPLETE , onSoundChannelComplete);
			_playing = true;
		}
		
		/**
		 * 播放完成
		 * @param	e
		 */
		protected function onSoundChannelComplete(e:Event):void
		{
			if (_loop)
			{
				replay();
			}
		}
		
		/**设置声音大小*/
		public function set volume(value:Number):void { _soundChannel.soundTransform = new SoundTransform(value); }
		public function get volume():Number { return _soundChannel.soundTransform.volume; }
		/** 设置声音属性*/
		public function set soundTransform(value:SoundTransform):void { _soundChannel.soundTransform = value; }
		public function get soundTransform():SoundTransform { return _soundChannel.soundTransform; }
		
		/**获取Sound对象*/
		public function get sound():Sound { return _sound;}
		
		/**设置循环播放*/
		public function set loop(value:Boolean):void { _loop = value; }
		public function get loop():Boolean { return _loop; }
		/**设置自动播放*/
		public function set auto(value:Boolean):void { _auto = value; }
		public function get auto():Boolean { return _auto; }
		/**是否在播放状态*/
		public function get playing():Boolean { return _playing; }
		
		
		/**总时间，以毫秒为单位*/
		public function get totalTime():Number { return _sound.length; }
		/**当前播放时间，以毫秒为单位*/
		public function get currentTime():Number { return _soundChannel.position; }
		/**当前时间，字符串已转换*/
		public function get currentTimeString():String 
		{
			var temp:Object = NumberSwitch.msTOmin(currentTime);
			return NumberSwitch.addZero(temp.min) + "分" + NumberSwitch.addZero(temp.ms) + "秒"; 
		} 
		/**总时间，字符串已转换*/
		public function get totalTimeString():String 
		{
			var temp:Object = NumberSwitch.msTOmin(totalTime);
			return NumberSwitch.addZero(temp.min) + "分" + NumberSwitch.addZero(temp.ms) + "秒"; 
		}
		
	}
	
}