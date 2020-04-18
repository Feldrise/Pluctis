import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pluctis/Helpers/PlantsInfoHelper.dart';
import 'package:pluctis/Helpers/VegeInfoHelper.dart';
import 'package:pluctis/Models/Plant.dart';
import 'package:pluctis/Models/Vegetable.dart';
import 'package:sqflite/sqflite.dart';

final String tablePlants = "plants";
final String tableVegetables = "vegetables";

String plantColumnId = "_id";
String plantColumnSlug = "slug";
String plantColumnName = "name";
String plantColumnCurrentLocation = "current_location";
String plantColumnWinterCycle = "cycle_winter";
String plantColumnSpringCycle = "cycle_spring";
String plantColumnSummerCycle = "cycle_summer";
String plantColumnAutumnCycle = "cycle_autumn";
String plantColumnNextWatering = "next_watering";

String vegetableColumnId = "_id";
String vegetableColumnSlug = "slug";

class DatabaseHelper {
  static final _databaseName = "PantasiaDatabase";
  static final _databaseVersion = 4;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
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
            $plantColumnSlug TEXT NOT NULL,
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
    Database db = await database;
    int id = await db.insert(tablePlants, plant.toMap());

    return id;
  } 

  Future<int> insertVegetable(Vegetable vegetable) async {
    Database db = await database;
    int id = await db.insert(tableVegetables, {vegetableColumnSlug: vegetable.slug});

    return id;
  }

  Future<Plant> queryPlant(int id) async {
    Database db = await database;

    List<Map> maps = await db.query(tablePlants,
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
      whereArgs: [id]
    );

    if (maps.length > 0) {
      PlantsInfoHelper plantsInfoHelper = PlantsInfoHelper.instance;

      Plant plant = Plant.fromMap(maps.first);
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
    Database db = await database;

    List<Map> maps = await db.query(tableVegetables,
      columns: [vegetableColumnId,
                vegetableColumnSlug],
      where: '$vegetableColumnId = ?',
      whereArgs: [id]
    );

    if (maps.length > 0) {
      VegeInfoHelper vegeInfoHelper = VegeInfoHelper.instance;

      Vegetable vegetable = await vegeInfoHelper.vegetableFromInfo(maps.first[vegetableColumnSlug]);
      vegetable.id = maps.first[vegetableColumnId];

      return vegetable;
    }

    return null;

  }

  Future<List<Plant>> queryAllPlants() async {
    Database db = await database;
    List<Plant> result = [];

    List<Map> maps = await db.query(tablePlants,
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

    PlantsInfoHelper plantsInfoHelper = PlantsInfoHelper.instance;
    
    for (var plant in maps) {
      Plant toAdd = Plant.fromMap(plant);
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
    Database db = await database;
    List<Vegetable> result = [];

    List<Map> maps = await db.query(tableVegetables,
      columns: [vegetableColumnId,
                vegetableColumnSlug],
    );
    
    VegeInfoHelper vegeInfoHelper = VegeInfoHelper.instance;

    for (var vegetable in maps) {
      Vegetable toAdd = await vegeInfoHelper.vegetableFromInfo(vegetable[vegetableColumnSlug]);
      toAdd.id = vegetable[vegetableColumnId];

      result.add(toAdd);
    }

    return result;

  }

  Future updatePlant(Plant plant) async {
    Database db = await database;

    db.update(tablePlants, plant.toMap(),
      where: '$plantColumnId = ?',
      whereArgs: [plant.id]
    );
  }

  Future deletePlant(Plant plant) async {
    Database db = await database;

    db.delete(tablePlants,
      where: '$plantColumnId = ?',
      whereArgs: [plant.id]
    );
  }

  Future deleteVegetable(Vegetable vegetable) async {
    Database db = await database;

    db.delete(tableVegetables,
      where: '$vegetableColumnId = ?',
      whereArgs: [vegetable.id]
    );
  }
}