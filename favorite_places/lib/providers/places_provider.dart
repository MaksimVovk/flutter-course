import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

Future<Database> _getDb() async {
  final dbpath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbpath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'create table user_places(id text primary key, title text, image text, lat real, lng real, address text);');
    },
    version: 1,
  );

  return db;
}

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);

  Future<void> loadPlaces() async {
    final db = await _getDb();

    final data = await db.query('user_places');
    final places = data
        .map(
          (it) => Place(
            id: it['id'] as String,
            title: it['title'] as String,
            image: File(it['image'] as String),
            location: PlaceLocation(
              latitude: it['lat'] as double,
              longitude: it['lng'] as double,
              address: it['address'] as String,
            ),
          ),
        )
        .toList();
    state = places;
  }

  void addPlace(Place place) async {
    final db = await _getDb();
    db.insert('user_places', {
      'id': place.id,
      'title': place.title,
      'image': place.image.path,
      'lat': place.location.latitude,
      'lng': place.location.longitude,
      'address': place.location.address,
    });
    state = [...state, place];
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
    (ref) => PlacesNotifier());
