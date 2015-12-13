package util
{
	
	public class Param extends Object
	{
		/*
		   public class CameraParam extends Object{
		   public function CameraParam() {
		   super();
		   }
		
		   public var Url:String;
		   public var LiveId:String;
		   public var cTitle:String;
		   }
		 */
		
		public function Param()
		{
			super();
		}
		
		public static var clock:Number = 100;
		
		public static var wsServerUrl:String;
		public static var roomId:String;
		public static var cookie:String;
		public static var sponsorStr:String;
		public static var status:String;
		public static var playTime:String;
		public static var remainingTime:String;
		public static var showStageId:String;
		
		public static var isLoadByWeb:Boolean = false;
		
		public static function init(o:Object):void
		{
			Util.log(Param, o);
			if (o["wsUrl"] != undefined)
			{
				isLoadByWeb = true;
				wsServerUrl = o["wsUrl"];
				//wsServerUrl = "ws://vls.whonow.cn:8086/chat/";
				roomId = o["roomId"];
				cookie = o["cookie"];
				sponsorStr = o["sponsor"];
				status = o["state"];
				playTime = o["playingDate"];
				remainingTime = o["remainingTime"];
				showStageId = o["showStageId"];
			}
		
		}
	}
}