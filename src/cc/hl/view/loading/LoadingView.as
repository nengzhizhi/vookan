package cc.hl.view.loading 
{
	import flash.display.Sprite;
	import ui.LoadingAnimition;
	import util.GlobalData;
	
	/**
	 * ...
	 * @author shl
	 */
	public class LoadingView extends Sprite 
	{
		private var animition:LoadingAnimition;
		
		public function LoadingView() 
		{
			animition = new LoadingAnimition();
			addChild(animition);
			animition.visible = false;
		}
		
		public function resize():void
		{
			if (animition != null)
			{
				animition.x = (GlobalData.STAGE.stageWidth - animition.width) * 0.5;
				animition.y = (GlobalData.STAGE.stageHeight - animition.height) * 0.5;
			}
		}
		
		public function showToggle(isshow:Boolean):void
		{
			animition.visible = isshow;
		}
	}

}