package cc.hl.model.video
{
	import cc.hl.model.video.base.VideoInfo;
	import cc.hl.model.video.event.VideoProviderEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import util.Util;
	
	public class LiveVideoProvider extends VideoProvider
	{
		public static const NS_READY:String = "live_ns_ready";
		public static const MAX_COUNT:int = 600;
		//public static const MAX_COUNT:int = 60;
		private var _nc:NetConnection;
		private var _ns:NetStream;
		private var _meta:Object;
		private var _buffering:Boolean;
		public var _index:int;
		private var _play:String;
		private var _playUrl:String;
		private var checkTimer:Timer;
		private var count:int;
		
		public function LiveVideoProvider(url:String, index:int)
		{
			super(null);
			_playUrl = url;
			_index = index;
			checkTimer = new Timer(100);
			checkTimer.addEventListener(TimerEvent.TIMER, onCheckTimer);
			init();
		}
		
		private function init():void
		{
			count = 0;
			
			var playUrl:String = _playUrl;
			Util.log(this, playUrl);
			var index:int = 0;
			var rtmp:String = null;
			var play:String = null;
			
			this.close();
			
			//尝试video硬件加速,并初始化video
			index = playUrl.lastIndexOf("/");
			rtmp = playUrl.substring(0, index);
			play = playUrl.substring((index + 1));
			_play = play;
			
			this._nc = new NetConnection();
			this._nc.client = {};
			this._nc.addEventListener(NetStatusEvent.NET_STATUS, function(event:NetStatusEvent):void
				{
					Util.log(this, event.info.code);
					switch (event.info.code)
					{
						case "NetConnection.Connect.Success": 
							_ns = new NetStream(_nc);
							_ns.client = {onMetaData: onMetaData};
							_ns.bufferTime = 0;
							_ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
							if (_video != null)
							{
								_video.attachNetStream(_ns);
							}
							else
							{
								_stageVideo.attachNetStream(_ns);
							}
							dispatchEvent(new Event(NS_READY));
							break;
						case "NetConnection.Call.Failed": 
						case "NetConnection.Connect.Failed": 
						case "NetConnection.Connect.Rejected": 
							dispatchEvent(new VideoProviderEvent(VideoProviderEvent.VIDEEO_ERROE));
							break;
					}
				});
			try
			{
				this._nc.connect(rtmp);
			}
			catch (ex:*)
			{
				Util.log(this, ex);
				dispatchEvent(new VideoProviderEvent(VideoProviderEvent.VIDEEO_ERROE));
			}
		}
		
		protected function onNetStatus(event:NetStatusEvent):void
		{
			Util.log(this, event.info.code);
			switch (event.info.code)
			{
				case "NetStream.Play.Start": 
					onNsReady(null);
					checkTimer.start();
					break;
				case "NetStream.Buffer.Full": 
					this._buffering = false;
					break;
				case "NetStream.Buffer.Empty": 
					this._buffering = true;
					break;
				case "NetStream.Play.Stop": 
					dispatchEvent(new VideoProviderEvent(VideoProviderEvent.VIDEO_STOP));
					this.close();
					Util.log(this, "直播被断开");
					break;
				case "NetStream.Buffer.Flush": 
					dispatchEvent(new VideoProviderEvent(VideoProviderEvent.VIDEO_STOP));
					checkTimer.stop();
					break;
				case "NetStream.Play.StreamNotFound": 
					dispatchEvent(new VideoProviderEvent(VideoProviderEvent.VIDEEO_ERROE));
					this.close();
					Util.log(this, "直播流未找到");
					break;
			}
		}
		
		//根据视频fps来判断视频是不是在播放
		private function onCheckTimer(e:TimerEvent):void
		{
			if (ns.currentFPS == 0 && _playing)
			{
				count++;
				if (count > MAX_COUNT)
				{
					//在一段时间fps一直是0时,发送视频错误
					dispatchEvent(new VideoProviderEvent(VideoProviderEvent.VIDEEO_ERROE));
					close();
				}
				_buffering = true;
			}
			else
			{
				count = 0;
				_buffering = false;
			}
		}
		
		override protected function get ns():NetStream
		{
			return this._ns;
		}
		
		override public function start(startTime:Number = 0):void
		{
			this._playing = true;
			isPlaying = true;
			ns.play(_play);
		}
		
		override public function stop():void
		{
			isPlaying = false;
			ns.close();
			checkTimer.stop();
		}
		
		override public function get buffPercent():Number
		{
			return this.ns.bufferLength / this.ns.bufferTime;
		}
		
		override public function get streamTime():Number
		{
			return 0;
		}
		
		override public function get buffering():Boolean
		{
			return this._buffering;
		}
		
		override public function getVideoInfo():String
		{
			var info:String = "";
			return info;
		}
		
		override public function get time():Number
		{
			if (this.ns != null)
			{
				return this.ns.time;
			}
			else
			{
				return 0;
			}
		}
		
		override public function set time(t:Number):void
		{
		}
		
		override public function get videoLength():Number
		{
			return 0;
		}
		
		protected function onMetaData(obj:Object):void
		{
			this._meta = obj;
		}
		
		override public function set playing(arg1:Boolean):void
		{
			if (_ns != null)
			{
				if (arg1 != this._playing)
				{
					this._playing = arg1;
					
					this._ns.togglePause();
				}
			}
		}
		
		protected function close():void
		{
			if (this._ns)
			{
				this._ns.close();
			}
			
			if (this._nc)
			{
				this._nc.close();
			}
			checkTimer.stop();
		}
		
		override public function reload():void
		{
			this.init();
		}
		
		public function dispose():void
		{
			this.close();
			_ns = null;
			_nc = null;
		}
	}

}