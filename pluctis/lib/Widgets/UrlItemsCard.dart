import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pluctis/Widgets/PluctisCard.dart';

import 'package:url_launcher/url_launcher.dart';

class UrlItemsCard extends StatelessWidget {
  const UrlItemsCard({Key key, 
                      this.title,
                      @required this.urls,
  }); 

  final String title;
  final List<String> urls;

  @override
  Widget build(BuildContext context) {    
    return PluctisCard(
      margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          title != null ? Text(title, style: Theme.of(context).textTheme.subhead,) : Container(),
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: urls.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 6, top: 6),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: urls[index],
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()..onTap = () { 
                          launch(urls[index]);
                        },
                      ),
                    ],
                  ),
                ),
              );
            } 
          ),
        ]
      ),
    );
  }
}