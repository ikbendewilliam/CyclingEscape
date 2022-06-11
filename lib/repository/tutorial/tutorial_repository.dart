import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/repository/shared_prefs/local/local_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
abstract class TutorialRepository {
  @factoryMethod
  factory TutorialRepository(LocalStorage localStorage) = _TutorialRepository;

  late int toursFinished;

  bool hasViewed(TutorialType type);

  void save();

  void addViewed(TutorialType type);
}

class _TutorialRepository implements TutorialRepository {
  final LocalStorage _localStorage;
  late final Set<TutorialType> _typesViewed = _localStorage.typesViewed;
  @override
  late int toursFinished = _localStorage.toursFinished;

  _TutorialRepository(this._localStorage);

  @override
  bool hasViewed(TutorialType type) => _typesViewed.contains(type);

  @override
  void save() {
    _localStorage.toursFinished = toursFinished;
    _localStorage.typesViewed = _typesViewed;
  }

  @override
  void addViewed(TutorialType type) {
    _typesViewed.add(type);
    save();
  }
}
