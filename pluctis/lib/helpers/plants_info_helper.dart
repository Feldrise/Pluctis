import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:pluctis/helpers/database_helper.dart';
import 'package:pluctis/models/plant.dart';
import 'package:sqflite/sqflite.dart';

const String plantInfoColumnSourcesLinks = "sources_links";
const String plantInfoColunmPlantation = "info_plantation";
const String plantInfoColunmWatering = "info_watering";
const String plantInfoColunmExposure = "info_exposure";
const String plantInfoColunmGoodAnimals = "good_animals";
const String plantInfoColumnDisease = "disease";
const String plantInfoColumnBadAnimals = "bad_animals";


class PlantsInfoHelper {
  PlantsInfoHelper._privateConstructor();
  static final PlantsInfoHelper instance = PlantsInfoHelper._privateConstructor();

  static Database _plantsInfoDatabase;

  Future<Database> get plantsInfoDatabase async {
    if (_plantsInfoDatabase != null) return _plantsInfoDatabase;
    
    return _initPlantsInfoDatabase();
  }

  // open plants info database
  Future<Database> _initPlantsInfoDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "plants_info.db");

    // delete existing if any
    await deleteDatabase(path);

    // Make sure the parent directory exists
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    // Copy from asset
    final ByteData data = await rootBundle.load(join("assets", "plants_info.db"));
    final List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes, flush: true);

    // open the database
    return openDatabase(path, readOnly: true);
  }

  Future<Plant> plantFromInfo(String slug) async {
    final Database db = await plantsInfoDatabase;

    final List<Map> maps = await db.query(tablePlants,
      columns: [plantColumnSlug,
                plantColumnName,
                plantColumnWinterCycle,
                plantColumnSpringCycle,
                plantColumnSummerCycle,
                plantColumnAutumnCycle,
                plantInfoColumnSourcesLinks,
                plantInfoColunmPlantation,
                plantInfoColunmWatering,
                plantInfoColunmExposure,
                plantInfoColunmGoodAnimals,
                plantInfoColumnDisease,
                plantInfoColumnBadAnimals],
      where: '$plantColumnSlug = ?',
      whereArgs: <String>[slug]
    );

    if (maps.isNotEmpty) {
      final Plant newPlant = Plant.fromMap(maps.first as Map<String, dynamic>);
      newPlant.currentLocation = "Indéfini";
      
      return newPlant;
    }

    return null;
  }  

  Future<List<Plant>> availablePlants() async {
    final Database db = await plantsInfoDatabase;
    final List<Plant> result = [];

    final List<Map> maps = await db.query(tablePlants,
      columns: [plantColumnSlug,
                plantColumnName,
                plantColumnWinterCycle,
                plantColumnSpringCycle,
                plantColumnSummerCycle,
                plantColumnAutumnCycle,
                plantInfoColumnSourcesLinks,
                plantInfoColunmPlantation,
                plantInfoColunmWatering,
                plantInfoColunmExposure,
                plantInfoColunmGoodAnimals,
                plantInfoColumnDisease,
                plantInfoColumnBadAnimals],
      orderBy: "$plantColumnName ASC"
    );

    for (final plant in maps) {
      final Plant toAdd = Plant.fromMap(plant as Map<String, dynamic>);
      toAdd.currentLocation = "Indéfini";
      
      result.add(toAdd);
    }

    return result;
  }

  Future<List<String>> plantInfoSourcesLink(String slug) async {
    final String sourcesLinksString = await plantInfo(slug, "sources_links");

    if (sourcesLinksString != null) {
      return sourcesLinksString.split('\\');
    }
    
    return [];
  }

  Future<String> plantInfoPlantation(String slug) async {
    return plantInfo(slug, "plantation");
  }

  Future<String> plantInfoWatering(String slug) async {
    return plantInfo(slug, "watering");
  }

  Future<String> plantInfoExposure(String slug) async {
    return plantInfo(slug, "exposure");
  }

  Future<String> plantInfoGoodAnimals(String slug) async {
    return plantInfo(slug, "good_animals");
  }

  Future<String> plantInfoDisease(String slug) async {
    return plantInfo(slug, "disease");
  }

  Future<String> plantInfoBadAnimals(String slug) async {
    return plantInfo(slug, "bad_animals");
  }

  Future<String> plantInfo(String slug, String infoType) async {
    final Database db = await plantsInfoDatabase;

    final List<Map> maps = await db.query(tablePlants,
      columns: [plantColumnSlug,
                plantInfoColumnSourcesLinks,
                plantInfoColunmPlantation,
                plantInfoColunmWatering,
                plantInfoColunmExposure,
                plantInfoColunmGoodAnimals,
                plantInfoColumnDisease,
                plantInfoColumnBadAnimals],
      where: '$plantColumnSlug = ?',
      whereArgs: <String>[slug]
    );

    if (maps.isNotEmpty) {
      if (infoType == "sources_links") {
        return maps.first[plantInfoColumnSourcesLinks] as String;
      }

      if (infoType == "plantation") {
        return maps.first[plantInfoColunmPlantation] as String;
      }
      
      if (infoType == "watering") {
        return maps.first[plantInfoColunmWatering] as String;
      }
      
      if (infoType == "exposure") {
        return maps.first[plantInfoColunmExposure] as String;
      }

      if (infoType == "good_animals") {
        return maps.first[plantInfoColunmGoodAnimals] as String;
      }

      if (infoType == "disease") {
        return maps.first[plantInfoColumnDisease] as String;
      }

      if (infoType == "bad_animals") {
        return maps.first[plantInfoColumnBadAnimals] as String;
      }

      return "Indéfini";
    }

    return "Indéfini";
  }
}