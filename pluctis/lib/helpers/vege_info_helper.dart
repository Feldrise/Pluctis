import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:pluctis/helpers/database_helper.dart';
import 'package:pluctis/models/vege_problem.dart';
import 'package:pluctis/models/vegetable.dart';
import 'package:sqflite/sqflite.dart';

const String tableVegeProblems = "problems";
const String tableVegeInfos = "vegetables";

const String vegeProblemsColumnSlug = "slug";
const String vegeProblemsColumnName = "name";
const String vegeProblemsColumnSymptoms = "symptoms";
const String vegeProblemsColumnRemedy = "remedy";

const String vegeInfoColumnSlug = "slug";
const String vegeInfoColumnName = "name";
const String vegeInfoColumnDescription = "description";
const String vegeInfoColumnSowMonths = "sow_months";
const String vegeInfoColumnPlantMonths = "plant_months";
const String vegeInfoColumnHarvestMonths = "harvest_months";
const String vegeInfoColumnSowing = "info_sowing";
const String vegeInfoColumnGrowing = "info_growing";
const String vegeInfoColumnHarvesting = "info_harvesting";
const String vegeInfoColumnProblems = "problems";


class VegeInfoHelper {
  VegeInfoHelper._privateConstructor();
  static final VegeInfoHelper instance = VegeInfoHelper._privateConstructor();

  static Database _vegeInfoDatabase;

  Future<Database> get vegeInfoDatabase async {
    if (_vegeInfoDatabase != null) return _vegeInfoDatabase;
    
    return _initVegeInfoDatabase();
  }

  // open vegetables info database
  Future<Database> _initVegeInfoDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "vege_garden_info.db");

    // delete existing if any
    await deleteDatabase(path);

    // Make sure the parent directory exists
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    // Copy from asset
    final ByteData data = await rootBundle.load(join("assets", "vege_garden_info.db"));
    final List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes, flush: true);

    // open the database
    return openDatabase(path, readOnly: true);
  }

  Future<Vegetable> vegetableFromInfo(String slug) async {
    final Database db = await vegeInfoDatabase;

    final List<Map> maps = await db.query(tableVegeInfos,
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
      whereArgs: <String>[slug]
    );

    if (maps.isNotEmpty) {
      final Vegetable newVegetable = Vegetable.fromMap(maps.first as Map<String, dynamic>);
      
      final String problemsSlugsString = maps.first[vegeInfoColumnProblems] as String;
      final List<String> problemsSlugs = problemsSlugsString.split(",");

      for (final problemSlug in problemsSlugs) {
        newVegetable.problems.add(await vegeProblemFromInfo(problemSlug));
      }
      
      return newVegetable;
    }

    return null;
  }  

  Future<VegeProblem> vegeProblemFromInfo(String slug) async {
    final Database db = await vegeInfoDatabase;

    final List<Map> maps = await db.query(tableVegeProblems,
      columns: [
        vegeProblemsColumnSlug,
        vegeProblemsColumnName,
        vegeProblemsColumnSymptoms,
        vegeProblemsColumnRemedy
      ],
      where: '$vegeProblemsColumnSlug = ?',
      whereArgs: <String>[slug]
    );

    if (maps.isNotEmpty) {
      final VegeProblem problem = VegeProblem.fromMap(maps.first as Map<String, dynamic>);
      return problem;
    }

    return null;
  }  

  
  Future<List<Vegetable>> availableVegetables() async {
    final Database db = await vegeInfoDatabase;
    final List<Vegetable> result = [];

    final List<Map> maps = await db.query(tableVegetables,
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

    for (final vegetable in maps) {
      final Vegetable toAdd = Vegetable.fromMap(vegetable as Map<String, dynamic>);
      
      final String problemsSlugsString = vegetable[vegeInfoColumnProblems] as String;
      final List<String> problemsSlugs = problemsSlugsString.split(",");

      for (final problemSlug in problemsSlugs) {
        toAdd.problems.add(await vegeProblemFromInfo(problemSlug));
      }
      
      result.add(toAdd);
    }

    return result;
  }
}