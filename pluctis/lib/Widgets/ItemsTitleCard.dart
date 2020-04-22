import 'package:flutter/material.dart';
import 'package:pluctis/Widgets/PluctisCard.dart';

class ItemsTitleCard extends StatelessWidget {
  const ItemsTitleCard({Key key, 
                   @required this.imageSource,
                   @required this.titles,
                   @required this.contents,
                   this.invert = false,
                   this.buttons,
  }) : assert(titles.length == contents.length);

  final String imageSource;
  
  final List<String> titles;
  final List<String> contents;
  final List<Widget> buttons;

  final bool invert;

  @override
  Widget build(BuildContext context) {    
    return PluctisCard(
      margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // We show the image
              ClipRRect(
                borderRadius: BorderRadius.circular(46),
                child: Image(
                  image: AssetImage(imageSource),
                  width: 92,
                  height: 92,
                  fit: BoxFit.fitHeight,
                ),
              ),
              
              // We show the fields
              Expanded(
                child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: titles.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: invert ? Text(contents[index]) : Text(titles[index]),
                      subtitle: invert ? Text(titles[index]) : Text(contents[index]), 
                    );
                    // return Text(titles[index]);
                  } 
                ),
              )
            ],
          ),
          (buttons != null && buttons.isNotEmpty) ?
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: buttons.length,
            itemBuilder: (context, index) {
              return buttons[index];
            } 
          )
          : Container(),
        ],
      ),
    );
  }
}