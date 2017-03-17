package SJL.utils
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	
	
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * ...2015/1/20 15:26
	 * @author ...CatmimiGod
	 */
	public class LoaderTool extends EventDispatcher
	{
		/**数组长度*/
		private var _len:uint;
		/**类型*/
		private var _type:String;
		/**数据数组*/
		private var _arr:Array;
		
		public var name:String;
		
		public static const SWF:String = "MovieClip";
		public static const JPG:String = "Bitmap";
		
		public function LoaderTool(arr:Array,type:String = SWF):void
		{
			if(arr && type)
				load(arr, type);
		}
		
		/**
		 * 
		 * @param	arr
		 * @param	type
		 */
		public function load(arr:Array,type:String = SWF):void
		{
			_len = arr.length;
			_arr = new Array();
			_type = type;
			for (var i:int = 0 ; i < _len ; i++)
			{
				var loader:Loader = new Loader();
				var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain , null);
				loader.load(new URLRequest(arr[i]), loaderContext);
				//loader.load(new URLRequest(arr[i]));
				loader.name = i.toString();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE , onCompleteLoaderHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR , onIOERRORHandler);
			}
		}
		
		/**
		 * 加载错误
		 * @param	e
		 */
		private function onIOERRORHandler(e:IOErrorEvent):void
		{
			trace("LoaderTool.IO_ERROR......");
		}
		
		/**
		 * 完成加载数据
		 * @param	e
		 */
		private function onCompleteLoaderHandler(e:Event):void
		{
			_len -= 1;
			e.target.removeEventListener(Event.COMPLETE , onCompleteLoaderHandler);
			switch(_type)
			{
				case "MovieClip":
					_arr[e.target.loader.name] = e.target.content as MovieClip;
					break;
				case "Bitmap":
					_arr[e.target.loader.name] = e.target.content as Bitmap;
					break;
			}
			if (_len == 0)
				this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 返回数据
		 */
		public function get dataArray():Array
		{
			return _arr;
		}
	}
	
}