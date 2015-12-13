package cc.hl.view.video
{
	import cc.hl.model.video.VideoManager;
	import cc.hl.Order;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import util.FlashCookie;
	import util.GlobalData;
	
	public class VideoMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "VideoMediator";
		
		public function VideoMediator(obj:Object)
		{
			super(NAME, obj);
		}
		
		override public function listNotificationInterests():Array
		{
			return [cc.hl.Order.Video_Show_Request, cc.hl.Order.Video_Play_Request, cc.hl.Order.Video_Pause_Request, cc.hl.Order.Video_Seek_Request, cc.hl.Order.Video_Volume_Request, cc.hl.Order.On_Resize, Order.Video_Reload_Request];
		}
		
		override public function handleNotification(notify:INotification):void
		{
			switch (notify.getName())
			{
				case cc.hl.Order.Video_Show_Request: 
					this.onStartVideo(notify.getBody());
					break;
				case cc.hl.Order.Video_Play_Request: 
					VideoManager.instance.playing = true;
					break;
				case cc.hl.Order.Video_Pause_Request: 
					VideoManager.instance.playing = false;
					break;
				case cc.hl.Order.Video_Seek_Request: 
					this.onSeekTime(notify.getBody());
					break;
				case cc.hl.Order.Video_Volume_Request: 
					GlobalData.currentVolume = notify.getBody().volume;
					VideoManager.instance.currentVideo.volume = GlobalData.currentVolume;
					break;
				case Order.Video_Reload_Request:
					reload();
					break;
				case cc.hl.Order.On_Resize: 
					this.onResize(notify.getBody());
					break;
			}
		}
		
		protected function onStartVideo(obj:Object):void
		{
			if (this.videoView.parent == null)
			{
				util.GlobalData.VIDEO_LAYER.addChild(this.videoView);
			}
			var index:int = obj.videoIndex;
			this.videoView.showVideo(index);
		}
		
		protected function onSeekTime(obj:Object):void
		{
			var seekTime:Number = obj.seekTime;
			this.videoView.seekTime(seekTime);
		}
		
		protected function reload():void
		{
			VideoManager.instance.reLoad();
		}
		
		protected function onResize(obj:Object):void
		{
			VideoManager.instance.currentVideo.resize(util.GlobalData.root.stage.stageWidth, util.GlobalData.root.stage.stageHeight);
		}
		
		override public function onRemove():void 
		{
			super.onRemove();
			if (this.videoView.parent != null)
			{
				util.GlobalData.VIDEO_LAYER.removeChild(this.videoView);
			}
			VideoManager.instance.dispose();
		}
		
		protected function get videoView():VideoView
		{
			return viewComponent as VideoView;
		}
	}
}