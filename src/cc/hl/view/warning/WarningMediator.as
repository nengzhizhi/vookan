package cc.hl.view.warning 
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
	public class WarningMediator extends Mediator implements IMediator 
	{
		public static const NAME:String = "warningMediator";
		
		public function WarningMediator(obj:Object = null) 
		{
			super(NAME, obj);
		}
		
		override public function listNotificationInterests():Array 
		{
			return [Order.On_Resize,
					Order.Warning_Show_Request];
		}
		
		override public function handleNotification(note:INotification):void 
		{
			switch(note.getName())
			{
				case Order.On_Resize:
					warningView.resize();
					break;
				case Order.Warning_Show_Request:
					showWarning(String(note.getBody()));
					break;
			}
		}
		
		private function showWarning(str:String):void
		{
			if (this.warningView.parent == null)
			{
				GlobalData.WARNINF_LAYER.addChild(this.warningView);
			}
			warningView.showWarning(str);
		}
		
		private function get warningView():WarningView
		{
			return viewComponent as WarningView;
		}
	}

}