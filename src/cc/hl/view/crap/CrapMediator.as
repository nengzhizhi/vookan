package cc.hl.view.crap 
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
	public class CrapMediator extends Mediator implements IMediator 
	{
		public static const NAME:String = "crapMediator";
		
		public function CrapMediator(obj:Object=null) 
		{
			super(NAME, obj);
			
		}
		
		override public function listNotificationInterests():Array 
		{
			return [Order.On_Resize,
					Order.Crap_Show_Request,
					Order.Video_Error_Request,
					Order.Crap_Hide_Request];
		}
		
		override public function handleNotification(note:INotification):void 
		{
			switch(note.getName())
			{
				case Order.On_Resize:
					resize();
					break;
				case Order.Crap_Show_Request:
					showCrap();
					break;
				case Order.Video_Error_Request:
					showCrap();
					break;
				case Order.Crap_Hide_Request:
					hideCrap();
					break;
			}
		}
		
		private function showCrap():void
		{
			if (this.crapView.parent == null)
			{
				GlobalData.STAGE.addChild(this.crapView);
			}
			resize();
		}
		
		private function hideCrap():void
		{
			if (this.crapView.parent != null)
			{
				GlobalData.STAGE.removeChild(this.crapView);
			}
		}
		
		private function resize():void
		{
			crapView.resize();
		}
		
		private function get crapView():CrapView
		{
			return viewComponent as CrapView;
		}
	}

}