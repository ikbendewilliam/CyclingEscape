import 'package:app_review/app_review.dart';
import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/model/gamedata/career.dart';
import 'package:cycling_escape/repository/shared_prefs/local/local_storage.dart';
import 'package:cycling_escape/repository/tutorial/tutorial_repository.dart';
import 'package:cycling_escape/screen_game/game_manager.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:cycling_escape/widget_game/positions/sprint.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class GameViewModel with ChangeNotifierEx {
  late final GameNavigator _navigator;
  late final GameManager _gameManager;
  final TutorialRepository _tutorialRepository;
  final LocalStorage _localStorage;
  final SpriteManager _spriteManager;

  GameManager get gameManager => _gameManager;

  GameViewModel(
    this._tutorialRepository,
    this._localStorage,
    this._spriteManager,
  );

  Future<void> init(
    GameNavigator navigator,
    Localization _localizations,
  ) async {
    _gameManager = GameManager(
      localizations: _localizations,
      spriteManager: _spriteManager,
      openTutorial: _openTutorial,
      localStorage: _localStorage,
      onEndCycling: _onEndCycling,
      onPause: _onPause,
      onSelectFollow: () => FollowType.autoFollow, // TODO
      playerTeam: null, // TODO
      career: Career(riders: 2, raceTypes: 2, rankingTypes: 2, cash: 100), // TODO
    );
    _navigator = navigator;
  }

  Future<void> _onEndCycling(List<Sprint>? sprints) async {
    print('race ended');
  }

  Future<void> _onPause() async {}

  Future<void> _openTutorial(TutorialType type) async {
    if (type == TutorialType.tourFirstFinished) {
      _tutorialRepository.toursFinished = _tutorialRepository.toursFinished + 1;
      _tutorialRepository.save();
      if (_tutorialRepository.toursFinished == 5) {
        await AppReview.requestReview;
      }
    }
    if (!_tutorialRepository.hasViewed(type)) await _navigator.openTutorial(type);
  }
}

mixin GameNavigator {
  Future<void> openTutorial(TutorialType type);
}
