package cc.hl.view.warning 
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import ui.Warning;
	import util.GlobalData;
	
	/**
	 * ...
	 * @author shl
	 */
	public class WarningView extends Sprite 
	{
		public static const WARNING_SHOW_TIME:int = 5000;
		private var warning:Warning;
		private var timer:Timer;
		
		public function WarningView() 
		{
			timer = new Timer(WARNING_SHOW_TIME);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			warning = new Warning();
			warning.warningText.autoSize = TextFieldAutoSize.LEFT;
			addChild(warning);
			warning.visible = false;
			resize();
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			timer.stop();
			warning.visible = false;
		}
		
		public function showWarning(str:String):void
		{
			warning.warningText.text = str;
			if (warning.warningText.textWidth > 112)
			{
				warning.bg.width = (warning.warningText.textWidth + 48);
			}
			warning.visible = true;
			warning.alpha = 0;
			warning.y = GlobalData.STAGE.stageHeight - 50;
			TweenLite.to(warning, 0.3, {"y": GlobalData.STAGE.stageHeight - 100, "alpha": 1, "ease": Linear.easeOut});
			if (timer.running)
			{
				timer.reset();
				timer.start();
			}
			else
			{
				timer.start();
			}
		}
		
		public function resize():void
		{
			if (warning != null)
			{
				warning.x = (GlobalData.STAGE.stageWidth - warning.width) * 0.5;
				warning.y = GlobalData.STAGE.stageHeight - 100;
			}
		}
	}

}