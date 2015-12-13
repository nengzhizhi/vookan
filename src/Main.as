package
{
	import cc.hl.MainCoreFacade;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import util.GlobalData;
	import util.Log;
	import util.Param;
	import util.Util;

	public class Main extends Sprite
	{
		private var facade:cc.hl.MainCoreFacade;
		private var password = "";
		
		public function Main()
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			stage.color = 0;
			stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoAvailability);
			
			//右键版本信息
			var contextmenu:ContextMenu = new ContextMenu();
			//contextmenu.hideBuiltInItems();
			var menuVer:ContextMenuItem = new ContextMenuItem("rtmpplayer version: " + util.GlobalData.VERSION, true, false);
			contextmenu.customItems.push(menuVer);
			var r:Sprite = root as Sprite;
			if (r)
			{
				r.contextMenu = contextmenu;
			}
			
			util.GlobalData.root = this;
			util.GlobalData.STAGE = stage;
			
			//获取domain
			var domain:String = Util.getDomain();
			if (domain != "")
				GlobalData.DOMAIN = domain;
			
			//param set
			Param.init(stage.loaderInfo.parameters);
			
			this.facade = cc.hl.MainCoreFacade.getInstance();
			this.facade.startUp(this);
			
			//用于输入密码查看log
			Log.init(this);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onStageVideoAvailability(e:StageVideoAvailabilityEvent):void
		{
			Util.log(this, "hardware accelerate availability: " + e.availability);
			util.GlobalData.stageVideoAvailable = e.availability == "available";
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			password += String(e.keyCode);
			if (password.length > 14)
			{
				password = password.substr(password.length - 14, 14);
			}
			if (password == "67797883797669")
			{
				Log.toggleShow();
			}
		
		}
	}

}