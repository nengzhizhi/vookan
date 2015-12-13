package cc.hl.view.crap 
{
	import flash.display.Sprite;
	import ui.Crap;
	import util.GlobalData;
	
	/**
	 * ...
	 * @author shl
	 */
	public class CrapView extends Sprite 
	{
		private var crap:Crap;
		
		public function CrapView() 
		{
			crap = new Crap();
			addChild(crap);
		}
		
		public function resize():void
		{
			if (crap != null)
			{
				crap.x = (GlobalData.STAGE.stageWidth - crap.width) * 0.5;
				crap.y = (GlobalData.STAGE.stageHeight - crap.height) * 0.5;
			}
		}
	}

}