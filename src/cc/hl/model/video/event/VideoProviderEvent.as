package cc.hl.model.video.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author shl
	 */
	public class VideoProviderEvent extends Event 
	{
		public static const VIDEO_STOP:String = "videoStop";
		public static const VIDEEO_ERROE:String = "videoError";
		
		public function VideoProviderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}