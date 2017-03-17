package SJL.media
{
	import flash.media.SoundTransform;
	import com.greensock.TweenLite;
	import com.greensock.plugins.*;
	
	/**
	 * ...2015/1/22 14:37
	 * @author ...CatmimiGod
	 */
	public class Mp3PlayerTween extends Mp3Player
	{
		/**缓动时间*/
		private var _tweenTime:Number = 1;
		/**当前声音*/
		private var _currentVolume:Number = 1;
		
		public function Mp3PlayerTween(url:String = null, tweenTime:Number = 1):void
		{
			super(url);
			_tweenTime = tweenTime;
			TweenPlugin.activate([VolumePlugin]);
		}
		
		/**
		 * 重写播放，以缓动的形式
		 */
		override public function play():void 
		{
			if (_playing)
				return;
			_soundChannel.soundTransform = new SoundTransform(0);
			super.play();
			TweenLite.to(_soundChannel, _tweenTime , { volume :_currentVolume} );
		}
		
		/**
		 * 重写暂停，以缓动的形式
		 */
		override public function pause():void 
		{
			if (!_playing)
				return;
			TweenLite.to(_soundChannel, _tweenTime , { volume :0, onComplete:super.pause} );
		}
		
		/**
		 * 重写设置声音，保存声音大小到currentVolume中
		 */
		override public function get volume():Number {return _currentVolume;}
		override public function set volume(value:Number):void 
		{
			_currentVolume = value;
			super.volume = value;
		}
		
		/**重写获取SoundTransform对象，使对象中的volume属性赋值给currentVolume*/
		override public function get soundTransform():SoundTransform {return super.soundTransform;}
		override public function set soundTransform(value:SoundTransform):void 
		{
			_currentVolume = value.volume;
			super.soundTransform = value;
		}
		
		/**当前声音*/
		public function get currentVolume():Number { return _currentVolume; }
		public function set currentVolume(value:Number):void { this.volume = value; }
		/**设置缓动时间*/
		public function get tweenTime():Number { return _tweenTime; }
		public function set tweenTime(value:Number):void { _tweenTime = value; }
	}
	
}