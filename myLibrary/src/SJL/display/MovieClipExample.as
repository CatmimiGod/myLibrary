package SJL.display
{
	import fl.video.VideoPlayer;
	import fl.video.VideoEvent;
	import flash.controller.KeyboardController;
	import flash.controller.NetworkClientController;
	import flash.controller.NetworkServerController;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	import SJL.single.MovieClipBaseSingle;
	
	/**
	 * ...2015/5/6 15:42
	 * @author ...CatmimiGod
	 */
	public class MovieClipExample extends MovieClip
	{
		/**配置文件*/
		protected var _config:XML;
		/**语言*/
		protected var _language:String;
		/**键盘*/
		private var _keyboard:KeyboardController;
		/**网络控制*/
		protected var _networkClient:NetworkClientController;
		protected var _networkServer:NetworkServerController;
		
		/**索引*/
		protected var _index:int = -1;
		protected var _subIndex:int = -1;
		protected var _sSubIndex:int = -1;
		/**loader对象*/
		protected var _loader:Loader;
		/**背景*/
		protected var _backGround:Bitmap;
		/**容器*/
		protected var _con:Sprite = new Sprite();
		/**路径*/
		protected var _url:String;
		/**video播放器*/
		protected var _video:VideoPlayer;
		/**视频播放状态*/
		protected var _videoPlaying:Boolean = false;
		
		/**背景视频*/
		protected var _backGroundVideo:VideoPlayer;
		/**背景视频播放*/
		protected var _backGroundVideoPlaying:Boolean = false;
		
		protected var _home:Boolean = false;
		protected var _back:Boolean = false;
		protected var _prev:Boolean = false;
		protected var _next:Boolean = false;
		
		public var DrawBackGround:Boolean = true;
		
		public function MovieClipExample():void
		{
			if (stage)
				init();
			else
				this.addEventListener(Event.ADDED_TO_STAGE , init);
		}
		
		/**
		 * 初始化
		 */
		protected function init(e:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE , init);
			MovieClipBaseSingle.getInstance().setParams(this);
			loadConfig();
		}
		
		/**
		 * 加载配置文件
		 * @param	url
		 */
		protected function loadConfig(url:String = "assets/config.xml"):void
		{
			var load:URLLoader = new URLLoader(new URLRequest(url));
			load.addEventListener(Event.COMPLETE , onCompleteLoadXML);
		}
		
		/**
		 * 加载完成配置文件
		 * @param	e
		 */
		protected function onCompleteLoadXML(e:Event):void
		{
			_config = XML(e.target.data);
			e.target.removeEventListener(Event.COMPLETE , onCompleteLoadXML);
			
			setStageDisplay();
			//setKeyboard();
			setNetwork();
			
			_backGround = new Bitmap(new BitmapData(this.stage.stageWidth, this.stage.stageHeight, true, 0));
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE , onCompleteLoadHandler);
			
			_video = new VideoPlayer(this.stage.stageWidth, this.stage.stageHeight);
			_video.smoothing = true;
			_video.addEventListener(VideoEvent.COMPLETE , onCompleteVideo);
			
			_backGroundVideo = new VideoPlayer(this.stage.stageWidth, this.stage.stageHeight);
			this.addChildAt(_backGroundVideo, 0);			
			_backGroundVideo.smoothing = true;
			_backGroundVideo.addEventListener(VideoEvent.COMPLETE , onCompleteVideo);
			MovieClipBaseSingle.getInstance().backGroundVideo = _backGroundVideo;
			
			this.addChildAt(_con, 0);
			this.addChildAt(_video, 0);

			//this.addChildAt(_backGround, 0);
			
			this.addEventListener(MouseEvent.CLICK , onClickHandler);
			
			_language = getDefaultLanguage();
			playIndex(getDefaultID());
		}
		
		/**
		 * 播放索引
		 * @param	index
		 */
		public function playIndex(...arg):void
		{
			var url:String;
			if (currentMC)
				currentMC.stop();
				
			_index = -1;
			_subIndex = -1;	
			_sSubIndex = -1;
			switch(arg.length)
			{
				case 1:
					_index = arg[0];
					url = getURL(_index);
					break;
				case 2:
					_index = arg[0];
					_subIndex = arg[1];
					url = getURL(_index,_subIndex);
					break;
				case 3:
					_index = arg[0];
					_subIndex = arg[1];
					_sSubIndex = arg[2];
					url = getURL(_index,_subIndex,_sSubIndex);
					break;
			}
			playURL(url);
		}
		
		/**
		 * 播放背景视频索引
		 * @param	...arg
		 */
		public function playBackGroundVideoIndex(...arg):void
		{
			var url:String;
			switch(arg.length)
			{
				case 1:
					url = getBackGroundVideoURL(arg[0]);
					break;
				case 2:
					url = getBackGroundVideoURL(arg[0],arg[1]);
					break;
				case 3:
					url = getBackGroundVideoURL(arg[0],arg[1],arg[2]);
					break;
			}
			playBackGroundVideo(url);
		}
		
		/**
		 * 播放索引
		 * @param	url
		 */
		public function playURL(url:String):void
		{
			_url = url;
			
			if(DrawBackGround)
				drawBackGround();
				
			if (url.indexOf(".swf") != -1 || url.indexOf(".jpg") != -1 || url.indexOf(".png") != -1)
			{
				_loader.load(new URLRequest(url));
			}
			else if (url.indexOf(".mp4") != -1 || url.indexOf(".flv") != -1)
			{
				_home = false;
				_back = false;
				clear();
				if (_video.source == url)
				{
					_video.seek(0);
					_video.play();
					_videoPlaying = true;
				}
				else
				{
					_video.play(url);
					_videoPlaying = true;
				}
			}
		}
		
		/**
		 * 播放背景视频(独立视频)
		 * @param	url
		 */
		public function playBackGroundVideo(url:String):void
		{
			if (_backGroundVideo.source == url)
			{
				_backGroundVideo.seek(0);
				_backGroundVideo.play();
				_backGroundVideoPlaying = true;
				_backGroundVideo.visible = true;
			}
			else
			{
				_backGroundVideo.play(url);
				_backGroundVideoPlaying = true;
				_backGroundVideo.visible = true;
			}
		}
		
		/**
		 * 完成加载
		 */
		protected function onCompleteLoadHandler(e:Event):void
		{
			clear();
			if (_url.indexOf(".jpg") != -1 || _url.indexOf(".png") != -1)
			{
				_home = false;
				_back = false;
				var bm:Bitmap = e.target.content as Bitmap;
				bm.smoothing = true;
				_con.addChild(bm);
			}
			else
			{
				var mc:MovieClip = e.target.content as MovieClip;
				//mc.play();
				if (_home)
				{
					if (mc.hasOwnProperty("homeHandler"))
					{
						mc.homeHandler();
					}
				}
				else if (_back)
				{
					if (mc.hasOwnProperty("backHandler"))
					{
						mc.backHandler();
					}
				}
				else if (_prev)
				{
					if (mc.hasOwnProperty("prevHandler"))
					{
						mc.prevHandler();
					}
				}
				else if (_next)
				{
					if (mc.hasOwnProperty("nextHandler"))
					{
						mc.nextHandler();
					}
				}
				else
				{
					if (mc.hasOwnProperty("addHandler"))
					{
						mc.addHandler();
					}
				}
				_home = false;
				_back = false;
				_prev = false;
				_next = false;
				_con.addChild(mc);
			}
		}
		
		/**
		 * 完成视频播放
		 * @param	e
		 */
		protected function onCompleteVideo(e:*):void
		{
			switch(e.target)
			{
				case _video:
					videoReplay();
					break;
				case _backGroundVideo:
					drawBackGround();
					_backGroundVideo.seek(0);
					_backGroundVideo.play();
					MovieClipBaseSingle.getInstance().dispatchEvent(new Event("backGroundVideoComplete"));
					break;
			}
		}
		
		/**
		 * 绘画背景
		 */
		protected function drawBackGround():void
		{
			_backGround.bitmapData.draw(this);
		}
		
		/**
		 * 清空当前的显示对象
		 */
		protected function clear():void
		{
			if(_con.numChildren > 0)
			{
				_con.removeChildren();
			}
			
			if (_video)
			{
				if (_videoPlaying)
				{
					_video.stop();
					_videoPlaying = false;
				}
				_video.clear();
			}
			
			if (_backGroundVideo)
			{
				if (_backGroundVideoPlaying)
				{
					_backGroundVideo.stop();
					_backGroundVideoPlaying = false;
				}
				_backGroundVideo.clear();
				_backGroundVideo.visible = false;
			}
		}
		
		/**
		 * 视频重新播放
		 */
		protected function videoReplay():void
		{
			drawBackGround();
			_video.seek(0);
			_video.play();
		}
		
		/**
		 * 播放暂停
		 */
		public function playStop():void
		{
			if (_url.indexOf(".swf") != -1)
			{
				var mc:MovieClip = _con.getChildAt(0) as MovieClip;
				if (mc.hasOwnProperty("playStop"))
				{
					mc.playStop();
				}
				else
				{
					mc.isPlaying ? mc.stop() : mc.play();
				}
			}
			else if (_url.indexOf(".mp4") != -1 || _url.indexOf(".flv") != -1)
			{
				_videoPlaying ? _video.stop() : _video.play();
				_videoPlaying = !_videoPlaying;
			}
			
			//if (_backGroundVideo)
			//{
				//_backGroundVideoPlaying ? _backGroundVideo.pause() : _backGroundVideo.play();
				//_backGroundVideoPlaying = !_backGroundVideoPlaying;
			//}
		}
		
		/**
		 * 上一页
		 */
		public function prev():void
		{
			_prev = true;
			
			if (_sSubIndex >= 0)
			{
				/**到开头*/
				if (_sSubIndex == 0)
				{
					
				}
				else
				{
					playIndex(_index, _subIndex, _sSubIndex - 1);
				}
			}
			else if (_subIndex >= 0)
			{
				/**到开头*/
				if (_subIndex == 0)
				{
					
				}
				else
				{
					playIndex(_index, _subIndex - 1);
				}
			}
			else if (_index >= 0)
			{
				/**到开头*/
				if (_index == 0)
				{
					
				}
				else
				{
					playIndex(_index - 1);
				}
			}
		}
		
		/**
		 * 下一页
		 */
		public function next():void
		{
			_next = true;
			
			if (_sSubIndex >= 0)
			{
				/**到末尾*/
				if (_sSubIndex == getURLLength(_index,_subIndex,_sSubIndex) - 1)
				{
					
				}
				else
				{
					playIndex(_index, _subIndex, _sSubIndex + 1);
				}
			}
			else if (_subIndex >= 0)
			{
				/**到末尾*/
				if (_subIndex == getURLLength(_index,_subIndex) - 1)
				{
					
				}
				else
				{
					playIndex(_index, _subIndex + 1);
				}
			}
			else if (_index >= 0)
			{
				/**到末尾*/
				if (_index == getURLLength(_index) - 1)
				{
					
				}
				else
				{
					playIndex(_index + 1);
				}
			}
		}
		
		/**
		 * 上一页，所有XML里面的id都会触发
		 */
		public function prevAll():void
		{
			_prev = true;
			
			if (_sSubIndex >= 0)
			{
				/**到开头*/
				if (_sSubIndex == 0)
				{
					
				}
				else
				{
					playIndex(_index, _subIndex, _sSubIndex - 1);
				}
			}
			else if (_subIndex >= 0)
			{
				/**到开头*/
				if (_subIndex == 0)
				{
					playIndex(_index);
				}
				else
				{
					if (getURLLength(_index,_subIndex - 1, 0 ) != 0)
					{
						playIndex(_index, _subIndex, getURLLength(_index, _subIndex -1, 0) - 1);
					}
					else
					{
						playIndex(_index, _subIndex - 1);
					}
				}
			}
			else if (_index >= 0)
			{
				/**到开头*/
				if (_index == 0)
				{
					
				}
				else
				{
					if (getURLLength(_index - 1, 0) != 0)
					{
						playIndex(_index - 1, getURLLength(_index - 1, 0) - 1);
					}
					else
					{
						playIndex(_index - 1);
					}
				}
			}
		}
		
		/**
		 * 下一页，所有XML里面的id都会触发
		 */
		public function nextAll():void
		{
			_next = true;
			if (_sSubIndex >= 0)
			{
				/**到末尾*/
				if (_sSubIndex == getURLLength(_index,_subIndex,_sSubIndex) - 1)
				{
					
				}
				else
				{
					playIndex(_index, _subIndex, _sSubIndex + 1);
				}
			}
			else if (_subIndex >= 0)
			{
				/**到末尾*/
				if (_subIndex == getURLLength(_index,_subIndex) - 1)
				{
					if (_index == getURLLength(_index) - 1)
					{
						
					}
					else
					{
						/**整体层级向前+1*/
						playIndex(_index + 1);
					}
				}
				else
				{
					if (getURLLength(_index, _subIndex, 0 != 0))
					{
						playIndex(_index, _subIndex,0);
					}
					else
					{
						playIndex(_index, _subIndex + 1);
					}
				}
			}
			else if (_index >= 0)
			{
				/**到末尾*/
				if (_index == getURLLength(_index) - 1)
				{
					if (getURLLength(_index, 0) != 0)
					{
						playIndex(_index, 0);
					}
				}
				else
				{
					if (getURLLength(_index, 0) != 0)
					{
						playIndex(_index, 0);
					}
					else
					{
						playIndex(_index + 1);
					}
				}
			}
		}
		
		/**
		 * 上一页面
		 */
		public function prevPage():void
		{
			if(currentMC.hasOwnProperty("prevPage"))
				currentMC.prevPage();
		}
		
		/**
		 * 下一页面
		 */
		public function nextPage():void
		{
			if(currentMC.hasOwnProperty("nextPage"))
				currentMC.nextPage();
		}
		
		/**
		 * 返回
		 */
		public function back():void
		{
			_home = false;
			_back = true;
			
			if (_sSubIndex >= 0)
			{
				playIndex(_index, _subIndex);
			}
			else if (_subIndex >= 0)
			{
				playIndex(_index);
			}
			else
			{
				if(_index != getHomeID())
					playIndex(getHomeID());
			}
		}
		
		/**
		 * 主页
		 */
		public function home():void
		{
			_home = true;
			_back = false;
			
			if(_index != getHomeID() || _subIndex != -1 || _sSubIndex != -1)
				playIndex(getHomeID());
		}
		
		/*****************************************鼠标交互*********************************************/
		
		/**
		 * 鼠标交互
		 * @param	e
		 */
		protected function onClickHandler(e:MouseEvent):void
		{
			var btnName:String = e.target.name;
			var mc:MovieClip;
			var arr:Array;
			var param:Object;
			//trace(btnName)
			switch(btnName)
			{
				case "btn_playStop":
					playStop();
					break;
				case "btn_home":
					home();
					break;
				case "btn_prev":
					prev();
					break;
				case "btn_next":
					next();
					break;
				case "btn_prevAll":
					prevAll();
					break;
				case "btn_nextAll":
					nextAll();
					break;
				case "btn_nextPage":
					nextPage();
					break;
				case "btn_prevPage":
					prevPage()
					break;
				case "btn_back":
					mc = _con.getChildAt(0) as MovieClip;
					if (mc.hasOwnProperty("back"))
					{
						if (mc.currentFrame == 1)
							back();
							
						mc.back();
					}
					else
					{
						back();
					}
					break;
				case "btn_switch":
					mc = e.target.parent as MovieClip;
					mc.currentFrame == mc.totalFrames ? mc.gotoAndStop(1) : mc.nextFrame();
					break;
				case "btn_language":
					changeLanguage();
					break;
				default:
					arr = btnName.split("_");
					if (btnName.indexOf("playIndex_") == 0)
					{
						switch(arr.length)
						{
							case 2:
								playIndex(arr[1]);
								break;
							case 3:
								playIndex(arr[1],arr[2]);
								break;
						}
					}
					else if(btnName.indexOf("frame_stop_") == 0)
					{
						mc = e.target.parent as MovieClip;
						//mc.gotoAndStop(mc.currentFrame + 1);
						param = btnName.replace("frame_stop_", "");
						mc.gotoAndStop(param);
					}
					else if(btnName.indexOf("frame_play_") == 0)
					{
						mc = e.target.parent as MovieClip;
						//mc.gotoAndStop(mc.currentFrame + 1);
						param = btnName.replace("frame_play_", "");
						mc.gotoAndPlay(param);
					}
					else if(btnName.indexOf("pframe_stop_") == 0)
					{
						mc = e.target.parent.parent as MovieClip;
						//mc.gotoAndStop(mc.currentFrame + 1);
						param = btnName.replace("pframe_stop_", "");
						mc.gotoAndStop(param);
					}
					else if(btnName.indexOf("pframe_play_") == 0)
					{
						mc = e.target.parent.parent as MovieClip;
						//mc.gotoAndStop(mc.currentFrame + 1);
						param = btnName.replace("pframe_play_", "");
						mc.gotoAndPlay(param);
					}
					else if(btnName.indexOf("ppframe_stop_") == 0)
					{
						mc = e.target.parent.parent.parent as MovieClip;
						//mc.gotoAndStop(mc.currentFrame + 1);
						param = btnName.replace("ppframe_stop_", "");
						mc.gotoAndStop(param);
					}
					else if(btnName.indexOf("ppframe_play_") == 0)
					{
						mc = e.target.parent.parent.parent as MovieClip;
						//mc.gotoAndStop(mc.currentFrame + 1);
						param = btnName.replace("ppframe_play_", "");
						mc.gotoAndPlay(param);
					}
					break;
			}
		}
		
		/*****************************************改变语言*********************************************/
		
		/**
		 * 改变语言
		 * @param	str
		 */
		public function changeLanguage(str:String = null):void
		{
			var language:String = str;
			if (language != null)
				language = str.toLowerCase();
			if (language == "cn" || language == "en")
			{
				_language = language;
			}
			else
			{
				_language = _language == "cn" ? "en" : "cn";
			}
			playIndex(_index,_subIndex);
		}
		
		
		/*****************************************解析XML配置文件*********************************************/
		
		/**
		 * 根据索引获取路径
		 * @param	...arg
		 * @return
		 */
		protected function getURL(...arg):String
		{
			var str:String = null;
			switch(arg.length)
			{
				case 1:
					str = _config.content.(@language == _language).param.(@id == int(arg[0])).@url;
					break;
				case 2:
					if (int(arg[1] == -1))
						str = _config.content.(@language == _language).param.(@id == int(arg[0])).@url;
					else
						str = _config.content.(@language == _language).param.(@id == int(arg[0])).subParam.(@id == int(arg[1])).@url;
					break;
				case 3:
					if (int(arg[2] == -1))
						str = _config.content.(@language == _language).param.(@id == int(arg[0])).subParam.(@id == int(arg[1])).@url;
					else
						str = _config.content.(@language == _language).param.(@id == int(arg[0])).subParam.(@id == int(arg[1])).sSubParam.(@id == int(arg[2])).@url;
					break;
			}
			return str;
		}
		
		/**
		 * 根据索引获取路径
		 * @param	...arg
		 * @return
		 */
		protected function getBackGroundVideoURL(...arg):String
		{
			var str:String = null;
			switch(arg.length)
			{
				case 1:
					str = _config.content.(@language == _language).backGroundVideo.(@id == int(arg[0])).@url;
					break;
				case 2:
					if (int(arg[1] == -1))
						str = _config.content.(@language == _language).backGroundVideo.(@id == int(arg[0])).@url;
					else
						str = _config.content.(@language == _language).backGroundVideo.(@id == int(arg[0])).subBackGroundVideo.(@id == int(arg[1])).@url;
					break;
				case 3:
					if (int(arg[2] == -1))
						str = _config.content.(@language == _language).backGroundVideo.(@id == int(arg[0])).subBackGroundVideo.(@id == int(arg[1])).@url;
					else
						str = _config.content.(@language == _language).backGroundVideo.(@id == int(arg[0])).subBackGroundVideo.(@id == int(arg[1])).subBackGroundVideo.(@id == int(arg[2])).@url;
					break;
			}
			return str;
		}
		
		/**
		 * 根据索引获取长度
		 * @param	...arg
		 * @return
		 */
		protected function getURLLength(...arg):int
		{
			var index:int;
			switch(arg.length)
			{
				case 1:
					index = _config.content.(@language == _language).param.length();
					break;
				case 2:
					if (int(arg[1] == -1))
						index = _config.content.(@language == _language).param.length();
					else
						index = _config.content.(@language == _language).param.(@id == int(arg[0])).subParam.length();
					break;
				case 3:
					if (int(arg[2] == -1))
						index = _config.content.(@language == _language).param.(@id == int(arg[0])).subParam.length();
					else
						index = _config.content.(@language == _language).param.(@id == int(arg[1])).subParam.(@id == int(arg[2])).sSubParam.length();
					break;
			}
			return index;
		}
		
		/**
		 * 获取默认语言
		 * @return
		 */
		protected function getDefaultLanguage():String
		{
			var str:String = _config.defaultLanguage;
			str = str.toLowerCase();
			if (str == "cn")
			{
				return "cn";
			}
			else
			{
				return "en";
			}
		}
		
		/**
		 * 设置舞台属性
		 */
		protected function setStageDisplay():void
		{
			if (_config.hasOwnProperty("x"))
			{
				this.stage.nativeWindow.x = Number(_config.x);
			}
			
			if (_config.hasOwnProperty("y"))
			{
				this.stage.nativeWindow.y = Number(_config.y);
			}
			
			if (_config.hasOwnProperty("stage"))
			{
				for each(var node:XML in _config.stage.children())
				{
					var prop:String = node.localName();
					stage[prop] = _config.stage[prop];
				}
			}
		}
		
		/**
		 *获取默认播放值
		 */
		protected function getDefaultID():int
		{
			var id:int = 0;
			if (_config.hasOwnProperty("content"))
			{
				id = int(_config.content.(@language == _language).@default);
			}
			return id;
		}
		
		/**
		 *获取默认主页值
		 */
		protected function getHomeID():int
		{
			var id:int = 0;
			if (_config.hasOwnProperty("content"))
			{
				id = int(_config.content.(@language == _language).@home);
			}
			return id;
		}
		
		/**
		 * 设置键盘
		 */
		protected function setKeyboard():void
		{
			_keyboard = new KeyboardController(this);
			var len:int = _config.keyboard.keycode.length();
			//trace(_config.keyboard.@enable == "true")
			if (len == 0 || _config.keyboard.@enable != "true")
				return;
				
			for (var i:int; i < len; i ++)
			{
				var way:String = _config.keyboard.keycode[i].@way;
				var args:String = _config.keyboard.keycode[i].@args;
				if (args == null || args == "")
				{
					switch(way.toLowerCase())
					{
						case "down":
							_keyboard.addKeyItem(_config.keyboard.keycode[i].@id , String(_config.keyboard.keycode[i].@funName),null,KeyboardEvent.KEY_DOWN);
							break;
						case "up":
							_keyboard.addKeyItem(_config.keyboard.keycode[i].@id , String(_config.keyboard.keycode[i].@funName),null,KeyboardEvent.KEY_DOWN);
							break;
					}
				}
				else
				{
					switch(way.toLowerCase())
					{
						case "down":
							_keyboard.addKeyItem(_config.keyboard.keycode[i].@id , String(_config.keyboard.keycode[i].@funName), _config.keyboard.keycode[i].@args,KeyboardEvent.KEY_DOWN);
							break;s
						case "up":
							_keyboard.addKeyItem(_config.keyboard.keycode[i].@id , String(_config.keyboard.keycode[i].@funName), _config.keyboard.keycode[i].@args,KeyboardEvent.KEY_DOWN);
							break;
					}
				}
			}
		}
		
		/**
		 * 设置socket连接
		 */
		protected function setNetwork():void
		{
			if (_config.networkServer.@enabled == "true")
			{
				trace("NetworkServerController ::: " ,_config.networkClient.address, _config.networkClient.port)
				_networkServer = new NetworkServerController(this, _config.networkServer.port);
			}
			
			if (_config.networkClient.@enabled == "true")
			{
				trace("networkClient ::: " ,_config.networkClient.address, _config.networkClient.port)
				_networkClient = new NetworkClientController(this, _config.networkClient.address, _config.networkClient.port);
			}
		}
		
		/**
		 * 获取当前mc
		 */
		protected function get currentMC():MovieClip
		{
			if(_con.numChildren > 0)
				return _con.getChildAt(0) as MovieClip;
			else
				return new MovieClip;
		}
	}
	
}