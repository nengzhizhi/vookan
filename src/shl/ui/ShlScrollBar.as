package shl.ui
{
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author shl
	 */
	public class ShlScrollBar extends Sprite
	{
		
		public var oneWheelPixels:int = 10;
		
		private var position:Number = 0;
		private var slider:Sprite;
		private var showWidth:int;
		private var showHeight:int;
		private var mymask:Shape;
		private var oldMouseY:Number;
		private var rollAnimation:TweenLite;
		public var content:DisplayObject;
		
		//sd是滑动条 cnt是要显示的内容 sw是显示的宽度 sh是显示的高度
		public function ShlScrollBar(sd:Sprite, cnt:DisplayObject, sw:int, sh:int)
		{
			slider = sd;
			content = cnt;
			showWidth = sw;
			showHeight = sh;
			//遮罩初始化
			mymask = new Shape();
			mymask.graphics.beginFill(0xffffff);
			mymask.graphics.drawRect(0, 0, sw, sh);
			mymask.graphics.endFill();
			this.mask = mymask;
			addChild(mymask);
			
			slider.buttonMode = true;
			slider.x = 400 - slider.width - 2;
			addChild(content);
			addChild(slider);
			
			addListener();
			render();
		}
		
		public function setPosition(pos:Number):void
		{
			if (pos < 0)
			{
				pos = 0;
			}
			if (pos > 1)
			{
				pos = 1;
			}
			this.position = pos;
		}
		
		public function getPosition():Number
		{
			return position;
		}
		
		public function setShowArea(sw:int, sh:int):void
		{
			this.showWidth = sw;
			this.showHeight = sh;
			mymask.graphics.clear();
			mymask.graphics.beginFill(0xffffff);
			mymask.graphics.drawRect(0, 0, showWidth, showHeight);
			mymask.graphics.endFill();
			render();
		}
		
		public function contentChange():void
		{
			renderConstY();
		}
		
		private function addListener():void
		{
			if (!this.slider.hasEventListener(MouseEvent.MOUSE_DOWN))
			{
				this.slider.addEventListener(MouseEvent.MOUSE_DOWN, onSliderDown);
			}
		}
		
		private function removeListener():void
		{
			if (this.slider.hasEventListener(MouseEvent.MOUSE_DOWN))
			{
				this.slider.removeEventListener(MouseEvent.MOUSE_DOWN, onSliderDown);
			}
		}
		
		public function onMouseWheel(delta:int):void
		{
			if (content.height <= showHeight)
			{
				setPosition(0);
				return;
			}
			var offset:int = oneWheelPixels * delta;
			if (this.rollAnimation)
			{
				this.rollAnimation.kill();
			}
			var de:int = content.y + offset;
			if (de > 0)
			{
				de = 0;
			}
			if (de < showHeight - content.height)
			{
				de = showHeight - content.height;
			}
			this.rollAnimation = TweenLite.to(content, 0.5, 
			{"y": de, "ease": Linear.easeOut, onUpdate: onUpdateslider, onComplete:onUpdateslider} );
		}
		
		private function onUpdateslider():void 
		{
			var p:Number = content.y / (showHeight - content.height);
			setPosition(p);
			slider.y = (showHeight - slider.height) * position;
		}
		
		private function onSliderDown(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSliderMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onSliderUp);
			oldMouseY = mouseY;
		}
		
		private function onSliderMove(e:MouseEvent):void
		{
			var l:Number = mouseY - oldMouseY;
			oldMouseY = mouseY;
			setSliderPosition(slider.y + l);
			var p:Number = slider.y / (showHeight - slider.height);
			setPosition(p);
			render();
		}
		
		private function onSliderUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSliderMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onSliderUp);
		}
		
		private function setSliderPosition(yy:Number):void
		{
			if (yy < 0)
			{
				yy = 0;
			}
			if (content.height <= showHeight)
			{
				yy = 0;
			}
			if (yy > showHeight - slider.height)
			{
				yy = showHeight - slider.height;
			}
			slider.y = yy;
		}
		
		public function render():void
		{
			if (content)
			{
				if (content.height <= showHeight)
				{
					//content.y = 0;
					//slider.y = 0;
					slider.visible = false;
				}
				else
				{
					content.y = -(content.height - showHeight - 5) * position;
					slider.y = (showHeight - slider.height) * position;
					slider.visible = true;
				}
			}
		}
		
		public function renderConstY():void
		{
			if (content)
			{
				if (content.height <= showHeight)
				{
					//content.y = 0;
					//slider.y = 0;
					slider.visible = false;
				}
				else
				{
					var pos:Number = -content.y / (content.height - showHeight - 5);
					setPosition(pos);
					slider.y = (showHeight - slider.height) * position;
					slider.visible = true;
				}
			}
		}
		
		public function dispose():void
		{
			removeListener();
			slider = null;
			content = null;
			mymask = null;
		}
	}

}