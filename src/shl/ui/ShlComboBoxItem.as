package shl.ui 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author shl
	 */
	public class ShlComboBoxItem extends Sprite 
	{
		
		public var content:String;
		
		public function ShlComboBoxItem(c:String, w:int, h:int)
		{
			content = c;
			
			var sb:SimpleButton = new SimpleButton();
			var up:Sprite = new Sprite();
			var over:Sprite = new Sprite();
			var down:Sprite = new Sprite();
			var hit:Sprite = new Sprite();
			
			up.graphics.beginFill(0xffffff);
			up.graphics.drawRect(0, 0, w, h);
			up.graphics.endFill();
			
			over.graphics.beginFill(0xdcdcdc);
			over.graphics.drawRect(0, 0, w, h);
			over.graphics.endFill();
			
			down.graphics.beginFill(0xb4b4b4);
			down.graphics.drawRect(0, 0, w, h);
			down.graphics.endFill();
			
			hit.graphics.beginFill(0xffffff);
			hit.graphics.drawRect(0, 0, w, h);
			hit.graphics.endFill();
			
			var upText:TextField = TextFactory.createText(content, 12, 0x000000);
			upText.y = -1;
			upText.x = 4;
			var overText:TextField = TextFactory.createText(content, 12, 0x000000);
			overText.y = -1;
			overText.x = 4;
			var downText:TextField = TextFactory.createText(content, 12, 0x000000);
			downText.y = -1;
			downText.x = 4;
			
			up.addChild(upText);
			over.addChild(overText);
			down.addChild(downText);
			
			sb.upState = up;
			sb.overState = over;
			sb.downState = down;
			sb.hitTestState = hit;
			addChild(sb);
		}
		
	}

}