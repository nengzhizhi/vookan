package cc.hl.model.net
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.interfaces.IProxy;
	import flash.external.ExternalInterface;

	import flash.utils.getTimer;
	import util.Util;
	import util.JSFunctionName;
	import cc.hl.model.comment.CommentTime;
	import cc.hl.model.comment.SingleCommentData;

	public class ClientProxy extends Proxy implements IProxy
	{
		public function ClientProxy(){
			super();
			this.addJsCallback();
		}

		public static var NAME:String = "ClientProxy";
		private static var _instance:ClientProxy = null;

		public static function get instance():ClientProxy
		{
			if (_instance == null) {
				_instance = new ClientProxy();
			}
			return _instance;
		}

		private function addJsCallback():void
		{
			if (ExternalInterface.available)
			{
				try
				{
					ExternalInterface.addCallback(JSFunctionName.SEND_MESSAGE, this.sendMessage);
					ExternalInterface.addCallback(JSFunctionName.RECV_MESSAGE, this.recvMessage);
				}
				catch (ex:*)
				{
					Util.log(this, ex);
				}				
			}
		}

		private function sendMessage(m:String):void
		{
			Util.log(this, 'sendMessage' + m);
			CommentTime.instance.start(new SingleCommentData(m, 16777215, util.GlobalData.textSizeValue, getTimer(), true));
		}

		private function recvMessage(m:String):void
		{
			Util.log(this, 'sendMessage' + m);
			CommentTime.instance.start(new SingleCommentData(m, 16777215, util.GlobalData.textSizeValue, getTimer(), false));
		}

		public function doSendMessage(m:String):void
		{
			Util.jscall(JSFunctionName.CONSOLE_LOG, 'doSendMessage' + m);
			Util.jscall(JSFunctionName.DO_SEND_MESSAGE, m);
			CommentTime.instance.start(new SingleCommentData(m, 16777215, util.GlobalData.textSizeValue, getTimer(), true));
		}
	}
}