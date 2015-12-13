package shl.ui
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author shl
	 */
	public class ShlButton extends SimpleButton 
	{
		
		public function ShlButton() 
		{
			super();
			
		}
		
		public static function buttonFromImage(up:ShlImage, over:ShlImage, down:ShlImage,hittest:ShlImage = null):ShlButton
		{
			var button:ShlButton = new ShlButton();
			button.upState = up;
			button.downState = down;
			button.overState = over;
			if (hittest == null)
			{
				button.hitTestState = up;
			}
			else
			{
				button.hitTestState = hittest;
			}
			return button;
		}
		
		public static function buttonFromSprite(up:Sprite, over:Sprite, down:Sprite, hittest:Sprite = null):ShlButton
		{
			var button:ShlButton = new ShlButton();
			button.upState = up;
			button.downState = down;
			button.overState = over;
			if (hittest == null)
			{
				button.hitTestState = up;
			}
			else
			{
				button.hitTestState = hittest;
			}
			return button;
		}
	}

}