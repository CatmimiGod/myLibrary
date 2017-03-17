package SJL.utils
{
	
	/**
	 * ...2015/1/22 15:10
	 * @author ...CatmimiGod
	 */
	public class NumberSwitch
	{
		/**
		 * 由毫秒转换为分钟, 返回{min:分钟,ms:秒钟};
		 * @param	num
		 * @return 
		 */
		public static function msTOmin(num:Number):Object
		{
			var temp:Number = num;
			temp /= 1000;
			return { min :Math.floor(temp / 60), ms:Math.floor(temp % 60) };
		}
		
		/**
		 * 将小于10的数字前面加0
		 * @param	num
		 * @return
		 */
		public static function addZero(num:Number):String
		{
			if (num < 10)
			{
				return "0" + num.toString();
			}
			else
			{
				return num.toString();
			}
		}
		
	}
	
}