package SJL.net
{
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author CatmimiGod
	 */
	public class SocketMemory extends SocketTool
	{
		/**本地储存*/
		protected var _myhost:SharedObject = SharedObject.getLocal("host");
		protected var _myport:SharedObject = SharedObject.getLocal("port");
		
		public function SocketMemory(host:String = "127.0.0.1", port:int = 2000):void
		{
			if (_myhost.data.savedValue != null && _myport.data.savedValue != null)
			{
				host = _myhost.data.savedValue;
				port = int(_myport.data.savedValue);
			}
			else
			{
				saveData(host, port);
			}
			
			super(host, port);
		}
		
		/**
		 * 连接
		 * @param	host
		 * @param	port
		 */
		override public function connect(host:String, port:int):void
		{
			saveData(host, port);
			super.connect(host, port);
		}
		
		/**
		 * 接收数据
		 * @return
		 */
		public function getData():Object
		{
			if (_myhost.data.savedValue != null && _myport.data.savedValue != null)
			{
				return { host:_myhost.data.savedValue , port:int(_myport.data.savedValue) };
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 保存数据
		 */
		public function saveData(host:String,port:int):void
		{
			_myhost.data.savedValue = host;
			_myport.data.savedValue = port;
			_myhost.flush();
			_myport.flush();
		}
	}
	
}