import 'package:flutter/material.dart';
import 'spieleapp.dart';

class Item {
  final String name;
  final String id;
  String? image;
  List<String> categories = [];
  List<String> numberOfPlayers = [];
  List<String> durationOfGame = [];
  List<String> weather = [];
  List<String> locations = [];
  String description = '';
  List<String> keywords = [];
  String material = '';

  Item({
    required this.name,
    required this.id,
  });

  Image? getImage() {
    if (image != null) {
      return Image.network(
        image!,
        loadingBuilder: (context, child, loadingProgress) {
          return loadingProgress == null
              ? child
              : const CircularProgressIndicator();
        },
      );
    } else {
      return null;
    }
  }

  List<Widget> createIcons() {
    List<Widget> iconWidgets = [];

    void addIconsFor(List<String> subject) {
      for (var key in subject) {
        final icon = CustomIcons.iconMap[key];
        if (icon != null) {
          iconWidgets.add(
            Padding(
              padding: const EdgeInsets.all(5),
              child: Icon(
                icon,
                color: L.iconColor,
                size: L.iconSize,
              ),
            ),
          );
        }
      }
    }

    addIconsFor(categories);
    addIconsFor(numberOfPlayers);
    addIconsFor(durationOfGame);
    addIconsFor(weather);
    addIconsFor(locations);

    return iconWidgets;
  }

  factory Item.fromIndexJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
    );
  }

  factory Item.fromFullJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      id: json['id'],
    )
      ..image = json['image']
      ..categories = List<String>.from(json['categories'] ?? [])
      ..numberOfPlayers = List<String>.from(json['numberOfPlayers'] ?? [])
      ..durationOfGame = List<String>.from(json['durationOfGame'] ?? [])
      ..weather = List<String>.from(json['weather'] ?? [])
      ..locations = List<String>.from(json['locations'] ?? [])
      ..description = json['description'] ?? ''
      ..keywords = List<String>.from(json['keywords'] ?? [])
      ..material = json['material'] ?? '';
  }
}
