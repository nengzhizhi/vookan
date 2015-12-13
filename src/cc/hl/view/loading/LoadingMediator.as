package cc.hl.view.loading 
{
	import cc.hl.Order;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import util.GlobalData;
	
	/**
	 * ...
	 * @author shl
	 */
	public class LoadingMediator extends Mediator implements IMediator 
	{
		public static const NAME:String = "loadingMediator";
		
		public function LoadingMediator(obj:Object=null) 
		{
			super(NAME, obj);
			
		}
		
		override public function listNotificationInterests():Array 
		{
			return [Order.On_Resize,
					Order.Loading_Show_request,
					Order.ControlBar_Update_Request];
		}
		
		override public function handleNotification(note:INotification):void 
		{
			switch(note.getName())
			{
				case Order.On_Resize:
					resize();
					break;
				case Order.Loading_Show_request:
					showLoading(note.getBody());
					break;
				case Order.ControlBar_Update_Request:
					if (String(note.getBody().isBuffering) == "true")
					{
						showLoading(true);
					}
					if (String(note.getBody().isBuffering) == "false")
					{
						showLoading(false);
					}
					break;
			}
		}
		
		private function showLoading(isshow:Boolean):void
		{
			if (loadingView.parent == null)
			{
				GlobalData.LOADING_LAYER.addChild(loadingView);
			}
			loadingView.showToggle(isshow);
			resize();
		}
		
		private function resize():void
		{
			loadingView.resize();
		}
		
		private function get loadingView():LoadingView
		{
			return viewComponent as LoadingView;
		}
	}

}