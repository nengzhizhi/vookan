package cc.hl.view.controlBar
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import shl.ui.Resource;
	import shl.ui.ShlButton;
	import shl.ui.ShlImage;
	import shl.ui.TextFactory;
	import ui.Controlbg;
	import ui.VolumeBar;
	import util.GlobalData;
	
	/**
	 * ...
	 * @author shl
	 */
	public class ControlBar extends Sprite 
	{
		private var bg:Controlbg;
		public var playBtn:ShlButton;
		public var pauseBtn:ShlButton;
		public var reloadBtn:ShlButton;
		public var fullScreenBtn:ShlButton;
		public var normalScreenBtn:ShlButton;
		public var danmuShowBtn:ShlButton;
		public var danmuHideBtn:ShlButton;
		public var volumeHigh:ShlButton;
		public var volumeMute:ShlButton;
		public var volumeBar:VolumeBar;
		
				
		public function ControlBar() 
		{
			bg = new Controlbg();
			
			playBtn = ShlButton.buttonFromImage(ShlImage.imageFromClass(Resource.play_normal), ShlImage.imageFromClass(Resource.play_hover), ShlImage.imageFromClass(Resource.play_click));
			pauseBtn = ShlButton.buttonFromImage(ShlImage.imageFromClass(Resource.pause_normal), ShlImage.imageFromClass(Resource.pause_hover), ShlImage.imageFromClass(Resource.pause_click));
			reloadBtn = ShlButton.buttonFromImage(ShlImage.imageFromClass(Resource.reload_normal), ShlImage.imageFromClass(Resource.reload_hover), ShlImage.imageFromClass(Resource.reload_click));
			fullScreenBtn = ShlButton.buttonFromImage(ShlImage.imageFromClass(Resource.fullscreen_normal), ShlImage.imageFromClass(Resource.fullscreen_hover), ShlImage.imageFromClass(Resource.fullscreen_click));
			normalScreenBtn = ShlButton.buttonFromImage(ShlImage.imageFromClass(Resource.normalscreen_normal), ShlImage.imageFromClass(Resource.normalscreen_hover), ShlImage.imageFromClass(Resource.normalscreen_click));
			danmuShowBtn = ShlButton.buttonFromImage(ShlImage.imageFromClass(Resource.danmushow_normal), ShlImage.imageFromClass(Resource.danmushow_hover), ShlImage.imageFromClass(Resource.danmushow_click));
			danmuHideBtn = ShlButton.buttonFromImage(ShlImage.imageFromClass(Resource.danmuhide_normal), ShlImage.imageFromClass(Resource.danmuhide_hover), ShlImage.imageFromClass(Resource.danmuhide_click));
			volumeHigh = ShlButton.buttonFromImage(ShlImage.imageFromClass(Resource.volume_high_normal), ShlImage.imageFromClass(Resource.volume_high_hover), ShlImage.imageFromClass(Resource.volume_high_click));
			volumeMute = ShlButton.buttonFromImage(ShlImage.imageFromClass(Resource.volume_mute_normal), ShlImage.imageFromClass(Resource.volume_mute_hover), ShlImage.imageFromClass(Resource.volume_mute_click));
			volumeBar = new VolumeBar();
			
			playBtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			playBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			pauseBtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			pauseBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			volumeHigh.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			volumeHigh.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			volumeMute.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			volumeMute.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			reloadBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			reloadBtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			danmuHideBtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			danmuHideBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			danmuShowBtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			danmuShowBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			fullScreenBtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			fullScreenBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			normalScreenBtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			normalScreenBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			playBtn.y = pauseBtn.y = reloadBtn.y = fullScreenBtn.y = normalScreenBtn.y = danmuHideBtn.y = danmuShowBtn.y = volumeHigh.y = volumeMute.y = 8;
			volumeBar.y = 18;
			playBtn.x = pauseBtn.x = 17;
			reloadBtn.x = 58;
			
			addChild(bg);
			addChild(playBtn);
			addChild(pauseBtn);
			addChild(reloadBtn);
			addChild(fullScreenBtn);
			addChild(normalScreenBtn);
			addChild(danmuHideBtn);
			addChild(danmuShowBtn);
			addChild(volumeHigh);
			addChild(volumeMute);
			addChild(volumeBar);
			
			playBtn.visible = false;
			danmuHideBtn.visible = false;
			normalScreenBtn.visible = false;
			volumeMute.visible = false;
			
			//keep fullscreen display right state
			GlobalData.STAGE.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
		}
		
		private function onFullScreen(e:FullScreenEvent):void 
		{
			setIsFullscreen(e.fullScreen);
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case playBtn:
					TipOfControlbar.getInstance().showTip("播放");
					break;
				case pauseBtn:
					TipOfControlbar.getInstance().showTip("暂停");
					break;
				case volumeMute:
				case volumeHigh:
					TipOfControlbar.getInstance().showTip("音量");
					break;
				case reloadBtn:
					TipOfControlbar.getInstance().showTip("刷新");
					break;
				case danmuHideBtn:
					TipOfControlbar.getInstance().showTip("弹幕 关");
					break;
				case danmuShowBtn:
					TipOfControlbar.getInstance().showTip("弹幕 开");
					break;
				case fullScreenBtn:
					TipOfControlbar.getInstance().showTip("全屏");
					break;
				case normalScreenBtn:
					TipOfControlbar.getInstance().showTip("退出全屏");
					break;
			}
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			TipOfControlbar.getInstance().hideTip();
		}
		
		public function resize(ww:int, hh:int):void
		{
			bg.width = ww;
			fullScreenBtn.x = normalScreenBtn.x = ww - 40;
			danmuHideBtn.x  =  danmuShowBtn.x = ww - 80;
			volumeBar.x = ww - 182;
			volumeHigh.x = volumeMute.x = ww - 212;
		}
		
		public function setMute(isMute:Boolean):void
		{
			if (isMute)
			{
				volumeHigh.visible = false;
				volumeMute.visible = true;
			}
			else
			{
				volumeHigh.visible = true;
				volumeMute.visible = false;
			}
		}
		
		public function setDanmuOn(isOn:Boolean):void
		{
			if (isOn)
			{
				danmuHideBtn.visible = true;
				danmuShowBtn.visible = false;
			}
			else
			{
				danmuHideBtn.visible = false;
				danmuShowBtn.visible = true;
			}
		}
		
		public function setPlaying(isPlaying:Boolean):void
		{
			if (isPlaying)
			{
				playBtn.visible = false;
				pauseBtn.visible = true;
			}
			else
			{
				playBtn.visible = true;
				pauseBtn.visible = false;
			}
			
		}
		
		public function setIsFullscreen(isFullscreen:Boolean):void
		{
			if (isFullscreen)
			{
				fullScreenBtn.visible = false;
				normalScreenBtn.visible = true;
			}
			else
			{
				fullScreenBtn.visible = true;
				normalScreenBtn.visible = false;
			}
		}
	}

}