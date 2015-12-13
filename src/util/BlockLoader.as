﻿package util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	
	public class BlockLoader extends EventDispatcher
	{
		
		public static const HTTPLOADER_ERROR:String = "httploader_error";
		
		private var _url:String;
		private var _urlloader:URLLoader;
		private var _request:URLRequest;
		private var _dataFormat:String;
		private var _trytimes:int;
		private var _timeout:int;
		private var _timer:Timer;
		private var _event:Event;
		private var _loadonce:Boolean = false;
		private var _testFunc:Function;
		private var _random:Boolean;
		private var _log:Array;
		
		public function BlockLoader(url:String = "", dataFormat:String = "", tryTimes:uint = 3, timeOut:uint = 20000, testFucn:Function = null, random:Boolean = true)
		{
			this._dataFormat = dataFormat;
			this._trytimes = tryTimes;
			this._timeout = timeOut;
			this._url = url;
			this._testFunc = testFucn;
			this._random = random;
			this._log = [];
			if (url.length > 0)
			{
				this._request = new URLRequest(url);
				this.sendRequest();
			}
			;
		}
		
		public function get data():*
		{
			if (this._urlloader)
			{
				return (this._urlloader.data);
			}
			;
			return (null);
		}
		
		public function load(urlRequest:URLRequest):void
		{
			this._request = urlRequest;
			this.sendRequest();
		}
		
		public function get trytimes():int
		{
			return (this._trytimes);
		}
		
		public function get log():String
		{
			return (this._log.join("\n"));
		}
		
		private function sendRequest():void
		{
			this._urlloader = new URLLoader(this._request);
			if (this._dataFormat.length > 0)
			{
				this._urlloader.dataFormat = this._dataFormat;
			}
			this._urlloader.addEventListener(ProgressEvent.PROGRESS, this.progress);
			this._urlloader.addEventListener(Event.COMPLETE, this.complete);
			this._urlloader.addEventListener(IOErrorEvent.IO_ERROR, this.ioerror);
			this._urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityerror);
			this._timer = new Timer(this._timeout, 1);
			this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTimeout);
			this._timer.start();
			this._loadonce = true;
		}
		
		public function unload():void
		{
			try
			{
				this._urlloader.removeEventListener(Event.COMPLETE, this.complete);
				this._urlloader.removeEventListener(IOErrorEvent.IO_ERROR, this.ioerror);
				this._urlloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityerror);
				this._urlloader.close();
			}
			catch (e:Error)
			{
			}
			;
			this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onTimeout);
			this._timer.reset();
		}
		
		private function progress(_arg1:ProgressEvent):void
		{
			this._timer.reset();
			this._timer.start();
		}
		
		private function onTimeout(_arg1:TimerEvent):void
		{
			var _local2:String = (("[BlockLoader]  读取 " + this._request.url) + " 时发生超时错误");
			this._log.push(_local2);
			Util.log(this, _local2);
			this.reload();
		}
		
		private function securityerror(_arg1:SecurityErrorEvent):void
		{
			this._event = _arg1;
			var _local2:String = (("[BlockLoader]  读取 " + this._request.url) + " 时发生安全策略错误");
			this._log.push(_local2);
			Util.log(this, _local2);
			this.reload();
		}
		
		private function ioerror(_arg1:IOErrorEvent):void
		{
			this._event = _arg1;
			var _local2:String = (("[BlockLoader]  读取 " + this._request.url) + " 时发生IO错误");
			this._log.push(_local2);
			Util.log(this, _local2);
			this.reload();
		}
		
		private function complete(_arg1:Event):void
		{
			if (((!((this._testFunc == null))) && (!(this._testFunc(this._urlloader.data)))))
			{
				this.reload();
			}
			else
			{
				this._timer.reset();
				dispatchEvent(_arg1);
			}
			;
		}
		
		private function reload():void
		{
			var msg:* = null;
			this._trytimes--;
			this._timer.reset();
			if (this._trytimes > 0)
			{
				try
				{
					this._urlloader.close();
				}
				catch (e:Error)
				{
				}
				;
				setTimeout(function():void
					{
						if (_urlloader)
						{
							if (((_loadonce) && (_random)))
							{
								_request.url = Util.addUrlParam(_url, "acran", Math.random());
							}
							;
							_urlloader.load(_request);
							_timer.start();
						}
						;
					}, 1000);
			}
			else
			{
				msg = (("[BlockLoader]  读取或解析" + this._request.url) + "失败");
				this._log.push(msg);
				Log.log(msg);
				this.dispathError();
			}
			;
		}
		
		private function dispathError():void
		{
			this.unload();
			dispatchEvent(new Event(HTTPLOADER_ERROR));
			if (((this._event) && (this.hasEventListener(this._event.type))))
			{
				dispatchEvent(this._event);
			}
			;
		}
	
	}
} 
