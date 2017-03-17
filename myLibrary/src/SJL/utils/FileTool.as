package SJL.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	
	/**
	 * ...2015/1/20 15:26
	 * @author CatmimiGod
	 */
	public class  FileTool
	{

		/**
		 * 在指定file路径下创建一个fileName名字的文件夹
		 * @param	file			File路径
		 * @param	fileName		文件夹名称
		 */
		public static function buildFile(file:File, fileName:String):void
		{
			var newFile:File = file.resolvePath(fileName);
			if (!newFile.exists)
				newFile.createDirectory();
		}
		
		/**
		 * 在指定file路径下返回该路径下的所有文件列表
		 * @param	file			File路径
		 * @return
		 */
		public static function getDirectoryListing(file:File):Array
		{
			return file.getDirectoryListing();
		}
		
		/**
		 * 读取指定file路径下的文件，返回ByteArray
		 * @param	file			File路径
		 * @return
		 */
		public static function readFile(file:File):ByteArray
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(file , FileMode.READ);
			var bytes:ByteArray = new ByteArray();
			fileStream.readBytes(bytes);
			fileStream.close();
			
			return bytes;
		}
		
		/**
		 * 在指定file路径下写入byteArray文件
		 * @param	file			File路径
		 * @param	byte			需要写入的ByteArray文件
		 */
		public static function writeByteArrayFile(file:File, byte:ByteArray):void
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.position = 0;
			fileStream.writeBytes(byte);
			fileStream.close();
		}
		
		/**
		 * 在指定file路径下写入String文件
		 * @param	file			File路径
		 * @param	msg				需要写入的String文件
		 */
		public static function writeUTFBytesFile(file:File, msg:String):void
		{
			var fileStream:FileStream = new FileStream();
			file = file.resolvePath("/");
			fileStream.open(file, FileMode.WRITE);
			fileStream.position = 0;
			fileStream.writeUTFBytes(msg);
			fileStream.close();
		}
	}
	
}