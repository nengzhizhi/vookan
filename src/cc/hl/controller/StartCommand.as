package cc.hl.controller
{
	import cc.hl.model.net.ClientProxy;
	import cc.hl.model.video.VideoManager;
	import cc.hl.Order;
	import cc.hl.view.controlBar.ControlBarMediator;
	import cc.hl.view.controlBar.ControlBarView;
	import cc.hl.view.crap.CrapMediator;
	import cc.hl.view.crap.CrapView;
	import cc.hl.view.danmu.DanmuMediator;
	import cc.hl.view.danmu.DanmuView;
	import cc.hl.view.nosignal.NoSignalMediator;
	import cc.hl.view.nosignal.NoSignalView;
	import cc.hl.view.video.VideoMediator;
	import cc.hl.view.video.VideoView;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Capabilities;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import util.BlockLoader;
	import util.FlashCookie;
	import util.GlobalData;
	import util.Param;
	import util.Util;
	
	public class StartCommand extends SimpleCommand implements ICommand
	{
		public function StartCommand()
		{
			super();
		}
		
		override public function execute(param1:INotification):void
		{
			regsiterPreview();

			//没有在直播,直接显示没有节目,返回
			if (Param.status == "false")
			{
				Util.log(this, "播放状态为false");
				sendNotification(Order.Nosignal_Show_Request);
				return;
			}
			
			//var clientProxy:ClientProxy = new ClientProxy();
			//facade.registerProxy(clientProxy);
			var clientProxy = ClientProxy.instance;

			checkFlashPlayerVersion();	
		}
		
		
		//一启动就要注册的view
		private function regsiterPreview():void
		{
			facade.registerMediator(new NoSignalMediator(new NoSignalView()));
			facade.registerMediator(new CrapMediator(new CrapView()));
			facade.registerMediator(new DanmuMediator(new DanmuView()));
		}
		
		private function checkFlashPlayerVersion():void
		{
			var version:String = Capabilities.version;
			Util.log(this, version);
			var tempArray:Array = version.split(" ");
			var tempArray2:Array = String(tempArray[1]).split(",");
			var first:String = tempArray2[0];
			var second:String = tempArray2[1];
			if (int(first) > 11)
			{
				return;
			}
			else if (int(first) == 11)
			{
				if (int(second) < 3)
				{
					GlobalData.playerNeedUpdate = true;
				}
			}
			else
			{
				GlobalData.playerNeedUpdate = true;
			}
		}
	}
}