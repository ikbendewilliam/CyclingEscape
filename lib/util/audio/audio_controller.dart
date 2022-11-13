import 'package:audio_session/audio_session.dart';
import 'package:collection/collection.dart';
import 'package:cycling_escape/repository/shared_prefs/local/local_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';

@singleton
class AudioController {
  static const _audioFolder = 'assets/audio';
  static const String _backgroundMusic = '$_audioFolder/background_music.mp3';
  static const String _buttonPress = '$_audioFolder/button_press.mp3';
  static const String _dice = '$_audioFolder/dice.mp3';

  final _players = <AudioPlayer, String>{};
  final LocalStorage _localStorage;

  AudioController(this._localStorage) {
    _configureSession();
  }

  Future<void> _configureSession() async {
    final session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.ambient,
        androidAudioAttributes: AndroidAudioAttributes(
          usage: AndroidAudioUsage.game,
          contentType: AndroidAudioContentType.music,
        ),
        androidWillPauseWhenDucked: true,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers,
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
      ),
    );
  }

  void playBackgroundMusic() {
    if (!_localStorage.musicEnabled) return;
    if (_players.containsValue(_backgroundMusic)) return;
    _play(_backgroundMusic, loop: true);
  }

  void playButtonPress() {
    if (!_localStorage.soundEnabled) return;
    _play(_buttonPress);
  }

  void playDice() {
    if (!_localStorage.soundEnabled) return;
    _play(_dice);
  }

  void stopBackgroundMusic() {
    _players.entries.firstWhereOrNull((element) => element.value == _backgroundMusic)?.key.stop();
  }

  Future<void> _play(String asset, {bool loop = false}) async {
    final player = AudioPlayer();
    await player.setAsset(asset);
    _players.addAll({
      player: asset,
    });
    if (loop) await player.setLoopMode(LoopMode.one);
    await player.play();
    await player.dispose();
    _players.remove(player);
  }
}
