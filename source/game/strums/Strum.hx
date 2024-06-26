package game.strums;

class Strum extends FlxSprite {
	public var id:Int;
	public var cpu:Bool = false;

	public var lastHitTime:Float = -5000;
	public var parent:StrumLine;

	public var speed:Float = 1;

	public function new(parent:StrumLine, x:Float, y:Float, id:Int, cpu:Bool, speed:Float) {
		super(x, y);
		this.parent = parent;
		this.id = id;
		this.speed = speed;
		create();
		animation.play("static");
	}

	public function create() {

	}

	public function confirm() {
		animation.play("confirm");
		lastHitTime = Conductor.instance.songPosition;
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);
		if (cpu) {
			switch(animation.getCurAnimName()) {
				case "static":
					// nothing
				case "confirm":
					if (Conductor.instance.songPosition > lastHitTime + (Conductor.instance.stepCrochet * 1.5))
						animation.play("static", true);
				default:
					animation.play("static", true);
			}
		} else {
			switch(animation.getCurAnimName()) {
				case "static":
					if (parent.controlsArray[id].justPressed)
						animation.play("pressed");
				case "pressed":
					if (parent.controlsArray[id].justReleased)
						animation.play("static");
					// nothing
				case "confirm":
					if (parent.controlsArray[id].justReleased)
						animation.play("static");
			}
		}

		centerOffsets();
		centerOrigin();
		offset.x += width / 2;
		offset.y += height / 2;
	}
}