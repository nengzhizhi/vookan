package shl.ui
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author shl
	 */
	public class ShlImage extends Sprite 
	{
		
		public function ShlImage() 
		{
			super();
			
		}
		
		public static function imageFromClass(cls:Class):ShlImage
		{
			var image:ShlImage = new ShlImage();
			var dp:Bitmap = new cls();
			dp.smoothing = true;
			image.addChild(dp);
			return image;
		}
		
		public static function imageFromURL(url:String, w:int, h:int):ShlImage
		{
			var image:ShlImage = new ShlImage();
			ShlImageManager.getInstance().loadURLWithoutCache(url, image, w, h);
			return image;
		}
	}

}