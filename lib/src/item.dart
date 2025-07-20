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
        'slsspiele.ballspiel': CustomIcons.spieltyp_ballspiel,
        'slsspiele.geschicklichkeit':
            CustomIcons.spieltyp_geschicklichkeitsspiel,
        // numberOfPlayers:
        'slsspiele.grossegruppe': CustomIcons.anzahl_grossegruppe,
        // durationOfGame:
        'slsspiele.mittellang': CustomIcons.dauer_mittel,
        // weather:
        'slsspiele.sonne': CustomIcons.wetter_sonne,
        // locations:
        'slsspiele.drinnen': CustomIcons.ort_drinnen,
        'slsspiele.draußen': CustomIcons.ort_draussen,
      };

  static Item hotPotato() {
    Item game = Item(name: "Die heiße Kartoffel", id: "#1");
    game.image =
        'https://holgerm.github.io/spieleapp_content/items/0/media/kartoffel.jpeg';
    game.categories = const [
      'slsspiele.ballspiel',
      'slsspiele.geschicklichkeit',
      'slsspiele.bewegungsspiel'
    ];
    game.numberOfPlayers = const ['slsspiele.grossegruppe'];
    game.durationOfGame = const ['slsspiele.mittellang'];
    game.weather = const ['slsspiele.sonne'];
    game.locations = const ['slsspiele.drinnen', 'slsspiele.draußen'];
    game.material = "Softball";
    game.keywords = const [
      'Teambilding',
      'laut',
      'Schulklassen',
      'Klassiker',
      'Kindergeburtstag'
    ];
    game.description =
        '''Die Spielenden stellen sich in einem Kreis auf und werfen einander den Ball zu (ähnlich wie beim Volleyball-Spiel). Wenn jemand den Ball fallen lässt, dann hockt er sich in der Mitte des Kreises hin. Das Spiel geht weiter. Aus der Kreismitte wird man befreit, wenn jemand aus dem Kreis beim Abwehren des Balls einen Spieler in der Mitte trifft. Wenn es nicht gelingt, dann hockt derjenige sich auch in die Mitte.
Die Spielenden, die in der Kreismitte sitzen, versuchen den vorbefliegenden Ball zu fangen. Wenn es gelingt den Ball zu fangen, sind alle, die in der Mitte hockt befreit. Wichtig dabei ist, dass die Spieler in der Kreismitte nicht aufstehen dürfen. Sie versuchen den Ball aus der Hocke zu fangen und dürfen nur hochspringen und sich wieder hinhocken.''';
    return game;
  }
}
