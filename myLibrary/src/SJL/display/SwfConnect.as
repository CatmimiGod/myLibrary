package SJL.display
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;	
	import SJL.utils.LoaderTool;
	
	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name="change", type="flash.events.Event")]
	/**
	 * ...2015/1/20 15:25
	 * @author ...CatmimiGod
	 */
	public class SwfConnect extends Sprite 
	{
		/**swf加载器*/
		protected var _loader:LoaderTool;
		/**当前播放数组，内部都是MovieClip*/
		protected var _swfArr:Array;
		/**当前播放索引*/
		protected var _index:int;
		/**当前播放的影片剪辑*/
		protected var _mc:MovieClip;
		/**自动继续播放*/
		protected var _auto:Boolean = false;
		
		public function SwfConnect(auto:Boolean = false):void
		{
			_auto = auto;
		}
		
		/**
		 * 以数组方式加载swf
		 * @param	value
		 */
		public function loadSwf(value:Array):void
		{
			this.removeEventListener(Event.ENTER_FRAME, onFrameHandler);
			_loader = new LoaderTool(value);
			_loader.addEventListener(Event.COMPLETE , onCompleteLoadHandler);
		}
		
		/**
		 * 完成加载swf
		 * @param	e
		 */
		protected function onCompleteLoadHandler(e:Event):void
		{
			_swfArr = _loader.dataArray;
			playIndex();
		}
		
		/**
		 * 替换播放数组,可以直接用此方法替换播放数组，此方法会自动调用playIndex(index:int = 0 , frame:uint = 1)播放；
		 * @param	value
		 */
		public function changeArr(value:Array):void
		{
			this.removeEventListener(Event.ENTER_FRAME, onFrameHandler);
			/**验证是否是MovieClip*/
			for (var i:int; i < value.length; i++)
			{
				if (!value[i] is MovieClip)
				{
					throw ArgumentError("这个数组里面有个不是MovieClip,索引是" + i + "，请检查");
				}
			}
			_swfArr = value;
		}
		
		/**
		 * 播放索引中的swf
		 * @param	index
		 */
		public function playIndex(index:int = 0 , frame:uint = 1):void
		{
			if (index > _swfArr.length - 1)
			{
				index = 0;
			}
			else if (index < 0)
			{
				index = _swfArr.length - 1;
			}
			
			_index = index;
			addSwf(_swfArr[_index] , frame);
		}
		
		/**
		 * 移动播放头到当前帧
		 * @param	frame
		 */
		public function seek(frame:uint):void
		{
			if (frame > arrTotalFrames)
				frame = 1;
				
			var tempFrame:int;
			for (var i:int ; i < _swfArr.length; i++)
			{
				/**累加当前总帧数，如果输入的帧小于这几个swf.totalFrames则找寻到此帧数在当前数组中存在*/
				tempFrame += _swfArr[i].totalFrames;
				if (frame < tempFrame)
				{
					tempFrame = 0;
					for (var j:int ; j < i; j++)
					{
						tempFrame += _swfArr[j].totalFrames;
					}
					playIndex(j, uint(frame - tempFrame));
					break;
				}
			}
		}
		
		/**
		 * 添加swf到舞台
		 * @param	mc
		 */
	    protected function addSwf(mc:MovieClip , frame:uint = 1):void
		{
			if(_mc)
				this.removeChild(_mc);
			
			_mc = mc;
			this.dispatchEvent(new Event(Event.CHANGE));
			this.addChild(_mc);
			_mc.gotoAndPlay(frame);
			this.addEventListener(Event.ENTER_FRAME, onFrameHandler);
		}
		
		/**
		 * 帧侦听
		 * @param	e
		 */
		protected function onFrameHandler(e:Event):void
		{
			if (_mc.currentFrame == _mc.totalFrames)
			{
				_mc.stop();
				this.removeEventListener(Event.ENTER_FRAME , onFrameHandler);
				this.dispatchEvent(new Event(Event.COMPLETE));
				if (_auto)
					playIndex(_index += 1);
			}
		}
		
		/**
		 * 整个数组中的所有swf总共的帧数
		 */
		public function get arrTotalFrames():int
		{
			var frame:int;
			for (var i:int; i < _swfArr.length ; i++)
			{
				frame += _swfArr[i].totalFrames;
			}
			return frame;
		}
		
		/**
		 * 整个数组中当前swf的帧数
		 */
		public function get arrCurrentFrame():int
		{
			if (_index == 0)
			{
				return _mc.currentFrame;
			}
			else
			{
				var frame:int;
				for (var i:int; i < _index; i++)
				{
					frame += _swfArr[i].totalFrames;
				}
				frame += _mc.currentFrame;
				return frame;
			}
		}
		
		/**
		 * 清除显示对象，并且回收侦听器和数据
		 */
		public function clear():void
		{
			this.removeEventListener(Event.ENTER_FRAME , onFrameHandler);
			_index = 0;
			this.removeChildren();
			_mc = null;
		}
		
		/**
		 * 当前MC
		 */
		public function get currentMC():MovieClip { return _mc; }
		/**自动继续播放*/
		public function get auto():Boolean { return _auto; }
		public function set auto(value:Boolean):void { _auto = value; }
		/**返回索引*/
		public function get index():int { return _index; }
		/**返回长度*/
		public function get len():int { return _swfArr.length; }
	}
	
}