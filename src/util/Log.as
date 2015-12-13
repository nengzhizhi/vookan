package util
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	public class Log
	{
		
		
		private static var _s:Sprite;
		private static var _tf:TextField;
		private static var container:DisplayObjectContainer;
		
		public static function init(pcontainer:DisplayObjectContainer, ww:Number = 800, hh:Number = 600):void
		{
			var main:DisplayObjectContainer = pcontainer;
			container = pcontainer;
			var width:int = ww;
			var height:int = hh;
			_s = new Sprite();
			_s.graphics.beginFill(0, 0.7);
			_s.graphics.drawRect(0, 0, width, height);
			_s.graphics.endFill();
			_s.addEventListener(MouseEvent.CLICK, function(pcontainer:MouseEvent):void
				{
					pcontainer.stopPropagation();
				});
			_tf = new TextField();
			_tf.width = (width - 2);
			_tf.height = (height - 35);
			_tf.x = 1;
			_tf.y = 1;
			_tf.defaultTextFormat = new TextFormat("Courier New", null, 0xffffff);
			_tf.alpha = 1;
			_tf.appendText(Capabilities.version + "\n");
			if (ExternalInterface.available)
			{
				try
				{
					_tf.appendText((("浏览器标识：" + ExternalInterface.call("function(){ return navigator.userAgent; }")) + "\n"));
				}
				catch (error:Error)
				{
					_tf.appendText(("Error: " + error.message));
				}
			}
			_s.addChild(_tf);
			
			_s.visible = false;
			_s.x = 2;
			_s.y = 2;
		}
		
		public static function toggleShow():void
		{
			_s.visible = !_s.visible;
			if (_s.visible)
				container.addChild(_s);
		}
		
		public static function log(str:String):void
		{
			var logstr:String = Util.covertToTime(getTimer()) + " " + "  ---->  " + str + "\n";
			if (_tf != null)
			{
				if (_tf.length > 100000)
				{
					_tf.text = "";
					_tf.appendText("too many log > 100000,clear!\n");
				}
				_tf.appendText(logstr);
				_tf.scrollV = _tf.bottomScrollV;
			}
		}
		
		public static function getText():String
		{
			return (_tf.text);
		}
	}
} 
