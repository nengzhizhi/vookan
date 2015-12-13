package cc.hl.view.nosignal
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import shl.ui.TextFactory;
	import ui.NoSignal;
	import util.GlobalData;
	import util.Param;
	import util.Util;
	
	/**
	 * ...
	 * @author shl
	 */
	public class NoSignalView extends Sprite
	{
		private var logo:NoSignal;
		private var tip:TextField;
		
		public function NoSignalView()
		{
			logo = new NoSignal();
			addChild(logo);
			var remainingTime:int;
			try
			{
				remainingTime = int(Param.remainingTime);
			}
			catch (ex:*)
			{
				Util.log(this, ex);
			}
			if (Param.playTime != null && Param.playTime != "")
			{
				tip = TextFactory.createText("", 14, 0xffffff);
				addChild(tip);
				if (remainingTime > 0)
				{
					
				tip.text = "本节目将在 " + Param.playTime + " 直播";
				
				}
				else
				{
					tip.text = "本节目已经结束,请选择其他节目观看~";
				}
			}
			
			resize();
		}
		
		public function hidePlayTime():void
		{
			if (tip != null)
			{
				if (tip.parent != null)
				{
					removeChild(tip);
				}
			}
		}
		
		public function resize():void
		{
			if (logo != null)
			{
				logo.x = (GlobalData.STAGE.stageWidth - logo.width) * 0.5;
				logo.y = (GlobalData.STAGE.stageHeight - logo.height) * 0.5;
			}
			if (tip != null)
			{
				tip.x = (GlobalData.STAGE.stageWidth - tip.textWidth) * 0.5;
				tip.y = logo.y + logo.height;
			}
		}
	}

}