package SJL.display
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
		
	/**
	 * ...2015/1/20 15:25
	 * @author ...CatmimiGod
	 */
	public class SWFLoaderDirectory
	{
		/**swf加载器*/
		private var _swfLoader:SWFLoader;
		/**层级数组*/
		private var _arr:Array;
		
		/**
		 * 初始化，会自动将当前加入的SWFLoader的OnlyOne设置为true,非可视对象，主要用于管理SWFLoader
		 * @param	swfloader
		 */
		public function SWFLoaderDirectory(swfloader:SWFLoader):void
		{
			_swfLoader = swfloader;
			_swfLoader.OnlyOne = true;
			_arr = new Array();
		}
		
		/**
		 * 添加影片剪辑
		 * @param	mc
		 * @param	params		{ type:"play", frame:1 ,tween : true , tweenTime : 0.8}
		 */
		public function addSwf(mc:MovieClip, params:Object = null):void
		{
			_swfLoader.addSwf(mc,params);
			_arr.push(mc);
		}
		
		/**
		 * 同级切换影片剪辑
		 * @param	mc
		 * @param	params		{ type:"play", frame:1 ,tween : true , tweenTime : 0.8}
		 */
		public function changeSwf(mc:MovieClip , params:Object = null):void
		{
			if (_arr.length != 0)
				_arr.pop();
				
			addSwf(mc, params);
		}
		
		/**
		 * 返回上一级
		 * @param	params			如果params参数为空，则自动停留在上一层级的最后一帧。{ type:"play", frame:1 };
		 * 							params参数含有type和frame ，type为play或stop用来指定mc的状态，当frame为字符串时则会寻找帧标签，
		 * 							为数字时则会按帧数来寻找，寻找规则与MovieClip的gotoAndStop 和 gotoAndPlay相同。
		 * 							如果返回层级中只剩下一级，则会回收所有实例。
		 */
		public function back(params:Object = null):void
		{
			if (_arr.length > 1)
			{
				_arr.pop();
				var mc:MovieClip = _arr[_arr.length -1];
				if (params == null)
					params = { type:"stop", frame:mc.totalFrames };
				_swfLoader.addSwf(mc, params);
			}
			else
			{
				_swfLoader.RemoveALL();
			}
		}
		
		/**获取设置层级数组,如需要返回特定层级则自己定义层级数组，内部是MovieClip*/
		public function get DirectoryArr():Array { return _arr; }
		public function set DirectoryArr(value:Array):void { _arr = value; }
		/**获取swfloader对象*/
		public function get swfloader():SWFLoader { return _swfLoader; }
		/**清除*/
		public function clear():void
		{
			_arr = new Array();
			_swfLoader.RemoveALL();
		}
	}
	
}