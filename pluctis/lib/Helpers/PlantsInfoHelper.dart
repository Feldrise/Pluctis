import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:pluctis/Helpers/DatabaseHelper.dart';
import 'package:pluctis/Models/Plant.dart';
import 'package:sqflite/sqflite.dart';

String plantInfoColunmPlantation = "info_plantation";
String plantInfoColunmWatering = "info_watering";
String plantInfoColunmExposure = "info_exposure";

class PlantsInfoHelper {
  PlantsInfoHelper._privateConstructor();
  static final PlantsInfoHelper instance = PlantsInfoHelper._privateConstructor();

  static Database _plantsInfoDatabase;

  Future<Database> get plantsInfoDatabase async {
    if (_plantsInfoDatabase != null) return _plantsInfoDatabase;
    
    _plantsInfoDatabase = await _initPlantsInfoDatabase();
    return _plantsInfoDatabase;
  }

  // open plants info database
  _initPlantsInfoDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "plants_info.db");

    // delete existing if any
    await deleteDatabase(path);

    // Make sure the parent directory exists
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    // Copy from asset
    ByteData data = await rootBundle.load(join("assets", "plants_info.db"));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(path).writeAsBytes(bytes, flush: true);

    // open the database
    return await openDatabase(path, readOnly: true);
  }

  Future<Plant> plantFromInfo(String slug) async {
    Database db = await plantsInfoDatabase;

    List<Map> maps = await db.query(tablePlants,
      columns: [plantColumnSlug,
                plantColumnName,
                plantColumnWinterCycle,
                plantColumnSpringCycle,
                plantColumnSummerCycle,
                plantColumnAutumnCycle,
                plantInfoColunmPlantation,
                plantInfoColunmWatering,
                plantInfoColunmExposure],
      where: '$plantColumnSlug = ?',
      whereArgs: [slug]
    );

    if (maps.length > 0) {
      Plant newPlant = Plant.fromMap(maps.first);
      newPlant.currentLocation = "Indéfini";
      
      return newPlant;
    }

    return null;
  }  

  Future<List<Plant>> availablePlants() async {
    Database db = await plantsInfoDatabase;
    List<Plant> result = [];

    List<Map> maps = await db.query(tablePlants,
      columns: [plantColumnSlug,
                plantColumnName,
                plantColumnWinterCycle,
                plantColumnSpringCycle,
                plantColumnSummerCycle,
                plantColumnAutumnCycle,
                plantInfoColunmPlantation,
                plantInfoColunmWatering,
                plantInfoColunmExposure],
    );

    for (var plant in maps) {
      Plant toAdd = Plant.fromMap(plant);
      toAdd.currentLocation = "Indéfini";
      
      result.add(toAdd);
    }

    return result;
  }

  Future<String> plantInfoPlantation(String slug) async {
    return await plantInfo(slug, "plantation");
  }

  Future<String> plantInfoWatering(String slug) async {
    return await plantInfo(slug, "watering");
  }

  Future<String> plantInfoExposure(String slug) async {
    return await plantInfo(slug, "exposure");
  }

  Future<String> plantInfo(String slug, String infoType) async {
    Database db = await plantsInfoDatabase;

    List<Map> maps = await db.query(tablePlants,
      columns: [plantColumnSlug,
                plantInfoColunmPlantation,
                plantInfoColunmWatering,
                plantInfoColunmExposure],
      where: '$plantColumnSlug = ?',
      whereArgs: [slug]
    );

    if (maps.length > 0) {
      if (infoType == "plantation")
        return maps.first[plantInfoColunmPlantation];
      
      if (infoType == "watering")
        return maps.first[plantInfoColunmWatering];
      
      if (infoType == "exposure") 
        return maps.first[plantInfoColunmExposure];

      return "Indéfini";
    }

    return "Indéfini";
  }
}