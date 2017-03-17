package SJL.display
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import com.greensock.TweenLite;
	
	/**在添加新的影片剪辑，并且targetMC的值是当前添加的mc的时候发生*/
	[Event(name = "change" , type = "flash.events.Event")]
	/**在完成加载外部调用SWF的时候发生*/
	[Event(name = "select" , type = "flash.events.Event")]
	
	/**
	 * ...
	 * @author CatmimiGod
	 * 2014/2/25 10:54
	 * SWF内外部加载器
	 */
	public class SWFLoader extends Sprite
	{
		/**当前影片剪辑_targetMC*/
		protected var _targetMC:MovieClip;
		/**存储参数*/
		protected var _params:Object = { type:"play", frame:1 };
		/**是否只保持一个当前对象,在外部调用SWF的时候如果此属性为false，反复添加同一个路径的SWF将会叠加在容器中，而重复添加已经加载在文档中的MovieClip则是把它设置在显示层的最上一层*/
		protected var _OnlyOne:Boolean = true;
		/**是否启用加载缓动缓动*/
		protected var _tween:Boolean = false;
		/**缓动时间*/
		protected var _tweenTime:Number = 0.8;
		
		/**
		 * 初始化SWFLoader对象，目标将会被加载到mc中
		 * @param	mc				目标加载容器
		 * @param	OnlyOne			是否只保持一个当前对象,在外部调用SWF的时候如果此属性为false，反复添加同一个路径的SWF将会叠加在容器中，而重复添加已经加载在文档中的MovieClip则是把它设置在显示层的最上一层
		 * @param	tween			是否启用缓动
		 */
		public function SWFLoader(OnlyOne:Boolean = true, tween:Boolean = false):void
		{
			_OnlyOne = OnlyOne;
			_tween = tween;
			/**初始化容器影片剪辑，清空所有显示对象*/
			if (this.numChildren > 0)
				this.removeChildren();
		}
		
		/***************************************加载外部SWF***************************************/
		
		/**
		 *  加载外部SWF
		 * @param	url         外部地址
		 * @param	params		参数属性            type: "play"或者是"stop", frame:1帧数
		 */
		public function LoadSWF(url:String, params:Object = null):void
		{
			_params = null;
			
			if(params != null)
				_params = params;
			
			var loader:Loader = new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadCompleteSWF, false, 0, true);
		}
		
		/**
		 * 完成加载外部SWF
		 * @param	e
		 */
		private function onLoadCompleteSWF(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE, onLoadCompleteSWF);
			var mc:MovieClip = e.target.content as MovieClip;
			_targetMC = mc;
			this.dispatchEvent(new Event(Event.SELECT));
			addSwf(mc,_params);
		}
		
		/***************************************往显示容器添加SWF并且加当前SWF设置为目标对象***************************************/
		
		/**
		 * 加载已经实例化的SWF
		 * @param	mc          实例化MC
		 * @param	frame		当前播放头位置
		 * @param	type		类型，是停止还是播放  可选参数"play"和"stop"
		 */
		
		public function addSwf(mc:MovieClip, params:Object = null):void
		{
			if (_OnlyOne)
				RemoveALL();
				
			_targetMC = mc;
			if (params != null)
				parsingObject(_targetMC, params);
			else
				parsingObject(_targetMC, { type:"play", frame:1, tween:_tween , tweenTime:_tweenTime } );
		}
		
		/***************************************加载影片剪辑状态设置***************************************/
		
		/**
		 * 解析Object
		 * @param	mc
		 * @param	params		params参数含有type和frame ，type为play或stop用来指定mc的状态，当frame为字符串时则会寻找帧标签，
		 * 						为数字时则会按帧数来寻找，寻找规则与MovieClip的gotoAndStop 和 gotoAndPlay相同。
		 * 						默认值为(mc,{ type:"play", frame:1 ,tween : true , tweenTime : 0.8});
		 */
		private function parsingObject(mc:MovieClip,params:Object):void
		{
			var type:String;
			var frame:Object;
			var tween:Boolean;
			var tweenTime:Number;
			
			type = 	(params.hasOwnProperty("type")) ? params.type : "play";
			frame =  (params.hasOwnProperty("frame")) ? params.frame : 1;
			tween = (params.hasOwnProperty("tween")) ? params.tween : _tween;
			tweenTime = (params.hasOwnProperty("tweenTime")) ? params.tweenTime : _tweenTime;
			
			this.addChild(mc);
			this.dispatchEvent(new Event(Event.CHANGE));
			setSWFType(mc, type, frame);
			if(tween)
				setTween(mc, tweenTime);
		}
		
		/**
		 * 设置SWF播放状态
		 * @param	mc  		执行的影片剪辑
		 * @param	type 		类型	
		 * @param	frame		帧数
		 */
		public function setSWFType(mc:MovieClip,type:String, frame:Object):void
		{
			switch(type)
			{
				case "play":
					mc.gotoAndPlay(frame);
					break;
				case "stop":
					mc.gotoAndStop(frame);
					break;
			}
		}
		
		/***************************************回收设置***************************************/
		
		/**
		 * 回收当前_targetMC的影片剪辑，并且将_targetMC设置为最上层的MC,如果没有其他MC存在则当前_targetMC为null
		 * 此方法会返回当前的_target
		 */
		public function RemoveTarget():MovieClip
		{
			if(_targetMC != null)
				this.removeChild(_targetMC);
			
			var len:int = this.numChildren;
			if (len > 0)
			{
				for (var i:int = len - 1; i >= 0 ; i--)
				{
					if (this.getChildAt(i) as MovieClip)
					{
						_targetMC = this.getChildAt(i) as MovieClip;
						break;
					}
				}
			}
			else
			{
				_targetMC = null;
			}
			return _targetMC;
		}
		
		/**
		 * 清除所有当前显示对象
		 */
		public function RemoveALL():void
		{
			this.removeChildren();
			_targetMC = null;
		}
		
		public function clear():void
		{
			RemoveALL();
		}
		
		/***************************************缓动设置***************************************/
		
		/**
		 * 设置缓动
		 * @param	mc        
		 * @param	time
		 */
		public function setTween(mc:MovieClip,time:Number = 0.8):void
		{
			mc.alpha = 0;
			TweenLite.to(mc, time, { alpha:1 } );
		}
		
		/***************************************返回值设置***************************************/
		
		/**
		 * 获取当前目标MC
		 */
		public function get currentMC():MovieClip
		{
			return _targetMC;
		}
		
		/**设置是否只有一个目标影片剪辑对象,在外部调用SWF的时候如果此属性为false，反复添加同一个路径的SWF将会叠加在容器中，而重复添加已经加载在文档中的MovieClip则是把它设置在显示层的最上一层*/
		public function set OnlyOne(value:Boolean):void { _OnlyOne = value; }
		/**是否缓动*/
		public function set Tween(value:Boolean):void { _tween = value; }
		public function get Tween():Boolean { return _tween; }
		/**缓动时间*/
		public function set TweenTime(value:Number):void { _tweenTime = value; }
		public function get TweenTime():Number { return _tweenTime; }
		
	}
	
}