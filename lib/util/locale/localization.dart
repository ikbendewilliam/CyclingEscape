import 'dart:convert';

import 'package:cycling_escape/util/locale/localization_keys.dart';
import 'package:cycling_escape/util/locale/localization_overrides.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

//============================================================//
//THIS FILE IS AUTO GENERATED. DO NOT EDIT//
//============================================================//
class Localization {
  var _localisedValues = <String, dynamic>{};
  var _localisedOverrideValues = <String, dynamic>{};

  static Localization of(BuildContext context) => Localizations.of<Localization>(context, Localization)!;

  /// The locale is used to get the correct json locale.
  /// It can later be used to check what the locale is that was used to load this Localization instance.
  final Locale locale;

  Localization({required this.locale});

  static Future<Localization> load(Locale locale, {
    LocalizationOverrides? localizationOverrides,
    bool showLocalizationKeys = false,
    bool useCaching = true,
    }) async {
    final localizations = Localization(locale: locale);
    if (showLocalizationKeys) {
      return localizations;
    }
    if (localizationOverrides != null) {
      final overrideLocalizations = await localizationOverrides.getOverriddenLocalizations(locale);
      localizations._localisedOverrideValues = overrideLocalizations;
    }
    final jsonContent = await rootBundle.loadString('assets/locale/${locale.toLanguageTag()}.json', cache: useCaching);
    localizations._localisedValues = json.decode(jsonContent) as Map<String, dynamic>; // ignore: avoid_as
    return localizations;
  }

  String _t(String key, {List<dynamic>? args}) {
    try {
      final value = (_localisedOverrideValues[key] ?? _localisedValues[key]) as String?;
      if (value == null) return key;
      if (args == null || args.isEmpty) return value;
      var newValue = value;
      // ignore: avoid_annotating_with_dynamic
      args.asMap().forEach((index, dynamic arg) => newValue = _replaceWith(newValue, arg, index + 1));
      return newValue;
    } catch (e) {
      return '⚠$key⚠';
    }
  }

  String _replaceWith(String value, Object? arg, int argIndex) {
    if (arg == null) return value;
    if (arg is String) {
      return value.replaceAll('%$argIndex\$s', arg);
    } else if (arg is num) {
      return value.replaceAll('%$argIndex\$d', '$arg');
    }
    return value;
  }

  /// Translations:
  ///
  /// en:  **'continue'**
  ///
  /// nl:  **'Verder'**
  ///
  /// fr:  **'continuer'**
  ///
  /// es:  **'continuar'**
  String get continueButton => _t(LocalizationKeys.continueButton);

  /// Translations:
  ///
  /// en:  **'career'**
  ///
  /// nl:  **'Cariere'**
  ///
  /// fr:  **'carrière'**
  ///
  /// es:  **'carrera'**
  String get careerButton => _t(LocalizationKeys.careerButton);

  /// Translations:
  ///
  /// en:  **'Info'**
  ///
  /// nl:  **'Info'**
  ///
  /// fr:  **'Info'**
  ///
  /// es:  **'Información'**
  String get careerInfoTitle => _t(LocalizationKeys.careerInfoTitle);

  /// Translations:
  ///
  /// en:  **'Congratulations, you have earned'**
  ///
  /// nl:  **'Proficiat, je verdient'**
  ///
  /// fr:  **'Félicitations, vous avez gagné'**
  ///
  /// es:  **'Enhorabuena, se ha ganado'**
  String get careerFinishedEarnings => _t(LocalizationKeys.careerFinishedEarnings);

  /// Translations:
  ///
  /// en:  **'You have:'**
  ///
  /// nl:  **'Je hebt:'**
  ///
  /// fr:  **'Vous avez:'**
  ///
  /// es:  **'Tienes:'**
  String get careerMoney => _t(LocalizationKeys.careerMoney);

  /// Translations:
  ///
  /// en:  **'Local Race'**
  ///
  /// nl:  **'Locale Race'**
  ///
  /// fr:  **'Course locale'**
  ///
  /// es:  **'Raza local'**
  String get careerLocalRace => _t(LocalizationKeys.careerLocalRace);

  /// Translations:
  ///
  /// en:  **'National Race'**
  ///
  /// nl:  **'Nationale Race'**
  ///
  /// fr:  **'National Race'**
  ///
  /// es:  **'Raza Nacional'**
  String get careerNationalRace => _t(LocalizationKeys.careerNationalRace);

  /// Translations:
  ///
  /// en:  **'Continental Race'**
  ///
  /// nl:  **'Continentale Race'**
  ///
  /// fr:  **'Course continentale'**
  ///
  /// es:  **'Carrera continental'**
  String get careerContinentalRace => _t(LocalizationKeys.careerContinentalRace);

  /// Translations:
  ///
  /// en:  **'National Tour'**
  ///
  /// nl:  **'Nationale Ronde'**
  ///
  /// fr:  **'Tournée nationale'**
  ///
  /// es:  **'Tour Nacional'**
  String get careerNationalTour => _t(LocalizationKeys.careerNationalTour);

  /// Translations:
  ///
  /// en:  **'Continental Tour'**
  ///
  /// nl:  **'Continentale Ronde'**
  ///
  /// fr:  **'Continental Tour'**
  ///
  /// es:  **'Tour continental'**
  String get careerContinentalTour => _t(LocalizationKeys.careerContinentalTour);

  /// Translations:
  ///
  /// en:  **'International Race'**
  ///
  /// nl:  **'Internationale Race'**
  ///
  /// fr:  **'Course internationale'**
  ///
  /// es:  **'Carrera internacional'**
  String get careerInternationalRace => _t(LocalizationKeys.careerInternationalRace);

  /// Translations:
  ///
  /// en:  **'International Tour'**
  ///
  /// nl:  **'Internationale Ronde'**
  ///
  /// fr:  **'Tournée internationale'**
  ///
  /// es:  **'Gira internacional'**
  String get careerInternationalTour => _t(LocalizationKeys.careerInternationalTour);

  /// Translations:
  ///
  /// en:  **'World Tour'**
  ///
  /// nl:  **'Wereldronde'**
  ///
  /// fr:  **'World Tour'**
  ///
  /// es:  **'Gira mundial'**
  String get careerWorldTour => _t(LocalizationKeys.careerWorldTour);

  /// Translations:
  ///
  /// en:  **'Winner gets:'**
  ///
  /// nl:  **'Winnaar krijgt:'**
  ///
  /// fr:  **'Le gagnant obtient:'**
  ///
  /// es:  **'El ganador obtiene:'**
  String get careerWinnerEarnings => _t(LocalizationKeys.careerWinnerEarnings);

  /// Translations:
  ///
  /// en:  **'Unlock in upgrades'**
  ///
  /// nl:  **'Speel vrij in upgrades'**
  ///
  /// fr:  **'Déverrouiller dans les mises à niveau'**
  ///
  /// es:  **'Desbloquear en actualizaciones'**
  String get careerBlocked => _t(LocalizationKeys.careerBlocked);

  /// Translations:
  ///
  /// en:  **'Riders for other teams:'**
  ///
  /// nl:  **'Renners in andere teams:'**
  ///
  /// fr:  **'Coureurs pour d'autres équipes:'**
  ///
  /// es:  **'Pilotos de otros equipos:'**
  String get careerRaceRiders => _t(LocalizationKeys.careerRaceRiders);

  /// Translations:
  ///
  /// en:  **'Map Length:'**
  ///
  /// nl:  **'Map Lengte:'**
  ///
  /// fr:  **'Longueur de la carte:'**
  ///
  /// es:  **'Longitud del mapa:'**
  String get careerRaceDuration => _t(LocalizationKeys.careerRaceDuration);

  /// Translations:
  ///
  /// en:  **'Map Type:'**
  ///
  /// nl:  **'Map Type:'**
  ///
  /// fr:  **'Type de carte:'**
  ///
  /// es:  **'Tipo de mapa:'**
  String get careerRaceType => _t(LocalizationKeys.careerRaceType);

  /// Translations:
  ///
  /// en:  **'Your riders'**
  ///
  /// nl:  **'Jouw renners'**
  ///
  /// fr:  **'Vos coureurs'**
  ///
  /// es:  **'Tus pasajeros'**
  String get upgradesRiders => _t(LocalizationKeys.upgradesRiders);

  /// Translations:
  ///
  /// en:  **'Rankings'**
  ///
  /// nl:  **'Rankings'**
  ///
  /// fr:  **'Rankings'**
  ///
  /// es:  **'Clasificaciones'**
  String get upgradesRankings => _t(LocalizationKeys.upgradesRankings);

  /// Translations:
  ///
  /// en:  **'Race type'**
  ///
  /// nl:  **'Race type'**
  ///
  /// fr:  **'Type de course'**
  ///
  /// es:  **'Tipo de carrera'**
  String get upgradesRaceTypes => _t(LocalizationKeys.upgradesRaceTypes);

  /// Translations:
  ///
  /// en:  **'single race'**
  ///
  /// nl:  **'enkele race'**
  ///
  /// fr:  **'course unique'**
  ///
  /// es:  **'carrera única'**
  String get singleRaceButton => _t(LocalizationKeys.singleRaceButton);

  /// Translations:
  ///
  /// en:  **'tour'**
  ///
  /// nl:  **'ronde'**
  ///
  /// fr:  **'tour'**
  ///
  /// es:  **'recorrido'**
  String get tourButton => _t(LocalizationKeys.tourButton);

  /// Translations:
  ///
  /// en:  **'save'**
  ///
  /// nl:  **'opslaan'**
  ///
  /// fr:  **'save'**
  ///
  /// es:  **'guardar'**
  String get saveButton => _t(LocalizationKeys.saveButton);

  /// Translations:
  ///
  /// en:  **'main menu'**
  ///
  /// nl:  **'hoofdmenu'**
  ///
  /// fr:  **'menu principal'**
  ///
  /// es:  **'menú principal'**
  String get mainMenuButton => _t(LocalizationKeys.mainMenuButton);

  /// Translations:
  ///
  /// en:  **'upgrades'**
  ///
  /// nl:  **'upgrades'**
  ///
  /// fr:  **'upgrades'**
  ///
  /// es:  **'actualizaciones'**
  String get upgradesButton => _t(LocalizationKeys.upgradesButton);

  /// Translations:
  ///
  /// en:  **'configure race'**
  ///
  /// nl:  **'stel race in'**
  ///
  /// fr:  **'configure race'**
  ///
  /// es:  **'configurar raza'**
  String get singleRaceTitle => _t(LocalizationKeys.singleRaceTitle);

  /// Translations:
  ///
  /// en:  **'Teams:'**
  ///
  /// nl:  **'Teams:'**
  ///
  /// fr:  **'Équipes:'**
  ///
  /// es:  **'Equipos:'**
  String get raceTeams => _t(LocalizationKeys.raceTeams);

  /// Translations:
  ///
  /// en:  **'Riders:'**
  ///
  /// nl:  **'renners:'**
  ///
  /// fr:  **'Coureurs:'**
  ///
  /// es:  **'Riders:'**
  String get raceRiders => _t(LocalizationKeys.raceRiders);

  /// Translations:
  ///
  /// en:  **'Type:'**
  ///
  /// nl:  **'Type:'**
  ///
  /// fr:  **'Type:'**
  ///
  /// es:  **'Tipo:'**
  String get raceType => _t(LocalizationKeys.raceType);

  /// Translations:
  ///
  /// en:  **'Flat'**
  ///
  /// nl:  **'vlak'**
  ///
  /// fr:  **'Plat'**
  ///
  /// es:  **'Plano'**
  String get raceTypeFlat => _t(LocalizationKeys.raceTypeFlat);

  /// Translations:
  ///
  /// en:  **'Cobbled'**
  ///
  /// nl:  **'kasseien'**
  ///
  /// fr:  **'Cobbled'**
  ///
  /// es:  **'Adoquinado'**
  String get raceTypeCobbled => _t(LocalizationKeys.raceTypeCobbled);

  /// Translations:
  ///
  /// en:  **'Hilled'**
  ///
  /// nl:  **'heuvels'**
  ///
  /// fr:  **'Hilled'**
  ///
  /// es:  **'Hilled'**
  String get raceTypeHilled => _t(LocalizationKeys.raceTypeHilled);

  /// Translations:
  ///
  /// en:  **'Heavy'**
  ///
  /// nl:  **'zwaar'**
  ///
  /// fr:  **'Lourd'**
  ///
  /// es:  **'Pesado'**
  String get raceTypeHeavy => _t(LocalizationKeys.raceTypeHeavy);

  /// Translations:
  ///
  /// en:  **'Length:'**
  ///
  /// nl:  **'Lengte:'**
  ///
  /// fr:  **'Longueur:'**
  ///
  /// es:  **'Longitud:'**
  String get raceDuration => _t(LocalizationKeys.raceDuration);

  /// Translations:
  ///
  /// en:  **'Short'**
  ///
  /// nl:  **'kort'**
  ///
  /// fr:  **'Court'**
  ///
  /// es:  **'Corto'**
  String get raceDurationShort => _t(LocalizationKeys.raceDurationShort);

  /// Translations:
  ///
  /// en:  **'Medium'**
  ///
  /// nl:  **'Medium'**
  ///
  /// fr:  **'Moyen'**
  ///
  /// es:  **'Medio'**
  String get raceDurationMedium => _t(LocalizationKeys.raceDurationMedium);

  /// Translations:
  ///
  /// en:  **'Long'**
  ///
  /// nl:  **'Lang'**
  ///
  /// fr:  **'Long'**
  ///
  /// es:  **'Long'**
  String get raceDurationLong => _t(LocalizationKeys.raceDurationLong);

  /// Translations:
  ///
  /// en:  **'Very Long'**
  ///
  /// nl:  **'Super Lang'**
  ///
  /// fr:  **'Très long'**
  ///
  /// es:  **'Muy largo'**
  String get raceDurationVeryLong => _t(LocalizationKeys.raceDurationVeryLong);

  /// Translations:
  ///
  /// en:  **'start a tour'**
  ///
  /// nl:  **'start een ronde'**
  ///
  /// fr:  **'démarrer une visite'**
  ///
  /// es:  **'iniciar un recorrido'**
  String get tourTitle => _t(LocalizationKeys.tourTitle);

  /// Translations:
  ///
  /// en:  **'Tour overview'**
  ///
  /// nl:  **'Touroverzicht'**
  ///
  /// fr:  **'Aperçu de la tour'**
  ///
  /// es:  **'Resumen del tour'**
  String get activeTourTitle => _t(LocalizationKeys.activeTourTitle);

  /// Translations:
  ///
  /// en:  **'current stadings after race [arg1 number] of [arg2 number]'**
  ///
  /// nl:  **'huidige stadings na race [arg1 number] of [arg2 number]'**
  ///
  /// fr:  **'Classement actuel après la course [arg1 number] de [arg2 number]'**
  ///
  /// es:  **'stadings actuales después de la carrera [arg1 number] de [arg2 number]'**
  String activeTourStandings(num arg1, num arg2) => _t(LocalizationKeys.activeTourStandings, args: <dynamic>[arg1, arg2]);

  /// Translations:
  ///
  /// en:  **'Results will show here after the first race'**
  ///
  /// nl:  **'Uitslagen worden hier getoond na de eerste race'**
  ///
  /// fr:  **'Les résultats seront affichés ici après la première course'**
  ///
  /// es:  **'Los resultados se mostrarán aquí después de la primera carrera'**
  String get activeTourFirstRace => _t(LocalizationKeys.activeTourFirstRace);

  /// Translations:
  ///
  /// en:  **'Your team'**
  ///
  /// nl:  **'Uw team'**
  ///
  /// fr:  **'Votre équipe'**
  ///
  /// es:  **'Tu equipo'**
  String get yourTeam => _t(LocalizationKeys.yourTeam);

  /// Translations:
  ///
  /// en:  **'Start next race'**
  ///
  /// nl:  **'Start volgende race'**
  ///
  /// fr:  **'Commencer la prochaine course'**
  ///
  /// es:  **'Iniciar la siguiente carrera'**
  String get nextRaceButton => _t(LocalizationKeys.nextRaceButton);

  /// Translations:
  ///
  /// en:  **'Finish'**
  ///
  /// nl:  **'Finish'**
  ///
  /// fr:  **'Finir'**
  ///
  /// es:  **'Finish'**
  String get finishButton => _t(LocalizationKeys.finishButton);

  /// Translations:
  ///
  /// en:  **'Warning, this will result in a long race!'**
  ///
  /// nl:  **'Waarschuwing, dit zal resulteren in een lange race!'**
  ///
  /// fr:  **'Avertissement, ceci entraînera une longue course !'**
  ///
  /// es:  **'¡Advertencia, esto resultará en una carrera larga!'**
  String get longRaceWarning => _t(LocalizationKeys.longRaceWarning);

  /// Translations:
  ///
  /// en:  **'There is already a tour in progress, do you want to continue or start a new one?'**
  ///
  /// nl:  **'Er is al een tour aan de gang, wil je doorgaan of een nieuwe starten?'**
  ///
  /// fr:  **'Il y a déjà une tour en cours, voulez-vous continuer ou en commencer une nouvelle ?'**
  ///
  /// es:  **'Ya hay un tour en curso, ¿quieres continuar o empezar uno nuevo?'**
  String get tourInProgressText => _t(LocalizationKeys.tourInProgressText);

  /// Translations:
  ///
  /// en:  **'Start new tour'**
  ///
  /// nl:  **'Start nieuwe tour'**
  ///
  /// fr:  **'Commencer une nouvelle visite'**
  ///
  /// es:  **'Iniciar nuevo tour'**
  String get startNewTourButton => _t(LocalizationKeys.startNewTourButton);

  /// Translations:
  ///
  /// en:  **'Warning, this will result in long races!'**
  ///
  /// nl:  **'Waarschuwing, dit zal resulteren in lange tochten!'**
  ///
  /// fr:  **'Attention, ceci entraînera des courses longues !'**
  ///
  /// es:  **'¡Advertencia, esto resultará en carreras largas!'**
  String get longTourWarning => _t(LocalizationKeys.longTourWarning);

  /// Translations:
  ///
  /// en:  **'back'**
  ///
  /// nl:  **'back'**
  ///
  /// fr:  **'Retour'**
  ///
  /// es:  **'back'**
  String get backButton => _t(LocalizationKeys.backButton);

  /// Translations:
  ///
  /// en:  **'start'**
  ///
  /// nl:  **'start'**
  ///
  /// fr:  **'start'**
  ///
  /// es:  **'start'**
  String get startButton => _t(LocalizationKeys.startButton);

  /// Translations:
  ///
  /// en:  **'races:'**
  ///
  /// nl:  **'races:'**
  ///
  /// fr:  **'courses:'**
  ///
  /// es:  **'carreras:'**
  String get tourRaces => _t(LocalizationKeys.tourRaces);

  /// Translations:
  ///
  /// en:  **'Understood'**
  ///
  /// nl:  **'Begrepen'**
  ///
  /// fr:  **'Compris'**
  ///
  /// es:  **'Entendido'**
  String get tutorialConfirm => _t(LocalizationKeys.tutorialConfirm);

  /// Translations:
  ///
  /// en:  **'OK'**
  ///
  /// nl:  **'OK'**
  ///
  /// fr:  **'OK'**
  ///
  /// es:  **'OK'**
  String get okButton => _t(LocalizationKeys.okButton);

  /// Translations:
  ///
  /// en:  **'Autofollow ask above threshold'**
  ///
  /// nl:  **'Autofollow vragen boven drempel'**
  ///
  /// fr:  **'Autofollow demander au-dessus du seuil'**
  ///
  /// es:  **'Autofollow pedir por encima del umbral'**
  String get settingsAutofollowAskAboveThreshold => _t(LocalizationKeys.settingsAutofollowAskAboveThreshold);

  /// Translations:
  ///
  /// en:  **'Music'**
  ///
  /// nl:  **'Muziek'**
  ///
  /// fr:  **'Musique'**
  ///
  /// es:  **'Música'**
  String get settingsEnableMusic => _t(LocalizationKeys.settingsEnableMusic);

  /// Translations:
  ///
  /// en:  **'Sound'**
  ///
  /// nl:  **'Geluid'**
  ///
  /// fr:  **'Son'**
  ///
  /// es:  **'Sonido'**
  String get settingsEnableSound => _t(LocalizationKeys.settingsEnableSound);

  /// Translations:
  ///
  /// en:  **'Change cyclist names'**
  ///
  /// nl:  **'Wijzig namen'**
  ///
  /// fr:  **'Changer les noms des cyclistes'**
  ///
  /// es:  **'Cambiar nombres de ciclistas'**
  String get changeNamesButton => _t(LocalizationKeys.changeNamesButton);

  /// Translations:
  ///
  /// en:  **'credits'**
  ///
  /// nl:  **'credits'**
  ///
  /// fr:  **'credits'**
  ///
  /// es:  **'Créditos'**
  String get creditsTitle => _t(LocalizationKeys.creditsTitle);

  /// Translations:
  ///
  /// en:  **'This game was developed by WiVe.\n\nThe following people made this possible! \n\nBart barto - riders sprite \nthedarkbear.itch.io/3-parallax - the background in the menus \nKenney.nl - for the icons and nature \nkidcomic.net - the icon \nSaranai - UI elements\nchosic.com/free-music/all/ (Komiku) - Music\nPixabay (102706) - Dice throw sound\nzapsplat.com - Button press sound'**
  ///
  /// nl:  **'Dit spel is ontwikkeld door WiVe.\n\n De volgende mensen hebben dit mede mogelijk gemaakt!\n\nBart barto - renners sprite\nthedarkbear.itch.io/3-parallax - de achtergrond in de menu's\nkenney.nl - voor de icoontjes en natuur\nkidcomic.net - het icon\nSaranai - UI elementen\nchosic.com/free-music/all/ (Komiku) - Music\nPixabay (102706) - Dice throw sound\nzapsplat.com - Button press sound'**
  ///
  /// fr:  **'Ce jeu a été développé par WiVe.\n\nLes personnes suivantes ont rendu cela possible ! \n\nBart barto - riders sprite \nthedarkbear.itch.io/3-parallax - le fond dans les menus \nKenney.nl - pour les icônes et la nature \nkidcomic.net - l'icône \nSaranai - Éléments d'interface utilisateur\nchosic.com/free-music/all/ (Komiku) - Music\nPixabay (102706) - Dice throw sound\nzapsplat.com - Button press sound'**
  ///
  /// es:  **'Este juego fue desarrollado por WiVe.\n\nLas siguientes personas lo han hecho posible \n\nBart barto - jinete sprite \nthedarkbear.itch.io/3-parallax - el fondo de los menús \nKenney.nl - para los iconos y la naturaleza \nkidcomic.net - el icono \nSaranai - Elementos de interfaz de usuario\nchosic.com/free-music/all/ (Komiku) - Music\nPixabay (102706) - Dice throw sound\nzapsplat.com - Button press sound'**
  String get creditsText => _t(LocalizationKeys.creditsText);

  /// Translations:
  ///
  /// en:  **'Change Cyclist names'**
  ///
  /// nl:  **'Wijzig namen'**
  ///
  /// fr:  **'Changer les noms des cyclistes'**
  ///
  /// es:  **'Cambiar nombres de ciclistas'**
  String get changeNamesTitle => _t(LocalizationKeys.changeNamesTitle);

  /// Translations:
  ///
  /// en:  **'Tour in progress'**
  ///
  /// nl:  **'Tour in uitvoering'**
  ///
  /// fr:  **'Tour en cours'**
  ///
  /// es:  **'Tour en progreso'**
  String get tourInProgressTitle => _t(LocalizationKeys.tourInProgressTitle);

  /// Translations:
  ///
  /// en:  **'Follow'**
  ///
  /// nl:  **'Volgen'**
  ///
  /// fr:  **'Suivez'**
  ///
  /// es:  **'Seguir'**
  String get followTitle => _t(LocalizationKeys.followTitle);

  /// Translations:
  ///
  /// en:  **'help'**
  ///
  /// nl:  **'help'**
  ///
  /// fr:  **'help'**
  ///
  /// es:  **'ayuda'**
  String get helpTitle => _t(LocalizationKeys.helpTitle);

  /// Translations:
  ///
  /// en:  **'Hello and welcome to the help page. You can find most information about the game on this page. If you were to have any more questions, don't hesitate to send me a mail.'**
  ///
  /// nl:  **'Hallo en welkom op de helppagina. Op deze pagina vind je de meeste informatie over het spel. Mocht je nog vragen hebben, aarzel dan niet om mij een mail te sturen.'**
  ///
  /// fr:  **'Bonjour et bienvenue sur la page d'aide. Vous trouverez la plupart des informations sur le jeu sur cette page. Si vous avez d'autres questions, n'hésitez pas à m'envoyer un mail.'**
  ///
  /// es:  **'Hola y bienvenido a la página de ayuda. Puedes encontrar la mayor parte de la información sobre el juego en esta página. Si tienes más preguntas, no dudes en enviarme un correo electrónico.'**
  String get helpHome1 => _t(LocalizationKeys.helpHome1);

  /// Translations:
  ///
  /// en:  **'If you enjoy the game (or don't) let me know by writing a review.'**
  ///
  /// nl:  **'Als je het spel leuk vindt (of niet), laat het me weten door een recensie te schrijven.'**
  ///
  /// fr:  **'Si vous aimez le jeu (ou non), faites-le moi savoir en écrivant une critique.'**
  ///
  /// es:  **'Si disfrutas del juego (o no), avísame escribiendo una reseña'**
  String get helpHome2 => _t(LocalizationKeys.helpHome2);

  /// Translations:
  ///
  /// en:  **'You can find information about the following topics:'**
  ///
  /// nl:  **'U kunt informatie vinden over de volgende onderwerpen:'**
  ///
  /// fr:  **'Vous pouvez trouver des informations sur les sujets suivants:'**
  ///
  /// es:  **'Puede encontrar información sobre los siguientes temas:'**
  String get helpHome3 => _t(LocalizationKeys.helpHome3);

  /// Translations:
  ///
  /// en:  **'Basics'**
  ///
  /// nl:  **'Basis'**
  ///
  /// fr:  **'Principes de base'**
  ///
  /// es:  **'Conceptos básicos'**
  String get helpBasicsTitle => _t(LocalizationKeys.helpBasicsTitle);

  /// Translations:
  ///
  /// en:  **'The goal of the game is to finish first. You do this by throwing the dice and selecting where you want to move. After you or the computer has moved, the cyclist that is right behind the one that just moved may be able to follow. If they can follow depends on some conditions (see below). The first one to cross the finish line (second white line) wins the race. How the points are distributed and time is calculated is explained in the Results tab of this help page.'**
  ///
  /// nl:  **'Het doel van het spel is om als eerste te eindigen. Dit doe je door de dobbelstenen te gooien en te selecteren waar je heen wilt. Nadat u of de computer zich heeft verplaatst, kan de fietser die vlak achter de zojuist verplaatste fietser staat volgen. Of ze kunnen volgen, hangt af van enkele voorwaarden (zie hieronder). De eerste die de finishlijn voorbijrijdt (tweede witte lijn) wint de race. Hoe de punten worden verdeeld en de tijd wordt berekend, wordt uitgelegd op het tabblad Resultaten van deze helppagina.'**
  ///
  /// fr:  **'Le but du jeu est de finir le premier. Pour ce faire, lancez les dés et sélectionnez l'endroit où vous voulez vous déplacer. Une fois que vous ou l'ordinateur avez bougé, le cycliste qui se trouve juste derrière celui qui vient de bouger peut être en mesure de suivre. S'ils peuvent suivre dépend de certaines conditions (voir ci-dessous). Le premier à franchir la ligne d'arrivée (deuxième ligne blanche) remporte la course. La répartition des points et le calcul du temps sont expliqués dans l'onglet Résultats de cette page d'aide. '**
  ///
  /// es:  **'El objetivo del juego es terminar primero. Para hacerlo, lanza los dados y selecciona dónde quieres moverte. Una vez que tú o la computadora se hayan movido, el ciclista que está justo detrás del que acaba de moverse Ser capaz de seguir. Si pueden seguir depende de algunas condiciones (ver más abajo). El primero en cruzar la línea de meta (segunda línea blanca) gana la carrera. Cómo se distribuyen los puntos y se calcula el tiempo se explica en la pestaña Resultados de esta página de ayuda. '**
  String get helpBasics1 => _t(LocalizationKeys.helpBasics1);

  /// Translations:
  ///
  /// en:  **'Following'**
  ///
  /// nl:  **'Volgen'**
  ///
  /// fr:  **'Suivi'**
  ///
  /// es:  **'Siguiente'**
  String get helpBasics2 => _t(LocalizationKeys.helpBasics2);

  /// Translations:
  ///
  /// en:  **'A very important aspect of the game is when to follow. Whenever the option to follow is shown it always shows you how much you would need to throw to get at that spot. A good rule of hand is that when you need at a 7 or more following is worth it. This is also what the computer uses as a threshold. You may notice that there is also an option to auto follow. Clicking this will say to the game that you will always follow whenever you need a 7 or more (you can change this in settings). Whenever you need less than a 7 to follow and you have already pressed auto previously it will still ask if you want to follow. This is because in some circumstances this may be a smart move. You can also disable this in settings.'**
  ///
  /// nl:  **'Een heel belangrijk aspect van het spel is wanneer je het moet volgen. Elke keer dat de optie die je moet volgen wordt getoond, laat het je altijd zien hoeveel je zou moeten gooien om op die plek te komen. Een goede handregel is dat wanneer je een 7 of meer nodig hebt, het de moeite waard is. Dit is ook wat de computer als drempel gebruikt. U merkt misschien dat er ook een optie is om automatisch te volgen. Als je hierop klikt, krijg je het spel te horen dat je altijd zult volgen wanneer je een 7 of meer nodig hebt (je kunt dit wijzigen in de instellingen). Als je minder dan een 7 nodig hebt om te volgen en je hebt al eerder op auto gedrukt, wordt er nog steeds gevraagd of je wilt volgen. Dit komt omdat dit in sommige omstandigheden een slimme zet kan zijn. U kunt dit ook uitschakelen in de instellingen.'**
  ///
  /// fr:  **'Un aspect très important du jeu est de savoir quand suivre. Chaque fois que l'option à suivre est affichée, elle vous montre toujours combien vous auriez besoin de lancer pour atteindre cet endroit. Une bonne règle de la main est que lorsque vous besoin de 7 abonnés ou plus en vaut la peine. C'est également ce que l'ordinateur utilise comme seuil. Vous remarquerez peut-être qu'il existe également une option de suivi automatique. Cliquer sur cette option indiquera au jeu que vous suivrez toujours chaque fois que vous en aurez besoin un 7 ou plus (vous pouvez le modifier dans les paramètres). Chaque fois que vous avez besoin de moins de 7 pour suivre et que vous avez déjà appuyé sur auto auparavant, il vous demandera toujours si vous voulez suivre. En effet, dans certaines circonstances, cela peut être une astuce déplacer. Vous pouvez également désactiver cette option dans les paramètres. '**
  ///
  /// es:  **'Un aspecto muy importante del juego es cuándo seguir. Siempre que se muestra la opción de seguir, siempre se muestra cuánto necesitarías lanzar para llegar a ese lugar. Una buena regla es que cuando si necesitas un seguimiento de 7 o más vale la pena. Esto también es lo que la computadora usa como umbral. Es posible que notes que también hay una opción para seguir automáticamente. Al hacer clic en esto, el juego le dirá que siempre lo seguirás cuando lo necesites. un 7 o más (puede cambiar esto en la configuración). Siempre que necesite menos de un 7 para seguir y ya haya presionado auto previamente, todavía le preguntará si desea seguir. Esto se debe a que en algunas circunstancias esto puede ser una buena idea mover. También puede desactivar esto en la configuración. '**
  String get helpBasics3 => _t(LocalizationKeys.helpBasics3);

  /// Translations:
  ///
  /// en:  **'Races, tours and career'**
  ///
  /// nl:  **'Races, rondes en carriere'**
  ///
  /// fr:  **'Courses, tournées et carrière'**
  ///
  /// es:  **'Carreras, giras y carrera'**
  String get helpBasics4 => _t(LocalizationKeys.helpBasics4);

  /// Translations:
  ///
  /// en:  **'These are explained in another tab, but in short you can decide if you want to play a single race. This is a quick race and is for when you only have a limited time or if you want to experiment with the game. Tours are longer events and consist of multiple races. Starting from the second race there will be special jerseys for the people that are first in a ranking.'**
  ///
  /// nl:  **'Deze worden uitgelegd in een ander tabblad, maar in het kort kun je beslissen of je een enkele race wilt spelen. Dit is een snelle race en is voor als je maar een beperkte tijd hebt of als je wilt experimenteren met het spel. Tours zijn langere evenementen en bestaan uit meerdere races. Vanaf de tweede race zijn er speciale truien voor de mensen die als eerste in een ranglijst staan.'**
  ///
  /// fr:  **'Ceux-ci sont expliqués dans un autre onglet, mais en bref, vous pouvez décider si vous voulez jouer une seule course. C'est une course rapide et c'est pour quand vous n'avez qu'un temps limité ou si vous voulez expérimenter avec le jeu. Les tournées sont des épreuves plus longues et se composent de plusieurs courses. À partir de la deuxième course, il y aura des maillots spéciaux pour les personnes qui sont premières dans un classement.'**
  ///
  /// es:  **'Estos se explican en otra pestaña, pero en resumen puedes decidir si quieres jugar una sola carrera. Esta es una carrera rápida y es para cuando solo tienes un tiempo limitado o si quieres experimentar con el Los recorridos son eventos más largos y constan de varias carreras. A partir de la segunda carrera, habrá camisetas especiales para las personas que ocupen el primer lugar en una clasificación. '**
  String get helpBasics5 => _t(LocalizationKeys.helpBasics5);

  /// Translations:
  ///
  /// en:  **'Career is more a campaign, you will start with only a single cyclist and your goal is to become the best team.'**
  ///
  /// nl:  **'Carrière is meer een campagne, je begint met slechts één wielrenner en je doel is om het beste team te worden.'**
  ///
  /// fr:  **'La carrière est plus une campagne, vous commencerez avec un seul cycliste et votre objectif est de devenir la meilleure équipe.'**
  ///
  /// es:  **'La carrera es más una campaña, comenzarás con un solo ciclista y tu objetivo es convertirte en el mejor equipo'**
  String get helpBasics6 => _t(LocalizationKeys.helpBasics6);

  /// Translations:
  ///
  /// en:  **'Map types'**
  ///
  /// nl:  **'Map types'**
  ///
  /// fr:  **'Types de carte'**
  ///
  /// es:  **'Tipos de mapas'**
  String get helpMapTypesTitle => _t(LocalizationKeys.helpMapTypesTitle);

  /// Translations:
  ///
  /// en:  **'You may notice when you are selecting a race or tour that there are different map types. For now there are 4 types, you have flat, cobbled, hilled and heavy. This will determine what road types are created. Flat are regular road pieces and will not include any special road. Cobbled will create cobbled road. These roads have a different colour and a negative value shown on them. This value is then subtracted if you start from this position. Be carefull with -4 for example as you can get stuck there for a whole turn if you throw 4 or lower. When you choose a hilled type, there are hills/mountains created. These first have red roads with a rising negative value that will be subtracted. These go from -1 to -5 which are very difficult to traverse. After the red comes yellow roads with positive value. These will be added to your dices' value. Standing on a +5 and throwing a 12 will get you as far as 17! tiles. These values only count when you stop on the tile. If you go over them the value isn't taken into account.'**
  ///
  /// nl:  **'Wanneer u een race of tour selecteert, merkt u misschien dat er verschillende map typen zijn. Voorlopig zijn er 4 soorten, je hebt plat, kasseien, heuvelachtig en zwaar. Dit zal bepalen welke wegtypen er worden gemaakt. Vlak zijn gewone wegdelen en bevatten geen speciale weg. Met keien wordt een kasseien weg gecreëerd. Deze wegen hebben een andere kleur en er staat een negatieve waarde op. Deze waarde wordt vervolgens afgetrokken als u vanuit deze positie start. Pas op met -4 bijvoorbeeld, want je kunt daar een hele beurt vast komen te zitten als je 4 of lager gooit. Wanneer je een heuvelachtig type kiest, worden er heuvels / bergen gecreëerd. Deze hebben eerst rode wegen met een stijgende negatieve waarde die wordt afgetrokken. Deze gaan van -1 tot -5 en zijn erg moeilijk te doorkruisen. Na het rood komen gele wegen met positieve waarde. Deze worden toegevoegd aan de waarde van uw dobbelstenen. Als je op een +5 staat en een 12 gooit, kom je tot 17! tegels. Deze waarden tellen alleen als je stopt op de tegel. Als je ze doorloopt, wordt er geen rekening gehouden met de waarde.'**
  ///
  /// fr:  **'Lorsque vous sélectionnez une course ou un circuit, vous remarquerez peut-être qu'il existe différents types de cartes. Pour l'instant, il existe 4 types, vous avez plat, pavé, vallonné et lourd. Cela déterminera les types de route créés. Plat sont des tronçons de route normaux et n'incluront aucune route spéciale. Le pavé créera une route pavée. Ces routes ont une couleur différente et une valeur négative affichée sur elles. Cette valeur est ensuite soustraite si vous partez de cette position. Faites attention avec -4 pour Par exemple, vous pouvez rester coincé là-bas pendant un tour entier si vous en lancez 4 ou moins. Lorsque vous choisissez un type de collines, des collines / montagnes sont créées. Celles-ci ont d'abord des routes rouges avec une valeur négative croissante qui sera soustraite. Celles-ci vont de -1 à -5 qui sont très difficiles à parcourir. Après le rouge, viennent les routes jaunes à valeur positive. Elles seront ajoutées à la valeur de vos dés. Se tenir sur un +5 et lancer un 12 vous amènera jusqu'à 17 tuiles! . Ces valeurs ne comptent que lorsque vous vous arrêtez sur la vignette. Si vous dépassez r eux, la valeur n'est pas prise en compte. '**
  ///
  /// es:  **'Al seleccionar una carrera o un recorrido, es posible que notes que hay diferentes tipos de mapas. Por ahora, hay 4 tipos: plano, adoquinado, con colinas y pesado. Esto determinará qué tipos de carreteras se crean. Plano son tramos de carretera regulares y no incluirán ninguna carretera especial. Empedrado creará una carretera empedrada. Estas carreteras tienen un color diferente y un valor negativo que se muestra en ellas. Este valor se resta si comienza desde esta posición. Tenga cuidado con -4 para Por ejemplo, puedes quedarte atascado allí durante un turno completo si arrojas 4 o menos. Cuando eliges un tipo de colina, se crean colinas / montañas. Estas primero tienen carreteras rojas con un valor negativo ascendente que se restará. Estas van de -1 a -5 que son muy difíciles de atravesar. Después del rojo vienen caminos amarillos con valor positivo. Estos se sumarán al valor de tus dados. Si estás en un +5 y lanzas un 12, llegarás hasta 17 fichas. . Estos valores solo cuentan cuando te detienes en el mosaico. Si pasas Para ellos, el valor no se tiene en cuenta. '**
  String get helpMapTypes1 => _t(LocalizationKeys.helpMapTypes1);

  /// Translations:
  ///
  /// en:  **'The last type is Heavy and that is a combination of all other types. This will include flat, cobbled, uphill and downhill road. Note that since cobbled is less difficult than hills heavy may create races that are less difficult than hilled.'**
  ///
  /// nl:  **'Het laatste type is zwaar en dat is een combinatie van alle andere typen. Dit omvat vlakke wegen, kasseien wegen, bergopwaarts en bergafwaarts. Merk op dat, aangezien kasseien minder moeilijk zijn dan heuvels, zwaar races kunnen creëren die minder moeilijk zijn dan heuvelachtig.'**
  ///
  /// fr:  **'Le dernier type est Heavy et c'est une combinaison de tous les autres types. Cela comprendra les routes plates, pavées, en montée et en descente. Notez que puisque le pavé est moins difficile que les collines lourdes peut créer des courses moins difficiles que hilled. '**
  ///
  /// es:  **'El último tipo es Heavy y es una combinación de todos los demás tipos. Esto incluirá carreteras llanas, adoquinadas, cuesta arriba y cuesta abajo. Ten en cuenta que, dado que el adoquín es menos difícil que las colinas, es posible que las carreras sean menos difíciles que colina. '**
  String get helpMapTypes2 => _t(LocalizationKeys.helpMapTypes2);

  /// Translations:
  ///
  /// en:  **'The maps are always randomly generated from options. This does not mean that all options are always used. You may select heavy and only have cobbled or even no special road.'**
  ///
  /// nl:  **'De map worden altijd willekeurig gegenereerd op basis van opties. Dit betekent niet dat alle opties altijd worden gebruikt. U kunt zwaar kiezen en alleen een kasseien of zelfs geen speciale weg hebben.'**
  ///
  /// fr:  **'Les cartes sont toujours générées aléatoirement à partir des options. Cela ne signifie pas que toutes les options sont toujours utilisées. Vous pouvez sélectionner des routes lourdes et n'avoir que des routes pavées ou même aucune route spéciale.'**
  ///
  /// es:  **'Los mapas siempre se generan aleatoriamente a partir de opciones. Esto no significa que siempre se utilicen todas las opciones. Puede seleccionar pesado y solo tener un camino empedrado o incluso ningún camino especial.'**
  String get helpMapTypes3 => _t(LocalizationKeys.helpMapTypes3);

  /// Translations:
  ///
  /// en:  **'Results/rankings'**
  ///
  /// nl:  **'Resultaten/rankings'**
  ///
  /// fr:  **'Résultats / classements'**
  ///
  /// es:  **'Resultados / clasificaciones'**
  String get helpResultsTitle => _t(LocalizationKeys.helpResultsTitle);

  /// Translations:
  ///
  /// en:  **'(points, mountain sprints, finish, ...)'**
  ///
  /// nl:  **'(punten, bergsprints, aankomst, ...)'**
  ///
  /// fr:  **'(points, sprints en montagne, arrivée, ...)'**
  ///
  /// es:  **'(puntos, sprints de montaña, meta, ...)'**
  String get helpResults1 => _t(LocalizationKeys.helpResults1);

  /// Translations:
  ///
  /// en:  **'In most races there are sprints (green lines), mountain sprints (red line) and there is always a start (white) and a finish (also white). These may earn you points for the apropriate ranking. Start is just an indication, sprints and mountains will earn respectivly 5, 3, 2 and 1 (mountain) point. The finish earns you respectivly 10, 7, 5, 4, 3, 2, 1.'**
  ///
  /// nl:  **'Bij de meeste races zijn er sprints (groene lijnen), bergsprints (rode lijn) en is er altijd een start (wit) en een finish (ook wit). Deze kunnen u punten opleveren voor de bijhorende rangschikking. Start is slechts een indicatie, sprints en bergen leveren respectievelijk 5, 3, 2 en 1 (berg) punt op. De finish levert respectief 10, 7, 5, 4, 3, 2, 1 op.'**
  ///
  /// fr:  **'Dans la plupart des courses, il y a des sprints (lignes vertes), des sprints en montagne (ligne rouge) et il y a toujours un départ (blanc) et une arrivée (également blanche). Celles-ci peuvent vous rapporter des points pour le classement approprié. est juste une indication, les sprints et les montagnes rapporteront respectivement 5, 3, 2 et 1 point (montagne). La finition vous rapporte respectivement 10, 7, 5, 4, 3, 2, 1. '**
  ///
  /// es:  **'En la mayoría de las carreras hay sprints (líneas verdes), sprints de montaña (línea roja) y siempre hay una salida (blanca) y una llegada (también blanca). Estos pueden ganar puntos para la clasificación apropiada. Salida es solo una indicación, los sprints y las montañas ganarán respectivamente 5, 3, 2 y 1 punto (montaña). La llegada te otorga respectivamente 10, 7, 5, 4, 3, 2, 1. '**
  String get helpResults2 => _t(LocalizationKeys.helpResults2);

  /// Translations:
  ///
  /// en:  **'Who is first?'**
  ///
  /// nl:  **'Wie is eerst?'**
  ///
  /// fr:  **'Qui est le premier?'**
  ///
  /// es:  **'¿Quién es el primero?'**
  String get helpResults3 => _t(LocalizationKeys.helpResults3);

  /// Translations:
  ///
  /// en:  **'The first one to pass is not always the rider that gets the most points. The positions are only calculated at the END of the turn. This means that at the start of the turn you may pass it first, but then during the turn 4 riders may pass you and take all the points of the sprint. The closest position to the end is used to know how far you are, so be carefull when there are turns after the sprint. When the end of the positions are on the same line, the rider on the right hand side is first.'**
  ///
  /// nl:  **'De eerste die aankomt, is niet altijd de rijder met de meeste punten. De posities worden pas berekend aan het EINDE van de beurt. Dit betekent dat je aan het begin van de beurt eerst mag passeren, maar dan mogen tijdens de beurt 4 renners je passeren en alle punten van de sprint pakken. De positie die het dichtst bij het einde ligt, wordt gebruikt om te weten hoe ver je bent, dus wees voorzichtig als er bochten zijn na de sprint. Wanneer het einde van de posities op dezelfde lijn ligt, is de renner aan de rechterkant de eerste.'**
  ///
  /// fr:  **'Le premier à passer n'est pas toujours le coureur qui obtient le plus de points. Les positions ne sont calculées qu'à la FIN du virage. Cela signifie qu'au début du virage, vous pouvez le passer en premier, mais ensuite pendant le virage, 4 coureurs peuvent vous dépasser et prendre tous les points du sprint. La position la plus proche de la fin est utilisée pour savoir à quelle distance vous êtes, soyez donc prudent quand il y a des virages après le sprint. sur la même ligne, le coureur du côté droit est le premier. '**
  ///
  /// es:  **'El primero en pasar no siempre es el ciclista que obtiene más puntos. Las posiciones solo se calculan al FINAL del turno. Esto significa que al principio del turno puedes pasarlo primero, pero luego durante el turno 4 corredores pueden adelantarte y tomar todos los puntos del sprint. La posición más cercana al final se usa para saber qué tan lejos estás, así que ten cuidado cuando hay giros después del sprint. Cuando el final de las posiciones es en la misma línea, el ciclista del lado derecho es el primero. '**
  String get helpResults4 => _t(LocalizationKeys.helpResults4);

  /// Translations:
  ///
  /// en:  **'Different rankings'**
  ///
  /// nl:  **'Andere rankings'**
  ///
  /// fr:  **'Différents classements'**
  ///
  /// es:  **'Diferentes clasificaciones'**
  String get helpResults5 => _t(LocalizationKeys.helpResults5);

  /// Translations:
  ///
  /// en:  **'There are a few different rankings. Time, young, points, mountain and team. Time is the most important one and is calculated on how many turns it takes you to finish. This means that when you finish one turn after the first finisher you get +1 time. The one with the least time is the winner and may wear the yellow jersey. Young is calculated in the same way, however only riders with a number ending in a 1 or 2 are eligable. Other riders will not count towards this ranking. The first in the young ranking may wear the white jersey. Points is simpler, you gain points by finishing in the top 7 or passing a sprint in the top 4 (see above for the exact points). The first in the point ranking can wear the green jersey. The mountain ranking is similar to the point ranking with the only difference that you can only earn mountain points (mp) in sprints. The first in the mountain ranking may wear the polka dot jersey. The team ranking is a bit different. This uses the total of all of your riders in time and adds it together. The team with the less time wins this ranking, but there is no special jersey for this.'**
  ///
  /// nl:  **'Er zijn een paar verschillende ranglijsten. Tijd, jong, punten, berg en team. Tijd is de belangrijkste en wordt berekend op basis van het aantal beurten dat je nodig hebt om te voltooien. Dit betekent dat als je een beurt na de eerste finisher voltooit, je +1 tijd krijgt. Degene met de minste tijd is de winnaar en mag de gele trui dragen. Jongeren worden op dezelfde manier berekend, maar alleen rijders met een nummer dat eindigt op een 1 of 2 komen in aanmerking. Andere renners tellen niet mee voor dit klassement. De eerste van de jonge ranglijst mag de witte trui dragen. Punten is eenvoudiger, je verdient punten door in de top 7 te eindigen of door een sprint in de top 4 te halen (zie hierboven voor de exacte punten). De eerste in het puntenklassement mag de groene trui dragen. Het bergklassement is vergelijkbaar met het puntenklassement met als enige verschil dat je alleen bergpunten (mp) kunt verdienen in bergsprints. De eerste van het bergklassement mag de bolletjestrui dragen. De teamrangschikking is een beetje anders. Dit gebruikt het totaal van al je rijders in de tijd en telt deze bij elkaar op. Het team met de minste tijd wint deze ranking, maar hiervoor is geen speciale trui.'**
  ///
  /// fr:  **'Il existe différents classements. Temps, jeune, points, montagne et équipe. Le temps est le plus important et est calculé en fonction du nombre de tours qu'il vous faut pour terminer. Cela signifie que lorsque vous terminez un tour après le premier finisseur vous gagnez +1. Celui qui a le moins de temps est le vainqueur et peut porter le maillot jaune. Le jeune est calculé de la même manière, mais seuls les coureurs dont le numéro se termine par 1 ou 2 sont éligibles. Les autres coureurs ne comptera pas pour ce classement. Le premier du classement jeune peut porter le maillot blanc. Les points sont plus simples, vous gagnez des points en terminant dans le top 7 ou en passant un sprint dans le top 4 (voir ci-dessus pour les points exacts). Le premier du classement par points peut porter le maillot vert. Le classement de la montagne est similaire au classement par points avec la seule différence que vous ne pouvez gagner que des points de montagne (mp) dans les sprints. Le premier du classement de la montagne peut porter le maillot à pois. Le classement des équipes est un peu différent. Il utilise le total de tous l de vos coureurs dans le temps et les ajoute ensemble. L'équipe avec le moins de temps remporte ce classement, mais il n'y a pas de maillot spécial pour cela. '**
  ///
  /// es:  **'Hay algunas clasificaciones diferentes. Tiempo, joven, puntos, montaña y equipo. El tiempo es el más importante y se calcula en función de la cantidad de turnos que te lleva terminar. Esto significa que cuando terminas un turno después el primero en terminar, obtiene +1 vez. El que tenga menos tiempo es el ganador y puede usar el maillot amarillo. La juventud se calcula de la misma manera, sin embargo, solo los corredores con un número terminado en 1 o 2. Otros corredores no contará para esta clasificación. El primero en la clasificación joven puede usar la camiseta blanca. Los puntos es más simple, usted gana puntos terminando entre los 7 primeros o pasando un sprint entre los 4 primeros (ver arriba para los puntos exactos). el primero en el ranking de puntos puede usar el maillot verde. El ranking de montaña es similar al ranking de puntos con la única diferencia de que solo puede ganar puntos de montaña (mp) en sprints. El primero en el ranking de montaña puede usar el maillot de lunares. La clasificación del equipo es un poco diferente. Esto usa el total de al l de sus ciclistas en el tiempo y lo suma. El equipo con menos tiempo gana este ranking, pero no hay maillot especial para eso '**
  String get helpResults6 => _t(LocalizationKeys.helpResults6);

  /// Translations:
  ///
  /// en:  **'Tours'**
  ///
  /// nl:  **'Tours'**
  ///
  /// fr:  **'Visites'**
  ///
  /// es:  **'Tours'**
  String get helpToursTitle => _t(LocalizationKeys.helpToursTitle);

  /// Translations:
  ///
  /// en:  **'Tours are a combination of multiple races. Your first start is based on your team, but starting from the second race the start positions are based upon the time rankings of the tour. The rankings of each race are combined and shown at the end of each race. Starting from the second race certain riders will start wearing special jerseys. This is because they are first in one or more rankings. (If a rider is first in time and points, they will only wear the time jersey and the points jersey will not be worn that race).'**
  ///
  /// nl:  **'Tours zijn een combinatie van meerdere races. Je eerste start is gebaseerd op je team, maar vanaf de tweede race zijn de startposities gebaseerd op de tijdrangschikking van de tour. De klassementen van elke race worden gecombineerd en aan het einde van elke race getoond. Vanaf de tweede race zullen bepaalde renners speciale truien gaan dragen. Dit komt omdat ze als eerste staan in een of meer ranglijsten. (Als een renner eerste is in tijd en punten, zal hij alleen de tijdtrui dragen en zal de puntentrui die wedstrijd niet worden gedragen).'**
  ///
  /// fr:  **'Les circuits sont une combinaison de plusieurs courses. Votre premier départ est basé sur votre équipe, mais à partir de la deuxième course, les positions de départ sont basées sur le classement chronologique du circuit. Les classements de chaque course sont combinés et affichés à la fin de chaque course. À partir de la deuxième course, certains coureurs commenceront à porter des maillots spéciaux. En effet, ils sont premiers dans un ou plusieurs classements. (Si un coureur est premier en temps et points, il ne portera que le maillot chronométré et le maillot des points ne sera pas porté cette course). '**
  ///
  /// es:  **'Los recorridos son una combinación de varias carreras. Su primera salida se basa en su equipo, pero a partir de la segunda carrera, las posiciones de salida se basan en las clasificaciones de tiempo de la gira. Las clasificaciones de cada carrera se combinan y se muestran al final de cada carrera. A partir de la segunda carrera, ciertos ciclistas comenzarán a usar camisetas especiales. Esto se debe a que son los primeros en una o más clasificaciones. (Si un ciclista es el primero en tiempo y puntos, solo usará la camiseta de tiempo y el maillot de puntos no se usará en esa carrera). '**
  String get helpTours => _t(LocalizationKeys.helpTours);

  /// Translations:
  ///
  /// en:  **'Strategy'**
  ///
  /// nl:  **'Strategie'**
  ///
  /// fr:  **'Stratégie'**
  ///
  /// es:  **'Estrategia'**
  String get helpStrategyTitle => _t(LocalizationKeys.helpStrategyTitle);

  /// Translations:
  ///
  /// en:  **'To win you need to finish first, so you need to think about when to follow and which position to choose. Sometimes it is smart to not go all the available positions and instead of moving 10 for example only move 8. You can do this so you can follow the turn afterwards or to block a certain junction. In the same regard you should think about when to follow. In some instances it may be smart to follow a 6 or 5, while in other it is smart to not follow even a 10. Following a small number can be smart to ensure you get out of a sticky situation such as a mountain top or a difficult cobbled position. Another reason might be that the road is blocked so throwing a 10 will result in a similar situation. The last reason to follow a lower number is when you are behind and there is no one else to follow. It is as likely that they throw a 12 as you, so not following a 6, then throwing a 3 yourself and them throwing a high number would result in you being left behind alone. When you are certain you will finish (one or two tiles to go), you may decide to not follow a 10 for example. This will lose  you a certain second place, but with some luck may earn you the first place. This is less important if other riders have already finished and is dangerous when you are further away.'**
  ///
  /// nl:  **'Om te winnen moet je als eerste eindigen, dus je moet nadenken over wanneer je moet volgen en welke positie je moet kiezen. Soms is het slim om niet alle beschikbare posities te gaan en in plaats van 10 bijvoorbeeld alleen maar 8 te verplaatsen. Dit kun je doen zodat je de afslag achteraf kunt volgen of een bepaald kruispunt kunt blokkeren. In hetzelfde opzicht moet u nadenken over wanneer u moet volgen. In sommige gevallen kan het slim zijn om een ​​6 of 5 te volgen, terwijl het in andere gevallen slim is om niet eens een 10 te volgen. Het volgen van een klein aantal kan slim zijn om ervoor te zorgen dat je uit een lastige situatie komt, zoals een bergtop of een moeilijke geplaveide positie. Een andere reden zou kunnen zijn dat de weg geblokkeerd is, dus het gooien van een 10 zal in een vergelijkbare situatie resulteren. De laatste reden om een ​​lager nummer te volgen, is wanneer u achterloopt en er niemand anders is om te volgen. Het is net zo waarschijnlijk dat ze een 12 gooien als jij, dus als je geen 6 volgt, dan zelf een 3 gooit en ze een hoog getal gooien, zou je alleen achterblijven. Als je zeker weet dat je aankomt (nog een of twee tegels te gaan), kun je besluiten om bijvoorbeeld geen 10 te volgen. Hierdoor verlies je een zekere tweede plaats, maar met een beetje geluk kun je de eerste plaats verdienen. Dit is minder belangrijk als andere rijders al klaar zijn en is gevaarlijk als je verder weg bent.'**
  ///
  /// fr:  **'Pour gagner, vous devez terminer en premier, vous devez donc réfléchir à quand suivre et à quelle position choisir. Parfois, il est judicieux de ne pas parcourir toutes les positions disponibles et au lieu de déplacer 10 par exemple, ne déplacez que 8. Vous pouvez le faire pour suivre le virage par la suite ou pour bloquer une certaine intersection. De la même manière, vous devriez réfléchir au moment à suivre. Dans certains cas, il peut être judicieux de suivre un 6 ou un 5, tandis que dans d'autres, c'est intelligent ne pas suivre même un 10. Suivre un petit nombre peut être judicieux pour vous assurer de sortir d'une situation délicate comme un sommet de montagne ou une position pavée difficile. Une autre raison pourrait être que la route est bloquée, alors lancer un 10 entraînera une situation similaire. La dernière raison de suivre un nombre inférieur est lorsque vous êtes derrière et qu'il n'y a personne d'autre à suivre. Il est aussi probable qu'ils lancent un 12 que vous, donc ne pas suivre un 6, puis lancer un 3 vous-même et lancer un nombre élevé vous laisserait seul. Vous êtes certain que vous allez finir (une ou deux tuiles à faire), vous pouvez décider de ne pas suivre un 10 par exemple. Cela vous fera perdre une certaine deuxième place, mais avec un peu de chance, vous gagnerez peut-être la première place. Ceci est moins important si d'autres coureurs ont déjà terminé et est dangereux lorsque vous êtes plus loin. '**
  ///
  /// es:  **'Para ganar necesitas terminar primero, así que necesitas pensar cuándo seguir y qué posición elegir. A veces es inteligente no ir a todas las posiciones disponibles y en lugar de mover 10, por ejemplo, solo mover 8. Puede hacer esto para poder seguir el giro después o para bloquear un cruce determinado. En el mismo sentido, debe pensar en cuándo seguir. En algunos casos, puede ser inteligente seguir un 6 o 5, mientras que en otros es inteligente. no seguir ni siquiera un 10. Seguir un número pequeño puede ser inteligente para asegurarse de salir de una situación complicada, como la cima de una montaña o una posición difícil de adoquines. Otra razón podría ser que la carretera esté bloqueada, por lo que lanzar un 10 resultará en una situación similar. La última razón para seguir un número más bajo es cuando estás atrasado y no hay nadie más a quien seguir. Es tan probable que arrojen un 12 como tú, así que no sigas un 6, luego arrojes un 3 tú mismo y si arrojaran un número alto resultaría en que usted se quedara solo. Si está seguro de que terminará (faltan una o dos fichas), puede decidir no seguir un 10, por ejemplo. Esto le hará perder un cierto segundo lugar, pero con un poco de suerte puede ganarle el primer lugar. Esto es menos importante si otros ciclistas ya han terminado y es peligroso cuando estás más lejos '**
  String get helpStrategy => _t(LocalizationKeys.helpStrategy);

  /// Translations:
  ///
  /// en:  **'Settings'**
  ///
  /// nl:  **'Instellingen'**
  ///
  /// fr:  **'Paramètres'**
  ///
  /// es:  **'Configuración'**
  String get helpSettingsTitle => _t(LocalizationKeys.helpSettingsTitle);

  /// Translations:
  ///
  /// en:  **'There are a few settings that may improve your experience. The first two have to do with auto follow. You can decide the threshold, the number that you need to be able to follow automatically, and wether or not the game should ask if you want to follow when a lower value is needed. For example you set the threshold on 5 and ask on false. The game will then auto follow if you need a 5 to follow and automatically go to the next rider when they throw a 4.'**
  ///
  /// nl:  **'Er zijn een paar instellingen die uw ervaring kunnen verbeteren. De eerste twee hebben te maken met automatisch volgen. Je kunt de drempel bepalen, het aantal dat je nodig hebt om automatisch te kunnen volgen, en of het spel je moet vragen of je wilt volgen wanneer een lagere waarde nodig is. U stelt bijvoorbeeld de drempel op 5 en vraagt op false. Het spel zal dan automatisch volgen als je een 5 nodig hebt om te volgen en automatisch naar de volgende rijder gaan als deze een 4 gooit.'**
  ///
  /// fr:  **'Quelques paramètres peuvent améliorer votre expérience. Les deux premiers concernent le suivi automatique. Vous pouvez décider du seuil, du nombre que vous devez pouvoir suivre automatiquement et du jeu ou non. devrait vous demander si vous voulez suivre lorsqu'une valeur inférieure est nécessaire. Par exemple, vous définissez le seuil sur 5 et demandez sur false. Le jeu suivra alors automatiquement si vous avez besoin d'un 5 à suivre et passera automatiquement au cavalier suivant lorsqu'il lancera un 4. '**
  ///
  /// es:  **'Hay algunas configuraciones que pueden mejorar tu experiencia. Las dos primeras tienen que ver con el seguimiento automático. Puedes decidir el umbral, el número que necesitas poder seguir automáticamente y si el juego o no debe preguntar si desea seguir cuando se necesita un valor más bajo. Por ejemplo, establece el umbral en 5 y pregunta en falso. El juego se seguirá automáticamente si necesita un 5 para seguir y automáticamente irá al siguiente ciclista cuando arroje a 4. '**
  String get helpSettings1 => _t(LocalizationKeys.helpSettings1);

  /// Translations:
  ///
  /// en:  **'Cyclist move speed'**
  ///
  /// nl:  **'rennersnelheid'**
  ///
  /// fr:  **'Vitesse de déplacement du cycliste'**
  ///
  /// es:  **'Velocidad de movimiento del ciclista'**
  String get helpSettings2 => _t(LocalizationKeys.helpSettings2);

  /// Translations:
  ///
  /// en:  **'This determines the speed of the riders when they move. You can set this to fast (0.5s), normal (1s), slow(2s) or to skip (0.01s). When setting this to skip it may be hard to follow, but the game will progress much faster.'**
  ///
  /// nl:  **'Dit bepaalt de snelheid van de renners wanneer ze zich verplaatsen. U kunt dit instellen op snel (0,5 sec.), Normaal (1 sec.), Langzaam (2 sec.) Of overslaan (0,01 sec.). Als je dit instelt om over te slaan, is het misschien moeilijk te volgen, maar het spel zal veel sneller vorderen.'**
  ///
  /// fr:  **'Ceci détermine la vitesse des coureurs lorsqu'ils se déplacent. Vous pouvez régler ceci sur rapide (0,5s), normal (1s), lent (2s) ou pour sauter (0,01s). peut être difficile à suivre, mais le jeu progressera beaucoup plus rapidement. '**
  ///
  /// es:  **'Esto determina la velocidad de los ciclistas cuando se mueven. Puede configurar esto en rápido (0.5s), normal (1s), lento (2s) o para saltar (0.01s). puede ser difícil de seguir, pero el juego progresará mucho más rápido. '**
  String get helpSettings3 => _t(LocalizationKeys.helpSettings3);

  /// Translations:
  ///
  /// en:  **'Camera movement'**
  ///
  /// nl:  **'Camera beweging'**
  ///
  /// fr:  **'Mouvement de la caméra'**
  ///
  /// es:  **'Movimiento de la cámara'**
  String get helpSettings4 => _t(LocalizationKeys.helpSettings4);

  /// Translations:
  ///
  /// en:  **'This determines when the camera should automatically move. There are 3 options: disabled, you will always have to manually move the camera. Select only will move the camera to the next cyclist when it is their turn. Follow and select will follow a rider when they are moving. This gives you a nice overview of everything that happens, but may be a little nauseating.'**
  ///
  /// nl:  **'Dit bepaalt wanneer de camera automatisch moet bewegen. Er zijn 3 opties: uitgeschakeld, u zult de camera altijd handmatig moeten bewegen. Alleen selecteren zal de camera naar de volgende renner verplaatsen wanneer het hun beurt is. Volgen en selecteren zal een renner volgen wanneer deze in beweging is. Dit geeft je een mooi overzicht van alles wat er gebeurt, maar kan een beetje misselijkmakend zijn.'**
  ///
  /// fr:  **'Ceci détermine le moment où la caméra doit se déplacer automatiquement. Il y a 3 options: désactivée, vous devrez toujours déplacer manuellement la caméra. Sélectionnez uniquement pour déplacer la caméra vers le cycliste suivant quand c'est son tour. Suivez et sélectionnez suivra un coureur lorsqu'il se déplace. Cela vous donne un bon aperçu de tout ce qui se passe, mais cela peut être un peu nauséabond. '**
  ///
  /// es:  **'Esto determina cuándo la cámara debe moverse automáticamente. Hay 3 opciones: desactivado, siempre tendrás que mover la cámara manualmente. Seleccionar solo moverá la cámara al siguiente ciclista cuando sea su turno. Sigue y selecciona seguirá a un ciclista cuando se esté moviendo. Esto le brinda una buena descripción general de todo lo que sucede, pero puede ser un poco nauseabundo. '**
  String get helpSettings5 => _t(LocalizationKeys.helpSettings5);

  /// Translations:
  ///
  /// en:  **'Difficulty'**
  ///
  /// nl:  **'Moeilijkheidsgraad'**
  ///
  /// fr:  **'Difficulté'**
  ///
  /// es:  **'Dificultad'**
  String get helpSettings6 => _t(LocalizationKeys.helpSettings6);

  /// Translations:
  ///
  /// en:  **'When the game is much to easy or hard, you can change the difficulty (even in game). Setting this on easy will give you a big advantage and (whenever possible) will increase your throw up to 2 more (1 for each dice). Setting the difficulty to hard will increase all opponents throws with this amount. This may seem little, but know that a short race is on average 8 turns which may result in as much as 16 more thrown. Following even a low number of tiles is highly recommended on hard difficulty!'**
  ///
  /// nl:  **'Als het spel veel te gemakkelijk of moeilijk is, kun je de moeilijkheidsgraad wijzigen (zelfs tijdens een race). Als je dit op 'easy' instelt, heb je een groot voordeel en (waar mogelijk) vergroot je je worp tot 2 extra (1 voor elke dobbelsteen). Door de moeilijkheidsgraad op hard te zetten, worden alle worpen van de tegenstander met dit bedrag verhoogd. Dit lijkt misschien klein, maar weet dat een korte race gemiddeld 8 beurten omvat, wat kan resulteren in maar liefst 16 extra plaatsen. Het volgen van zelfs een klein aantal tegels wordt ten zeerste aanbevolen op moeilijkheidsgraden!'**
  ///
  /// fr:  **'Lorsque le jeu est beaucoup trop facile ou difficile, vous pouvez modifier la difficulté (même en jeu). Régler ceci sur facile vous donnera un gros avantage et (si possible) augmentera votre lancer jusqu'à 2 de plus ( 1 pour chaque dé). Régler la difficulté sur difficile augmentera tous les lancers de l'adversaire avec ce montant. Cela peut sembler peu, mais sachez qu'une course courte comporte en moyenne 8 tours, ce qui peut entraîner jusqu'à 16 lancers supplémentaires. un faible nombre de tuiles est fortement recommandé en difficulté difficile! '**
  ///
  /// es:  **'Cuando el juego es demasiado fácil o difícil, puedes cambiar la dificultad (incluso en el juego). Establecer esto en fácil te dará una gran ventaja y (siempre que sea posible) aumentará tu lanzamiento hasta 2 más ( 1 por cada dado). Establecer la dificultad en alto aumentará todos los lanzamientos de los oponentes con esta cantidad. Esto puede parecer poco, pero sepa que una carrera corta tiene un promedio de 8 turnos, lo que puede resultar en hasta 16 lanzamientos más. ¡Se recomienda un número bajo de fichas en dificultad difícil! '**
  String get helpSettings7 => _t(LocalizationKeys.helpSettings7);

  /// Translations:
  ///
  /// en:  **'More information and contact'**
  ///
  /// nl:  **'Meer informatie en contact'**
  ///
  /// fr:  **'Plus d'informations et contact'**
  ///
  /// es:  **'Más información y contacto'**
  String get helpMoreTitle => _t(LocalizationKeys.helpMoreTitle);

  /// Translations:
  ///
  /// en:  **'If you need more information, want to report a bug, have a suggestion, or just want to have a chat, you may contact me on wivecontact@gmail.com I would love to hear from you.'**
  ///
  /// nl:  **'Als je meer informatie nodig hebt, een bug wilt rapporteren, een suggestie hebt of gewoon een praatje wilt maken, kun je contact met me opnemen via wivecontact@gmail.com. Ik hoor graag van je.'**
  ///
  /// fr:  **'Si vous avez besoin de plus d'informations, souhaitez signaler un bug, avez une suggestion ou souhaitez simplement discuter, vous pouvez me contacter sur wivecontact@gmail.com. J'adorerais avoir de vos nouvelles.'**
  ///
  /// es:  **'Si necesitas más información, quieres informar un error, tienes una sugerencia o simplemente quieres charlar, puedes contactarme en wivecontact@gmail.com Me encantaría saber de ti.'**
  String get helpMore => _t(LocalizationKeys.helpMore);

  /// Translations:
  ///
  /// en:  **'next race'**
  ///
  /// nl:  **'volgende race'**
  ///
  /// fr:  **'prochaine course'**
  ///
  /// es:  **'próxima carrera'**
  String get nextRaceTitle => _t(LocalizationKeys.nextRaceTitle);

  /// Translations:
  ///
  /// en:  **'Races Done:'**
  ///
  /// nl:  **'Races gedaan:'**
  ///
  /// fr:  **'Courses terminées:'**
  ///
  /// es:  **'Carreras terminadas:'**
  String get nextRaceRacesDone => _t(LocalizationKeys.nextRaceRacesDone);

  /// Translations:
  ///
  /// en:  **'out of'**
  ///
  /// nl:  **'van'**
  ///
  /// fr:  **'hors de'**
  ///
  /// es:  **'fuera de'**
  String get nextRaceOf => _t(LocalizationKeys.nextRaceOf);

  /// Translations:
  ///
  /// en:  **'Best rider:'**
  ///
  /// nl:  **'Beste renner:'**
  ///
  /// fr:  **'Meilleur coureur:'**
  ///
  /// es:  **'Mejor piloto:'**
  String get nextRaceBestRider => _t(LocalizationKeys.nextRaceBestRider);

  /// Translations:
  ///
  /// en:  **'settings'**
  ///
  /// nl:  **'instellingen'**
  ///
  /// fr:  **'settings'**
  ///
  /// es:  **'configuración'**
  String get settingsTitle => _t(LocalizationKeys.settingsTitle);

  /// Translations:
  ///
  /// en:  **'Autofollow threshold:'**
  ///
  /// nl:  **'Autovolg drempel:'**
  ///
  /// fr:  **'Seuil de suivi automatique:'**
  ///
  /// es:  **'Umbral de seguimiento automático:'**
  String get settingsAutofollowThreshold => _t(LocalizationKeys.settingsAutofollowThreshold);

  /// Translations:
  ///
  /// en:  **'Autofollow ask below threshold'**
  ///
  /// nl:  **'Autovolg onder drempel vragen'**
  ///
  /// fr:  **'Suivi automatique des demandes en dessous du seuil'**
  ///
  /// es:  **'Autofollow preguntar por debajo del umbral'**
  String get settingsAutofollowAskBelowThreshold => _t(LocalizationKeys.settingsAutofollowAskBelowThreshold);

  /// Translations:
  ///
  /// en:  **'Cyclist move speed'**
  ///
  /// nl:  **'rennersnelheid'**
  ///
  /// fr:  **'Vitesse de déplacement du cycliste'**
  ///
  /// es:  **'Velocidad de movimiento del ciclista'**
  String get settingsCyclistMoveSpeed => _t(LocalizationKeys.settingsCyclistMoveSpeed);

  /// Translations:
  ///
  /// en:  **'Slow'**
  ///
  /// nl:  **'traag'**
  ///
  /// fr:  **'Lent'**
  ///
  /// es:  **'Lento'**
  String get settingsCyclistMoveSpeedSlow => _t(LocalizationKeys.settingsCyclistMoveSpeedSlow);

  /// Translations:
  ///
  /// en:  **'Normal'**
  ///
  /// nl:  **'Normaal'**
  ///
  /// fr:  **'Normal'**
  ///
  /// es:  **'Normal'**
  String get settingsCyclistMoveSpeedNormal => _t(LocalizationKeys.settingsCyclistMoveSpeedNormal);

  /// Translations:
  ///
  /// en:  **'Fast'**
  ///
  /// nl:  **'snel'**
  ///
  /// fr:  **'Rapide'**
  ///
  /// es:  **'Rápido'**
  String get settingsCyclistMoveSpeedFast => _t(LocalizationKeys.settingsCyclistMoveSpeedFast);

  /// Translations:
  ///
  /// en:  **'Skip'**
  ///
  /// nl:  **'Skip'**
  ///
  /// fr:  **'Ignorer'**
  ///
  /// es:  **'Omitir'**
  String get settingsCyclistMoveSpeedSkip => _t(LocalizationKeys.settingsCyclistMoveSpeedSkip);

  /// Translations:
  ///
  /// en:  **'Camera auto move'**
  ///
  /// nl:  **'Camera beweging'**
  ///
  /// fr:  **'Déplacement automatique de la caméra'**
  ///
  /// es:  **'Movimiento automático de la cámara'**
  String get settingsCameraAutoMove => _t(LocalizationKeys.settingsCameraAutoMove);

  /// Translations:
  ///
  /// en:  **'Disabled'**
  ///
  /// nl:  **'Uit'**
  ///
  /// fr:  **'Disabled'**
  ///
  /// es:  **'Desactivado'**
  String get settingsCameraAutoMoveDisabled => _t(LocalizationKeys.settingsCameraAutoMoveDisabled);

  /// Translations:
  ///
  /// en:  **'Select only'**
  ///
  /// nl:  **'Enkel selecteren'**
  ///
  /// fr:  **'Sélectionner uniquement'**
  ///
  /// es:  **'Seleccionar solo'**
  String get settingsCameraAutoMoveSelectOnly => _t(LocalizationKeys.settingsCameraAutoMoveSelectOnly);

  /// Translations:
  ///
  /// en:  **'Select and follow'**
  ///
  /// nl:  **'selecteren en volgen'**
  ///
  /// fr:  **'Sélectionnez et suivez'**
  ///
  /// es:  **'Seleccionar y seguir'**
  String get settingsCameraAutoMoveSelectAndFollow => _t(LocalizationKeys.settingsCameraAutoMoveSelectAndFollow);

  /// Translations:
  ///
  /// en:  **'Difficulty'**
  ///
  /// nl:  **'Moeilijkheidsgraad'**
  ///
  /// fr:  **'Difficulty'**
  ///
  /// es:  **'Dificultad'**
  String get settingsDifficulty => _t(LocalizationKeys.settingsDifficulty);

  /// Translations:
  ///
  /// en:  **'Easy'**
  ///
  /// nl:  **'simpel'**
  ///
  /// fr:  **'Easy'**
  ///
  /// es:  **'Fácil'**
  String get settingsDifficultyEasy => _t(LocalizationKeys.settingsDifficultyEasy);

  /// Translations:
  ///
  /// en:  **'Normal'**
  ///
  /// nl:  **'Normaal'**
  ///
  /// fr:  **'Normal'**
  ///
  /// es:  **'Normal'**
  String get settingsDifficultyNormal => _t(LocalizationKeys.settingsDifficultyNormal);

  /// Translations:
  ///
  /// en:  **'Hard'**
  ///
  /// nl:  **'moeilijk'**
  ///
  /// fr:  **'Hard'**
  ///
  /// es:  **'Difícil'**
  String get settingsDifficultyHard => _t(LocalizationKeys.settingsDifficultyHard);

  /// Translations:
  ///
  /// en:  **'You need to throw'**
  ///
  /// nl:  **'gooi minstens'**
  ///
  /// fr:  **'Vous devez lancer'**
  ///
  /// es:  **'Necesitas lanzar'**
  String get followAmount => _t(LocalizationKeys.followAmount);

  /// Translations:
  ///
  /// en:  **'Follow'**
  ///
  /// nl:  **'Volgen'**
  ///
  /// fr:  **'Suivre'**
  ///
  /// es:  **'Seguir'**
  String get followFollow => _t(LocalizationKeys.followFollow);

  /// Translations:
  ///
  /// en:  **'Leave'**
  ///
  /// nl:  **'Laten gaan'**
  ///
  /// fr:  **'Quitter'**
  ///
  /// es:  **'Salir'**
  String get followLeave => _t(LocalizationKeys.followLeave);

  /// Translations:
  ///
  /// en:  **'Auto follow'**
  ///
  /// nl:  **'Autovolgen'**
  ///
  /// fr:  **'Suivi automatique'**
  ///
  /// es:  **'Seguimiento automático'**
  String get followAuto => _t(LocalizationKeys.followAuto);

  /// Translations:
  ///
  /// en:  **'paused'**
  ///
  /// nl:  **'pauze'**
  ///
  /// fr:  **'paused'**
  ///
  /// es:  **'paused'**
  String get pausedTitle => _t(LocalizationKeys.pausedTitle);

  /// Translations:
  ///
  /// en:  **'Gained'**
  ///
  /// nl:  **'Krijgt'**
  ///
  /// fr:  **'Gagné'**
  ///
  /// es:  **'Ganado'**
  String get raceGained => _t(LocalizationKeys.raceGained);

  /// Translations:
  ///
  /// en:  **'Tutorial'**
  ///
  /// nl:  **'Tutorial'**
  ///
  /// fr:  **'Tutoriel'**
  ///
  /// es:  **'Tutorial'**
  String get tutorialTitle => _t(LocalizationKeys.tutorialTitle);

  /// Translations:
  ///
  /// en:  **'Welcome'**
  ///
  /// nl:  **'Welkom'**
  ///
  /// fr:  **'Bienvenue'**
  ///
  /// es:  **'Bienvenido'**
  String get tutorialWelcomeTitle => _t(LocalizationKeys.tutorialWelcomeTitle);

  /// Translations:
  ///
  /// en:  **'Welcome to cycling escape, I hope you enjoy your stay. There are a few items that may be confusing, but I'll explain them when we encounter them. If you ever need more help, you can go to the help page (i right bottom). (Games are automatically saved). For now let's begin!'**
  ///
  /// nl:  **'Welkom bij Cycling Escape, ik hoop dat je geniet van je verblijf. Er zijn een paar items die verwarrend kunnen zijn, maar ik zal ze uitleggen wanneer we ze tegenkomen. Als u ooit meer hulp nodig heeft, kunt u naar de helppagina gaan (i rechtsonder). (Games worden automatisch opgeslagen). Laten we nu beginnen!'**
  ///
  /// fr:  **'Bienvenue à l'évasion à vélo, j'espère que vous apprécierez votre séjour. Il y a quelques éléments qui peuvent prêter à confusion, mais je les expliquerai quand nous les rencontrerons. Si vous avez besoin de plus d'aide, vous pouvez aller à la page d'aide (i en bas à droite). (Les jeux sont automatiquement enregistrés). Pour l'instant, commençons! '**
  ///
  /// es:  **'Bienvenido a la escapada en bicicleta. Espero que disfrutes tu estadía. Hay algunos elementos que pueden ser confusos, pero los explicaré cuando los encontremos. Si alguna vez necesitas más ayuda, puedes ir al página de ayuda (abajo a la derecha). (Los juegos se guardan automáticamente). ¡Por ahora, comencemos! '**
  String get tutorialWelcomeDescription => _t(LocalizationKeys.tutorialWelcomeDescription);

  /// Translations:
  ///
  /// en:  **'Career'**
  ///
  /// nl:  **'Carierre'**
  ///
  /// fr:  **'Carrière'**
  ///
  /// es:  **'Carrera'**
  String get tutorialCareerTitle => _t(LocalizationKeys.tutorialCareerTitle);

  /// Translations:
  ///
  /// en:  **'Welcome in career, your goal is to win as many races and get as much money as you can. With this money you can buy more riders for your team, more difficult races and more ranking.'**
  ///
  /// nl:  **'Welkom in je carrière, je doel is om zoveel mogelijk races te winnen en zoveel mogelijk geld te verdienen. Met dit geld kun je meer renners voor je team, moeilijkere races en meer ranschikkings kopen.'**
  ///
  /// fr:  **'Bienvenue dans votre carrière, votre objectif est de gagner le plus de courses et de gagner le plus d'argent possible. Avec cet argent, vous pouvez acheter plus de coureurs pour votre équipe, des courses plus difficiles et plus de classement.'**
  ///
  /// es:  **'Bienvenido a la carrera, tu objetivo es ganar tantas carreras y conseguir tanto dinero como puedas. Con este dinero puedes comprar más corredores para tu equipo, carreras más difíciles y más ranking.'**
  String get tutorialCareerDescription => _t(LocalizationKeys.tutorialCareerDescription);

  /// Translations:
  ///
  /// en:  **'Single race'**
  ///
  /// nl:  **'Enkele race'**
  ///
  /// fr:  **'Course unique'**
  ///
  /// es:  **'Raza única'**
  String get tutorialSingleRaceTitle => _t(LocalizationKeys.tutorialSingleRaceTitle);

  /// Translations:
  ///
  /// en:  **'This is a single race, the first to finish is the winner. You can pick how many teams compete, how many riders and the type of road. If you like a challenge go for a hilled or even heavy race.'**
  ///
  /// nl:  **'Dit is een enkele race, de eerste die finisht is de winnaar. U kunt kiezen hoeveel teams strijden, hoeveel renners en het type weg. Als je van een uitdaging houdt, ga dan voor een berg of zelfs zware race.'**
  ///
  /// fr:  **'Il s'agit d'une course unique, le premier à terminer est le vainqueur. Vous pouvez choisir le nombre d'équipes en compétition, le nombre de coureurs et le type de route. Si vous aimez les défis, partez pour une course en pente ou même lourde. '**
  ///
  /// es:  **'Esta es una carrera única, el primero en terminar es el ganador. Puedes elegir cuántos equipos compiten, cuántos ciclistas y el tipo de camino. Si te gustan los desafíos, haz una carrera montañosa o incluso pesada. '**
  String get tutorialSingleRaceDescription => _t(LocalizationKeys.tutorialSingleRaceDescription);

  /// Translations:
  ///
  /// en:  **'Tour'**
  ///
  /// nl:  **'Tour'**
  ///
  /// fr:  **'Tour'**
  ///
  /// es:  **'Tour'**
  String get tutorialTourTitle => _t(LocalizationKeys.tutorialTourTitle);

  /// Translations:
  ///
  /// en:  **'A tour constists of multiple races. You can pick one configuration or regenerate to pick a different one. All races use the same configuration, but will be different due to them being randomly generated each time.'**
  ///
  /// nl:  **'Een tour bestaat uit meerdere races. U kunt een configuratie kiezen of opnieuw genereren om een andere te kiezen. Alle races gebruiken dezelfde configuratie, maar zullen anders zijn omdat ze elke keer willekeurig worden gegenereerd.'**
  ///
  /// fr:  **'Une tournée comprend plusieurs courses. Vous pouvez choisir une configuration ou régénérer pour en choisir une différente. Toutes les courses utilisent la même configuration, mais seront différentes car elles sont générées aléatoirement à chaque fois.'**
  ///
  /// es:  **'Un recorrido consta de varias carreras. Puedes elegir una configuración o regenerar para elegir una diferente. Todas las carreras usan la misma configuración, pero serán diferentes debido a que se generan aleatoriamente cada vez.'**
  String get tutorialTourDescription => _t(LocalizationKeys.tutorialTourDescription);

  /// Translations:
  ///
  /// en:  **'Race time'**
  ///
  /// nl:  **'Tijd om te racen'**
  ///
  /// fr:  **'Heure de la course'**
  ///
  /// es:  **'Tiempo de carrera'**
  String get tutorialOpenRaceTitle => _t(LocalizationKeys.tutorialOpenRaceTitle);

  /// Translations:
  ///
  /// en:  **'Welcome to the race. The goal is to win sprints and be the first and furthest over the finish line. Know that riders on the right hand side have priority. The rider that is furthest will go first and then every other one will get their turn. Then we select the new first rider and so on.'**
  ///
  /// nl:  **'Welkom bij de race. Het doel is om sprints te winnen en als eerste en het verst over de finish te komen. Weet dat renners aan de rechterkant voorrang hebben. De renner die het verst is, gaat als eerste en daarna komen alle anderen aan de beurt. Vervolgens selecteren we de nieuwe eerste rijder enzovoort.'**
  ///
  /// fr:  **'Bienvenue dans la course. L'objectif est de gagner des sprints et d'être le premier et le plus éloigné de la ligne d'arrivée. Sachez que les coureurs du côté droit ont la priorité. Le coureur le plus éloigné ira en premier, puis tous les autres. on aura son tour. Ensuite, nous sélectionnons le nouveau premier coureur et ainsi de suite. '**
  ///
  /// es:  **'Bienvenido a la carrera. El objetivo es ganar sprints y ser el primero y más lejano en la línea de meta. Sepa que los ciclistas del lado derecho tienen prioridad. El ciclista que esté más lejos irá primero y luego todos los demás uno tendrá su turno. Luego seleccionamos al nuevo primer ciclista y así sucesivamente. '**
  String get tutorialOpenRaceDescription => _t(LocalizationKeys.tutorialOpenRaceDescription);

  /// Translations:
  ///
  /// en:  **'Your turn'**
  ///
  /// nl:  **'Jouw beurt'**
  ///
  /// fr:  **'C'est à vous de jouer'**
  ///
  /// es:  **'Tu turno'**
  String get tutorialThrowDiceTitle => _t(LocalizationKeys.tutorialThrowDiceTitle);

  /// Translations:
  ///
  /// en:  **'Your turn! Throw the dices by tapping on the screen. You will be able to move the value you throw.'**
  ///
  /// nl:  **'Jouw beurt! Gooi de dobbelstenen door op het scherm te tikken. U kunt de waarde die u gooit verplaatsen.'**
  ///
  /// fr:  **'A votre tour! Lancez les dés en appuyant sur l'écran. Vous pourrez déplacer la valeur que vous lancez.'**
  ///
  /// es:  **'¡Tu turno! Lanza los dados tocando la pantalla. Podrás mover el valor que arrojes.'**
  String get tutorialThrowDiceDescription => _t(LocalizationKeys.tutorialThrowDiceDescription);

  /// Translations:
  ///
  /// en:  **'Select a position'**
  ///
  /// nl:  **'Selecteer een positie'**
  ///
  /// fr:  **'Sélectionnez une position'**
  ///
  /// es:  **'Seleccionar una posición'**
  String get tutorialSelectPositionTitle => _t(LocalizationKeys.tutorialSelectPositionTitle);

  /// Translations:
  ///
  /// en:  **'Well thrown! You can now move this many spaces. Don't worry, we already did the calculation for you. Simply select any highlighted position and you will move there. Try to go as far as possible.'**
  ///
  /// nl:  **'Goed gegooid! U kunt nu zoveel vakjes verplaatsen. Maak je geen zorgen, we hebben de berekening al voor je gedaan. Selecteer eenvoudig een gemarkeerde positie en u gaat daarheen. Probeer zo ver mogelijk te gaan.'**
  ///
  /// fr:  **'Bien lancé! Vous pouvez maintenant déplacer autant d'espaces. Ne vous inquiétez pas, nous avons déjà fait le calcul pour vous. Sélectionnez simplement n'importe quelle position en surbrillance et vous vous y déplacerez. Essayez d'aller aussi loin que possible.'**
  ///
  /// es:  **'¡Bien hecho! Ahora puede mover tantos espacios. No se preocupe, ya hicimos el cálculo por usted. Simplemente seleccione cualquier posición resaltada y se moverá allí. Intente llegar lo más lejos posible.'**
  String get tutorialSelectPositionDescription => _t(LocalizationKeys.tutorialSelectPositionDescription);

  /// Translations:
  ///
  /// en:  **'Follow.. or not'**
  ///
  /// nl:  **'Volg je of niet'**
  ///
  /// fr:  **'Suivre .. ou pas'**
  ///
  /// es:  **'Seguir ... o no'**
  String get tutorialFollowOrNotTitle => _t(LocalizationKeys.tutorialFollowOrNotTitle);

  /// Translations:
  ///
  /// en:  **'You have the option to follow. This means that you will move the same number of spaces as the rider in front of you. I suggest only following when you need to throw a 7 or more. You can also use the auto follow command. The game will then decide for you based on your settings. For now this means that it will follow whenever you need to throw a 7 or more.'**
  ///
  /// nl:  **'Je hebt de mogelijkheid om te volgen. Dit betekent dat u hetzelfde aantal velden verplaatst als de renner voor u. Ik stel voor om alleen te volgen als je een 7 of meer moet gooien. U kunt ook de knop voor automatisch volgen gebruiken. De game beslist dan voor je op basis van je instellingen. Voorlopig betekent dit dat het zal volgen wanneer je een 7 of meer moet gooien.'**
  ///
  /// fr:  **'Vous avez la possibilité de suivre. Cela signifie que vous déplacerez le même nombre d'espaces que le cavalier devant vous. Je suggère de suivre uniquement lorsque vous avez besoin de lancer un 7 ou plus. Vous pouvez également utiliser le commande de suivi automatique. Le jeu décidera alors pour vous en fonction de vos paramètres. Pour l'instant, cela signifie qu'il suivra chaque fois que vous aurez besoin de lancer un 7 ou plus.'**
  ///
  /// es:  **'Tienes la opción de seguir. Esto significa que moverás el mismo número de espacios que el ciclista que tienes delante. Sugiero seguir solo cuando necesites lanzar un 7 o más. También puedes usar el comando de seguimiento automático. El juego decidirá por ti en función de tu configuración. Por ahora, esto significa que seguirá siempre que necesites lanzar un 7 o más. '**
  String get tutorialFollowOrNotDescription => _t(LocalizationKeys.tutorialFollowOrNotDescription);

  /// Translations:
  ///
  /// en:  **'Can't follow'**
  ///
  /// nl:  **'Je kan niet volgen'**
  ///
  /// fr:  **'Impossible de suivre'**
  ///
  /// es:  **'No puedo seguir'**
  String get tutorialCantFollowTitle => _t(LocalizationKeys.tutorialCantFollowTitle);

  /// Translations:
  ///
  /// en:  **'You would normally be able to follow, however this is not possible this time. This can be because of a number of reasons, either there is no free tile behind their new tile or they took a route that makes it impossible to reach the tile behind them in the same number of steps. You will have to throw for this rider when it's their turn.'**
  ///
  /// nl:  **'Normaal gesproken zou je kunnen volgen, maar dit is dit keer niet mogelijk. Dit kan verschillende redenen hebben: ofwel is er geen vrije tegel achter hun nieuwe tegel, ofwel hebben ze een route gevolgd die het onmogelijk maakt om de tegel achter hen in hetzelfde aantal stappen te bereiken. Je zult voor deze renner moeten gooien als het hun beurt is.'**
  ///
  /// fr:  **'Vous seriez normalement en mesure de suivre, mais ce n'est pas possible cette fois. Cela peut être dû à un certain nombre de raisons, soit il n'y a pas de tuile libre derrière leur nouvelle tuile, soit ils ont emprunté un itinéraire qui le rend impossible pour atteindre la tuile derrière eux dans le même nombre de pas. Vous devrez lancer pour ce cavalier quand ce sera son tour. '**
  ///
  /// es:  **'Normalmente podrías seguir, sin embargo, esto no es posible esta vez. Esto puede deberse a varias razones, o no hay un mosaico libre detrás del nuevo mosaico o tomaron una ruta que lo hace imposible para llegar a la loseta detrás de ellos en el mismo número de pasos. Tendrás que lanzar para este jinete cuando sea su turno. '**
  String get tutorialCantFollowDescription => _t(LocalizationKeys.tutorialCantFollowDescription);

  /// Translations:
  ///
  /// en:  **'Maybe still follow'**
  ///
  /// nl:  **'Misschien toch volgen'**
  ///
  /// fr:  **'Peut-être encore suivre'**
  ///
  /// es:  **'Quizás aún sigas'**
  String get tutorialStillFollowTitle => _t(LocalizationKeys.tutorialStillFollowTitle);

  /// Translations:
  ///
  /// en:  **'When you select auto follow you will still receive a popup whenever the amount needed to follow is less than 7. This is because it you might still want to follow. If you don't want this you can disable this in settings.'**
  ///
  /// nl:  **'Als je automatisch volgen selecteert, ontvang je nog steeds een pop-up als het benodigde aantal minder dan 7 is. Dit komt omdat je het misschien toch wilt volgen. Als u dit niet wilt, kunt u dit uitschakelen in de instellingen.'**
  ///
  /// fr:  **'Lorsque vous sélectionnez le suivi automatique, vous recevrez toujours une fenêtre contextuelle chaque fois que le montant à suivre est inférieur à 7. C'est parce que vous voudrez peut-être toujours suivre. Si vous ne le souhaitez pas, vous pouvez le désactiver dans Les paramètres.'**
  ///
  /// es:  **'Cuando selecciones el seguimiento automático, seguirás recibiendo una ventana emergente siempre que la cantidad necesaria para seguir sea inferior a 7. Esto se debe a que es posible que quieras seguirlo. Si no quieres esto, puedes desactivarlo en ajustes.'**
  String get tutorialStillFollowDescription => _t(LocalizationKeys.tutorialStillFollowDescription);

  /// Translations:
  ///
  /// en:  **'Difficult terrain'**
  ///
  /// nl:  **'Moeilijk terein'**
  ///
  /// fr:  **'Terrain difficile'**
  ///
  /// es:  **'Terreno difícil'**
  String get tutorialDifficultTerrainTitle => _t(LocalizationKeys.tutorialDifficultTerrainTitle);

  /// Translations:
  ///
  /// en:  **'This position is more difficult. Whenever you start on a tile that has a negative value on it, that value will be subtracted from the number you throw. This means that some moves you will be unable to move. Know that this is only when you stop, you can go over them without any problems.'**
  ///
  /// nl:  **'Deze positie is moeilijker. Elke keer dat je begint op een tegel met een negatieve waarde, wordt die waarde afgetrokken van het getal dat je gooit. Dit betekent dat u bij sommige zetten niet kunt bewegen. Weet dat dit alleen is als u stopt, u kunt er zonder problemen overheen gaan.'**
  ///
  /// fr:  **'Cette position est plus difficile. Chaque fois que vous commencez sur une tuile qui a une valeur négative, cette valeur sera soustraite du nombre que vous lancez. Cela signifie que certains mouvements vous ne pourrez pas bouger. Sachez que ce n'est que lorsque vous vous arrêtez, vous pouvez les parcourir sans aucun problème. '**
  ///
  /// es:  **'Esta posición es más difícil. Siempre que comiences en una ficha que tenga un valor negativo, ese valor se restará del número que arrojes. Esto significa que no podrás mover algunos movimientos. Debes saber que esto es solo cuando te detienes, puedes repasarlos sin ningún problema. '**
  String get tutorialDifficultTerrainDescription => _t(LocalizationKeys.tutorialDifficultTerrainDescription);

  /// Translations:
  ///
  /// en:  **'Downhill'**
  ///
  /// nl:  **'Bergaf'**
  ///
  /// fr:  **'Descente'**
  ///
  /// es:  **'Cuesta abajo'**
  String get tutorialDownhillTitle => _t(LocalizationKeys.tutorialDownhillTitle);

  /// Translations:
  ///
  /// en:  **'Downhill gives you extra speed! Whenever you start on a tile that has a positive value on it, that value will be added from the number you throw. This means that you can go much further! Enjoy the ride.'**
  ///
  /// nl:  **'Bergaf geeft je extra snelheid! Elke keer dat je begint op een tegel met een positieve waarde, wordt die waarde opgeteld bij het getal dat je gooit. Dit betekent dat u veel verder kunt gaan! Geniet van de rit.'**
  ///
  /// fr:  **'La descente vous donne une vitesse supplémentaire! Chaque fois que vous démarrez sur une tuile qui a une valeur positive, cette valeur sera ajoutée à partir du nombre que vous lancez. Cela signifie que vous pouvez aller beaucoup plus loin! Profitez de la balade.'**
  ///
  /// es:  **'¡El descenso te da velocidad extra! Siempre que comiences en una ficha que tenga un valor positivo, ese valor se agregará al número que arrojes. ¡Esto significa que puedes llegar mucho más lejos! ¡Disfruta el viaje!'**
  String get tutorialDownhillDescription => _t(LocalizationKeys.tutorialDownhillDescription);

  /// Translations:
  ///
  /// en:  **'Sprint!'**
  ///
  /// nl:  **'Sprint!'**
  ///
  /// fr:  **'Sprint!'**
  ///
  /// es:  **'¡Sprint!'**
  String get tutorialSprintTitle => _t(LocalizationKeys.tutorialSprintTitle);

  /// Translations:
  ///
  /// en:  **'You just passed a sprint. Depending on the colour it is a normal sprint (green) or a mountain sprint (red). After each turn we check if any riders have passed the sprint and the person that is furthest (or more on the right if they are as far) might get points. The first gets 5 points, the second to fourth get 3, 2 and 1 respectivly.'**
  ///
  /// nl:  **'Je bent net een sprint gepasseerd. Afhankelijk van de kleur is het een normale sprint (groen) of een bergsprint (rood). Na elke beurt kijken we of er renners de sprint hebben gepasseerd en de persoon die het verst is (of meer rechts als ze even ver zijn) punten kan krijgen. De eerste krijgt 5 punten, de tweede tot en met de vierde respectievelijk 3, 2 en 1.'**
  ///
  /// fr:  **'Vous venez de passer un sprint. Selon la couleur, il s'agit d'un sprint normal (vert) ou d'un sprint de montagne (rouge). Après chaque virage, nous vérifions si des coureurs ont réussi le sprint et la personne la plus éloignée ( ou plus sur la droite s'ils sont aussi loin) peuvent obtenir des points. Le premier obtient 5 points, le deuxième au quatrième obtient respectivement 3, 2 et 1. '**
  ///
  /// es:  **'Acabas de pasar un sprint. Dependiendo del color es un sprint normal (verde) o un sprint de montaña (rojo). Después de cada turno comprobamos si algún ciclista ha pasado el sprint y la persona que está más lejos ( o más a la derecha si están tan lejos) pueden obtener puntos. El primero obtiene 5 puntos, el segundo al cuarto obtienen 3, 2 y 1 respectivamente. '**
  String get tutorialSprintDescription => _t(LocalizationKeys.tutorialSprintDescription);

  /// Translations:
  ///
  /// en:  **'Finish!'**
  ///
  /// nl:  **'Aankomst!'**
  ///
  /// fr:  **'Terminez!'**
  ///
  /// es:  **'¡Finalizar!'**
  String get tutorialFinishTitle => _t(LocalizationKeys.tutorialFinishTitle);

  /// Translations:
  ///
  /// en:  **'Congratulations, you've just finished. We use how many turns that took to determine your 'time' and rank. After each turn we check if any riders have passed the finish and the person that is furthest (or more on the right if they are as far) finishes first. The riders that finish will be removed from the board. When all riders have finished, we show the rankings.'**
  ///
  /// nl:  **'Gefeliciteerd, je bent net aangekomen. We gebruiken het aantal beurten dat duurde om uw 'tijd' en rang te bepalen. Na elke beurt kijken we of er renners de finish zijn gepasseerd en de persoon die het verst is (of meer rechts als ze even ver zijn) als eerste finisht. De renners die finishen worden van het bord verwijderd. Als alle renners klaar zijn, laten we de ranglijst zien.'**
  ///
  /// fr:  **'Félicitations, vous venez de terminer. Nous utilisons le nombre de virages nécessaires pour déterminer votre temps et votre rang. Après chaque virage, nous vérifions si des coureurs ont passé l'arrivée et la personne la plus éloignée (ou plus) à droite s'ils sont aussi loin) termine en premier. Les coureurs qui terminent seront retirés du tableau. Lorsque tous les coureurs auront terminé, nous montrons le classement. '**
  ///
  /// es:  **'Felicitaciones, acaba de terminar. Usamos cuántos giros fueron necesarios para determinar su 'tiempo' y rango. Después de cada turno, verificamos si algún ciclista ha pasado la meta y la persona que está más lejos (o más a la derecha si están tan lejos) termina primero. Los corredores que terminan serán eliminados del tablero. Cuando todos los corredores hayan terminado, mostramos la clasificación. '**
  String get tutorialFinishDescription => _t(LocalizationKeys.tutorialFinishDescription);

  /// Translations:
  ///
  /// en:  **'Rankings'**
  ///
  /// nl:  **'Rankings'**
  ///
  /// fr:  **'Classements'**
  ///
  /// es:  **'Clasificaciones'**
  String get tutorialRankingsTitle => _t(LocalizationKeys.tutorialRankingsTitle);

  /// Translations:
  ///
  /// en:  **'How did you do? You can now see all rankings (use the arrows to change the ranking showed). In a tour, the first in every ranking (except team) get a special jersey they wear in the next race. This way you can always see where the best riders are.'**
  ///
  /// nl:  **'Hoe deed je? U kunt nu alle ranglijsten zien (gebruik de pijlen om de weergegeven ranking te wijzigen). In een tour krijgen de eersten in elke ranglijst (behalve team) een speciale trui die ze in de volgende race dragen. Zo kun je altijd zien waar de beste renners zijn.'**
  ///
  /// fr:  **'Comment avez-vous fait? Vous pouvez maintenant voir tous les classements (utilisez les flèches pour changer le classement affiché). Lors d'une tournée, les premiers de chaque classement (hors équipe) reçoivent un maillot spécial qu'ils portent lors de la prochaine course . De cette façon, vous pouvez toujours voir où sont les meilleurs coureurs. '**
  ///
  /// es:  **'¿Cómo te fue? Ahora puedes ver todas las clasificaciones (usa las flechas para cambiar la clasificación que se muestra). En un recorrido, los primeros en cada clasificación (excepto el equipo) obtienen una camiseta especial que usan en la próxima carrera . De esta manera siempre puedes ver dónde están los mejores ciclistas. '**
  String get tutorialRankingsDescription => _t(LocalizationKeys.tutorialRankingsDescription);

  /// Translations:
  ///
  /// en:  **'Settings'**
  ///
  /// nl:  **'Instellingen'**
  ///
  /// fr:  **'Paramètres'**
  ///
  /// es:  **'Configuración'**
  String get tutorialSettingsTitle => _t(LocalizationKeys.tutorialSettingsTitle);

  /// Translations:
  ///
  /// en:  **'Change the settings to make your experience more enjoyable. If you want more information on what does what, you can go to help (main menu > i in the corner).'**
  ///
  /// nl:  **'Wijzig de instellingen om uw ervaring aangenamer te maken. Als je meer informatie wilt over wat wat doet, ga dan naar Help (hoofdmenu > i in de hoek).'**
  ///
  /// fr:  **'Modifiez les paramètres pour rendre votre expérience plus agréable. Si vous voulez plus d'informations sur ce qui fait quoi, vous pouvez aller à l'aide (menu principal> i dans le coin).'**
  ///
  /// es:  **'Cambia la configuración para que tu experiencia sea más agradable. Si quieres más información sobre qué hace qué, puedes ir a ayuda (menú principal> i en la esquina).'**
  String get tutorialSettingsDescription => _t(LocalizationKeys.tutorialSettingsDescription);

  /// Translations:
  ///
  /// en:  **'On to the next one'**
  ///
  /// nl:  **'Op naar de volgende'**
  ///
  /// fr:  **'Passons au suivant'**
  ///
  /// es:  **'Pasamos al siguiente'**
  String get tutorialFirstTourFinishedTitle => _t(LocalizationKeys.tutorialFirstTourFinishedTitle);

  /// Translations:
  ///
  /// en:  **'Well done, you've just finished your first tour. Hopefully you did well. If you enjoyed it (or didn't), consider rating the game and please continue with more races, tours and the career!'**
  ///
  /// nl:  **'Goed gedaan, je bent net klaar met je eerste tour. Hopelijk heb je het goed gedaan. Als je het leuk vond (of niet), overweeg dan om het spel te beoordelen en ga alsjeblieft verder met meer races, tours en de carrière!'**
  ///
  /// fr:  **'Bien joué, vous venez de terminer votre première tournée. J'espère que vous avez bien fait. Si vous l'avez apprécié (ou pas), pensez à évaluer le jeu et continuez avec plus de courses, de tournées et de carrière!'**
  ///
  /// es:  **'Bien hecho, acabas de terminar tu primer recorrido. Espero que lo hayas hecho bien. Si lo disfrutaste (o no), considera calificar el juego y continúa con más carreras, recorridos y la carrera.'**
  String get tutorialFirstTourFinishedDescription => _t(LocalizationKeys.tutorialFirstTourFinishedDescription);

  /// Translations:
  ///
  /// en:  **'Money'**
  ///
  /// nl:  **'Geld'**
  ///
  /// fr:  **'Argent'**
  ///
  /// es:  **'Dinero'**
  String get tutorialFirstCareerTitle => _t(LocalizationKeys.tutorialFirstCareerTitle);

  /// Translations:
  ///
  /// en:  **'Well done, you've just earned your first money, you can spend this in upgrades to improve your team.'**
  ///
  /// nl:  **'Goed gedaan, je hebt zojuist je eerste geld verdiend, je kunt dit uitgeven aan upgrades om je team te verbeteren.'**
  ///
  /// fr:  **'Bien joué, vous venez de gagner votre premier argent, vous pouvez le dépenser en surclassements pour améliorer votre équipe.'**
  ///
  /// es:  **'Bien hecho, acaba de ganar su primer dinero, puede gastarlo en actualizaciones para mejorar su equipo'**
  String get tutorialFirstCareerDescription => _t(LocalizationKeys.tutorialFirstCareerDescription);

  /// Translations:
  ///
  /// en:  **'Upgrades'**
  ///
  /// nl:  **'Upgrades'**
  ///
  /// fr:  **'Mises à niveau'**
  ///
  /// es:  **'Actualizaciones'**
  String get tutorialUpgradesTitle => _t(LocalizationKeys.tutorialUpgradesTitle);

  /// Translations:
  ///
  /// en:  **'You can upgrade your team by hiring more riders, unlocking more rankings (sprints, team, mountain and young) or unlock better races'**
  ///
  /// nl:  **'Je kunt je team upgraden door meer renners aan te nemen, meer klassementen te ontgrendelen (sprints, team, berg en jongere) of door betere races te ontgrendelen'**
  ///
  /// fr:  **'Vous pouvez améliorer votre équipe en embauchant plus de coureurs, en débloquant plus de classements (sprints, équipe, montagne et jeune) ou débloquer de meilleures courses'**
  ///
  /// es:  **'Puedes mejorar tu equipo contratando más ciclistas, desbloqueando más clasificaciones (sprints, equipo, montaña y jóvenes) o desbloqueando mejores carreras'**
  String get tutorialUpgradesDescription => _t(LocalizationKeys.tutorialUpgradesDescription);

  /// Translations:
  ///
  /// en:  **'results'**
  ///
  /// nl:  **'resultaten'**
  ///
  /// fr:  **'résultats'**
  ///
  /// es:  **'resultados'**
  String get resultsTitle => _t(LocalizationKeys.resultsTitle);

  /// Translations:
  ///
  /// en:  **'time'**
  ///
  /// nl:  **'tijd'**
  ///
  /// fr:  **'time'**
  ///
  /// es:  **'hora'**
  String get resultsTimeTitle => _t(LocalizationKeys.resultsTimeTitle);

  /// Translations:
  ///
  /// en:  **'Young Riders'**
  ///
  /// nl:  **'Jongere'**
  ///
  /// fr:  **'Jeunes cavaliers'**
  ///
  /// es:  **'Jóvenes jinetes'**
  String get resultsYoungRidersTitle => _t(LocalizationKeys.resultsYoungRidersTitle);

  /// Translations:
  ///
  /// en:  **'Points'**
  ///
  /// nl:  **'Punten'**
  ///
  /// fr:  **'Points'**
  ///
  /// es:  **'Puntos'**
  String get resultsPointsTitle => _t(LocalizationKeys.resultsPointsTitle);

  /// Translations:
  ///
  /// en:  **'Mountain'**
  ///
  /// nl:  **'Berg'**
  ///
  /// fr:  **'Montagne'**
  ///
  /// es:  **'Montaña'**
  String get resultsMountainTitle => _t(LocalizationKeys.resultsMountainTitle);

  /// Translations:
  ///
  /// en:  **'Team'**
  ///
  /// nl:  **'Team'**
  ///
  /// fr:  **'Équipe'**
  ///
  /// es:  **'Equipo'**
  String get resultsTeamTitle => _t(LocalizationKeys.resultsTeamTitle);

  /// Translations:
  ///
  /// en:  **'End of your career'**
  ///
  /// nl:  **'Einde van je carrière'**
  ///
  /// fr:  **'End of your career'**
  ///
  /// es:  **'Fin de carrera'**
  String get careerFinishTitle => _t(LocalizationKeys.careerFinishTitle);

  /// Translations:
  ///
  /// en:  **'Reset career'**
  ///
  /// nl:  **'Carrière resetten'**
  ///
  /// fr:  **'Réinitialisation de la carrière'**
  ///
  /// es:  **'Reiniciar carrera'**
  String get careerResetTitle => _t(LocalizationKeys.careerResetTitle);

  /// Translations:
  ///
  /// en:  **'Start next event'**
  ///
  /// nl:  **'Start volgende evenement'**
  ///
  /// fr:  **'Début de la prochaine épreuve'**
  ///
  /// es:  **'Empezar el siguiente evento'**
  String get careerSelectRidersTitle => _t(LocalizationKeys.careerSelectRidersTitle);

  /// Translations:
  ///
  /// en:  **'Rankings'**
  ///
  /// nl:  **'Ranglijsten'**
  ///
  /// fr:  **'Rankings'**
  ///
  /// es:  **'Rankings'**
  String get careerStandingsTitle => _t(LocalizationKeys.careerStandingsTitle);

  /// Translations:
  ///
  /// en:  **'Calendar'**
  ///
  /// nl:  **'Kalender'**
  ///
  /// fr:  **'Calendar'**
  ///
  /// es:  **'Calendario'**
  String get careerCalendarTitle => _t(LocalizationKeys.careerCalendarTitle);

  /// Translations:
  ///
  /// en:  **'Career'**
  ///
  /// nl:  **'Carrière'**
  ///
  /// fr:  **'Career'**
  ///
  /// es:  **'career'**
  String get careerOverviewTitle => _t(LocalizationKeys.careerOverviewTitle);

  /// Translations:
  ///
  /// en:  **'Complete the first race to see results'**
  ///
  /// nl:  **'Voltooi de eerste race om resultaten te zien'**
  ///
  /// fr:  **'Terminez la première course pour voir les résultats'**
  ///
  /// es:  **'Completa la primera carrera para ver los resultados'**
  String get careerStandingsNoRacesCompleted => _t(LocalizationKeys.careerStandingsNoRacesCompleted);

  /// Translations:
  ///
  /// en:  **'results after [arg1 number] races'**
  ///
  /// nl:  **'resultaten na [arg1 number] races'**
  ///
  /// fr:  **'Résultats après [arg1 number] courses'**
  ///
  /// es:  **'resultados después de [arg1 number] carreras'**
  String careerStandingsRacesCompleted(num arg1) => _t(LocalizationKeys.careerStandingsRacesCompleted, args: <dynamic>[arg1]);

  /// Translations:
  ///
  /// en:  **'no.'**
  ///
  /// nl:  **'nee'**
  ///
  /// fr:  **'no.'**
  ///
  /// es:  **'no'**
  String get careerStandingsNumber => _t(LocalizationKeys.careerStandingsNumber);

  /// Translations:
  ///
  /// en:  **'name'**
  ///
  /// nl:  **'name'**
  ///
  /// fr:  **'nom'**
  ///
  /// es:  **'nombre'**
  String get careerStandingsName => _t(LocalizationKeys.careerStandingsName);

  /// Translations:
  ///
  /// en:  **'Races'**
  ///
  /// nl:  **'Races'**
  ///
  /// fr:  **'Races'**
  ///
  /// es:  **'Races'**
  String get careerStandingsRaces => _t(LocalizationKeys.careerStandingsRaces);

  /// Translations:
  ///
  /// en:  **'Points'**
  ///
  /// nl:  **'Punten'**
  ///
  /// fr:  **'Points'**
  ///
  /// es:  **'Puntos'**
  String get careerStandingsPoints => _t(LocalizationKeys.careerStandingsPoints);

  /// Translations:
  ///
  /// en:  **'Winner'**
  ///
  /// nl:  **'Winnaar'**
  ///
  /// fr:  **'Winner'**
  ///
  /// es:  **'Winner'**
  String get careerStandingsWinner => _t(LocalizationKeys.careerStandingsWinner);

  /// Translations:
  ///
  /// en:  **'You have the best rider in the world! Congratulations!'**
  ///
  /// nl:  **'Je hebt de beste renner van de wereld! Gefeliciteerd!'**
  ///
  /// fr:  **'Vous avez le meilleur coureur du monde ! Félicitations !'**
  ///
  /// es:  **'¡Tienes al mejor piloto del mundo! Enhorabuena!'**
  String get careerSingleWon => _t(LocalizationKeys.careerSingleWon);

  /// Translations:
  ///
  /// en:  **'The best rider in the world belongs to another team...'**
  ///
  /// nl:  **'De beste renner van de wereld hoort bij een ander team...'**
  ///
  /// fr:  **'Le meilleur coureur du monde appartient à une autre équipe...'**
  ///
  /// es:  **'El mejor piloto del mundo pertenece a otro equipo...'**
  String get careerSingleLost => _t(LocalizationKeys.careerSingleLost);

  /// Translations:
  ///
  /// en:  **'Your best rider has [arg1 number] points'**
  ///
  /// nl:  **'Je beste renner heeft [arg1 number] punten'**
  ///
  /// fr:  **'Votre meilleur coureur a [arg1 number] points'**
  ///
  /// es:  **'Tu mejor piloto tiene [arg1 number] puntos'**
  String careerSinglePoints(num arg1) => _t(LocalizationKeys.careerSinglePoints, args: <dynamic>[arg1]);

  /// Translations:
  ///
  /// en:  **'You have the best team in the world! Congratulations!'**
  ///
  /// nl:  **'Je hebt het beste team ter wereld! Gefeliciteerd!'**
  ///
  /// fr:  **'Vous avez la meilleure équipe du monde ! Félicitations !'**
  ///
  /// es:  **'¡Tienes el mejor equipo del mundo! Enhorabuena!'**
  String get careerTeamWon => _t(LocalizationKeys.careerTeamWon);

  /// Translations:
  ///
  /// en:  **'Another team has done better...'**
  ///
  /// nl:  **'Een andere ploeg heeft het beter gedaan...'**
  ///
  /// fr:  **'Une autre équipe a fait mieux...'**
  ///
  /// es:  **'Otro equipo lo ha hecho mejor...'**
  String get careerTeamLost => _t(LocalizationKeys.careerTeamLost);

  /// Translations:
  ///
  /// en:  **'Your team has [arg1 number] points'**
  ///
  /// nl:  **'Jouw team heeft [arg1 number] punten'**
  ///
  /// fr:  **'Votre équipe a [arg1 number] points'**
  ///
  /// es:  **'Tu equipo tiene [arg1 number] puntos'**
  String careerTeamPoints(num arg1) => _t(LocalizationKeys.careerTeamPoints, args: <dynamic>[arg1]);

  /// Translations:
  ///
  /// en:  **'You have won the career mode! Congratulations! Feel free to share your score and try to defeat other players' best score'**
  ///
  /// nl:  **'Je hebt de career mode gewonnen! Gefeliciteerd! Voel je vrij om je score te delen en probeer de beste score van andere spelers te verslaan'**
  ///
  /// fr:  **'Vous avez gagné le mode carrière ! Félicitations ! N'hésitez pas à partager votre score et à essayer de battre le meilleur score des autres joueurs'**
  ///
  /// es:  **'¡Has ganado el modo carrera! ¡Enhorabuena! No dudes en compartir tu puntuación e intentar derrotar la mejor puntuación de otros jugadores'**
  String get careerTotalWon => _t(LocalizationKeys.careerTotalWon);

  /// Translations:
  ///
  /// en:  **'You didn't win both the single and team ranking... Press continue to reset the career mode and try again!'**
  ///
  /// nl:  **'Je hebt niet zowel het single- als het teamklassement gewonnen.... Druk op continue om de carrièremodus te resetten en het opnieuw te proberen!'**
  ///
  /// fr:  **'Vous n'avez pas gagné le classement individuel et par équipe... Appuyez sur continue pour réinitialiser le mode carrière et réessayez !'**
  ///
  /// es:  **'No has ganado la clasificación individual y por equipos... Pulsa continuar para reiniciar el modo carrera e inténtalo de nuevo!'**
  String get careerTotalLost => _t(LocalizationKeys.careerTotalLost);

  /// Translations:
  ///
  /// en:  **'Complete a tour to see your ranking'**
  ///
  /// nl:  **'Voltooi een tour om je klassement te zien'**
  ///
  /// fr:  **'Terminez un tour pour voir votre classement'**
  ///
  /// es:  **'Completa un recorrido para ver tu clasificación'**
  String get careerOverviewNoResults => _t(LocalizationKeys.careerOverviewNoResults);

  /// Translations:
  ///
  /// en:  **'This will reset your career. Are you sure?'**
  ///
  /// nl:  **'Dit zal je carrière resetten. Weet je het zeker?'**
  ///
  /// fr:  **'Ceci va réinitialiser votre carrière. Are you sure ?'**
  ///
  /// es:  **'Esto reiniciará tu carrera. ¿Estás seguro?'**
  String get careerResetMessage => _t(LocalizationKeys.careerResetMessage);

  /// Translations:
  ///
  /// en:  **'Rankings'**
  ///
  /// nl:  **'Rankings'**
  ///
  /// fr:  **'Rankings'**
  ///
  /// es:  **'Rankings'**
  String get careerOverviewRankings => _t(LocalizationKeys.careerOverviewRankings);

  /// Translations:
  ///
  /// en:  **'Calendar'**
  ///
  /// nl:  **'Kalender'**
  ///
  /// fr:  **'Calendar'**
  ///
  /// es:  **'Calendario'**
  String get careerOverviewCalendar => _t(LocalizationKeys.careerOverviewCalendar);

  /// Translations:
  ///
  /// en:  **'Finish'**
  ///
  /// nl:  **'Finish'**
  ///
  /// fr:  **'Finish'**
  ///
  /// es:  **'Finish'**
  String get careerOverviewFinish => _t(LocalizationKeys.careerOverviewFinish);

  /// Translations:
  ///
  /// en:  **'Reset'**
  ///
  /// nl:  **'Reset'**
  ///
  /// fr:  **'Reset'**
  ///
  /// es:  **'Reset'**
  String get careerOverviewReset => _t(LocalizationKeys.careerOverviewReset);

  /// Translations:
  ///
  /// en:  **'Reset'**
  ///
  /// nl:  **'Reset'**
  ///
  /// fr:  **'Reset'**
  ///
  /// es:  **'Reset'**
  String get careerResetButton => _t(LocalizationKeys.careerResetButton);

  /// Translations:
  ///
  /// en:  **'Go back'**
  ///
  /// nl:  **'Ga terug'**
  ///
  /// fr:  **'Go back'**
  ///
  /// es:  **'Volver'**
  String get careerResetBack => _t(LocalizationKeys.careerResetBack);

  /// Translations:
  ///
  /// en:  **'Next Race'**
  ///
  /// nl:  **'Volgende Race'**
  ///
  /// fr:  **'Next Race'**
  ///
  /// es:  **'CarreraSiguiente'**
  String get careerOverviewStartNext => _t(LocalizationKeys.careerOverviewStartNext);

  /// Translations:
  ///
  /// en:  **'Join the discord server:'**
  ///
  /// nl:  **'Word lid van de discord server:'**
  ///
  /// fr:  **'Rejoindre le serveur discord:'**
  ///
  /// es:  **'Únase al servidor de discordia:'**
  String get discordServerIntro => _t(LocalizationKeys.discordServerIntro);

  /// Translations:
  ///
  /// en:  **'https://discord.gg/yNneVMy7Ff'**
  ///
  /// nl:  **'https://discord.gg/yNneVMy7Ff'**
  ///
  /// fr:  **'https://discord.gg/yNneVMy7Ff'**
  ///
  /// es:  **'https://discord.gg/yNneVMy7Ff'**
  String get discordServerUrl => _t(LocalizationKeys.discordServerUrl);

  /// Translations:
  ///
  /// en:  **'Welcom to version 2.0! \n I've made many changes to the game and hope you like it. \n You are now able to choice a different language in settings. \n Career has been revamped and you now have 37 races/tours with a global ranking. Try to win the single and team ranking and be the best in the world! \n Cyclists now have names, you can change them in settings. Feel free to give your own spin to it or even add yourself! \n If you have any questions or ideas, please join the discord server (i button on home).'**
  ///
  /// nl:  **'Welkom bij versie 2.0! \n Ik heb veel veranderingen in het spel aangebracht en ik hoop dat jullie het leuk vinden. \n Je kunt nu een andere taal kiezen in de instellingen. \n De carrière is vernieuwd en je hebt nu 37 races/rondes met een globaal klassement. Probeer het individuele en teamklassement te winnen en de beste van de wereld te worden! \n Renners hebben nu namen, je kunt ze veranderen in de instellingen. Voel je vrij om er je eigen draai aan te geven of zelfs jezelf toe te voegen! \n Als je vragen of ideeën hebt, kom dan naar de discord server (i knop op home).'**
  ///
  /// fr:  **'Bienvenue à la version 2.0 ! \n J'ai apporté de nombreuses modifications au jeu et j'espère qu'il vous plaira. \n Vous pouvez maintenant choisir une langue différente dans les paramètres. \n La carrière a été revue et vous avez maintenant 37 courses/tours avec un classement mondial. Essayez de gagner le classement individuel et par équipe et soyez le meilleur au monde ! \n Les cyclistes ont maintenant des noms, vous pouvez les changer dans les paramètres. N'hésitez pas à leur donner votre propre style ou même à vous ajouter ! \n Si vous avez des questions ou des idées, n'hésitez pas à rejoindre le serveur discord (bouton i sur l'accueil).'**
  ///
  /// es:  **'¡Bienvenidos a la versión 2.0! \n He hecho muchos cambios en el juego y espero que os guste. \n Ahora puedes elegir un idioma diferente en los ajustes. \n La carrera ha sido renovada y ahora tienes 37 carreras/tours con una clasificación global. Intenta ganar la clasificación individual y por equipos y sé el mejor del mundo. \n Los ciclistas ahora tienen nombres, puedes cambiarlos en la configuración. ¡Siéntete libre de darle tu propio giro o incluso añadirte a ti mismo! \n Si tienes alguna pregunta o idea, únete al servidor de discordia (botón i en la home)'**
  String get v2dialogText => _t(LocalizationKeys.v2dialogText);

  /// Translations:
  ///
  /// en:  **'Tour up above'**
  ///
  /// nl:  **'Tour hierboven'**
  ///
  /// fr:  **'Tour en haut'**
  ///
  /// es:  **'Tour arriba'**
  String get calendarEvent1 => _t(LocalizationKeys.calendarEvent1);

  /// Translations:
  ///
  /// en:  **'Tour of Valor'**
  ///
  /// nl:  **'Tour of Valor'**
  ///
  /// fr:  **'Tour of Valor'**
  ///
  /// es:  **'Tour of Valor'**
  String get calendarEvent2 => _t(LocalizationKeys.calendarEvent2);

  /// Translations:
  ///
  /// en:  **'Tour of the desert'**
  ///
  /// nl:  **'Ronde door de woestijn'**
  ///
  /// fr:  **'Tour du désert'**
  ///
  /// es:  **'Recorrido por el desierto'**
  String get calendarEvent3 => _t(LocalizationKeys.calendarEvent3);

  /// Translations:
  ///
  /// en:  **'Tour of the sun'**
  ///
  /// nl:  **'Ronde van de zon'**
  ///
  /// fr:  **'Tour du soleil'**
  ///
  /// es:  **'Tour del sol'**
  String get calendarEvent4 => _t(LocalizationKeys.calendarEvent4);

  /// Translations:
  ///
  /// en:  **'Tour of Persia'**
  ///
  /// nl:  **'Ronde door Perzië'**
  ///
  /// fr:  **'Tour de la Perse'**
  ///
  /// es:  **'Tour de Persia'**
  String get calendarEvent5 => _t(LocalizationKeys.calendarEvent5);

  /// Translations:
  ///
  /// en:  **'Circulation of the news paper'**
  ///
  /// nl:  **'Circulatie van de nieuwskrant'**
  ///
  /// fr:  **'Circulation du journal'**
  ///
  /// es:  **'Circulación del periódico'**
  String get calendarEvent6 => _t(LocalizationKeys.calendarEvent6);

  /// Translations:
  ///
  /// en:  **'Brussels - Kuurne - Brussels'**
  ///
  /// nl:  **'Brussel - Kuurne - Brussel'**
  ///
  /// fr:  **'Bruxelles - Kuurne - Bruxelles'**
  ///
  /// es:  **'Bruselas - Kuurne - Bruselas'**
  String get calendarEvent7 => _t(LocalizationKeys.calendarEvent7);

  /// Translations:
  ///
  /// en:  **'Street of Bianche'**
  ///
  /// nl:  **'Straat van Bianche'**
  ///
  /// fr:  **'Rue de Bianche'**
  ///
  /// es:  **'Calle de Bianche'**
  String get calendarEvent8 => _t(LocalizationKeys.calendarEvent8);

  /// Translations:
  ///
  /// en:  **'Nice Paris'**
  ///
  /// nl:  **'Nice Parijs'**
  ///
  /// fr:  **'Nice Paris'**
  ///
  /// es:  **'Niza - París'**
  String get calendarEvent9 => _t(LocalizationKeys.calendarEvent9);

  /// Translations:
  ///
  /// en:  **'Tirreno-Andromeda'**
  ///
  /// nl:  **'Tirreno-Andromeda'**
  ///
  /// fr:  **'Tirreno-Andromeda'**
  ///
  /// es:  **'Tirreno-Andrómeda'**
  String get calendarEvent10 => _t(LocalizationKeys.calendarEvent10);

  /// Translations:
  ///
  /// en:  **'Milan-Remi'**
  ///
  /// nl:  **'Milaan-Remi'**
  ///
  /// fr:  **'Milan-Remi'**
  ///
  /// es:  **'Milán-Remi'**
  String get calendarEvent11 => _t(LocalizationKeys.calendarEvent11);

  /// Translations:
  ///
  /// en:  **'Tour of Catan'**
  ///
  /// nl:  **'Ronde van Catan'**
  ///
  /// fr:  **'Tour de Catane'**
  ///
  /// es:  **'Vuelta a Catán'**
  String get calendarEvent12 => _t(LocalizationKeys.calendarEvent12);

  /// Translations:
  ///
  /// en:  **'E17 Harelbeke'**
  ///
  /// nl:  **'E17 Harelbeke'**
  ///
  /// fr:  **'E17 Harelbeke'**
  ///
  /// es:  **'E17 Harelbeke'**
  String get calendarEvent13 => _t(LocalizationKeys.calendarEvent13);

  /// Translations:
  ///
  /// en:  **'Gents - Weasel'**
  ///
  /// nl:  **'Gents - Wezel'**
  ///
  /// fr:  **'Gents - Weasel'**
  ///
  /// es:  **'Gents - Weasel'**
  String get calendarEvent14 => _t(LocalizationKeys.calendarEvent14);

  /// Translations:
  ///
  /// en:  **'Straight through Belgium'**
  ///
  /// nl:  **'Dwars door België'**
  ///
  /// fr:  **'Tout droit à travers la Belgique'**
  ///
  /// es:  **'Recta a través de Bélgica'**
  String get calendarEvent15 => _t(LocalizationKeys.calendarEvent15);

  /// Translations:
  ///
  /// en:  **'Classic Limburg'**
  ///
  /// nl:  **'Klassiek Limburg'**
  ///
  /// fr:  **'Classic Limburg'**
  ///
  /// es:  **'Limburgo clásico'**
  String get calendarEvent16 => _t(LocalizationKeys.calendarEvent16);

  /// Translations:
  ///
  /// en:  **'Tour around Flanders'**
  ///
  /// nl:  **'Rondje Vlaanderen'**
  ///
  /// fr:  **'Tour des Flandres'**
  ///
  /// es:  **'Vuelta a Flandes'**
  String get calendarEvent17 => _t(LocalizationKeys.calendarEvent17);

  /// Translations:
  ///
  /// en:  **'Tour of Basket'**
  ///
  /// nl:  **'Rondje basket'**
  ///
  /// fr:  **'Tour du Panier'**
  ///
  /// es:  **'Vuelta a la cesta'**
  String get calendarEvent18 => _t(LocalizationKeys.calendarEvent18);

  /// Translations:
  ///
  /// en:  **'Rubble from Paris'**
  ///
  /// nl:  **'Puinhoop van Parijs'**
  ///
  /// fr:  **'Décombres de Paris'**
  ///
  /// es:  **'Escombros de París'**
  String get calendarEvent19 => _t(LocalizationKeys.calendarEvent19);

  /// Translations:
  ///
  /// en:  **'Arrow of Brabant'**
  ///
  /// nl:  **'Pijl van Brabant'**
  ///
  /// fr:  **'Flèche de Brabant'**
  ///
  /// es:  **'Flecha de Brabante'**
  String get calendarEvent20 => _t(LocalizationKeys.calendarEvent20);

  /// Translations:
  ///
  /// en:  **'Gold Beer Race'**
  ///
  /// nl:  **'Goudbierrace'**
  ///
  /// fr:  **'Gold Beer Race'**
  ///
  /// es:  **'Carrera de la Cerveza de Oro'**
  String get calendarEvent21 => _t(LocalizationKeys.calendarEvent21);

  /// Translations:
  ///
  /// en:  **'Touring the Alps'**
  ///
  /// nl:  **'Toeren door de Alpen'**
  ///
  /// fr:  **'Touring the Alps'**
  ///
  /// es:  **'Vuelta a los Alpes'**
  String get calendarEvent22 => _t(LocalizationKeys.calendarEvent22);

  /// Translations:
  ///
  /// en:  **'Arrow of Walloon'**
  ///
  /// nl:  **'Pijl van Wallonië'**
  ///
  /// fr:  **'Flèche de Wallonie'**
  ///
  /// es:  **'Flecha de Valonia'**
  String get calendarEvent23 => _t(LocalizationKeys.calendarEvent23);

  /// Translations:
  ///
  /// en:  **'Bastogne-Liège-Bastogne'**
  ///
  /// nl:  **'Bastenaken-Luik-Bastenaken'**
  ///
  /// fr:  **'Bastogne-Liège-Bastogne'**
  ///
  /// es:  **'Bastogne-Liège-Bastogne'**
  String get calendarEvent24 => _t(LocalizationKeys.calendarEvent24);

  /// Translations:
  ///
  /// en:  **'Tour de Romantic'**
  ///
  /// nl:  **'Ronde van de romantiek'**
  ///
  /// fr:  **'Tour de Romantique'**
  ///
  /// es:  **'Tour de Romantic'**
  String get calendarEvent25 => _t(LocalizationKeys.calendarEvent25);

  /// Translations:
  ///
  /// en:  **'Giro in Italic'**
  ///
  /// nl:  **'Giro in Italic'**
  ///
  /// fr:  **'Giro in Italic'**
  ///
  /// es:  **'Giro en Itálica'**
  String get calendarEvent26 => _t(LocalizationKeys.calendarEvent26);

  /// Translations:
  ///
  /// en:  **'Tour of Californication'**
  ///
  /// nl:  **'Ronde van Californication'**
  ///
  /// fr:  **'Tour of Californication'**
  ///
  /// es:  **'Tour de California'**
  String get calendarEvent27 => _t(LocalizationKeys.calendarEvent27);

  /// Translations:
  ///
  /// en:  **'Critérium of Delphine'**
  ///
  /// nl:  **'Critérium van Delphine'**
  ///
  /// fr:  **'Critérium de la Delphine'**
  ///
  /// es:  **'Critérium de Delphine'**
  String get calendarEvent28 => _t(LocalizationKeys.calendarEvent28);

  /// Translations:
  ///
  /// en:  **'Tour of Swiss knives'**
  ///
  /// nl:  **'Ronde van zwiterse messen'**
  ///
  /// fr:  **'Tour des couteaux suisses'**
  ///
  /// es:  **'Tour de los cuchillos suizos'**
  String get calendarEvent29 => _t(LocalizationKeys.calendarEvent29);

  /// Translations:
  ///
  /// en:  **'Tour de France cheese'**
  ///
  /// nl:  **'Tour de France kaas'**
  ///
  /// fr:  **'Tour de France des fromages'**
  ///
  /// es:  **'Tour de Francia del queso'**
  String get calendarEvent30 => _t(LocalizationKeys.calendarEvent30);

  /// Translations:
  ///
  /// en:  **'Classic Sebastian'**
  ///
  /// nl:  **'Klassieker Sebastian'**
  ///
  /// fr:  **'Classic Sebastian'**
  ///
  /// es:  **'Clásico de Sebastián'**
  String get calendarEvent31 => _t(LocalizationKeys.calendarEvent31);

  /// Translations:
  ///
  /// en:  **'Binck or bank Tour'**
  ///
  /// nl:  **'Binck of bank Tour'**
  ///
  /// fr:  **'Binck ou le Tour des banques'**
  ///
  /// es:  **'Tour de Binck o del banco'**
  String get calendarEvent32 => _t(LocalizationKeys.calendarEvent32);

  /// Translations:
  ///
  /// en:  **'Tour of pain'**
  ///
  /// nl:  **'Ronde van de pijn'**
  ///
  /// fr:  **'Tour de la douleur'**
  ///
  /// es:  **'Tour del dolor'**
  String get calendarEvent33 => _t(LocalizationKeys.calendarEvent33);

  /// Translations:
  ///
  /// en:  **'Tour of the Queen'**
  ///
  /// nl:  **'Ronde van de Koningin'**
  ///
  /// fr:  **'Tour de la Reine'**
  ///
  /// es:  **'Tour de la Reina'**
  String get calendarEvent34 => _t(LocalizationKeys.calendarEvent34);

  /// Translations:
  ///
  /// en:  **'Great price of Queue'**
  ///
  /// nl:  **'Grote prijs van de wachtrij'**
  ///
  /// fr:  **'Grand prix de la Queue'**
  ///
  /// es:  **'Gran precio de la cola'**
  String get calendarEvent35 => _t(LocalizationKeys.calendarEvent35);

  /// Translations:
  ///
  /// en:  **'Great price of Moutain'**
  ///
  /// nl:  **'Grote prijs van de berg'**
  ///
  /// fr:  **'Grand prix de la Montagne'**
  ///
  /// es:  **'Gran precio de la Montaña'**
  String get calendarEvent36 => _t(LocalizationKeys.calendarEvent36);

  /// Translations:
  ///
  /// en:  **'Tour of Lombard'**
  ///
  /// nl:  **'Ronde van Lombard'**
  ///
  /// fr:  **'Tour de Lombard'**
  ///
  /// es:  **'Vuelta a Lombard'**
  String get calendarEvent37 => _t(LocalizationKeys.calendarEvent37);

  String getTranslation(String key, {List<dynamic>? args}) => _t(key, args: args ?? <dynamic>[]);

}
