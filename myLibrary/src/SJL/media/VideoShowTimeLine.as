package SJL.media
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import fl.video.VideoEvent;
	
	/**
	 * ...2015/1/7 17:08
	 * @author ...CatmimiGod
	 * 所有TimeLine控件想要使用必须继承此类
	 * 例如：
	 *  this.x = 50;
	 *	this.y = 1080;
	 *	this.playAndStopButton = this["playstop"];
	 * 	this.backButton = this["back"];
	 *	this.backGroundLine = this["background"];
	 *	this.colorLine = this["colorline"];
	 *	this.pointButton = this["drag"];
	 *	this.volumeButton = this["volume"]
	 *	running();
	 *  最后一定要运用running来激活控件，否则无法使用。
	 */
	public class VideoShowTimeLine extends Sprite
	{
		/**播放暂停按钮*/
		public var playAndStopButton:MovieClip = new MovieClip;
		/**返回按钮*/
		public var backButton:MovieClip = new MovieClip;
		/**进度条背景*/
		public var backGroundLine:MovieClip = new MovieClip;
		/**进度条颜色*/
		public var colorLine:MovieClip = new MovieClip;
		/**进度条小点*/
		public var pointButton:MovieClip = new MovieClip;
		/**声音按钮*/
		public var volumeButton:MovieClip = new MovieClip;
		/**是否在拖动小点*/
		protected var _isDrag:Boolean = false;
		/**seek时间*/
		protected var _seekTime:Number = 0;
		
		public function VideoShowTimeLine():void
		{
			
		}
		
		/**
		 * 激活控件
		 */
		public function running():void
		{
			playAndStopButton.buttonMode = true;
			playAndStopButton.addEventListener(MouseEvent.CLICK, onClickHandler);
			
			backButton.buttonMode = true;
			backButton.addEventListener(MouseEvent.CLICK, onClickHandler);
			
			backGroundLine.buttonMode = true;
			backGroundLine.addEventListener(MouseEvent.CLICK, onClickHandler);
			
			pointButton.x = backGroundLine.x;
			pointButton.y = backGroundLine.y;
			pointButton.buttonMode = true;
			pointButton.addEventListener(MouseEvent.MOUSE_DOWN , onDownPointHandler);
			
			colorLine.mouseEnabled = false;
			colorLine.x = backGroundLine.x;
			colorLine.y = backGroundLine.y;
			colorLine.width = pointButton.x - backGroundLine.x;
			colorLine.height = backGroundLine.height;
			
			volumeButton.buttonMode = true;
			volumeButton.addEventListener(MouseEvent.CLICK, onClickHandler);
			
			this.addEventListener(Event.ENTER_FRAME, onFrameHandler);
		}
		
		/**
		 * 鼠标事件
		 * @param	e
		 */
		protected function onClickHandler(e:MouseEvent):void
		{
			switch(e.target.name)
			{
				case playAndStopButton.name:
					if (playAndStopButton.currentFrame == 1)
					{
						VideoShowSingle.getInstance().videoShowPlayer.pause();
						playAndStopButton.gotoAndStop(2);
					}
					else
					{
						VideoShowSingle.getInstance().videoShowPlayer.play();
						playAndStopButton.gotoAndStop(1);
					}
					break;
				case backButton.name:
					VideoShowSingle.getInstance().videoShow.stop();
					break;
				case backGroundLine.name:
					_isDrag = true;
					_seekTime = (e.target.mouseX) / backGroundLine.width * VideoShowSingle.getInstance().videoShowPlayer.totalTime;
					VideoShowSingle.getInstance().videoShowPlayer.addEventListener(VideoEvent.SEEKED, onSeekedHandler);
					VideoShowSingle.getInstance().videoShowPlayer.seek(_seekTime);
					break;
				case volumeButton.name:
					if (volumeButton.currentFrame == 1)
					{
						VideoShowSingle.getInstance().videoShowPlayer.volume = 0;
						volumeButton.gotoAndStop(2);
					}
					else
					{
						VideoShowSingle.getInstance().videoShowPlayer.volume = 1;
						volumeButton.gotoAndStop(1);
					}
					break;
			}
		}
		
		/**
		 * 点击小点触发
		 * @param	e
		 */
		protected function onDownPointHandler(e:MouseEvent):void
		{
			_isDrag = true;
			pointButton.startDrag(false, new Rectangle(backGroundLine.x, backGroundLine.y, backGroundLine.width, 0));
			pointButton.stage.addEventListener(MouseEvent.MOUSE_UP, onUpPointHandler);
		}
		
		/**
		 * 松开小点
		 * @param	e
		 */
		protected function onUpPointHandler(e:MouseEvent):void
		{
			pointButton.stage.removeEventListener(MouseEvent.MOUSE_UP, onUpPointHandler);
			pointButton.stopDrag();
			_seekTime = (pointButton.x - backGroundLine.x) / backGroundLine.width * VideoShowSingle.getInstance().videoShowPlayer.totalTime;
			VideoShowSingle.getInstance().videoShowPlayer.addEventListener(VideoEvent.SEEKED, onSeekedHandler);
			VideoShowSingle.getInstance().videoShowPlayer.seek(_seekTime);
		}
		
		/**
		 * 完成seek事件
		 * @param	e
		 */
		protected function onSeekedHandler(e:VideoEvent):void
		{
			_isDrag = false;
			e.target.removeEventListener(VideoEvent.SEEKED, onSeekedHandler);
		}
		
		/**
		 * Frame事件
		 * @param	e
		 */
		protected function onFrameHandler(e:Event):void
		{
			if (!_isDrag)
			{
				pointButton.x = VideoShowSingle.getInstance().videoShowPlayer.playheadTime / VideoShowSingle.getInstance().videoShowPlayer.totalTime * backGroundLine.width + backGroundLine.x;
				VideoShowSingle.getInstance().videoShowPlayer.playing ? playAndStopButton.gotoAndStop(1) : playAndStopButton.gotoAndStop(2);
			}
			colorLine.width = pointButton.x - backGroundLine.x;
		}
	}
	
}