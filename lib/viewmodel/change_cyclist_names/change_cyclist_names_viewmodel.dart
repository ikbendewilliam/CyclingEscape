import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/repository/name/name_repository.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangeCyclistNamesViewModel with ChangeNotifierEx {
  late final ChangeCyclistNamesNavigator _navigator;
  final NameRepository _nameRepository;
  final _names = <int, String>{};

  Map<int, String> get names => _names;

  ChangeCyclistNamesViewModel(
    this._nameRepository,
  );

  Future<void> init(ChangeCyclistNamesNavigator navigator) async {
    _navigator = navigator;
    _names.addAll(_nameRepository.names);
  }

  void _nameChanged(int key, String value) {
    _names[key] = value;
    _nameRepository.setName(key, value);
    notifyListeners();
  }

  Future<void> onEditNamePressed(int key, String value) async {
    final newName = await _navigator.editName(value);
    if (newName.isNullOrEmpty || newName == value) return;
    _nameChanged(key, newName!);
  }

  void onClosePressed() => _navigator.goBack<void>();
}

mixin ChangeCyclistNamesNavigator implements BackNavigator {
  Future<String?> editName(String value);
}
