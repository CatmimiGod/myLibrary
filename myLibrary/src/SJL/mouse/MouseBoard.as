package SJL.mouse
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import SJL.events.MouseBoardEvent;

	[Event(name = "direction_click" , type = "SJL.events.MouseBoardEvent")]
	[Event(name = "direction_left" , type = "SJL.events.MouseBoardEvent")]
	[Event(name = "direction_right" , type = "SJL.events.MouseBoardEvent")]
	[Event(name = "direction_top" , type = "SJL.events.MouseBoardEvent")]
	[Event(name = "direction_down" , type = "SJL.events.MouseBoardEvent")]
	
	/**
	 * ...2015/1/15 15:45
	 * @author CatmimiGod
	 */
	public class MouseBoard extends EventDispatcher
	{
		private var _initPoint:Point;
		private var _overPoint:Point;
		/**偏移基准量度*/
		public var direction:Number = 300;
		/**是否已经按下*/
		private var _isDown:Boolean = false;
		
		private var _targetName:String = null;
		
		/**方向数量*/
		public var dirNum:int = 4;
		
		public const DirNum4:int = 4;
		public const DirNum8:int = 8;
		
		private var _mouseEvent:MouseEvent;
		
		/**
		 * 
		 * @param	stage
		 * @param	direction
		 */
		public function MouseBoard(obj:*,direction:Number = 300):void
		{
			this.direction = direction;
			obj.addEventListener(MouseEvent.MOUSE_DOWN , onMouseDownHandler);
		}
		
		/**
		 * 鼠标按下事件
		 * @param	e
		 */
		private function onMouseDownHandler(e:MouseEvent):void
		{
			_targetName = e.target.name;
			_mouseEvent = e;
			_isDown = true;
			_initPoint = new Point(e.target.stage.mouseX, e.target.stage.mouseY);
			//trace(_initPoint);
			e.target.stage.addEventListener(MouseEvent.MOUSE_UP , onMouseUpHandler);
		}
		
		/**
		 * 鼠标松开事件
		 * @param	e
		 */
		private function onMouseUpHandler(e:MouseEvent):void
		{
			_isDown = false;
			_overPoint = new Point(e.target.stage.mouseX, e.target.stage.mouseY);
			//trace(_overPoint);
			checkPoint();
			e.target.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
		}
		
		/**
		 * 检查2点之间的距离
		 */
		private function checkPoint():void
		{
			if (Point.distance(_initPoint, _overPoint) > direction)
			{
				//trace("大于基准距离")
				switch(dirNum)
				{
					case DirNum4:
						dirNum4();
						break;
					case DirNum8:
						dirNum8();
						break;
				}
			}
			else
			{
				//trace("小于基准距离")
				this.dispatchEvent(new MouseBoardEvent(MouseBoardEvent.DIRECTION_CLICK,false,false,null,_mouseEvent));
			}
			
			//trace(Point.distance(_initPoint, _overPoint))
		}
		
		/**
		 * 4个方向判断
		 */
		private function dirNum4():void
		{
			var numX:Number = _overPoint.x - _initPoint.x;
			var numY:Number = _overPoint.y - _initPoint.y;
			var absX:Number = Math.abs(numX);
			var absY:Number = Math.abs(numY);
			
			if (numX > 0 && numY > 0)
			{
				if (absX > absY)
				{
					//trace("向右")
					this.dispatchEvent(new MouseBoardEvent(MouseBoardEvent.DIRECTION_RIGHT,false,false,null,_mouseEvent));
				}
				else
				{
					//trace("向下")
					this.dispatchEvent(new MouseBoardEvent(MouseBoardEvent.DIRECTION_DOWN,false,false,null,_mouseEvent));
				}
			}
			else if (numX < 0 && numY > 0)
			{
				if (absX > absY)
				{
					//trace("向左")
					this.dispatchEvent(new MouseBoardEvent(MouseBoardEvent.DIRECTION_LEFT,false,false,null,_mouseEvent));
				}
				else
				{
					//trace("向下")
					this.dispatchEvent(new MouseBoardEvent(MouseBoardEvent.DIRECTION_DOWN,false,false,null,_mouseEvent));
				}
			}
			else if (numX < 0 && numY < 0)
			{
				if (absX > absY)
				{
					//trace("向左")
					this.dispatchEvent(new MouseBoardEvent(MouseBoardEvent.DIRECTION_LEFT,false,false,null,_mouseEvent));
				}
				else
				{
					//trace("向上")
					this.dispatchEvent(new MouseBoardEvent(MouseBoardEvent.DIRECTION_TOP,false,false,null,_mouseEvent));
				}
			}
			else if (numX > 0 && numY < 0)
			{
				if (absX > absY)
				{
					//trace("向右")
					this.dispatchEvent(new MouseBoardEvent(MouseBoardEvent.DIRECTION_RIGHT,false,false,null,_mouseEvent));
				}
				else
				{
					//trace("向上")
					this.dispatchEvent(new MouseBoardEvent(MouseBoardEvent.DIRECTION_TOP,false,false,null,_mouseEvent));
				}
			}
		}
		
		/**
		 * 8个方向判断
		 */
		private function dirNum8():void
		{
			
		}
		
		public function get targetName():String
		{
			return _targetName;
		}
	}	
}