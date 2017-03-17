package SJL.mail
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import org.bytearray.smtp.events.SMTPEvent;
	import org.bytearray.smtp.mailer.SMTPMailer;
	
	import SJL.events.DebugEvent;
	
	
	/**邮件已发送*/
	[Event(name = "mailSent" , type = "org.bytearray.smtp.events.SMTPEvent")]
	/**通过身份验证*/
	[Event(name = "authenticated" , type = "org.bytearray.smtp.events.SMTPEvent")]
	/**邮件正在发送*/
	[Event(name = "mailError" , type = "org.bytearray.smtp.events.SMTPEvent")]
	/**坏的序列*/
	[Event(name = "badSequence" , type = "org.bytearray.smtp.events.SMTPEvent")]
	/**连接成功*/
	[Event(name = "connected" , type = "org.bytearray.smtp.events.SMTPEvent")]
	/**断开连接*/
	[Event(name = "disconnected" , type = "org.bytearray.smtp.events.SMTPEvent")]
	
	
	/**Debug输出*/
	[Event(name = "debug" , type = "SJL.events.DebugEvent")]
	
	/**
	 * ...单例邮件发送工具
	 * 2015/1/20 15:26
	 * @author CatmimiGod
	 */
	public class SingleMailTool extends EventDispatcher
	{
		/**单例对象*/
		private static var _instance:SingleMailTool;
		
		/**邮件服务器IP地址*/
		private  var Host:String;
		/**邮件服务器端口号*/
		private  var Port:int;
		/**用户名*/
		private  var Login:String;
		/**密码*/
		private  var Pass:String;
		/**收件人*/
		private  var Dest:String;
		
		/**类型*/
		private var Type:String;
		/**两种类型常量*/
		private const HTML_Mail:String = "sendHTMLMail";
		private const Attached_Mail:String = "AttachedMail";
		
		/**主题*/
		private var Subject:String;
		/**内容*/
		private var Mess:String;
		/**数据*/
		private var Byte:ByteArray;
		/**数据名称*/
		private var ByteName:String;
		
		
		public function SingleMailTool():void
		{
			
		}
		
		/**
		 * 获取全局管理实例
		 * @return
		 */
		public static function getInstance():SingleMailTool
		{
			if (!_instance)
				_instance = new SingleMailTool();
				
			return _instance;	
		}
		
		/**
		 * 设置数据
		 * @param	value
		 */
		public function setParam(value:MailParam):void
		{
			Host = value.Host;
			Port = value.Port;
			Login = value.Login;
			Pass = value.Pass;
		}
		
		/**
		 * * 发送文本邮件
		 * @param	pDest			收件人
		 * @param	pSubject		主题
		 * @param	pMess			内容
		 */
		public function sendHTMLMail(pDest:String, pSubject:String, pMess:String):void
		{
			Type = HTML_Mail;
			Dest = pDest;
			Subject = pSubject;
			Mess = pMess;
			
			login();
		}
		
		/**
		 * 发送带有附件的邮件
		 * @param	pDest			收件人
		 * @param	pSubject		主题
		 * @param	pMess			内容
		 * @param	pByte			附件数据
		 * @param	pByteName		附件名称
		 */
		public function sendAttachedMail(pDest:String, pSubject:String, pMess:String, pByte:ByteArray, pByteName:String):void
		{
			Type = Attached_Mail;
			Dest = pDest;
			Subject = pSubject;
			Mess = pMess;
			Byte = pByte;
			ByteName = pByteName;
			
			login();
		}
		
		/**
		 * 登录
		 */
		protected function login():void
		{
			var smtpMailer:SMTPMailer = new SMTPMailer(Host, Port);
			addEvent(smtpMailer);
			smtpMailer.authenticate(Login, Pass);
		}
		
		/**
		 * 添加侦听器
		 * @param	smtpMailer
		 */
		private function addEvent(smtpMailer:SMTPMailer):void
		{
			smtpMailer.addEventListener(SMTPEvent.AUTHENTICATED , onMailHandler);
			smtpMailer.addEventListener(SMTPEvent.BAD_SEQUENCE, onMailHandler);
			smtpMailer.addEventListener(SMTPEvent.CONNECTED, onMailHandler);
			smtpMailer.addEventListener(SMTPEvent.DISCONNECTED , onMailHandler);
			smtpMailer.addEventListener(SMTPEvent.MAIL_ERROR , onMailHandler);
			smtpMailer.addEventListener(SMTPEvent.MAIL_SENT , onMailHandler);
		}
		
		/**
		 * 回收侦听器
		 * @param	smtpMailer
		 */
		private function removeEvent(smtpMailer:SMTPMailer):void
		{
			smtpMailer.removeEventListener(SMTPEvent.AUTHENTICATED , onMailHandler);
			smtpMailer.removeEventListener(SMTPEvent.BAD_SEQUENCE, onMailHandler);
			smtpMailer.removeEventListener(SMTPEvent.CONNECTED, onMailHandler);
			smtpMailer.removeEventListener(SMTPEvent.DISCONNECTED , onMailHandler);
			smtpMailer.removeEventListener(SMTPEvent.MAIL_ERROR , onMailHandler);
			smtpMailer.removeEventListener(SMTPEvent.MAIL_SENT , onMailHandler);
		}
		
		/**
		 * 发生事件
		 * @param	e
		 */
		private function onMailHandler(e:SMTPEvent):void
		{
			this.dispatchEvent(e.clone());
			switch(e.type)
			{
				case SMTPEvent.AUTHENTICATED:
					debugInfo("通过身份验证...");
					onAuthSuccess(e);
					break;
				case SMTPEvent.BAD_SEQUENCE:
					debugInfo("坏的序列...");
					break;
				case SMTPEvent.CONNECTED:
					debugInfo("连接成功...");
					break;
				case SMTPEvent.DISCONNECTED:
					debugInfo("断开连接...");
					break;
				case SMTPEvent.MAIL_ERROR:
					debugInfo("请稍后...");
					break;
				case SMTPEvent.MAIL_SENT:
					debugInfo("邮件已发送！");
					removeEvent(e.target as SMTPMailer);
					break;
			}
		}
		
		/**
		 * 登录成功,通过身份验证
		 * @param	e
		 */
		protected function onAuthSuccess(e:SMTPEvent):void
		{
			var smtpMailer:SMTPMailer = e.target as SMTPMailer;
			switch(Type)
			{
				case HTML_Mail:
					smtpMailer.sendHTMLMail(Login, Dest, Subject, Mess);
					break;
				case Attached_Mail:
					smtpMailer.sendAttachedMail(Login, Dest, Subject, Mess, Byte, ByteName);
					break;
			}
		}
		
		/**
		 * Debug显示
		 * @param	str
		 */
		public function debugInfo(str:String):void
		{
			this.dispatchEvent(new DebugEvent(DebugEvent.Debug, str));
		}
	}
	
}