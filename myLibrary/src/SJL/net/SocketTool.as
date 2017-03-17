package SJL.net
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.Socket;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;

	/**
	 * ...
	 * @author CatmimiGod
	 */
	public class SocketTool extends Socket
	{
		/**IP地址*/
		protected var _host:String = "127.0.0.1";
		/**端口*/
		protected var _port:int = 2000;
		/**socket重连*/
		protected var _isReconnect:Boolean = true;
		/**延迟*/
		protected var _delay:Number = 5000;
		protected var _timeOutID:uint = 1;

		public function SocketTool(host:String = "127.0.0.1",port:int = 2000):void
		{
			_host = host;
			_port = port;
			
			super(_host, _port);
			socketAddEvent(this);
		}
		
		/**
		 * 连接
		 * @param	host
		 * @param	port
		 */
		override public function connect(host:String, port:int):void
		{
			_host = host;
			_port = port;
			
			if(_isReconnect)
				clearTimeout(_timeOutID);
			
			super.connect(_host, _port);
		}
		
		/**
		 * 添加侦听器
		 * @param	s
		 */
		private function socketAddEvent(s:Socket):void
		{
			s.addEventListener(Event.CONNECT, onSocketHandler);
			s.addEventListener(IOErrorEvent.IO_ERROR, onSocketHandler);
			s.addEventListener(Event.CLOSE, onSocketHandler);
		}
		
		/**
		 * 回收侦听器
		 * @param	s
		 */
		private function socketRemoveEvent(s:Socket):void
		{
			s.removeEventListener(Event.CONNECT, onSocketHandler);
			s.removeEventListener(IOErrorEvent.IO_ERROR, onSocketHandler);
			s.removeEventListener(Event.CLOSE, onSocketHandler);
		}
		
		/**
		 * socket连接侦听
		 * @param	e
		 */
		private function onSocketHandler(e:Event):void
		{
			switch(e.type)
			{
				case Event.CONNECT:
					if(_isReconnect)
						clearTimeout(_timeOutID);
						
					trace("connect...");
					break;
				case IOErrorEvent.IO_ERROR:
					if(_isReconnect)
						_timeOutID = setTimeout(this.connect, _delay, _host, _port);
						
					trace("io_error...re connect " + _host + "  " + _port);
					break;
				case Event.CLOSE:
					if(_isReconnect)
						_timeOutID = setTimeout(this.connect, _delay, _host, _port);
						
					trace("close...");
					break;
			}
		}
		
		/***************************************************************************/
		/**
		 * 发送UTF-8 字符串数据
		 * @param	str
		 */
		public function sendMessage(str:String):void
		{
			if (this.connected)
			{
				this.writeUTFBytes(str);
				this.flush();
			}
		}
		
		/**
		 * 发送以 AMF 序列化格式发送数据
		 * @param	obj
		 */
		public function sendAMF(obj:Object):void
		{
			if (this.connected)
			{
				this.writeObject(obj);
				this.flush();
			}
		}
		
		/**设置重连时间*/
		public function get delay():Number { return delay; }
		public function set delay(value:Number):void { _delay = value; }
		
		/**
		 * 返回是否重连
		 */
		public function get reconnect():Boolean { return _isReconnect; }
		/**
		 * 设置是否重连
		 */
		public function set reconnect(value:Boolean):void { _isReconnect = value; }
		
		/**
		 * 销毁这个方式
		 */
		public function dispose():void
		{
			socketRemoveEvent(this);
			if(_isReconnect)
				clearTimeout(_timeOutID);
			if(this.connected)	
				this.close();
		}
		
		/**
		 * 返回IP地址
		 */
		public function get host():String
		{
			return _host;
		}
		
		/**
		 * 返回端口号
		 */
		public function get port():int
		{
			return _port;
		}
	}

}