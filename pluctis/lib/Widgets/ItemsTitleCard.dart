import 'package:flutter/material.dart';

class ItemsTitleCard extends StatelessWidget {
  const ItemsTitleCard({Key key, 
                   @required this.imageSource,
                   @required this.titles,
                   @required this.contents,
  }) : assert(titles.length == contents.length);

  final String imageSource;
  
  final List<String> titles;
  final List<String> contents;

  @override
  Widget build(BuildContext context) {    
    return Card(
      margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      child: Padding(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // We show the image
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(66),
                child: Image(
                  image: AssetImage(imageSource),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            // We show the fields
            Expanded(
              flex: 6,
              child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: titles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(titles[index]), 
                    subtitle: Text(contents[index]),
                  );
                  // return Text(titles[index]);
                } 
              ),
            )
          ],
        ),
      ),
    );
  }
}