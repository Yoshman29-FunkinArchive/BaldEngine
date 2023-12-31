package game;

import flixel.util.FlxSignal;

class GameStats {
	public function new() {}

	public var onChange:FlxTypedSignal<GameStats->Void> = new FlxTypedSignal<GameStats->Void>();

	// PUBLIC VARIABLES
	public var score(get, set):Int;
	public var misses(get, set):Int;
	public var accuracy(get, null):Float;
	public var healthMultiplier:Float = 1;
	public var combo:Int = 0;

	// PRIVATE VARIABLES
	private var _score:Int = 0;
	private var _misses:Int = 0;
	private var _accuracy_amount:Float = 0;
	private var _accuracy_value:Float = 0;

	// GETTER / SETTERS
	private inline function get_score()
		return _score;
	private inline function set_score(score:Int) {
		if (_score != (_score = score))
			onChange.dispatch(this);
		return _score;
	}

	private inline function get_misses()
		return _misses;
	private inline function set_misses(misses:Int) {
		if (_misses != (_misses = misses))
			onChange.dispatch(this);
		return _misses;
	}

	private inline function get_accuracy()
		return (_accuracy_amount == 0) ? 0 : (_accuracy_value / _accuracy_amount) * 100;

	public function updateAccuracy(acc:Float, factor:Float = 1) {
		_accuracy_amount += factor;
		_accuracy_value += acc;
		onChange.dispatch(this);
	}

	public function calculateRating(note:Note) {
		if (note.isSustainNote) {
			_accuracy_amount += 0.25;
			_accuracy_value += 0.25;
			PlayState.instance.health += 0.002 * healthMultiplier;
			return;
		}
		var diff = Math.abs(note.time - Conductor.instance.songPosition) / note.latePressWindow;

		var rating:Rating = SICK;
		if (diff > 0.9) {
			rating = SHIT;
		} else if (diff > 0.75) {
			rating = BAD;
		} else if (diff > 0.2) {
			rating = GOOD;
		}

		switch(rating) {
			case SICK:
				_accuracy_amount += 1;
				_accuracy_value += 1;
				_score += 300;
			case GOOD:
				_accuracy_amount += 1;
				_accuracy_value += 0.80;
				_score += 200;
			case BAD:
				_accuracy_amount += 1;
				_accuracy_value += 0.45;
				_score += 100;
			case SHIT:
				_accuracy_amount += 1;
				_accuracy_value += 0.25;
				_score += 50;
			default:
				// no need to update
				return;
		}

		combo++;
		showRating(Std.string(rating));
		PlayState.instance.health += 0.0115 * healthMultiplier;

		onChange.dispatch(this);
	}

	public function showRating(rating:String) {
		PlayState.instance.stage.ratings.showRating(rating, combo);
		PlayState.instance.modchartHandler.onRatingShown();
	}
	public function miss() {
		_misses++;
		_accuracy_amount += 1;
		PlayState.instance.health -= 0.02375 * healthMultiplier;

		if (combo != (combo = 0))
			showRating(null);
		onChange.dispatch(this);
		PlayState.instance.modchartHandler.onMissed();
	}

	public function toString() {
		return 'Score:${score} • Misses:${misses} • Accuracy:${FlxMath.roundDecimal(accuracy, 2)}%';
	}

	public function getSaveData() {
		return {
			score: score,
			misses: misses,
			accuracy: accuracy
		};
	}
}

enum abstract Rating(Int) {
	var SICK = 0;
	var GOOD = 1;
	var BAD = 2;
	var SHIT = 3;

	public function toString() {
		return switch(cast(this, Rating)) {
			case SICK: "sick";
			case GOOD: "good";
			case BAD: "bad";
			case SHIT: "shit";
			default: null;
		}
	}
}