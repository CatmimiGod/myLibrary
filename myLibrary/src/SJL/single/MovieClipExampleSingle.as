package SJL.single
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author CatmimiGod
	 */
	public class  MovieClipExampleSingle extends EventDispatcher
	{
		
		/**抽象模型*/
		protected var _params:Object = new Object;
		
		/**单例*/
		private static var instance:MovieClipExampleSingle = new MovieClipExampleSingle();
		/**自动播放状态*/
		public var auto:Boolean = false;
		
		public var backGroundVideo:*;
		
		public function MovieClipExampleSingle():void
		{
			if (instance)
			{
				throw new Error("Single.getInstance()获取实例");
			}
		}
		
		/**
		 * 获取单例
		 * @return
		 */
		public static function getInstance():MovieClipExampleSingle
		{
			return instance;
		}
		
		/**
		 * 设置模型焦点
		 * @param	params
		 */
		public function setParams(params:Object):void
		{
			_params = params;
		}
		
		/**
		 * 播放索引
		 * @param	...arg
		 */
		public function playIndex(...arg):void
		{
			if (_params.hasOwnProperty("playIndex"))
			{
				switch(arg.length)
				{
					case 1:
						_params.playIndex(arg[0]);
						break;
					case 2:
						_params.playIndex(arg[0],arg[1]);
						break;
				}
			}
		}
		
		/**
		 * 播放背景视频索引
		 * @param	...arg
		 */
		public function playBackGroundVideoIndex(...arg):void
		{
			if (_params.hasOwnProperty("playBackGroundVideoIndex"))
			{
				switch(arg.length)
				{
					case 1:
						_params.playBackGroundVideoIndex(arg[0]);
						break;
					case 2:
						_params.playBackGroundVideoIndex(arg[0],arg[1]);
						break;
				}
			}
		}
	}
	
}