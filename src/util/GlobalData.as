package util
{
	import flash.display.Sprite;
	import flash.display.Stage;

	public class GlobalData extends Object
	{
		public function GlobalData() {
			super();
		}
		
		public static const VERSION:String = "0.1.0.6";
		//public static const DOMAIN:String = "http://zhijin.tv:8087";
		public static var DOMAIN:String = "http://vls.kf.whonow.cn:8087";
		public static const AUTHORITY_CARD:String = "authorityCard";
		public static const POLLING_CARD:String = "pollingCard";
		
		//url
		public static const GET_TIME_LINE_DATA:String = "/app/interaction/findAllInteractions";
		public static const FIND_TOP_3_USERS:String = "/app/statistics/interaction/findTop3Users";
		public static const FIND_ALL_ITEMS_TOP_USER:String = "/app/statistics/interaction/findAllItemsTopUser";
		public static const GET_DANMU_URL:String = "/app/room/getRecords";
		public static const GET_CAMERAS_RUL:String = "/admin/room/findRoomCameras";
		public static const GET_IS_LOGIN:String = "/app/user/isLogin";
		
		//文字
		public static const LOGIN_TIP:String = "请先登录后即可发言";
		public static const NEED_UPDATE_TIP:String = "您的FlashPlayer版本过低,更新即可在全屏时发送弹幕~";
		
		public static var max_use_memory_level:int = 0;

		public static var VIDEO_LAYER:Sprite;
		public static var CONTROL_BAR_LAYER:Sprite;
		public static var DANMU_LAYER:Sprite;
		public static var CAMERA_LAYER:Sprite;
		public static var TIMELINE_LAYER:Sprite;
		public static var TOOL_LAYER:Sprite;
		public static var MARQUEE_LAYER:Sprite;
		public static var LOADING_LAYER:Sprite;
		public static var WARNINF_LAYER:Sprite;
		public static var STAGE:Stage;

		public static var root:Main;

		public static const MAX_USE_MEMORY_ARRAY:Array = [
														104857600,//100M
														209715200,//200M, 
														0x19000000, 
														int.MAX_VALUE//4G
													];//视频缓存池能够使用的最大内存

		public static var offsetUpHeight:int = 20;
		public static var offsetDownHeight:int = 0;													
		public static var textAlphaValue:Number = 0.85;
		public static var textSizeValue:Number = 14;
		
		public static var isTimeLineShow:Boolean = false;
		public static var stageVideoAvailable:Boolean = false;
		public static var playerNeedUpdate:Boolean = false;
		
		public static var playedSecond:Number = 0;
		public static var currentVolume:Number = 1;
		public static var videos:Object;

	}
}