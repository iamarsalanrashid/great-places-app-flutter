import 'dart:io';

import 'package:flutter/material.dart';

import '../models/place.dart';
import '../helpers/db_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  addPlace(String pickedTitle, File pickedImage) {
    final Place newPlace = Place(title: pickedTitle,
        location: null,
        id: DateTime.now().toString(),
        image: pickedImage);
    _items.add(newPlace);
    notifyListeners();
    DBhelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,

    });
  }

  Future<void> fetchAndSetProducts() async {
    final dataList = await DBhelper.getData('user_places');
    _items = dataList.map((item) =>
        Place(title: item['title'] as String,
          location: null,
          id: item['id'] as String,
          image: File(item['image'] as String),)).toList();
  }
}
