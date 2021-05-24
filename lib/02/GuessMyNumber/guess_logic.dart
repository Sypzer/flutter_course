import 'dart:math';

class GuessLogic {
  String _youTriedTxt;
  String _adviceTxt;
  String _buttonTxt;

  Random _random = new Random();

  bool _buttonToReset;
  bool _guessed;

  int _randomInt;

  void initializeLogic() {
    _randomInt = _random.nextInt(100);
    _buttonToReset = false;
    _guessed = false;
    _buttonTxt = 'Guess';
  }

  void setButtonToReset() {
    _buttonTxt = 'Reset';
    _buttonToReset = true;
  }

  bool guess(int input) {
    _guessed = true;
    _youTriedTxt = 'You tried $input';
    if (input > _randomInt) {
      _adviceTxt = 'Try lower!';
    } else if (input < _randomInt) {
      _adviceTxt = 'Try higher!';
    } else {
      _adviceTxt = 'You guessed right!';
      _buttonToReset = true;
      return true;
    }
    return false;
  }

  String get adviceTxt => _adviceTxt;

  String get youTriedTxt => _youTriedTxt;

  bool get guessed => _guessed;

  String get buttonTxt => _buttonTxt;

  bool get buttonToReset => _buttonToReset;
}
