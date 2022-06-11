import 'package:cycling_escape/repository/shared_prefs/local/local_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
abstract class NameRepository {
  @factoryMethod
  factory NameRepository(LocalStorage localStorage) = _NameRepository;

  Map<int, String> get names;

  String getName(int id);

  void setName(int id, String name);
}

class _NameRepository implements NameRepository {
  final LocalStorage _localStorage;
  final _names = <int, String>{};
  static const _defaultCyclisNames = <int, String>{
    21: 'T. PAGOČOR',
    22: 'J. ELMAIDA',
    23: 'J. AYUSA PESQUERO',
    24: 'B. MCNYLTU',
    25: 'D. ILUSSU',
    31: 'M. VEN DAR PEOL',
    32: 'T. MIRLEER',
    33: 'J. PHELIPSIN',
    34: 'X. MEIRUSSE',
    35: 'D. DO BENDT',
    41: 'A. VLOSAV',
    42: 'S. HAGUITI GIRCAA',
    43: 'J. HENDLIY',
    44: 'L. KÄNMA',
    45: 'D. VON PAPPEL',
    51: 'W. VEN AART',
    52: 'P. RIGLOČ',
    53: 'C. LOPARTE',
    54: 'J. VENGIGAARD RUSMESSEN',
    55: 'T. BONOET',
    61: 'R. OVENEPEEL',
    62: 'K. ESGREAN',
    63: 'J. ILAPHALIPPE',
    64: 'M. VENSAVENANT',
    65: 'F. SANÉCHÉL',
    71: 'D. MÍRTANEZ PEVODA',
    72: 'D. VEN BAARLA',
    73: 'R. CORAPAZ MANTENEGRO',
    74: 'M. KWIOTKAWSKI',
    75: 'C. RÍDROGUEZ CONA',
    81: 'B. GARMIY HUILA',
    82: 'A. KROSTIFF',
    83: 'A. POSQAALON',
    84: 'D. PIZZOVOVO',
    85: 'Q. HARMENS',
    91: 'M. MIHOROČ',
    92: 'D. TUENS',
    93: 'P. BALBIO LEPÓZ DA ARMENTIE',
    94: 'D. CURASO',
    95: 'M. LENDA MAANA',
  };

  @override
  Map<int, String> get names {
    _fillNamesIfEmpty();
    return _names;
  }

  _NameRepository(this._localStorage);

  void _fillNamesIfEmpty() {
    if (_names.isEmpty) _names.addAll(_localStorage.cyclistNames);
    if (_names.isEmpty) _names.addAll(_defaultCyclisNames);
  }

  @override
  String getName(int id) {
    _fillNamesIfEmpty();
    return _names[id] ?? '';
  }

  @override
  void setName(int id, String name) {
    _names[id] = name;
    _localStorage.setCyclistNames(_names);
  }
}
