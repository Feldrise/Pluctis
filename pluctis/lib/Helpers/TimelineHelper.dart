
import 'package:pluctis/Models/Plant.dart';

enum Month { january, february, march, april, may, june, july, august, september, october, november, december }

Map<Month, String> monthSlug = {
  Month.january: "jan",
  Month.february: "feb",
  Month.march: "mar",
  Month.april: "apr",
  Month.march: "mar",
  Month.april: "apr",
  Month.may: "may",
  Month.june: "jun",
  Month.august: "aug",
  Month.september: "sep",
  Month.october: "oct",
  Month.november: "nov",
  Month.december: "dec"
};

class TimelineHelper {
  final String winter = "winter";
  final String spring = "spring";
  final String summer = "summer";
  final String autumn = "autumn";

  TimelineHelper._privateConstructor();
  static final TimelineHelper instance = TimelineHelper._privateConstructor();

  String get currentSeason {
    DateTime now = DateTime.now();

    if ((now.day >= 21 && now.month >= 12) || (now.day < 20 && now.month <= 3)) {
      return winter;
    }
    
    if ((now.day >= 20 && now.month >= 3) || (now.day < 20 && now.month <= 6)) {
      return spring;
    }

    if ((now.day >= 20 && now.month >= 6) || (now.day < 22 && now.month <= 9)) {
      return spring;
    }

    return autumn;
  }

  DateTime nextWateringForPlant(DateTime lastWatered, Plant plant) {
    DateTime base = DateTime(lastWatered.year, lastWatered.month, lastWatered.day, 10, 00);

    if (currentSeason == winter) {
      return base.add(Duration(days: plant.winterCycle));
    }
    if (currentSeason == spring) {
      return base.add(Duration(days: plant.springCycle));
    }
    if (currentSeason == summer) {
      return base.add(Duration(days: plant.summerCycle));
    }

    return base.add(Duration(days: plant.autumnCycle));
  }

  String remainingDaysString(Plant plant) {
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 00);
    Duration remaining = plant.nextWatering.difference(now);

    if (remaining.inDays == 0) {
      return "Aujourd'hui";
    }
    else if (remaining.inDays == 1) {
      return "Demain";
    }
    else if (remaining.inDays < 0) {
      return "Dépassé";
    }

    return "${remaining.inDays} jours";
  }

}