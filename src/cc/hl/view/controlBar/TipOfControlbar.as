package cc.hl.view.controlBar 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import shl.ui.TextFactory;
	import ui.Tipbg;
	import util.GlobalData;
	import util.Util;
	
	/**
	 * ...
	 * @author shl
	 */
	public class TipOfControlbar extends Sprite 
	{
		private static var _instance:TipOfControlbar;
		
		private var tipbg:Tipbg;
		private var tip:TextField;
		private var showing:Boolean = false;
		
		public function TipOfControlbar() 
		{
			this.y = -22;
			tipbg = new Tipbg();
			tip = TextFactory.createText("", 12, 0xffffff);
			tip.y = -10;
			addChild(tipbg);
			addChild(tip);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (showing)
			{
				this.x = GlobalData.STAGE.mouseX;
			}
			else
			{
				this.visible = false;
			}
		}
		
		public static function getInstance():TipOfControlbar
		{
			if (_instance == null)
			{
				_instance = new TipOfControlbar();
			}
			return _instance;
		}
		
		public function showTip(str:String):void
		{
			updateString(str);
			this.visible = true;
			showing = true;
		}
		
		public function hideTip():void
		{
			showing = false;
			this.visible = false;
		}
		
		private function updateString(str:String):void
		{
			tip.text = str;
			tip.x = -tip.textWidth * 0.5 - 1;
			tipbg.width = tip.textWidth + 11;
		}
	}

}