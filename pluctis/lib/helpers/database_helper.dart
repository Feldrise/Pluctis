import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pluctis/helpers/plants_info_helper.dart';
import 'package:pluctis/helpers/vege_info_helper.dart';
import 'package:pluctis/models/plant.dart';
import 'package:pluctis/models/vegetable.dart';
import 'package:sqflite/sqflite.dart';

const String tablePlants = "plants";
const String tableVegetables = "vegetables";

const String plantColumnId = "_id";
const String plantColumnSlug = "slug";
const String plantColumnName = "name";
const String plantColumnCurrentLocation = "current_location";
const String plantColumnWinterCycle = "cycle_winter";
const String plantColumnSpringCycle = "cycle_spring";
const String plantColumnSummerCycle = "cycle_summer";
const String plantColumnAutumnCycle = "cycle_autumn";
const String plantColumnNextWatering = "next_watering";

const String vegetableColumnId = "_id";
const String vegetableColumnSlug = "slug";

class DatabaseHelper {
  static const _databaseName = "PantasiaDatabase";
  static const _databaseVersion = 4;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    return _initDatabase();
  }

  // open the database
  Future<Database> _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,);
  }

  // SQL string to create the database 
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tablePlants (
            $plantColumnId INTEGER PRIMARY KEY,
            $plantColumnSlug TEXT NOT NULL,
            $plantColumnName TEXT NOT NULL,
            $plantColumnCurrentLocation TEXT NOT NULL,
            $plantColumnWinterCycle INT NOT NULL,
            $plantColumnSpringCycle INT NOT NULL,
            $plantColumnSummerCycle INT NOT NULL,
            $plantColumnAutumnCycle INT NOT NULL,
            $plantColumnNextWatering INT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableVegetables (
            $plantColumnId INTEGER PRIMARY KEY,
            $plantColumnSlug TEXT NOT NULL
          )
          ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion >= 3 && oldVersion < 3) {
      await db.execute('DROP TABLE interior_plants');
      await db.execute('DROP TABLE garden_plants');

      await db.execute('''
          CREATE TABLE $tablePlants (
            $plantColumnId INTEGER PRIMARY KEY,
            $plantColumnSlug TEXT NOT NULL,
            $plantColumnName TEXT NOT NULL,
            $plantColumnCurrentLocation TEXT NOT NULL,
            $plantColumnWinterCycle INT NOT NULL,
            $plantColumnSpringCycle INT NOT NULL,
            $plantColumnSummerCycle INT NOT NULL,
            $plantColumnAutumnCycle INT NOT NULL,
            $plantColumnNextWatering INT NOT NULL
          )
          ''');
    }
    if (newVersion >= 4 && oldVersion < 4) {
      await db.execute('''
          CREATE TABLE $tableVegetables (
            $plantColumnId INTEGER PRIMARY KEY,
            $plantColumnSlug TEXT NOT NULL
          )
          ''');
    }
  }  

  Future<int> insertPlant(Plant plant) async {
    final Database db = await database;
    final int id = await db.insert(tablePlants, plant.toMap());

    return id;
  } 

  Future<int> insertVegetable(Vegetable vegetable) async {
    final Database db = await database;
    final String slug = vegetable.slug;
    final int id = await db.insert(tableVegetables, <String, String>{vegetableColumnSlug: slug});

    return id;
  }

  Future<Plant> queryPlant(int id) async {
    final Database db = await database;

    final List<Map> maps = await db.query(tablePlants,
      columns: [plantColumnId,
                plantColumnSlug,
                plantColumnName,
                plantColumnCurrentLocation,
                plantColumnWinterCycle,
                plantColumnSpringCycle,
                plantColumnSummerCycle,
                plantColumnAutumnCycle,
                plantColumnNextWatering],
      where: '$plantColumnId = ?',
      whereArgs: <int>[id]
    );

    if (maps.isNotEmpty) {
      final PlantsInfoHelper plantsInfoHelper = PlantsInfoHelper.instance;

      final Plant plant = Plant.fromMap(maps.first as Map<String, dynamic>);
      plant.sourcesLinks = await plantsInfoHelper.plantInfoSourcesLink(plant.slug);
      plant.infoPlantation = await plantsInfoHelper.plantInfoPlantation(plant.slug);
      plant.infoWatering = await plantsInfoHelper.plantInfoWatering(plant.slug);
      plant.infoExposure = await plantsInfoHelper.plantInfoExposure(plant.slug);
      plant.goodAnimals = await plantsInfoHelper.plantInfoGoodAnimals(plant.slug);
      plant.disease = await plantsInfoHelper.plantInfoDisease(plant.slug);
      plant.badAnimals = await plantsInfoHelper.plantInfoBadAnimals(plant.slug);

      return plant;
    }

    return null;

  }

  Future<Vegetable> queryVegetable(int id) async {
    final Database db = await database;

    final List<Map> maps = await db.query(tableVegetables,
      columns: [vegetableColumnId,
                vegetableColumnSlug],
      where: '$vegetableColumnId = ?',
      whereArgs: <int>[id]
    );

    if (maps.isNotEmpty) {
      final VegeInfoHelper vegeInfoHelper = VegeInfoHelper.instance;

      final Vegetable vegetable = await vegeInfoHelper.vegetableFromInfo(maps.first[vegetableColumnSlug] as String);
      vegetable.id = maps.first[vegetableColumnId] as int;

      return vegetable;
    }

    return null;

  }

  Future<List<Plant>> queryAllPlants() async {
    final Database db = await database;
    final List<Plant> result = [];

    final List<Map> maps = await db.query(tablePlants,
      columns: [plantColumnId,
                plantColumnSlug,
                plantColumnName,
                plantColumnCurrentLocation,
                plantColumnWinterCycle,
                plantColumnSpringCycle,
                plantColumnSummerCycle,
                plantColumnAutumnCycle,
                plantColumnNextWatering],
    );

    final PlantsInfoHelper plantsInfoHelper = PlantsInfoHelper.instance;
    
    for (final plant in maps) {
      final Plant toAdd = Plant.fromMap(plant as Map<String, dynamic>);
      toAdd.sourcesLinks = await plantsInfoHelper.plantInfoSourcesLink(toAdd.slug);
      toAdd.infoPlantation = await plantsInfoHelper.plantInfoPlantation(toAdd.slug);
      toAdd.infoWatering = await plantsInfoHelper.plantInfoWatering(toAdd.slug);
      toAdd.infoExposure = await plantsInfoHelper.plantInfoExposure(toAdd.slug);
      toAdd.goodAnimals = await plantsInfoHelper.plantInfoGoodAnimals(toAdd.slug);
      toAdd.disease = await plantsInfoHelper.plantInfoDisease(toAdd.slug);
      toAdd.badAnimals = await plantsInfoHelper.plantInfoBadAnimals(toAdd.slug);

      result.add(toAdd);
    }

    return result;
  }

  
  Future<List<Vegetable>> queryAllVegetable() async {
    final Database db = await database;
    final List<Vegetable> result = [];

    final List<Map> maps = await db.query(tableVegetables,
      columns: [vegetableColumnId,
                vegetableColumnSlug],
    );
    
    final VegeInfoHelper vegeInfoHelper = VegeInfoHelper.instance;

    for (final vegetable in maps) {
      final Vegetable toAdd = await vegeInfoHelper.vegetableFromInfo(vegetable[vegetableColumnSlug] as String);
      toAdd.id = vegetable[vegetableColumnId] as int;

      result.add(toAdd);
    }

    return result;

  }

  Future updatePlant(Plant plant) async {
    final Database db = await database;

    db.update(tablePlants, plant.toMap(),
      where: '$plantColumnId = ?',
      whereArgs: <int>[plant.id]
    );
  }

  Future deletePlant(Plant plant) async {
    final Database db = await database;

    db.delete(tablePlants,
      where: '$plantColumnId = ?',
      whereArgs: <int>[plant.id]
    );
  }

  Future deleteVegetable(Vegetable vegetable) async {
    final Database db = await database;

    db.delete(tableVegetables,
      where: '$vegetableColumnId = ?',
      whereArgs: <int>[vegetable.id]
    );
  }
}