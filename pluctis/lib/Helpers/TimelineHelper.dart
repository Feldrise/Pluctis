
import 'package:pluctis/Models/Plant.dart';
import 'package:pluctis/Models/Vegetable.dart';

enum Month { january, february, march, april, may, june, july, august, september, october, november, december }

Map<Month, String> monthSlug = {
  Month.january: "jan",
  Month.february: "feb",
  Month.march: "mar",
  Month.april: "apr",
  Month.may: "may",
  Month.june: "jun",
  Month.july: "jul",
  Month.august: "aug",
  Month.september: "sep",
  Month.october: "oct",
  Month.november: "nov",
  Month.december: "dec"
};

Map<int, Month> monthFromNumber = {
  1: Month.january,
  2: Month.february,
  3: Month.march,
  4: Month.april,
  5: Month.may,
  6: Month.june,
  7: Month.july,
  8: Month.august,
  9: Month.september,
  10: Month.october,
  11: Month.november,
  12: Month.december,
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

  String vegetableNextState(Vegetable vegetable) {
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 00);
    String result = "Inconnu";
    
    int nextMonthInt = (DateTime.now().month < 12) ? (DateTime.now().month + 1) : 1;
    bool haveNextState = false;

    do {
      // If we don't find a next state we should leave the loop anyway
      if (nextMonthInt == DateTime.now().month)
        break;

      DateTime nextMonth = DateTime(DateTime.now().year + ((nextMonthInt < DateTime.now().month) ? 1 : 0), nextMonthInt, 1, 10, 00);
      String nextMonthSlug = monthSlug[monthFromNumber[nextMonthInt]];
      String currentMonthSlug = monthSlug[monthFromNumber[DateTime.now().month]];

      if (vegetable.sowMonths.contains(nextMonthSlug) && (!vegetable.sowMonths.contains(currentMonthSlug) || nextMonthInt < DateTime.now().month)) {
        result = "Semi (${nextMonth.difference(now).inDays} jour(s))"; 
        haveNextState = true;
      }

      if (vegetable.plantMonths.contains(nextMonthSlug) && !vegetable.plantMonths.contains(currentMonthSlug)) {
        result = "Plantation (${nextMonth.difference(now).inDays} jour(s))"; 
        haveNextState = true;
      }

      if (vegetable.harvestMonths.contains(nextMonthSlug) && (!vegetable.harvestMonths.contains(currentMonthSlug) )) {
        result = "Cueillette (${nextMonth.difference(now).inDays} jour(s))"; 
        haveNextState = true;
      }

      nextMonthInt = (nextMonthInt < 12) ? nextMonthInt + 1 : 1;

    } while(!haveNextState);

    return result;
  }

}