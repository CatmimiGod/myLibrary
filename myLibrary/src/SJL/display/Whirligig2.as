package SJL.display
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	 * ...2015/1/28 11:32
	 * @author ...CatmimiGod
	 */
	public class  Whirligig2 extends Sprite
	{
		/**需要旋转的影片剪辑数据*/
		private var _items:Vector.<MovieClip>;
		/**是否处于滑动状态*/
		private var _isDrag:Boolean = false;
		/**速度*/
		private var _speed:Number = 0;
		/**当前X*/
		private var _currentX:Number = 0;
		/**后来的X*/
		private var _lastX:Number = 0;
		/**是否处于自动播放状态*/
		private var _auto:Boolean = true;
		
		/**计时器*/
		private var _time:Timer;
		//x,y表示center坐标；width,height表示radius宽高
		private var _rect:Rectangle = new Rectangle(960, 450, 700, 200);
		
		/**是否为全局转动*/
		public var global:Boolean = false;
		/**自动旋转时的速度*/
		public var autoSpeed:Number = 0.01;
		/**延迟时间*/
		public var delay:Number = 2000;
		/**记录初始数组数据*/
		private var _items2:Vector.<MovieClip>;
		/**是否缩放*/
		private var _scale:Boolean = true;
		
		/**
		 * 旋转木马~
		 * @param	rect			一个Rectangle对象，xy用来表示圆心位置,width,height表示radius宽高
		 * @param	items			需要进入旋转木马的对象
		 */
		public function Whirligig2(rect:Rectangle , items:Vector.<MovieClip> , scale:Boolean = true):void
		{
			_rect = rect;
			_items = items;
			_scale = scale;
			
			_items2 = new Vector.<MovieClip>;
			for (var i:int; i < items.length; i++)
			{
				_items2.push(items[i]);
			}
			
			if (stage)
			{
				init();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE , init);
			}
		}
		
		/**
		 * 添加进舞台
		 * @param	e
		 */
		private function init(e:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			for (var i:int ; i < _items.length ; i++)
			{
				_items[i].angle = i * ((Math.PI * 2) / _items.length);
				this.addChild(_items[i]);
			}
			
			updateDisplay(0);
			
			if (global)
			{
				stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEventHandler);
			}
			else
			{
				this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEventHandler);
			}
			
			stage.addEventListener(Event.ENTER_FRAME, onLoop);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseEventHandler);
			
			_time = new Timer(delay);
			_time.addEventListener(TimerEvent.TIMER, onTimerHandler);
		}
		
		/**
		 * 舞台鼠标事件
		 * @param	e
		 */
		private function onMouseEventHandler(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					_currentX = mouseX;
					_time.reset();
					_isDrag = true;
					_auto = false;
					break;
				case MouseEvent.MOUSE_UP:
					_isDrag = false;
					break;
			}
		}
		
		/**计时器到时*/
		private function onTimerHandler(e:TimerEvent):void { _auto = true; }
		
		/**
		 * 帧循环
		 * @param	e
		 */
		private function onLoop(e:Event):void
		{
			updateDisplay(_speed);
			
			if (_auto)
			{
				_speed = autoSpeed;
			}
			else
			{
				if(_isDrag)
				{
					_lastX = _currentX;
					_currentX = mouseX;
					_speed = (_lastX - _currentX) * 0.002;
				}	
				_speed *= 0.90;
				if (Math.abs(_speed) < 0.003)
				{
					_speed = 0;
					if (!_time.running)
						_time.start();
				}
			}	
		}
		
		/**
		 * 更新数据
		 * @param	speed
		 */
		private function updateDisplay(speed:Number):void
		{
			//先更新属性值
			for(var i:int = 0; i < _items.length; i ++)
			{
				var mc:MovieClip = _items[i] as MovieClip;
				
				mc.x = Math.cos(mc.angle) * _rect.width + _rect.x;
				mc.y = Math.sin(mc.angle) * _rect.height + _rect.y;
				if (_scale)
				{
					mc.scaleX = mc.scaleY = mc.y / (_rect.y + _rect.height);
					if(mc.scaleX >= 0.7)
						mc.alpha = mc.scaleX;
					else
						mc.alpha = mc.scaleX * 0.4;
				}
				mc.angle += speed;	
			}
			
			//在排Z顺
			_items.sort(sort);
			for(i = 0; i < _items.length; i++) 
			{
				//setChildIndex(_items[i], i + 1);	//因为有个背景底
				setChildIndex(_items[i], i);
			}
		}
		
		/**
		 * 对比影片剪辑
		 * @param	mc1
		 * @param	mc2
		 * @return
		 */
		private function sort(mc1:MovieClip, mc2:MovieClip):int
		{
			//if(mc1.scaleX > mc2.scaleX)
			//{
				//return 1;
			//}
			//else if(mc1.scaleX < mc2.scaleX)
			//{
				//return -1;
			//}
			//else
			//{
				//return 0;
			//}
			if (mc1.y > mc2.y)
			{
				return 1;
			}
			else if (mc1.y < mc2.y)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * 最前面的mc
		 * @return
		 */
		public function get frontMC():MovieClip
		{
			//return _items[_items.length - 1];
			return this.getChildAt(this.numChildren - 1) as MovieClip;
		}
		
		/**
		 * 重置
		 */
		public function reset():void
		{
			for (var i:int ; i < _items2.length ; i++)
			{
				_items2[i].angle = i * ((Math.PI * 2) / _items2.length);
			}
		}
	}
	
}