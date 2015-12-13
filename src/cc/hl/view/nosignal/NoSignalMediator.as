package cc.hl.view.nosignal 
{
	import cc.hl.Order;
	import cc.hl.view.controlBar.ControlBarMediator;
	import cc.hl.view.danmu.DanmuMediator;
	import cc.hl.view.video.VideoMediator;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import util.GlobalData;
	import util.Param;
	
	/**
	 * ...
	 * @author shl
	 */
	public class NoSignalMediator extends Mediator implements IMediator 
	{
		public static const NAME:String = "NoSignalMediator";
		
		public function NoSignalMediator(obj:Object=null) 
		{
			super(NAME, obj);
		}
		
		
		override public function listNotificationInterests():Array 
		{
			return [Order.On_Resize, Order.Nosignal_Show_Request,Order.Video_Stoped_Request];
		}
		
		override public function handleNotification(param1:INotification):void 
		{
			switch(param1.getName())
			{
				case Order.On_Resize:
					noSignalView.resize();
					break;
				case Order.Nosignal_Show_Request:
					showNosignal();
					break;
				case Order.Video_Stoped_Request:
					unRegister();
					noSignalView.hidePlayTime();
					showNosignal();
					break;
			}
		}
		
		private function unRegister():void
		{
			facade.removeMediator(VideoMediator.NAME);
			facade.removeMediator(ControlBarMediator.NAME);
		}
		
		private function showNosignal():void
		{
			if (noSignalView.parent == null)
			{
				GlobalData.STAGE.addChild(noSignalView);
			}
		}
		
		private function get noSignalView():NoSignalView
		{
			return viewComponent as NoSignalView
		}
	}

}