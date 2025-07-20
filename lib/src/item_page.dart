import 'package:flutter/material.dart';

import 'spieleapp.dart';

class ItemPage extends StatelessWidget {
  final Item item;

  const ItemPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(item.name),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item.getImage(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: item.createIcons(),
              ),
              Text(
                item.description,
                style: const TextStyle(fontSize: 17),
              ),
              const Divider(),
              Text(
                'Material: ${item.material}',
                style: const TextStyle(fontSize: 17),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
