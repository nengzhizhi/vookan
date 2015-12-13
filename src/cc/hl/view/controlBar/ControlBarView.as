package cc.hl.view.controlBar
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import util.FlashCookie;
	import util.GlobalData;
	import util.SkinEvent;
	import util.Util;
	
	public class ControlBarView extends Sprite
	{
		
		private var _controlBar:ControlBar;
		private var _volume:Number;
		private var _volumeBak:Number;
		private var danmuBar:DanmuBar;
		private var hideTimer:Timer;
		
		public static const CONTROL_BAR_HEIGHT:int = 40;
		public static const VOLUME_BAR_MAX:Number = 82;
		public static const HIDE_BAR_TIME:int = 5000;
		
		public function ControlBarView()
		{
			super();
			this._controlBar = new ControlBar();
			
			this._controlBar.playBtn.addEventListener(MouseEvent.CLICK, this.onPlayBtnClicked);
			this._controlBar.volumeHigh.addEventListener(MouseEvent.CLICK, this.onVolumeBtnClicked);
			this._controlBar.volumeMute.addEventListener(MouseEvent.CLICK, this.onVolumeBtnClicked);
			this._controlBar.pauseBtn.addEventListener(MouseEvent.CLICK, this.onPauseBtnClicked);
			this._controlBar.reloadBtn.addEventListener(MouseEvent.CLICK, this.onReloadBtnClicked);
			this._controlBar.fullScreenBtn.addEventListener(MouseEvent.CLICK, this.onFullScreen);
			this._controlBar.normalScreenBtn.addEventListener(MouseEvent.CLICK, this.onNormalScreen);
			this._controlBar.danmuShowBtn.addEventListener(MouseEvent.CLICK, this.onDanmuShow);
			this._controlBar.danmuHideBtn.addEventListener(MouseEvent.CLICK, this.onDanmuHide);
			
			danmuBar = new DanmuBar();
			danmuBar.addEventListener(SkinEvent.SKIN_DANMU_SEND, onSendDanmu);
			_controlBar.addChild(danmuBar);
			
			this.startVolumeBar();
			addChild(this._controlBar);
			addChild(TipOfControlbar.getInstance());
			addEventListener(Event.ADDED_TO_STAGE, this.onAddToStage);
			
			hideTimer = new Timer(HIDE_BAR_TIME);
			hideTimer.addEventListener(TimerEvent.TIMER, onHideTimer);
		}
		
		private function onAddToStage(event:Event):void
		{
			//setTimeout(function():void
				//{
					stage.addEventListener(MouseEvent.MOUSE_MOVE, controlBarAnimate);
					stage.addEventListener(Event.MOUSE_LEAVE, controlBarAnimate);
					controlBarAnimate(null);
				//}, 5000);
		}
		
		public static const CONTROL_BAR_THRESHOLD:int = 100;
		private var _animateState:String = "showing";
		private var _controlBarAnimate:TweenLite;
		
		private function controlBarAnimate(event:Event = null):void
		{
			if (stage == null)
			{
				return;
			}
			
			if ((event) && (event.type == MouseEvent.MOUSE_MOVE) && stage.stageHeight - stage.mouseY < CONTROL_BAR_THRESHOLD && !util.GlobalData.isTimeLineShow)
			{
				hideTimer.reset();
				if (this._animateState != "showing")
				{
					this._animateState = "showing";
					if (this._controlBarAnimate)
					{
						this._controlBarAnimate.kill();
					}
					this._controlBarAnimate = TweenLite.to(this, 0.5, {"y": stage.stageHeight - CONTROL_BAR_HEIGHT, "alpha": 1, "ease": Linear.easeOut});
				}
			}
			else if (this._animateState != "hiding")
			{
				if (!hideTimer.running)
				{
					hideTimer.reset();
					hideTimer.start();
				}
			}
		}
		
		private function onHideTimer(e:TimerEvent):void
		{
			hideTimer.stop();
			this._animateState = "hiding";
			if (this._controlBarAnimate)
			{
				this._controlBarAnimate.kill();
			}
			this._controlBarAnimate = TweenLite.to(this, 0.5, {"y": stage.stageHeight, "alpha": 0, "ease": Linear.easeOut});
		}
		
		public function resize(w:Number, h:Number):void
		{
			_controlBar.resize(w, h);
			if (GlobalData.STAGE.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
			{
				danmuBar.visible = true;
				danmuBar.x = GlobalData.STAGE.stageWidth - danmuBar.width - 250;
				danmuBar.y = 10;
			}
			else
			{
				danmuBar.visible = false;
			}
			this.y = util.GlobalData.root.stage.stageHeight - CONTROL_BAR_HEIGHT;
		}
		
		private function startVolumeBar():void
		{
			this._volume = 1;
			this._volumeBak = 1;
			var startVolumeDrag:Function = null;
			var endVolumeDrag:Function = null;
			var volumeDrag:Function = null;
			var isDragingVolume:Boolean = false;
			
			startVolumeDrag = function(param1:MouseEvent):void
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE, volumeDrag);
				stage.addEventListener(MouseEvent.MOUSE_UP, endVolumeDrag);
				isDragingVolume = true;
			};
			endVolumeDrag = function(param1:MouseEvent):void
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, volumeDrag);
				stage.removeEventListener(MouseEvent.MOUSE_UP, endVolumeDrag);
				//每次设置完音量储存到cookie里面
				FlashCookie.addKey("volume", GlobalData.currentVolume);
				Util.log(this, "在controlbarview把音量储存到了cookie里");
				isDragingVolume = false;
				TipOfControlbar.getInstance().hideTip();
			};
			volumeDrag = function(param1:MouseEvent):void
			{
				var _loc2_:Number = _controlBar.volumeBar.mouseX;
				if (_loc2_ < 0)
				{
					_loc2_ = 0;
				}
				if (_loc2_ > VOLUME_BAR_MAX)
				{
					_loc2_ = VOLUME_BAR_MAX;
				}
				volume = _loc2_ / VOLUME_BAR_MAX;
				if (isDragingVolume)
					TipOfControlbar.getInstance().showTip(int(_loc2_ / VOLUME_BAR_MAX * 100) + "%");
				if (param1.type == MouseEvent.CLICK)
				{
					//每次设置完音量储存到cookie里面
					Util.log(this, "在controlbarview把音量储存到了cookie里");
					FlashCookie.addKey("volume", GlobalData.currentVolume);
				}
			};
			
			this._controlBar.volumeBar.tg.x = VOLUME_BAR_MAX * GlobalData.currentVolume;
			this._controlBar.volumeBar.slider.width = VOLUME_BAR_MAX * GlobalData.currentVolume;
			this._controlBar.volumeBar.tg.addEventListener(MouseEvent.MOUSE_DOWN, startVolumeDrag);
			this._controlBar.volumeBar.addEventListener(MouseEvent.CLICK, volumeDrag);
			if (GlobalData.currentVolume == 0)
			{
				onVolumeBtnClicked();
			}
		}
		
		protected function onPlayBtnClicked(event:MouseEvent):void
		{
			_controlBar.setPlaying(true);
			dispatchEvent(new Event("CONTROL_BAR_PLAY"));
		}
		
		protected function onPauseBtnClicked(event:MouseEvent):void
		{
			_controlBar.setPlaying(false);
			dispatchEvent(new Event("CONTROL_BAR_PAUSE"));
		}
		
		protected function onReloadBtnClicked(event:MouseEvent):void
		{
			_controlBar.setPlaying(true);
			dispatchEvent(new Event("CONTROL_BAR_RELOAD"));
		}
		
		protected function onFullScreen(event:MouseEvent):void
		{
			//_controlBar.setIsFullscreen(false);
			dispatchEvent(new Event("CONTROL_BAR_FULLSCREEN"));
		}
		
		protected function onNormalScreen(event:MouseEvent):void
		{
			//_controlBar.setIsFullscreen(true);
			dispatchEvent(new Event("CONTROL_BAR_NORMALSCREEN"));
		}
		
		protected function onVolumeBtnClicked(param1:MouseEvent = null):void
		{
			if (this._volume == 0)
			{
				this.volume = this._volumeBak;
				_controlBar.setMute(false);
				dispatchEvent(new SkinEvent("CONTROL_BAR_VOLUME", this._volumeBak));
			}
			else
			{
				this._volumeBak = this.volume;
				this.volume = 0;
				_controlBar.setMute(true);
				dispatchEvent(new SkinEvent("CONTROL_BAR_VOLUME", 0));
			}
			//每次设置完音量储存到cookie里面
			Util.log(this, "在controlbarview把音量储存到了cookie里");
			FlashCookie.addKey("volume", GlobalData.currentVolume);
		}
		
		protected function onDanmuShow(event:MouseEvent):void
		{
			_controlBar.setDanmuOn(true);
			dispatchEvent(new Event("CONTROL_BAR_HIDE_DANMU"));
		}
		
		protected function onDanmuHide(event:MouseEvent):void
		{
			_controlBar.setDanmuOn(false);
			dispatchEvent(new Event("CONTROL_BAR_SHOW_DANMU"));
		}
		
		private function onSendDanmu(e:SkinEvent):void
		{
			var event:SkinEvent = new SkinEvent(SkinEvent.SKIN_DANMU_SEND);
			event.data = e.data;
			dispatchEvent(event);
		}
		
		public function get controlBar():ControlBar
		{
			return this._controlBar;
		}
		
		public function get volume():Number
		{
			return this._volume;
		}
		
		public function set volume(param1:Number):void
		{
			var _loc2_:* = NaN;
			if (param1 != this._volume)
			{
				if (param1 != this._volume)
				{
					if (param1 < 0)
					{
						param1 = 0;
					}
					if (param1 > 1)
					{
						param1 = 1;
					}
					this._volume = param1;
					_loc2_ = param1 * VOLUME_BAR_MAX;
					this._controlBar.volumeBar.tg.x = _loc2_;
					this._controlBar.volumeBar.slider.width = _loc2_;
					
					if (this._volume == 0)
					{
						_controlBar.setMute(true);
					}
					else
					{
						_controlBar.setMute(false);
					}
					
					dispatchEvent(new SkinEvent("CONTROL_BAR_VOLUME", param1));
				}
			}
		}
	
		public function dispose():void
		{
			hideTimer.stop();
		}
	}
}