package cc.hl.view.controlBar 
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import shl.ui.ShlButton;
	import shl.ui.TextFactory;
	import ui.Danmubg;
	import util.SkinEvent;
	import util.Util;
	
	/**
	 * ...
	 * @author shl
	 */
	public class DanmuBar extends Sprite 
	{
		public static const INPUT_WIDTH:int = 300;
		public static const BUTTON_WIDTH:int = 40;
		public static const HEIGHT:int = 20;
		public static const MAX_CHARS:int = 20;
		
		private var sendBtn:ShlButton;
		private var bg:Danmubg;
		private var textInput:TextField;
		
		
		public function DanmuBar() 
		{
			init();
		}
		
		private function init():void
		{
			bg = new Danmubg();
			bg.width = INPUT_WIDTH;
			addChild(bg);
			
			textInput = TextFactory.createText("在此处输入弹幕", 12, 0x606060);
			textInput.mouseEnabled = true;
			textInput.selectable = true;
			textInput.maxChars = MAX_CHARS;
			textInput.autoSize = TextFieldAutoSize.NONE;
			textInput.width = INPUT_WIDTH - 10;
			textInput.type = TextFieldType.INPUT;
			textInput.x = 7;
			addChild(textInput);
			
			var uptext:TextField = TextFactory.createText("发送", 12, 0xffffff);
			var upbg:Sprite = new Sprite();
			upbg.graphics.beginFill(0x50d2e0);
			upbg.graphics.drawRect(0, 0, BUTTON_WIDTH, HEIGHT);
			upbg.graphics.endFill();
			uptext.x = (upbg.width - uptext.width) * 0.5;
			uptext.y = (upbg.height - uptext.height) * 0.5;
			upbg.addChild(uptext);
			
			var downtext:TextField = TextFactory.createText("发送", 12, 0xffffff);
			var downbg:Sprite = new Sprite();
			downbg.graphics.beginFill(0x78dce6);
			downbg.graphics.drawRect(0, 0, BUTTON_WIDTH, HEIGHT);
			downbg.graphics.endFill();
			downtext.x = (downbg.width - downtext.width) * 0.5;
			downtext.y = (downbg.height - downtext.height) * 0.5;
			downbg.addChild(downtext);
			
			sendBtn = ShlButton.buttonFromSprite(upbg, downbg, downbg);
			sendBtn.x = INPUT_WIDTH;
			addChild(sendBtn);
			
			sendBtn.addEventListener(MouseEvent.CLICK, onSendClick);
			textInput.addEventListener(MouseEvent.CLICK, onClick);
			textInput.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onSendClick(e:MouseEvent):void 
		{
			sendMessage()
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (textInput.text == "在此处输入弹幕")
			{
				textInput.text = "";
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == 13)
			{
				sendMessage();
			}
		}
		
		private function sendMessage():void
		{
			if (textInput.text.length != 0 && textInput.text != "在此处输入弹幕")
			{
				Util.log(this, textInput.text);
				var event:SkinEvent = new SkinEvent(SkinEvent.SKIN_DANMU_SEND);
				event.data = textInput.text;
				dispatchEvent(event);
				textInput.text = "";
			}
		}
	}

}