import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

String tableVegeProblems = "problems";

String vegeProblemsColumnSlug = "slug";
String vegeProblemsColumnName = "name";
String vegeProblemsColumnSymptoms = "symptoms";
String vegeProblemsColumnRemedy = "remedy";


class VegeInfoHelper {
  VegeInfoHelper._privateConstructor();
  static final VegeInfoHelper instance = VegeInfoHelper._privateConstructor();

  static Database _vegeInfoDatabase;

  Future<Database> get vegeInfoDatabase async {
    if (_vegeInfoDatabase != null) return _vegeInfoDatabase;
    
    _vegeInfoDatabase = await _initPlantsInfoDatabase();
    return _vegeInfoDatabase;
  }

  // open plants info database
  _initPlantsInfoDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "vege_garden_info.db");

    // delete existing if any
    await deleteDatabase(path);

    // Make sure the parent directory exists
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    // Copy from asset
    ByteData data = await rootBundle.load(join("assets", "vege_garden_info.db"));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(path).writeAsBytes(bytes, flush: true);

    // open the database
    return await openDatabase(path, readOnly: true);
  }

  // Future<Plant> plantFromInfo(String slug) async {
  //   Database db = await plantsInfoDatabase;

  //   List<Map> maps = await db.query(tablePlants,
  //     columns: [plantColumnSlug,
  //               plantColumnName,
  //               plantColumnWinterCycle,
  //               plantColumnSpringCycle,
  //               plantColumnSummerCycle,
  //               plantColumnAutumnCycle,
  //               plantInfoColumnSourcesLinks,
  //               plantInfoColunmPlantation,
  //               plantInfoColunmWatering,
  //               plantInfoColunmExposure,
  //               plantInfoColunmGoodAnimals,
  //               plantInfoColumnDisease,
  //               plantInfoColumnBadAnimals],
  //     where: '$plantColumnSlug = ?',
  //     whereArgs: [slug]
  //   );

  //   if (maps.length > 0) {
  //     Plant newPlant = Plant.fromMap(maps.first);
  //     newPlant.currentLocation = "Indéfini";
      
  //     return newPlant;
  //   }

  //   return null;
  // }  
}