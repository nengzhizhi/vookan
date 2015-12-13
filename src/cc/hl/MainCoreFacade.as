package cc.hl
{
	import cc.hl.controller.InitViewCommand;
	import flash.display.Stage;
	import flash.events.Event;
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.interfaces.IFacade;
	import cc.hl.controller.StartCommand;


	public class MainCoreFacade extends Facade implements IFacade
	{
		public function MainCoreFacade(){
			super();
		}

		public static function getInstance() : MainCoreFacade
		{
			if(instance == null)
			{
				instance = new MainCoreFacade();
			}
			return instance as MainCoreFacade;
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(Order.Start_Up, StartCommand);
			registerCommand(Order.Init_View, InitViewCommand);
		}

		public function startUp(main:Main):void
		{
			sendNotification(Order.Start_Up, main);
			sendNotification(Order.Init_View, main);
			main.stage.addEventListener(Event.RESIZE, onResize);
		}
		
		private function onResize(e:Event):void 
		{
			sendNotification(Order.On_Resize, {"w": (e.target as Stage).stageWidth, "h": (e.target as Stage).stageHeight});
		}
	}


}