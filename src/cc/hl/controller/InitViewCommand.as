package cc.hl.controller 
{
	import cc.hl.model.video.VideoManager;
	import cc.hl.Order;
	import cc.hl.view.controlBar.ControlBarMediator;
	import cc.hl.view.controlBar.ControlBarView;
	import cc.hl.view.danmu.DanmuMediator;
	import cc.hl.view.danmu.DanmuView;
	import cc.hl.view.loading.LoadingMediator;
	import cc.hl.view.loading.LoadingView;
	import cc.hl.view.video.VideoMediator;
	import cc.hl.view.video.VideoView;
	import cc.hl.view.warning.WarningMediator;
	import cc.hl.view.warning.WarningView;
	import flash.display.Sprite;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import util.GlobalData;
	import util.Param;
	import util.Util;
	
	/**
	 * ...
	 * @author shl
	 */
	public class InitViewCommand extends SimpleCommand implements ICommand 
	{
		
		public function InitViewCommand() 
		{
			super();
		}
		
		override public function execute(param1:INotification):void 
		{
			//向舞台上添加各层,并排列深度
			var mainLayer:Main = param1.getBody() as Main;
			var videoLayer:Sprite = new Sprite();
			var controlBarLayer:Sprite = new Sprite();
			var danmuLayer:Sprite = new Sprite();
			var loadingLayer:Sprite = new Sprite();
			var warningLayer:Sprite = new Sprite();
			
			GlobalData.VIDEO_LAYER = videoLayer;
			GlobalData.CONTROL_BAR_LAYER = controlBarLayer;
			GlobalData.DANMU_LAYER = danmuLayer;
			GlobalData.LOADING_LAYER = loadingLayer;
			GlobalData.WARNINF_LAYER = warningLayer;
			
			mainLayer.addChild(videoLayer);
			mainLayer.addChild(controlBarLayer);
			mainLayer.addChild(danmuLayer);
			mainLayer.addChild(loadingLayer);
			mainLayer.addChild(warningLayer);
			
			//注册mediators
			facade.registerMediator(new LoadingMediator(new LoadingView()));
			facade.registerMediator(new VideoMediator(new VideoView()));
			facade.registerMediator(new ControlBarMediator(new ControlBarView()));
			facade.registerMediator(new DanmuMediator(new DanmuView()));
			facade.registerMediator(new WarningMediator(new WarningView()));
			
			//发送启动消息
			//sendNotification(Order.Video_Start_Request, {"vid":"XODg5NDU5MzA0", "type":"youku", "startTime":0});
			sendNotification(cc.hl.Order.ControlBar_Show_Request, null);
			sendNotification(cc.hl.Order.Danmu_Init_Request, null);
			
			//初始化视频
			var videos = [{
				stream_flv: 'rtmp://vlive3.rtmp.cdn.ucloud.com.cn/ucloud/test'
			}]
			VideoManager.instance.init(videos);
		}
	}

}