import 'package:flutter/material.dart';
import 'spieleapp.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Image getImage() {
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
      return const Image(image: AssetImage('assets/images/GameDefault.jpg'));
    }
  }

  List<Widget> createIcons() {
    List<Widget> iconWidgets = [];

    void addIconsFor(List<String> subject) {
      for (var key in subject) {
        if (iconMap.containsKey(key)) {
          Widget iconWidget = Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(
              iconMap[key],
              color: L.iconColor,
              size: L.iconSize,
            ),
          );
          iconWidgets.add(iconWidget);
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

  static get iconMap => {
        // categories:
        'ballspiel': CustomIcons.spieltyp_ballspiel,
        'geschicklichkeit': CustomIcons.spieltyp_geschicklichkeitsspiel,
        // numberOfPlayers:
        'grossegruppe': CustomIcons.anzahl_grossegruppe,
        // durationOfGame:
        'mittellang': CustomIcons.dauer_mittel,
        // weather:
        'sonne': CustomIcons.wetter_sonne,
        // locations:
        'drinnen': CustomIcons.ort_drinnen,
        'draußen': CustomIcons.ort_draussen,
      };

  static Future<Item> hotPotato() async {
    const url =
        'https://holgerm.github.io/spieleapp_content/items/0/content.json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Item.fromJson(data);
    } else {
      throw Exception('Failed to load game data');
    }
  }

  factory Item.fromJson(Map<String, dynamic> json) {
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
