package SJL.events
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author CatmimiGod
	 */
	public class  MouseBoardEvent extends Event
	{
		public static const DIRECTION_CLICK:String = "direction_click";
		public static const DIRECTION_LEFT:String = "direction_left";
		public static const DIRECTION_RIGHT:String = "direction_right";
		public static const DIRECTION_TOP:String = "direction_top";
		public static const DIRECTION_DOWN:String = "direction_down";
		//public static const DIRECTION_LEFT_TOP:String = "direction_left_top";
		//public static const DIRECTION_LEFT_DOWN:String = "direction_left_down";
		//public static const DIRECTION_RIGHT_TOP:String = "direction_right_top";
		//public static const DIRECTION_RIGHT_DOWN:String = "direction_right_down";
		
		private var _info:Object;
		private var _mouseEvent:MouseEvent;
		
		/**
		 * 鼠标键盘控制事件
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	info
		 */
		public function MouseBoardEvent(type:String,bubbles:Boolean = false,cancelable:Boolean = false,info:Object = null,mouseEvent:MouseEvent=null):void
		{
			super(type, bubbles, cancelable);
			_info = info;
			_mouseEvent = mouseEvent;
		}
		
		/**
		 * 
		 */
		public function get mouseEvent():MouseEvent
		{
			return _mouseEvent;
		}
		
		/**
		 * 返回信息
		 */
		public function get info():Object
		{
			return _info;
		}
		
		override public function toString():String 
		{
			return super.toString();
		}
	}
	
}