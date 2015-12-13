﻿package cc.hl.model.video.platform {
	
	import cc.hl.model.video.base.PartVideoInfo;
	import cc.hl.model.video.base.VideoInfo;
	import cc.hl.model.video.base.VideoType;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest
	import util.BlockLoader;
	import util.Util;
	

	public class YoukuVideoInfo extends VideoInfo {

		private const YOUKU_PLAYER:String = "http://vls.whonow.cn:8086/swf/yplugin.swf";

		//private const YOUKU_GETPLAYLIST:String = "http://v.youku.com/player/getPlayList/VideoIDS/";
		//private const YOUKU_GETFLVPATH:String = "http://k.youku.com/player/getFlvPath";
		private const YOUKU_GETPLAYLIST:String = "http://vls.whonow.cn:8086/vls/chat/getPlayList/VideoIDS/";
		private const YOUKU_GETFLVPATH:String = "http://vls.whonow.cn:8086/vls/chat/getFlvPath/";

		private const YOUKU_CLEAR_TYPE:Array = ["hd3","hd2","mp4","flv"];

		private var youkuLoader:Loader;
		private var youkuData:Object;
		private var youkuPlayer:Object;

		private var _bakUrls:Array;//备用urls，此处不用
		private var _bakTimes:Array;//备用times
		
		public var _index:int;

		public function YoukuVideoInfo(videoId:String, index:int = 0){
			this._bakUrls = [];
			this._bakTimes = [];
			super(videoId, VideoType.YOUKU);
			this._useSecond = true;
			this._index = index;
		}

		/**
		 * 载入youku插件
		**/
		override public function load():void{
			this.youkuLoader = new Loader();
			this.youkuLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onGetVideoInfo);
			this.youkuLoader.load(new URLRequest(this.YOUKU_PLAYER));
		}

		public function onGetVideoInfo(e:Event) : void{
			this.youkuPlayer = this.youkuLoader.contentLoaderInfo.applicationDomain.getDefinition("com.youku.utils.PlayListUtil");

			var loader:BlockLoader = null;
			loader = new BlockLoader(this.getYoukuPlayerListUrl(),"",3,10000);
			loader.addEventListener(Event.COMPLETE, function():void{
				var _loc5_:Array = null;
									
				youkuData = Util.decode(loader.data)["data"][0];
				if(youkuData == null){
					return;
				}

				var _loc1_:String = "flv";
				var _loc2_:String;

				/**
				 *此处按照hd3->hd2->mp4->flv的顺序选择
				**/

				for(_loc2_ in youkuData.stream_ids){
					if(YOUKU_CLEAR_TYPE.indexOf(_loc2_) < YOUKU_CLEAR_TYPE.indexOf(_loc1_)){
						_loc1_ = _loc2_;
					}
				}

				if(_loc1_ == "mp4"){
					_fileType = "mp4";
				}
				else{
					_fileType = "flv";
				}

				var info:Array = getInfoByType(_loc1_);
				_urlArray = info[0];
				_vtimems = info[1];

				var _loc4_:int = YOUKU_CLEAR_TYPE.indexOf(_loc1_);
				if(_loc4_ != YOUKU_CLEAR_TYPE.length - 1 ){
					_loc5_ = getInfoByType(YOUKU_CLEAR_TYPE[_loc4_ + 1]);
					_bakUrls = _loc5_[0];
					_bakTimes = _loc5_[1];
				}
				dispatchEvent(new Event(Event.COMPLETE));
			});
		}

		/**
		 * 重载VideoInfo的getPartVideoInfo函数，获取指定索引的partNetStream的videoInfo
		 * @param f	partNetStream在获取VideoInfo之后的回调函数
		 * @param index partNetStream的索引号
		 * @param startTime
		 * @return 用partNetStreasm的VideoInfo做参数，回调f
		**/

		//FIXME 
		//当只有一段码流时，开始定位会出现问题

		override public function getPartVideoInfo(f:Function, index:int, startTime:Number=0):void{
			var loader:BlockLoader = null;
			var url:String = null;


			var returnUrl:Function = function():void{
				if(startTime > 0){
					url = Util.addUrlParam(url, _startParamName, startTime);
				}

				var _loc1_:PartVideoInfo = new PartVideoInfo(index, url, _vtimems[index + 1] / 1000);
				f(_loc1_);				
			}

			if(index >= this._urlArray.length){
				//Util.jscall("console.log", "getPartVideoInfo参数错误!");
				Util.log(this, "getPartVideoInfo参数错误!");
				index = 0;
			}

			url = _urlArray[index];

			if(url.indexOf("&yxon=1&special=true") > 0){
				loader = new BlockLoader(url);
				loader.addEventListener(Event.COMPLETE,function():void{
					var res:Object = Util.decode(loader.data);
					url = res[0]["server"];
					_urlArray[index] = url;
					returnUrl();
				});

				loader.addEventListener("httploader_error",function():void{
					url.replace("&yxon=1&special=true","");
					returnUrl();
				});				
			}
			else{
				url.replace("&yxon=1&special=true","");
				returnUrl();
			}	

		}

		/**
		 * 以下函数用于解析youku实际视频源
		**/

		private function getInfoByType(param1:String) : Array {
			var _loc10_:String = null;
			var _loc11_:String = null;
			var _loc12_:String = null;
			var _loc13_:String = null;
			var _loc15_:String = null;
			var _loc16_:String = null;
			var _loc2_:String = "flv";
			if(param1 == "mp4"){
				_loc2_ = "mp4";
			}

			var _loc3_:String = this.youkuPlayer.getInstance().getSize(this.youkuData.ep);
			var _loc4_:Array = _loc3_.split("_");
			var _loc5_:String = _loc4_[0];
			var _loc6_:String = _loc4_[1];
			var _loc7_:String = this.getRealFileId(this.youkuData.streamfileids[param1],this.youkuData.seed);
			var _loc8_:Array = [];
			var _loc9_:Array = [Number(this.youkuData.seconds) * 1000];
			var _loc14_:* = 0;
			while(_loc14_ < this.youkuData.segs[param1].length)
			{
				_loc15_ = "http://k.youku.com/player/getFlvPath";
				_loc16_ = _loc14_.toString("16");
				if(_loc16_.length == 1)
				{
					_loc16_ = "0" + _loc16_;
				}
				_loc7_ = _loc7_.substring(0,8) + _loc16_.toUpperCase() + _loc7_.substring(10);
				_loc10_ = _loc5_ + "_" + _loc7_ + "_" + _loc6_ + "_0";
				_loc11_ = this.youkuPlayer.getInstance().changeSize(_loc10_);
				_loc12_ = _loc10_ + "_" + _loc11_.substr(0,4);
				_loc13_ = this.youkuPlayer.getInstance().setSize(_loc12_);
				_loc15_ = _loc15_ + ("/sid/" + _loc5_ + "_" + _loc16_.toLowerCase());
				_loc15_ = _loc15_ + ("/st/" + _loc2_);
				_loc15_ = _loc15_ + ("/fileid/" + _loc7_);
				_loc15_ = _loc15_ + ("?K=" + this.youkuData.segs[param1][_loc14_].k);
				_loc15_ = _loc15_ + "&ctype=10";
				_loc15_ = _loc15_ + "&ev=1";
				_loc15_ = _loc15_ + ("&token=" + _loc6_);
				_loc15_ = _loc15_ + ("&oip=" + this.youkuData.ip);
				_loc15_ = _loc15_ + ("&ep=" + _loc13_);
				_loc15_ = _loc15_ + "&yxon=1&special=true";
				_loc8_.push(_loc15_);
				_loc9_.push(Number(this.youkuData.segs[param1][_loc14_].seconds) * 1000);
				_loc14_++;
			}
			return [_loc8_,_loc9_];
		}

		protected function getYoukuPlayerListUrl() : String {
			var _loc1_:String = this.YOUKU_GETPLAYLIST + vid;
			var _loc2_:Date = new Date();
			var _loc3_:String = _loc2_.toString();
			var _loc4_:int = _loc3_.indexOf("GMT");
			var _loc5_:String = _loc3_.substr(_loc4_ + 3,3);
			_loc1_ = _loc1_ + ("/timezone/" + _loc5_);
			_loc1_ = _loc1_ + ("/version/" + "5");
			_loc1_ = _loc1_ + ("/source/" + "out");
			_loc1_ = _loc1_ + "?password=";
			_loc1_ = _loc1_ + "&ctype=10";
			_loc1_ = _loc1_ + ("&ran=" + int(Math.random() * 9999));
			_loc1_ = _loc1_ + ("&n=" + 3);
			_loc1_ = _loc1_ + ("&ev=" + 1);

			return _loc1_;
		}

		private function getMixedString(param1:int) : String {
			var _loc6_:* = 0;
			var _loc2_:* = "";
			var _loc3_:* = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/\\:._-1234567890";
			var _loc4_:int = _loc3_.length;
			var _loc5_:* = 0;
			while(_loc5_ < _loc4_)
			{
				param1 = (param1 * 211 + 30031) % 65536;
				_loc6_ = int(param1 * _loc3_.length / 65536);
				_loc2_ = _loc2_ + _loc3_.charAt(_loc6_);
				_loc3_ = _loc3_.substring(0,_loc6_) + _loc3_.substring(_loc6_ + 1);
				_loc5_++;
			}
			return _loc2_;
		}

		private function getRealFileId(param1:String, param2:int) : String {
			var _loc6_:String = null;
			var _loc3_:* = "";
			var _loc4_:String = this.getMixedString(param2);
			var _loc5_:Array = param1.split("*");
			for each(_loc6_ in _loc5_)
			{
				_loc3_ = _loc3_ + _loc4_.charAt(int(_loc6_));
			}
			return _loc3_.substr(0,_loc3_.length - 1);
		}		

	}
}