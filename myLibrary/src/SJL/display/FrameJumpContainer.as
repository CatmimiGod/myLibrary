package SJL.display
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author CatmimiGod
	 */
	public class FrameJumpContainer extends MovieClip
	{
		/**当前页面*/
		public var page:uint = 0;
		public var pageArr:Array = [];
		
		public var mainPage:String = "mainPage_0";
		
		public function FrameJumpContainer()
		{
			this.addEventListener(MouseEvent.CLICK , onClickHandler);
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function onClickHandler(e:MouseEvent):void
		{
			var btnName:String = e.target.name;
			switch(btnName)
			{
				case "mainPage_next":
					next();
					break;
				case "mainPage_prev":
					prev();
					break;
				default:
					if (btnName.indexOf("mainPage_") == 0)
					{
						mainPage = btnName;
						this.gotoAndPlay(btnName);
					}
					else if (btnName.indexOf("page_") == 0)
					{
						this.gotoAndPlay(btnName);
					}
			}
		}
		
		/**
		 * 下一页
		 */
		public function next():void
		{
			var index:int = pageArr.indexOf(mainPage);
			if (index == -1)
			{
				mainPage = pageArr[0];
				this.gotoAndPlay(mainPage);
			}
			else if(index == pageArr.length - 1)
			{
				
			}
			else
			{
				mainPage = pageArr[index + 1];
				this.gotoAndPlay(mainPage);
			}
			
		}
		
		/**
		 * * 上一页
		 */
		public function prev():void
		{
			var index:int = pageArr.indexOf(mainPage);
			if (index == -1)
			{
				mainPage = pageArr[0];
				this.gotoAndPlay(mainPage);
			}
			else if(index == 0)
			{
				
			}
			else
			{
				mainPage = pageArr[index - 1];
				this.gotoAndPlay(mainPage);
			}
		}
	}
	
}