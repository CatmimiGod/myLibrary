package SJL.media
{
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	/**
	 * ...2015/1/7 17:08
	 * @author ...CatmimiGod
	 */
	public class VideoShowSingle extends EventDispatcher
	{
		/**当前VideoShowPlayer对象*/
		public var videoShowPlayer:VideoShowPlayer;
		/**当前VideoShowTimeLine对象*/
		public var videoShowTimeLine:VideoShowTimeLine;
		/**当前VideoShow对象*/
		public var videoShow:VideoShow;
		/**当前缓动起始区域*/
		public var currentTweenRect:Rectangle;
		/**当前缓动时间*/
		public var tweenTime:Number = 0.8;
		/***/
		private static var instance:VideoShowSingle = new VideoShowSingle();
		
		public function VideoShowSingle():void
		{
			if (instance)
			{
				throw new Error("Single.getInstance()获取实例");
			}
		}
		
		/***/
		public static function getInstance():VideoShowSingle
		{
			return instance;
		}
	}
	
}