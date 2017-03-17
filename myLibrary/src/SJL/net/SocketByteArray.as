package SJL.net
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import SJL.net.SocketTool;
	
	/**在接收完指定数据后发生的事件*/
	[Event(name = "select" , type = "flash.events.Event")]
	
	/**
	 * ...通过socket发送和接收图片类
	 * @author CatmimiGod
	 */
	public class SocketByteArray extends SocketTool 
	{
		/**二进制数据*/
		private var _byte:ByteArray = new ByteArray();
		/**长度*/
		private var _length:uint = 0;
		/**数据索引*/
		private var _index:uint = 0;
		/**数据名称*/
		private var _name:String = null;
		/**数据头*/
		private var _type:uint = 0x525;
		/**是否是符合此类的数据结构*/
		private var _isType:Boolean = false;
		
		/**
		 * 构造函数
		 * @param	host			IP地址
		 * @param	port			端口号
		 * @param	reception		是否启用接收事件，默认不启用
		 */
		public function SocketByteArray(host:String = "127.0.0.1", port:int = 2000, reception:Boolean = false):void
		{
			super(host, port);
			
			if (reception)
				this.addEventListener(ProgressEvent.SOCKET_DATA, onSocketDataHandler);
		}
		
		/**
		 * 发送二进制的JPG数据
		 * @param	byte
		 */
		public function sendJPG(byte:ByteArray,index:uint = 0,name:String = "notName"):void
		{
			var temp:ByteArray = new ByteArray();
			
			/**写入本类发送类型*/
			temp.writeUnsignedInt(_type);
			/**留下前4位的位置来写长度用*/
			temp.position = 8;
			/**写入名称长度*/
			temp.writeUnsignedInt(name.length);
			/**写入名称*/
			temp.writeUTFBytes(name);
			/**写入图片数据长度*/
			temp.writeUnsignedInt(byte.length);
			/**写入图片数据*/
			temp.writeBytes(byte);
			/**写入结束索引*/
			temp.writeUnsignedInt(index);
			/**回到开始位置，写入长度信息*/
			temp.position = 4;
			temp.writeUnsignedInt(temp.length);
			/**发送数据*/
			this.writeBytes(temp);
			this.flush();
			trace("发送图片数据:" + byte.length);
			trace("发送总数据:" + temp.length);
			temp.clear();
		}
		
		/**
		 * 接收发送的二进制数据
		 * @param	e
		 */
		public function onSocketDataHandler(e:ProgressEvent):void
		{
			//trace("收到数据")
			if (this.bytesAvailable)
			{
				var temp:ByteArray = new ByteArray();
				this.readBytes(temp);
				
				if (temp.readUnsignedInt() == _type)
				{
					_isType = true;
					temp.position = 4;
					_length = temp.readUnsignedInt();
					trace("接收到总长度:", _length);
				}
				
				if(_isType)
					_byte.writeBytes(temp);
				
				if (_byte.length == _length)
				{
					_length = 0;
					_isType = false;
					
					/**获取最末位索引值*/
					_byte.position = _byte.length - 4;
					_index = _byte.readUnsignedInt();
					
					/**获取名称长度*/
					_byte.position = 8;
					var nameLen:uint = _byte.readUnsignedInt();
					_byte.position = 12;
					_name = _byte.readUTFBytes(nameLen);
					
					/**获取图片数据*/
					var byt:ByteArray = new ByteArray();
					_byte.position = nameLen + 12;
					var len:uint = _byte.readUnsignedInt();
					trace("图片长度:", len);
					byt.writeBytes(_byte , nameLen + 16 , len);
					_byte = byt;
					trace("实际接收图片长度:", _byte.length);
					
					this.dispatchEvent(new Event(Event.SELECT));
					//trace("收到信息:" + _byte.length);
					_byte.clear();
					//trace("清空：" + _byte.length)
				}
			}
		}
		
		/**
		 * 返回数据
		 */
		public function get data():ByteArray
		{
			return _byte;
		}
		
		/**
		 * 返回数据索引
		 */
		public function get index():uint
		{
			return _index;
		}
		
		/**
		 * 传输过来的名称
		 */
		public function get name():String
		{
			return _name;
		}
	}
	
}