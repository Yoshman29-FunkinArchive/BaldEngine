package game.cutscenes;

import flixel.FlxCamera;
#if VIDEO_SUPPORTED
import hxcodec.VideoSprite;

class VideoCutscene extends Cutscene {
    var path:String;
    var video:VideoSprite;

    public function new(path:String) {
        super();
        this.path = path;
    }
    public override function create() {
        super.create();
        
        camera = new FlxCamera();
        FlxG.cameras.add(camera, false);

        video = new VideoSprite();
        video.canvasWidth = FlxG.width;
        video.canvasHeight = FlxG.height;
        video.playVideo(AssetsFL.getPath(path));
        video.finishCallback = function() {
            close();
        };
        add(video);
    }

    public override function destroy() {
        FlxG.cameras.remove(camera);
        video.bitmap.stop();
        super.destroy();
    }
}
#else
class VideoCutscene extends Cutscene {
    public function new(_:String) {
        super();
    }
    public override function update(elapsed:Float) {
        super.update(elapsed);
        close();
    }
}
#end