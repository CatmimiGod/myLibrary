package SJL.utils
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * 	当状态改变时发生。
	 */ 
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 *	MovieClip选项按钮组件，针对CheckBoxGroupInteractive类的单选优化
	 * 
	 *	@author Huangmin
	 *	@date	2013-11-1
	 */
	public class RadioButtonGroupInteractive extends EventDispatcher
	{
		private var _spr:Sprite;
		private var _params:Object;
		private var _selectedIndex:int = -1;
		
		/**
		 *	组名称
		 */
		public var name:String = null;
		
		/**
		 * 是否是开关，可复位状态
		 */
		public var toggle:Boolean = false;
		
		/**
		 * 	Constructor.
		 * @param spr:Sprite 	显示对象
		 * @param params:Object 此对象必需具有两个属性，一个是子对象类型type:MovieClip, 另一个是indexOf:"mc_aa_number" {type:MovieClip, indexOf:"btn_"} 
		 * @param selectedIndex
		 */		
		public function RadioButtonGroupInteractive(spr:Sprite, params:Object, selectedIndex:int = -1)
		{
			if(spr == null || params == null)
				throw new ArgumentError("RadioButtonGroupInteractive.RadioButtonGroupInteractive().参数不能为空.");
		
			_spr = spr;
			_params = params;
			_selectedIndex = selectedIndex;
			
			if(_selectedIndex != -1)
				setFocusIndex(_selectedIndex);
			
			_spr.addEventListener(MouseEvent.CLICK, onMouseClickHandler);
		}
		
		/**
		 *	Mouse Click Event Handler. 
		 * @param e:MovieClip
		 */		
		private function onMouseClickHandler(e:MouseEvent):void
		{
			if(e.target is _params.type && e.target.name.indexOf(_params.indexOf) != -1 && e.target.parent == e.currentTarget)
			{
				var tn:String = e.target.name;
				var index:int = int(tn.replace(_params.indexOf, ""));
				
				if(_params.type == MovieClip)
					setFocusIndex(index);
			}
		}
		
		/**
		 *	Set MovieClip Display Status 
		 * 	@param index:int
		 */		
		protected function setFocusIndex(index:int):void
		{
			var len:int = _spr.numChildren;
			
			for(var i:int = 0; i < len; i ++)
			{
				if(_spr.getChildAt(i) is MovieClip && _spr.getChildAt(i).name.indexOf(_params.indexOf) != -1)
				{
					var mc:MovieClip = _spr.getChildAt(i) as MovieClip;
					var mcIndex:int = int(mc.name.replace(_params.indexOf, ""));
					
					/*if(mcIndex == index)
					{
						(mc.currentFrame == 2 && toggle) ? mc.gotoAndStop(1) : mc.gotoAndStop(2);
					}
					else
					{
						 mc.gotoAndStop(1);
					}*/
					
					mcIndex == index ? mc.currentFrame == 2 && toggle ? mc.gotoAndStop(1) : mc.gotoAndStop(2) : mc.gotoAndStop(1);
				}
			}
			
			
			//记录索引是否变更
			var isDispatch:Boolean = _selectedIndex != index ? true : false;
			//更新索引
			_selectedIndex = _selectedIndex == index && toggle ? -1 : index;
			
			//比较索引值与原值
			if(isDispatch || _selectedIndex != index)
				this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 *	获取或设置选择索引。<br />
		 */
		public function get selectedIndex():int	{	return _selectedIndex;	}
		public function set selectedIndex(value:int):void
		{	
			if(value != _selectedIndex)
			{
				if(_params.type == MovieClip)
					setFocusIndex(value);
			}
		}
		
		
	}
}

