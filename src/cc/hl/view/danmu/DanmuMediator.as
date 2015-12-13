package cc.hl.view.danmu
{
	
	import cc.hl.model.comment.CommentTime;
	import cc.hl.model.comment.SingleCommentData;
	import cc.hl.model.video.VideoManager;
	import cc.hl.Order;
	import flash.events.Event;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import util.BlockLoader;
	import util.GlobalData;
	import util.JSFunctionName;
	import util.Param;
	import util.Util;
	
	public class DanmuMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "DanmuMediator";
		
		private var rawRecordArray:Array;
		private var lastPlaySecond:Number = 0;
		private var records:Array;
		
		public function DanmuMediator(obj:Object)
		{
			super(NAME, obj);
			records = [];
		}
		
		override public function listNotificationInterests():Array
		{
			return [cc.hl.Order.Danmu_Init_Request, cc.hl.Order.Danmu_Show_Request, cc.hl.Order.Danmu_Hide_Request, cc.hl.Order.Danmu_Add_Request, cc.hl.Order.On_Resize, cc.hl.Order.ControlBar_Update_Request];
		}
		
		override public function handleNotification(notify:INotification):void
		{
			switch (notify.getName())
			{
				case cc.hl.Order.Danmu_Init_Request: 
					this.initDanmu();
					break;
				case cc.hl.Order.Danmu_Show_Request: 
					this.danmuView.showDanmu();
					break;
				case cc.hl.Order.Danmu_Hide_Request: 
					this.danmuView.hideDanmu();
					break;
				case cc.hl.Order.Danmu_Add_Request: 
					this.addDanmu(notify.getBody());
					break;
				case cc.hl.Order.On_Resize: 
					this.onResize(notify.getBody());
					break;
				case cc.hl.Order.ControlBar_Update_Request: 
					this.onTimer(notify.getBody());
					break;
			}
		}
		
		private function initDanmu():void
		{
			this.danmuView.initDanmu();
			if (this.danmuView.parent == null)
			{
				util.GlobalData.DANMU_LAYER.addChild(this.danmuView);
				this.danmuView.resize(util.GlobalData.root.stage.stageWidth, util.GlobalData.root.stage.stageHeight);
				//var loader:BlockLoader = new BlockLoader(GlobalData.DOMAIN + GlobalData.GET_DANMU_URL + "?roomId=" + Param.roomId + "&r=" + int(Math.random() * 9999));
				//
				//loader.addEventListener(Event.COMPLETE, function():void
					//{
						//var rawRecords:Object = Util.decode(loader.data);
						//rawRecordArray = rawRecords.data;
						//
						//for (var i:int = 0; i < rawRecordArray.length; i++)
						//{
							//records[i] = rawRecordArray[i].data.span;
						//}
					//});
					//Util.log(this, "关闭了弹幕功能");
			}
		}
		
		private function addDanmu(obj:Object):void
		{
			CommentTime.instance.start(new SingleCommentData(obj.message, 16777215, util.GlobalData.textSizeValue, 0, false));
		}
		
		private function onTimer(o:Object):void
		{
			//var playedSecond:Number = o.playedSeconds;
			//if (o.playedSeconds - this.lastPlaySecond > 1)
			//{
				//this.lastPlaySecond = o.playedSeconds - 1;
			//}
			//
			//if (VideoManager.instance.playing)
			//{
				//var recordStart:int = Util.bsearch(this.records, this.lastPlaySecond);
				//var recordEnd:int = Util.bsearch(this.records, o.playedSeconds);
				//
				//for (var i:int = recordStart; i < recordEnd; i++)
				//{
					//if (this.rawRecordArray[i].c == "chat.message_push")
					//{
						//CommentTime.instance.start(new SingleCommentData(this.rawRecordArray[i].data.message, 16777215, util.GlobalData.textSizeValue, 0, false));
						//Util.jscall(JSFunctionName.WS_RESPONSE, this.rawRecordArray[i]);
					//}
					//else if (this.rawRecordArray[i].c == "chat.consume_push")
					//{
						//Util.jscall(JSFunctionName.WS_RESPONSE, this.rawRecordArray[i]);
					//}
				//}
			//}
			//this.lastPlaySecond = o.playedSeconds;
		}
		
		private function onResize(obj:Object):void
		{
			this.danmuView.resize(obj.w, obj.h);
		}
		
		override public function onRemove():void 
		{
			super.onRemove();
			if (this.danmuView.parent != null)
			{
				util.GlobalData.DANMU_LAYER.removeChild(this.danmuView);
			}
		}
		
		public function get danmuView():DanmuView
		{
			return viewComponent as DanmuView;
		}
	}
}