package cc.hl.view.controlBar
{
	import cc.hl.model.net.ClientProxy;
	import cc.hl.Order;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import util.GlobalData;
	import util.SkinEvent;
	import util.Util;
	
	
	public class ControlBarMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ControlBarMediator";
		
		public function ControlBarMediator(obj:Object)
		{
			super(NAME, obj);
		}
		
		override public function listNotificationInterests():Array
		{
			return [cc.hl.Order.ControlBar_Show_Request, cc.hl.Order.On_Resize];
		}
		
		override public function handleNotification(notify:INotification):void
		{
			switch (notify.getName())
			{
				case cc.hl.Order.ControlBar_Show_Request: 
					this.onControlBarShow(notify.getBody());
					break;
				case cc.hl.Order.On_Resize: 
					this.onResize(notify.getBody());
					break;
			}
		}
		
		private function addListener():void
		{
			if (!this.controlBarView.hasEventListener("CONTROL_BAR_PLAY"))
			{
				this.controlBarView.addEventListener("CONTROL_BAR_PLAY", this.onPlay);
				this.controlBarView.addEventListener("CONTROL_BAR_PAUSE", this.onPause);
				this.controlBarView.addEventListener("CONTROL_BAR_RELOAD", this.onReload);
				this.controlBarView.addEventListener("CONTROL_BAR_FULLSCREEN", this.onFullScreen);
				this.controlBarView.addEventListener("CONTROL_BAR_NORMALSCREEN", this.onNormalScreen);
				this.controlBarView.addEventListener("CONTROL_BAR_SHOW_DANMU", this.onShowDanmu);
				this.controlBarView.addEventListener("CONTROL_BAR_HIDE_DANMU", this.onHideDanmu);
				this.controlBarView.addEventListener("CONTROL_BAR_VOLUME", this.onVolume);
				this.controlBarView.addEventListener(SkinEvent.SKIN_DANMU_SEND, onSendDanmu);
			}
		}
		
		private function onSendDanmu(e:SkinEvent):void
		{
			var client = ClientProxy.instance;
			client.doSendMessage(e.data);
		}
		
		protected function onControlBarShow(obj:Object):void
		{
			if (this.controlBarView.parent == null)
			{
				GlobalData.CONTROL_BAR_LAYER.addChild(this.controlBarView);
				this.addListener();
			}
			this.controlBarView.resize(GlobalData.root.stage.stageWidth, GlobalData.root.stage.stageHeight);
		}
		
		protected function onResize(obj:Object):void
		{
			if (this.controlBarView.parent != null)
			{
				this.controlBarView.resize(obj.w, obj.h);
			}
		}
		
		private function onPlay(event:Event):void
		{
			sendNotification(cc.hl.Order.Video_Play_Request, null);
		}
		
		private function onPause(event:Event):void
		{
			sendNotification(cc.hl.Order.Video_Pause_Request, null);
		}
		
		private function onReload(event:Event):void
		{
			sendNotification(Order.Video_Reload_Request);
			sendNotification(Order.Crap_Hide_Request);
		}
		
		private function onFullScreen(event:Event):void
		{
			try 
			{
				GlobalData.root.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
			catch (ex:*)
			{
				Util.log(this, ex);
			}
			if (GlobalData.playerNeedUpdate)
			{
				sendNotification(Order.Warning_Show_Request, GlobalData.NEED_UPDATE_TIP);
			}
		}
		
		private function onNormalScreen(event:Event):void
		{
			GlobalData.root.stage.displayState = StageDisplayState.NORMAL;
		}
		
		private function onShowDanmu(event:Event):void
		{
			sendNotification(cc.hl.Order.Danmu_Show_Request, null);
		}
		
		private function onHideDanmu(event:Event):void
		{
			sendNotification(cc.hl.Order.Danmu_Hide_Request, null);
		}
		
		private function onVolume(event:SkinEvent):void
		{
			sendNotification(cc.hl.Order.Video_Volume_Request, {"volume": event.data});
		}
		
		override public function onRemove():void 
		{
			super.onRemove();
			if (this.controlBarView.parent != null)
			{
				GlobalData.CONTROL_BAR_LAYER.removeChild(this.controlBarView);
			}
			controlBarView.dispose();
		}
		
		public function get controlBarView():ControlBarView
		{
			return viewComponent as ControlBarView;
		}
	}
}