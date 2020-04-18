import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:pluctis/Helpers/DatabaseHelper.dart';
import 'package:pluctis/Models/VegeProblem.dart';
import 'package:pluctis/Models/Vegetable.dart';
import 'package:sqflite/sqflite.dart';

String tableVegeProblems = "problems";
String tableVegeInfos = "vegetables";

String vegeProblemsColumnSlug = "slug";
String vegeProblemsColumnName = "name";
String vegeProblemsColumnSymptoms = "symptoms";
String vegeProblemsColumnRemedy = "remedy";

String vegeInfoColumnSlug = "slug";
String vegeInfoColumnName = "name";
String vegeInfoColumnDescription = "description";
String vegeInfoColumnSowMonths = "sow_months";
String vegeInfoColumnPlantMonths = "plant_months";
String vegeInfoColumnHarvestMonths = "harvest_months";
String vegeInfoColumnSowing = "info_sowing";
String vegeInfoColumnGrowing = "info_growing";
String vegeInfoColumnHarvesting = "info_harvesting";
String vegeInfoColumnProblems = "problems";


class VegeInfoHelper {
  VegeInfoHelper._privateConstructor();
  static final VegeInfoHelper instance = VegeInfoHelper._privateConstructor();

  static Database _vegeInfoDatabase;

  Future<Database> get vegeInfoDatabase async {
    if (_vegeInfoDatabase != null) return _vegeInfoDatabase;
    
    _vegeInfoDatabase = await _initVegeInfoDatabase();
    return _vegeInfoDatabase;
  }

  // open vegetables info database
  _initVegeInfoDatabase() async {
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

  Future<Vegetable> vegetableFromInfo(String slug) async {
    Database db = await vegeInfoDatabase;

    List<Map> maps = await db.query(tableVegeInfos,
      columns: [
        vegeInfoColumnSlug,
        vegeInfoColumnName,
        vegeInfoColumnDescription,
        vegeInfoColumnSowMonths,
        vegeInfoColumnPlantMonths,
        vegeInfoColumnHarvestMonths,
        vegeInfoColumnSowing,
        vegeInfoColumnGrowing,
        vegeInfoColumnHarvesting,
        vegeInfoColumnProblems,
      ],
      where: '$vegeInfoColumnSlug = ?',
      whereArgs: [slug]
    );

    if (maps.length > 0) {
      Vegetable newVegetable = Vegetable.fromMap(maps.first);
      
      String problemsSlugsString = maps.first[vegeInfoColumnProblems];
      List<String> problemsSlugs = problemsSlugsString.split(",");

      for (var problemSlug in problemsSlugs) {
        newVegetable.problems.add(await vegeProblemFromInfo(problemSlug));
      }
      
      return newVegetable;
    }

    return null;
  }  

  Future<VegeProblem> vegeProblemFromInfo(String slug) async {
    Database db = await vegeInfoDatabase;

    List<Map> maps = await db.query(tableVegeProblems,
      columns: [
        vegeProblemsColumnSlug,
        vegeProblemsColumnName,
        vegeProblemsColumnSymptoms,
        vegeProblemsColumnRemedy
      ],
      where: '$vegeProblemsColumnSlug = ?',
      whereArgs: [slug]
    );

    if (maps.length > 0) {
      VegeProblem problem = VegeProblem.fromMap(maps.first);
      return problem;
    }

    return null;
  }  

  
  Future<List<Vegetable>> availableVegetables() async {
    Database db = await vegeInfoDatabase;
    List<Vegetable> result = [];

    List<Map> maps = await db.query(tableVegetables,
      columns: [
        vegeInfoColumnSlug,
        vegeInfoColumnName,
        vegeInfoColumnDescription,
        vegeInfoColumnSowMonths,
        vegeInfoColumnPlantMonths,
        vegeInfoColumnHarvestMonths,
        vegeInfoColumnSowing,
        vegeInfoColumnGrowing,
        vegeInfoColumnHarvesting,
        vegeInfoColumnProblems,
      ],
    );

    for (var vegetable in maps) {
      Vegetable toAdd = Vegetable.fromMap(vegetable);
      
      String problemsSlugsString = vegetable[vegeInfoColumnProblems];
      List<String> problemsSlugs = problemsSlugsString.split(",");

      for (var problemSlug in problemsSlugs) {
        toAdd.problems.add(await vegeProblemFromInfo(problemSlug));
      }
      
      result.add(toAdd);
    }

    return result;
  }
}