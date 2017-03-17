package SJL.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * ...2015/1/20 15:26
	 * @author ...CatmimiGod
	 */
	public class ConfigTool extends EventDispatcher
	{
		/**xml*/
		private var _xml:XML;
		/**网络参数*/
		private var _network:XMLList;
		/**swf路径数组*/
		private var _swfURL:Array;
		/**swf路径数组2*/
		private var _swfURL2:Array;
		/**视频路径数组*/
		private var _videoURL:Array;
		/**音乐路径数组*/
		private var _musicURL:Array;
		/**图片路径数组*/
		private var _bitmapURL:Array;
		/**数字参数数组*/
		private var _numURL:Array;
		
		/**
		 * xml加载工具
		 * @param	url
		 */
		public function ConfigTool(url:String):void
		{
			load(url);
		}
		
		/**
		 * 加载XML
		 * @param	url
		 */
		private function load(url:String):void
		{
			var load:URLLoader = new URLLoader(new URLRequest(url));
			load.addEventListener(Event.COMPLETE, onCompleteLoadConfig);
			load.addEventListener(IOErrorEvent.IO_ERROR , onIOERRORHandler);
		}
		
		/**
		 * 加载config错误
		 * @param	e
		 */
		private function onIOERRORHandler(e:IOErrorEvent):void
		{
			trace("ConfigTool.IO_ERROR......");
		}
		
		/**
		 * 完成加载XML
		 * @param	e
		 */
		private function onCompleteLoadConfig(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE, onCompleteLoadConfig);
			_xml = XML(e.target.data);
			_network = _xml.network;
			upDataSwfURL();
			upDataSwfURL2();
			upDataMusicURL();
			upDataVideoURL();
			upDataBitmapURL();
			upDataNumURL();
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 更新swf路径数组
		 */
		protected function upDataSwfURL():void
		{
			var len:uint = _xml.swfURL.url.length();
			_swfURL = new Array();
			for (var i:int; i < len; i++)
			{
				_swfURL.push(_xml.swfURL.url[i]);
			}
		}
		
		/**
		 * 更新swf路径数组2
		 */
		protected function upDataSwfURL2():void
		{
			var len:uint = _xml.swfURL2.url.length();
			_swfURL2 = new Array();
			for (var i:int; i < len; i++)
			{
				_swfURL2.push(_xml.swfURL2.url[i]);
			}
		}
		
		/**
		 * 更新音乐路径数组
		 */
		protected function upDataMusicURL():void
		{
			var len:uint = _xml.musicURL.url.length();
			_musicURL = new Array();
			for (var i:int; i < len; i++)
			{
				_musicURL.push(_xml.musicURL.url[i]);
			}
		}
		
		/**
		 * 更新视频路径数组
		 */
		protected function upDataVideoURL():void
		{
			var len:uint = _xml.videoURL.url.length();
			_videoURL = new Array();
			for (var i:int; i < len; i++)
			{
				_videoURL.push(_xml.videoURL.url[i]);
			}
		}
		
		/**
		 * 更新图片路径数组
		 */
		protected function upDataBitmapURL():void
		{
			var len:uint = _xml.bitmapURL.url.length();
			_bitmapURL = new Array();
			for (var i:int; i < len; i++)
			{
				_bitmapURL.push(_xml.bitmapURL.url[i]);
			}
		}
		
		/**
		 * 更新数字参数数组
		 */
		protected function upDataNumURL():void
		{
			var len:uint = _xml.numURL.url.length();
			_numURL = new Array();
			for (var i:int; i < len; i++)
			{
				_numURL.push(_xml.numURL.url[i]);
			}
		}
		
		/**获取加载XML*/
		public function get xml():XML { return _xml; }
		/**获取网络参数*/
		public function get network():XMLList { return _network; }
		/**获取swf路径数组*/
		public function get swfURL():Array { return _swfURL; }
		/**获取swf路径数组2*/
		public function get swfURL2():Array { return _swfURL2; }
		/**获取music路径数组*/
		public function get musicURL():Array { return _musicURL; }
		/**获取视频路径数组*/
		public function get videoURL():Array { return _videoURL; }
		/**获取图片路径数组*/
		public function get bitmapURL():Array { return _bitmapURL; }
		/**获取数字参数数组*/
		public function get numURL():Array { return _numURL; }
	}
	
}