package cc.hl.view.video
{
	import flash.display.Sprite;
	import util.GlobalData;

	import cc.hl.model.video.VideoManager;
	import util.Util;
	import util.SkinEvent;
	
	public class VideoView extends Sprite {
		public function VideoView(){}

		public function showVideo(index:int = 0):void{
			if(index < 0 ){
				return;
			}

			var currentVideoInx:int = VideoManager.instance.currentVideoInx;

			if(VideoManager.instance.video(currentVideoInx).parent != null ){
				VideoManager.instance.video(currentVideoInx).volume = 0;
				VideoManager.instance.video(currentVideoInx).stop();
				VideoManager.instance.video(currentVideoInx).switchVideo(false);
				VideoManager.instance.video(currentVideoInx).parent.removeChild(VideoManager.instance.video(currentVideoInx));
			}
			if(!VideoManager.instance.video(index).isPlaying)
				VideoManager.instance.video(index).start();
				VideoManager.instance.video(index).switchVideo(true);
				VideoManager.instance.video(index).playing = VideoManager.instance.playing;
				VideoManager.instance.video(index).volume = GlobalData.currentVolume;
				VideoManager.instance.video(index).setVideoRatio(2);
				VideoManager.instance.video(index).resize(util.GlobalData.root.stage.stageWidth, util.GlobalData.root.stage.stageHeight);
				addChild(VideoManager.instance.video(index));
			}

		public function seekTime(timeToSeek:Number):void{
			//for(var i:int = 0;i < VideoManager.instance._videoCount;i++){
				//VideoManager.instance.video(i).time = timeToSeek;
			//}
			if(VideoManager.instance.currentVideo)
				VideoManager.instance.currentVideo.time = timeToSeek;
		}
	}
}