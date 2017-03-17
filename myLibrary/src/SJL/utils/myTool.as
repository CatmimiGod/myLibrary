package SJL.utils
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	
	/**
	 * ...
	 * @author ...CatmimiGod
	 */
	public class myTool 
	{
		/**
		 * 设置通用全屏缩放模式
		 * @param	stage
		 */
		public static function StageNormal(stage:Stage):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		
		public static function addFrameScript():void
		{
			
		}
		
		/**
		 * 在最后一帧添加stop方法
		 * @param	mc
		 */
		public static function totalFrameAddStop(mc:MovieClip):void
		{
			mc.addFrameScript(mc.totalFrames - 1, function() { mc.stop(); } );
		}
	}
	
}