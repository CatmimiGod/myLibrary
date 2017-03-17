package SJL.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author CatmimiGod
	 */
	public class DebugEvent extends Event
	{
		public static const Debug:String = "debug";
		
		private var _str:String;
		
		public function DebugEvent(type:String,str:String):void
		{
			super(type);
			_str = str;
		}
		
		public function get str():String
		{
			return _str;
		}
	}
	
}