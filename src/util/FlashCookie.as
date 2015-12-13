package util 
{
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author shl
	 */
	public class FlashCookie 
	{
		public static const DEFAULT_APP_NAME:String = "cookie_zhijintv";
		
		public function FlashCookie() 
		{
			
		}
		
		/**
		 * 向指定的cookie文件中指定的字段写入指定的数据
		 * @param	key		指定的字段
		 * @param	value	指定的数据
		 * @param	app		指定的cookie文件
		 * @param	isflush	是否立即刷写
		 */
		public static function addKey(key:String, value:*, app:String = DEFAULT_APP_NAME, isflush:Boolean = false):void
		{
			var so:SharedObject = SharedObject.getLocal(app, "/");
			var today:Date = new Date();
			var date:String = "date_" + key;
			if (so.data.cookie == undefined)
			{
				var obj:Object = { };
				obj["key_" + key] = value;
				obj[date] = today.getTime();
				so.data.cookie = obj;
			}
			else
			{
				so.data.cookie["key_" + key] = value;
				so.data.cookie[date] = today.getTime();
			}
			if (isflush)
				so.flush();
		}
		
		public static function getValue(key:String, app:String = DEFAULT_APP_NAME):*
		{
			var so:SharedObject = SharedObject.getLocal(app, "/");
			var value:String;
			if (isExists(key, app))
			{
				value = so.data.cookie["key_" + key];
			}
			else
			{
				value = null;
			}
			return value;
		}
		
		/**
		 * 在指定的cookie文件中删除指定字段数据
		 * @param	key	指定字段
		 * @param	app	指定cookie文件
		 */
		public static function deleteKey(key:String, app:String = DEFAULT_APP_NAME):void
		{
			var so:SharedObject = SharedObject.getLocal(app, "/");
			if (isExists(key, app))
			{
				delete so.data.cookie["key_" + key];
				so.flush();
			}
		}
		
		/**
		 * 判断某个字段所对应的数据内容是否存在
		 * @param	key
		 * @param	app
		 * @return
		 */
		public static function isExists(key:String, app:String = DEFAULT_APP_NAME):Boolean
		{
			var so:SharedObject = SharedObject.getLocal(app, "/");
			if ((so.data.cookie != undefined) && so.data.cookie["key_" + key] != undefined)
			{
				return true;
			}
			return false;
		}
	}

}