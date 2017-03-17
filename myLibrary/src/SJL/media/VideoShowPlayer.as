package SJL.media
{
	import fl.video.FLVPlayback;
	import fl.video.VideoPlayer;
	
	/**
	 * ...2015/1/7 17:08
	 * @author ...CatmimiGod
	 */
	public class VideoShowPlayer extends FLVPlayback 
	{
		public function VideoShowPlayer(width:Number = 1920, height:Number = 1080):void
		{
			//super (width, height);
			super();
			this.width = width;
			this.height = height;
		}
	}
	
}