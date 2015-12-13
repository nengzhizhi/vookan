﻿package cc.hl.model.video.platform {
	import cc.hl.model.video.base.VideoInfo;
	import cc.hl.model.video.base.VideoType;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class DouyuVideoInfo extends VideoInfo {

		private var _loadTimer:Timer;

		public function DouyuVideoInfo(vid:String, index:int){
			super(vid, VideoType.DOUYU, index);
		}

		override public function load():void{
			this._fileType = "live";
			this._urlArray = []; 
			this._urlArray[0] = this._vid;

			this._loadTimer = new Timer(10);
			this._loadTimer.addEventListener(TimerEvent.TIMER, function(){
				dispatchEvent(new Event(Event.COMPLETE));
			});
			this._loadTimer.start();
		}
	}
}