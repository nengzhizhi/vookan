package cc.hl{
	public class Order extends Object
	{
		public function Order()
		{
			super();
		}

		public static const Start_Up:String = "startUp";
		public static const On_Resize:String = "On_Resize";
		public static const Init_View:String = "initView";

		//video中使用request
		public static const Video_Show_Request:String = "Video_Show_Request";
		//public static const Video_Start_Request:String = "Video_Start_Request";
		public static const Video_Play_Request:String = "Video_Play_Request";
		public static const Video_Pause_Request:String = "Video_Pause_Request";
		public static const Video_Seek_Request:String = "Video_Seek_Request";
		public static const Video_Volume_Request:String = "Video_Volume_Request";
		public static const Video_Reload_Request:String = "Video_Reload_Request";
		public static const Video_Error_Request:String = "Video_TimeOut_Request";
		public static const Video_Stoped_Request:String = "Video_Stoped_request";

		//controlBar
		public static const ControlBar_Show_Request:String = "ControlBar_Show_Request";
		public static const ControlBar_Update_Request:String = "ControlBar_Update_Request";

		//danmu
		public static const Danmu_Init_Request:String = "Danmu_Init_Request";
		public static const Danmu_Show_Request:String = "Danmu_Show_Request";
		public static const Danmu_Hide_Request:String = "Danmu_Hide_Request";
		public static const Danmu_Add_Request:String = "Danmu_Add_Request";
		public static const Danmu_Timer_Request:String = "Demo_Timer_Request";
		
		//nosignal
		public static const Nosignal_Show_Request:String = "Nosignal_Show_Requset";
		//loading
		public static const Loading_Show_request:String = "Loading_show_request";
		//crap
		public static const Crap_Show_Request:String = "Crap_Show_Request";
		public static const Crap_Hide_Request:String = "Crap_Hide_Request";
		//warning
		public static const Warning_Show_Request:String = "Warning_Show_Request";
	}
}