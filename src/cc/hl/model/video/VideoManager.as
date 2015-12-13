package cc.hl.model.video
{
	
	import cc.hl.model.video.base.VideoInfo;
	import cc.hl.model.video.event.VideoProviderEvent;
	import cc.hl.Order;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import util.GlobalData;
	import util.Util;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class VideoManager
	{
		private var _videoProviders:Array;
		private var _videoInfos:Array;
		public var _videoCount:int = 0;
		private var _currentVideoIndex:int = 0;
		private var _playing:Boolean = true;
		private var sendTimer:Timer;
		
		public function VideoManager():void
		{
		}
		
		public function init(o:Object):void
		{
			this._videoProviders = [];
			this._videoInfos = [];
			this._videoCount = o.length;
			sendTimer = new Timer(500);
			sendTimer.addEventListener(TimerEvent.TIMER, sendLoop);
			
			var i:int = 0;
			while (i < o.length)
			{
				_videoProviders[i] = new LiveVideoProvider(o[i].stream_flv, i);
				(_videoProviders[i] as LiveVideoProvider).addEventListener(VideoProviderEvent.VIDEO_STOP, onStop);
				(_videoProviders[i] as LiveVideoProvider).addEventListener(VideoProviderEvent.VIDEEO_ERROE, onError);
				//给第一个视频流添加侦听,ready以后开始播放
				if (i == 0)
				{
					(_videoProviders[i] as LiveVideoProvider).addEventListener(LiveVideoProvider.NS_READY, onVideoReady);
				}
				i++;
			}
		}
		
		private function onVideoReady(e:Event):void
		{
			(e.target as LiveVideoProvider).removeEventListener(LiveVideoProvider.NS_READY, onVideoReady);
			sendTimer.start();
			sendNotification(cc.hl.Order.Video_Show_Request, {"videoIndex": (e.target as LiveVideoProvider)._index});
		}
		
		private function onError(e:VideoProviderEvent):void
		{
			//如果当前播放的视频发生错误,直接停止
			var liveVideo:LiveVideoProvider = e.target as LiveVideoProvider;
			if (liveVideo._index == currentVideoInx)
			{
				sendNotification(Order.Video_Error_Request);
				sendNotification(Order.Loading_Show_request, false);
				sendTimer.stop();
			}
		}
		
		private function onStop(e:VideoProviderEvent):void
		{
			//视频播放完毕,显示无节目
			var liveVideo:LiveVideoProvider = e.target as LiveVideoProvider;
			if (liveVideo._index == currentVideoInx)
			{
				sendTimer.stop();
				sendNotification(Order.Video_Stoped_Request);
				sendNotification(Order.Loading_Show_request, false);
				sendTimer.stop();
			}
		}
		
		private function sendLoop(te:TimerEvent = null):void
		{
			var playedSecond:Number = this.currentVideo.time;
			sendNotification(cc.hl.Order.ControlBar_Update_Request, {"playedSeconds": playedSecond + 0.5, "isBuffering": (currentVideo as LiveVideoProvider).buffering.toString()});
			GlobalData.playedSecond = playedSecond + 0.5;
			if ((currentVideo as LiveVideoProvider).buffering)
			{
				currentVideo.volume = 0;
			}
			else
			{
				currentVideo.volume = GlobalData.currentVolume;
			}
		}
		
		private static var _instance:VideoManager = null;
		
		public static function get instance():VideoManager
		{
			if (_instance == null)
			{
				_instance = new VideoManager();
			}
			return _instance;
		}
		
		public function get time():Number
		{
			return this.currentVideo.time;
		}
		
		public function set currentVideoInx(inx:int):void
		{
			this._currentVideoIndex = inx;
		}
		
		public function get currentVideoInx():int
		{
			return this._currentVideoIndex;
		}
		
		public function get playing():Boolean
		{
			return (this._playing);
		}
		
		public function get currentVideo():VideoProvider
		{
			return _videoProviders[_currentVideoIndex];
		}
		
		public function set playing(arg:Boolean):void
		{
			if (arg != this._playing)
			{
				this._playing = arg;
				currentVideo.playing = _playing;
			}
		}
		
		public function video(index:int):VideoProvider
		{
			if (index < 0 || index >= _videoCount)
			{
				return null;
			}
			else
			{
				return this._videoProviders[index];
			}
		}
		
		public function reLoad():void
		{
			currentVideo.reload();
			playing = true;
			if (sendTimer != null)
			{
				sendTimer.start();
			}
			(_videoProviders[currentVideoInx] as LiveVideoProvider).addEventListener(LiveVideoProvider.NS_READY, onVideoReady);
		}
		
		public static function sendNotification(message:String, obj:Object = null):void
		{
			var facade:IFacade = Facade.getInstance();
			facade.sendNotification(message, obj);
		}
		
		public function dispose():void
		{
			var i:int = 0;
			while (i < _videoProviders.length)
			{
				(_videoProviders[i] as LiveVideoProvider).dispose();
				i++;
			}
		}
	}
}