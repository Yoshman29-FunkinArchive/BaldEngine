package game.characters.presets;

import flixel.FlxCamera;
import flixel.math.FlxRect;

class SpriteCharacter extends FlxSprite implements Character {
	public var _(get, null):FlxSprite;

	public var gameOverChar:Class<Character> = BoyfriendDead;


	public function get__():FlxSprite
		return this;

	public var cameraOffset:FlxPoint = FlxPoint.get(125, -100);

	public var lastSingStep:Float = -5000;
	public var flipped:Bool = false;
	public var parent:StrumLine = null;

	public function new(x:Float, y:Float, flipped:Bool, parent:StrumLine) {
		super(x, y);
		this.flipped = flipped;
		this.parent = parent;
		if (flipped)
			scale.x *= -1;

		// preloading miss sfxs
		for(i in 1...4)
			FlxG.sound.load(Paths.sound('game/sfx/missnote$i'));
	}

	public function playMissAnim(strumID:Int, ?note:Note) {
		lastSingStep = Conductor.instance.curStepFloat;

		animation.play("miss-" + ["LEFT", "DOWN", "UP", "RIGHT"][strumID], true);
		FlxG.sound.play(Paths.sound('game/sfx/missnote${FlxG.random.int(1, 3)}'), FlxG.random.float(0.1, 0.2));
		parent.muteVocals();
	}

	public function playDeathAnim(callback:Void->Void) {
		animation.play('long-firstDeath', true);
		animation.finishCallback = function(name:String) {
			callback();
			animation.finishCallback = null;
		};
	}

	public function playDeathConfirmAnim() {
		animation.play('long-deathConfirm');
	}

	public function playSingAnim(strumID:Int, ?note:Note) {
		lastSingStep = Conductor.instance.curStepFloat;

		animation.play("sing-" + ["LEFT", "DOWN", "UP", "RIGHT"][strumID], true);
		parent.unmuteVocals();
	}

	public function dance(beat:Int, force:Bool) {
		if (!force) {
			switch(getAnimPrefix()) {
				case "sing":
					if (Conductor.instance.curStepFloat - lastSingStep < 3.5)
						return;
				case "miss":
					if (Conductor.instance.curStepFloat - lastSingStep < 7.5)
						return;
				case "long":
					if (!animation.curAnim.finished)
						return;
			}
		}

		playDanceAnim(beat);
	}

	public function getCameraPosition():FlxPoint {
		var midpoint = getMidpoint(FlxPoint.get());
		midpoint.x -= offset.x;
		midpoint.y -= offset.y;
		if (flipped)
			midpoint.x -= cameraOffset.x;
		else
			midpoint.x += cameraOffset.x;
		midpoint.y += cameraOffset.y;
		return midpoint;
	}

	public function playDanceAnim(beat:Int) {
		animation.play("dance-idle", false);
	}

	private function getAnimPrefix():String {
		var curAnim = animation.getCurAnimName();
		if (curAnim != null) {
			var pos = curAnim.indexOf("-");
			return (pos >= 0) ? curAnim.substr(0, pos) : null;
		}
		return null;
	}

	public override function getScreenBounds(?newRect:FlxRect, ?camera:FlxCamera):FlxRect {
		// thx ne_eo for the fix
		var sclx = scale.x;
		var scly = scale.y;
	   	scale.x = Math.abs(scale.x);
		scale.y = Math.abs(scale.y);
		var bounds = super.getScreenBounds(newRect, camera);
		scale.x = sclx;
		scale.y = scly;
		return bounds;
	}
}