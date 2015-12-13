package shl.ui 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author shl
	 */
	public class ShlComboBox extends Sprite 
	{
		
		private var data:Array;
		private var defaultText:String;
		private var arrow:MovieClip;
		private var sw:int;
		private var sh:int;
		
		private var bg:Sprite;
		private var itemContainer:Sprite;
		private var currentText:TextField;
		private var items:Array;
		private var isShow:Boolean = false;
		
		public function ShlComboBox(da:Array, ic:MovieClip, w:int, h:int, dt:String = "") 
		{
			data = da;
			arrow = ic;
			sw = w;
			sh = h;
			arrow.gotoAndStop(1);
			if (dt == "")
			{
				defaultText = data[0];
			}
			else
			{
				defaultText = dt;
			}
		}
		
		public function addItem(str:String):void
		{
			data.push(str);
		}
		
		public function init():void
		{
			this.buttonMode = true;
			bg = new Sprite();
			bg.graphics.beginFill(0xffffff);
			bg.graphics.drawRoundRect(0, 0, sw, sh, 2, 2);
			bg.graphics.endFill();
			addChild(bg);
			
			currentText = TextFactory.createText(defaultText, 12, 0x000000);
			currentText.y = -1;
			currentText.x = 4;
			bg.addChild(currentText);
			
			arrow.x = sw - arrow.width - 4;
			arrow.y = (sh - arrow.height) * 0.5;
			bg.addChild(arrow);
			
			bg.addEventListener(MouseEvent.CLICK, onClick);
			
			itemContainer = new Sprite();
			itemContainer.graphics.beginFill(0xffffff);
			itemContainer.graphics.drawRoundRect(0, 0, sw, sh * data.length + 14, 2, 2);
			itemContainer.graphics.endFill();
			
			var i:int;
			items = [];
			for (i = 0; i < data.length; i++)
			{
				var item:ShlComboBoxItem = new ShlComboBoxItem(data[i], sw, sh);
				items.push(item);
				item.y = i * sh + 7;
				itemContainer.addChild(item);
				item.addEventListener(MouseEvent.CLICK, onItemClick);
			}
			itemContainer.visible = false;
			addChild(itemContainer);
		}
		
		private function onItemClick(e:MouseEvent):void 
		{
			if (isShow)
			{
				itemContainer.visible = false;
				isShow = false;
				arrow.gotoAndStop(1);
				var temp:ShlComboBoxItem = e.currentTarget as ShlComboBoxItem;
				currentText.text = temp.content;
			}
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (!isShow)
			{
				itemContainer.y = - 3 - itemContainer.height;
				itemContainer.visible = true;
				isShow = true;
				arrow.gotoAndStop(2);
			}
			else
			{
				itemContainer.visible = false;
				isShow = false;
				arrow.gotoAndStop(1);
			}
		}
		
		public function getCurrentText():String
		{
			return currentText.text;
		}
		
		public function dispose():void
		{
			var i:int;
			for (i = 0; i < items.length; i++)
			{
				items[i].removeEventListener(MouseEvent.CLICK, onItemClick);
			}
			items = null;
		}
		
	}

}