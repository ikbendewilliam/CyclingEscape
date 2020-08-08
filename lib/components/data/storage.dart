import 'dart:ui';

import 'package:CyclingEscape/components/positions/gameMap.dart';

class Storage {
  static loadGameData() {}
  static saveGameData(data) {}
}

// class GameData {
//   GameMap gameMap;
//   List<Cyclists> cyclists;
//   List<Teams> teams;

//   GameData({this.gameMap, this.cyclists, this.teams});

//   GameData.fromJson(Map<String, dynamic> json) {
//     gameMap =
//         json['gameMap'] != null ? new GameMap.fromJson(json['gameMap']) : null;
//     if (json['cyclists'] != null) {
//       cyclists = new List<Cyclists>();
//       json['cyclists'].forEach((v) {
//         cyclists.add(new Cyclists.fromJson(v));
//       });
//     }
//     if (json['teams'] != null) {
//       teams = new List<Teams>();
//       json['teams'].forEach((v) {
//         teams.add(new Teams.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.gameMap != null) {
//       data['gameMap'] = this.gameMap.toJson();
//     }
//     if (this.cyclists != null) {
//       data['cyclists'] = this.cyclists.map((v) => v.toJson()).toList();
//     }
//     if (this.teams != null) {
//       data['teams'] = this.teams.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class OffsetFromJSON {
//   static Offset fromJson(Map<String, dynamic> json) {
//     return Offset(json['dx'], json['dy']);
//   }

//   static Map<String, dynamic> toJson(Offset offset) {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['dx'] = offset.dx;
//     data['dy'] = offset.dy;
//     return data;
//   }
// }

// class Sprints {
//   String id;
//   String type;
//   int angle;
//   int segment;
//   int width;
//   List<CyclistPlaces> cyclistPlaces;
//   P1 offset;

//   Sprints(
//       {this.id,
//       this.type,
//       this.angle,
//       this.segment,
//       this.width,
//       this.cyclistPlaces,
//       this.offset});

//   Sprints.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     type = json['type'];
//     angle = json['angle'];
//     segment = json['segment'];
//     width = json['width'];
//     if (json['cyclistPlaces'] != null) {
//       cyclistPlaces = new List<CyclistPlaces>();
//       json['cyclistPlaces'].forEach((v) {
//         cyclistPlaces.add(new CyclistPlaces.fromJson(v));
//       });
//     }
//     offset = json['offset'] != null ? new P1.fromJson(json['offset']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['type'] = this.type;
//     data['angle'] = this.angle;
//     data['segment'] = this.segment;
//     data['width'] = this.width;
//     if (this.cyclistPlaces != null) {
//       data['cyclistPlaces'] =
//           this.cyclistPlaces.map((v) => v.toJson()).toList();
//     }
//     if (this.offset != null) {
//       data['offset'] = this.offset.toJson();
//     }
//     return data;
//   }
// }

// class CyclistPlaces {
//   String cyclist;
//   int value;
//   bool displayed;

//   CyclistPlaces({this.cyclist, this.value, this.displayed});

//   CyclistPlaces.fromJson(Map<String, dynamic> json) {
//     cyclist = json['cyclist'];
//     value = json['value'];
//     displayed = json['displayed'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['cyclist'] = this.cyclist;
//     data['value'] = this.value;
//     data['displayed'] = this.displayed;
//     return data;
//   }
// }

// class Cyclists {
//   int number;
//   int rank;
//   String team;
//   int lastUsedOnTurn;
//   String lastPosition;

//   Cyclists(
//       {this.number,
//       this.rank,
//       this.team,
//       this.lastUsedOnTurn,
//       this.lastPosition});

//   Cyclists.fromJson(Map<String, dynamic> json) {
//     number = json['number'];
//     rank = json['rank'];
//     team = json['team'];
//     lastUsedOnTurn = json['lastUsedOnTurn'];
//     lastPosition = json['lastPosition'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['number'] = this.number;
//     data['rank'] = this.rank;
//     data['team'] = this.team;
//     data['lastUsedOnTurn'] = this.lastUsedOnTurn;
//     data['lastPosition'] = this.lastPosition;
//     return data;
//   }
// }

// class Teams {
//   bool isPlayer;
//   int numberStart;
//   List<String> cyclists;

//   Teams({this.isPlayer, this.numberStart, this.cyclists});

//   Teams.fromJson(Map<String, dynamic> json) {
//     isPlayer = json['isPlayer'];
//     numberStart = json['numberStart'];
//     cyclists = json['cyclists'].cast<String>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['isPlayer'] = this.isPlayer;
//     data['numberStart'] = this.numberStart;
//     data['cyclists'] = this.cyclists;
//     return data;
//   }
// }

/* Data used to generate class (https://javiercbk.github.io/json_to_dart/)
{
    "gameMap": {
        "positions": [{
            "id": "",
            "curvature": 0,
            "segment": 0,
            "isCurved": false,
            "isLast": false,
            "i": 0.0,
            "iValue": 0.0,
            "j": 0.0,
            "sprint": "",
            "positionType": "",
            "p1": {"dx": 0.0, "dy": 0.0},
            "p2": {"dx": 0.0, "dy": 0.0},
            "fieldValue": 0.0,
            "connections": [""],
            "cyclist": [""],
            "state": ""
        }],
        "sprints": [{
            "id": "",
            "type": "",
            "angle": 0.0,
            "segment": 0,
            "width": 0,
            "cyclistPlaces": [{
                "cyclist": "",
                "value": 0.0,
                "displayed": false
            }],
            "offset": {"dx": 0.0, "dy": 0.0}
        }]
    },
    "cyclists": [{
        "number": 0,
        "rank": 0,
        "team": "",
        "lastUsedOnTurn": 0,
        "lastPosition": ""
    }],
    "teams": [{
        "isPlayer": false,
        "numberStart": 0,
        "cyclists": [""]
    }]
}
*/
