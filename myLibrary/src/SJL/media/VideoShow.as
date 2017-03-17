package SJL.media
{
	import fl.video.VideoPlayer;
	import fl.video.VideoEvent;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import com.greensock.TweenLite;
	import flash.display.StageScaleMode;
	
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * ...2015/1/7 17:08
	 * @author CatmimiGod
	 * 如果需要缓动动画请设置缓动区域如： VideoShowSingle.getInstance().currentTweenRect = new Rectangle(target.x,target.y,target.width,target.height); 
	 * 这样设定会让视频从指定区域开始缩放至blackGroundRect大小。
	 * 
	 * VideoShowSingle.getInstance().videoShowTimeLine = new videoShowTimeLine();
	 * 这样设定则会使视频获得时间进度条，如不设置则不具有。所设置的进度条需要继承videoShowTimeLine类；
	 */
	public class VideoShow extends Sprite
	{
		/**videoplayer对象*/
		private var _video:VideoShowPlayer;
		/**url地址*/
		private var _url:String;
		/**背景*/
		private var _backGround:Shape;
		/**video默认区域*/
		private var _rect:Rectangle;
		/**时间进度条*/
		private var _timeLine:VideoShowTimeLine;
		
		/**
		 * 
		 * @param	videoRect				视频区域
		 * @param	blackGroundRect			背景区域
		 * @param	blackGroundColor		背景颜色
		 */
		public function VideoShow(videoRect:Rectangle, blackGroundRect:Rectangle = null, blackGroundColor:uint = 000000):void
		{
			if (blackGroundRect == null)
			{
				blackGroundRect = videoRect;
			}
			
			/**初始化背景*/
			_backGround = new Shape();
			_backGround.graphics.beginFill(blackGroundColor);
			_backGround.alpha = 0.5;
			_backGround.graphics.drawRect(blackGroundRect.x, blackGroundRect.y, blackGroundRect.width, blackGroundRect.height);
			_backGround.graphics.endFill();
			this.addChild(_backGround);
			
			/**初始化video播放器*/
			_video = new VideoShowPlayer(videoRect.width, videoRect.height);
			_video.x = videoRect.x;
			_video.y = videoRect.y;
			this.addChild(_video);
			_video.addEventListener(VideoEvent.READY , onReadyToPlay);
			_video.addEventListener(VideoEvent.COMPLETE , onCompletePlayVideo);
			_video.scaleMode = StageScaleMode.EXACT_FIT;
			
			/***/
			VideoShowSingle.getInstance().videoShowPlayer = _video;
			VideoShowSingle.getInstance().videoShow = this;
			
			/**初始化进度条*/
			_timeLine = VideoShowSingle.getInstance().videoShowTimeLine;
			if(_timeLine)
				this.addChild(_timeLine);
			
			/***/
			_rect = blackGroundRect;
			this.visible = false;
		}
		
		
		/**
		 * 播放flv
		 * @param	url
		 */
		public function play(url:String):void
		{
			if (_url == url)
			{
				_video.play();
				onReadyToPlay(null);
			}
			else	
			{
				_video.play(url);
			}
			_url = url;
		}
		
		/**
		 * 准备开始
		 * @param	e
		 */
		private function onReadyToPlay(e:VideoEvent):void
		{
			this.visible = true;
			this.alpha = 1;
			if (VideoShowSingle.getInstance().currentTweenRect != null)
				onTweenOpendVideo(VideoShowSingle.getInstance().currentTweenRect);
		}
		
		/**
		 * 停止flv
		 */
		public function stop():void
		{
			_video.stop();
			if (VideoShowSingle.getInstance().currentTweenRect != null)
				onTweenCloseVideo(VideoShowSingle.getInstance().currentTweenRect);
			else
				onCloseVideo();
		}
		
		/**
		 * 播放完毕
		 * @param	e
		 */
		public function onCompletePlayVideo(e:VideoEvent):void
		{
			//_video.seek(0);
			//_video.play();
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 缓动打开video
		 * @param	rect
		 */
		private function onTweenOpendVideo(rect:Rectangle):void
		{
			this.x = rect.x;
			this.y = rect.y;
			this.width = rect.width;
			this.height = rect.height;
			this.alpha = 0;
			TweenLite.to(this , VideoShowSingle.getInstance().tweenTime , { alpha : 1 ,x:_rect.x,y:_rect.y,width :_rect.width,height:_rect.height} );
		}
		
		/**
		 * 缓动关闭video
		 * @param	rect
		 */
		private function onTweenCloseVideo(rect:Rectangle):void
		{
			TweenLite.to(this, VideoShowSingle.getInstance().tweenTime , { alpha : 0 , x:rect.x, y:rect.y, width :rect.width, height:rect.height , onComplete:onCloseVideo} );
		}
		
		/**
		 * 关闭video
		 */
		private function onCloseVideo():void
		{
			this.visible = false;
			_video.stop();
			_video.seek(0);
		}
		
		/**视频声音*/
		public function get volume():Number { return _video.volume; }
		public function set volume(value:Number):void { _video.volume = value; }
		/**视频对象*/
		public function get videoShowPlayer():VideoShowPlayer { return _video; }
		/**背景对象*/
		public function get backGround():Shape { return _backGround; }
		/**视频区域*/
		public function get videoRect():Rectangle { return new Rectangle(_video.x, _video.y, _video.width, _video.height); }
	}
	
}