package SJL.mail
{
	
	/**
	 * ...2015/1/20 15:26
	 * @author CatmimiGod
	 */
	public class MailParam extends Object
	{
		/**邮件服务器IP地址*/
		public  var Host:String;
		/**邮件服务器端口号*/
		public  var Port:int;
		/**用户名*/
		public  var Login:String;
		/**密码*/
		public  var Pass:String;
		
		public function MailParam():void
		{
			super();
		}
	}
	
}