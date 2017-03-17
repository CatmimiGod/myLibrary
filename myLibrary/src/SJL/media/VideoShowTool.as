package SJL.media
{
	import flash.geom.Rectangle;
	
	/**
	 * ...2015/1/7 17:08
	 * @author ...CatmimiGod
	 */
	public class VideoShowTool 
	{
		public static function halfRect(rect:Rectangle):Rectangle
		{
			var _width:Number = rect.width * 0.5;
			var _height:Number = rect.height * 0.5;
			var _x:Number = (rect.width - _width) * 0.5 ;
			var _y:Number = (rect.height - _height) * 0.5;
			return new Rectangle(_x, _y, _width, _height);
		}
	}
	
}