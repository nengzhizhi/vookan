package shl.ui
{
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author shl
	 */
	public class TextFactory 
	{
		
		public function TextFactory() 
		{
			
		}
		
		public static function createText(str:String, size:int, color:uint, isBlod:Boolean = false, isNum:Boolean = false, isCenter:Boolean = false) :TextField
		{
			var fontName:String;
			if (checkFontFamily("Microsoft YaHei") || checkFontFamily("微软雅黑"))
			{
				fontName = "微软雅黑";
			}
			else if(checkFontFamily("SimHei") || checkFontFamily("黑体"))
			{
				fontName = "SimHei";
			}
			if (isNum)
			{
				fontName = "Aril";
			}
			var tf:TextFormat = new TextFormat(fontName, size, color, isBlod);
			var text:TextField = new TextField();
			if (isCenter)
			{
				text.autoSize = TextFieldAutoSize.CENTER;
			}
			else
			{
				text.autoSize = TextFieldAutoSize.LEFT;
			}
			text.antiAliasType = AntiAliasType.ADVANCED;
			text.selectable = false;
			text.mouseEnabled = false;
			text.defaultTextFormat = tf;
			if (str == null)
			{
				str = "";
			}
			text.text = str;
			return text;
		}
		
		public static function setTextFont(t:TextField):void
		{
			if (!t)
				return;
			var fontName:String;
			if (checkFontFamily("Microsoft YaHei") || checkFontFamily("微软雅黑"))
			{
				fontName = "Microsoft YaHei";
			}
			else if(checkFontFamily("SimHei") || checkFontFamily("黑体"))
			{
				fontName = "SimHei";
			}
			var tf:TextFormat = new TextFormat(fontName);
			t.defaultTextFormat = tf;
		}
		
		public static function checkFontFamily(fontName:String):Boolean
		{
			var localFonts:Array = Font.enumerateFonts(true);
			var f:Font;
			var fName:String;
			var hasfont:Boolean;
			for (var i:int = 0, len:int = localFonts.length; i < len; i++)
			{
				f = localFonts[i] as Font;
				fName = f.fontName;
				if (fName.indexOf(fontName) != -1)
				{
					hasfont = true;
					return hasfont;
				}
			}
			return hasfont;
		}

	}

}