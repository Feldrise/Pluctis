import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pluctis/widgets/pluctis_card.dart';

class ItemsCard extends StatelessWidget {
  const ItemsCard({@required this.icons,
                   @required this.titles,
                   @required this.contents,
                   this.invert = false,
  }) : assert(titles.length == contents.length && titles.length == icons.length);
  
  final List<String> icons;
  final List<String> titles;
  final List<String> contents;

  final bool invert;

  @override
  Widget build(BuildContext context) {    
    return PluctisCard(
      margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: SvgPicture.asset(
              'assets/svg/${icons[index]}.svg',
              semanticsLabel: "Icon",
              height: 48,
            ),
            title: invert ? Text(contents[index], textAlign: TextAlign.left) : Text(titles[index]), 
            subtitle: invert ? Text(titles[index]) : Text(contents[index], textAlign: TextAlign.left),
          );
          // return Text(titles[index]);
        }
      ),
    );
  }
}