import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pluctis/widgets/pluctis_card.dart';

import 'package:url_launcher/url_launcher.dart';

class UrlItemsCard extends StatelessWidget {
  const UrlItemsCard({Key key, 
                      this.title,
                      @required this.urls,
  }) : super(key: key); 

  final String title;
  final List<String> urls;

  @override
  Widget build(BuildContext context) {    
    return PluctisCard(
      margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (title != null) Text(title, style: Theme.of(context).textTheme.subtitle1,) else Container(),
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: urls.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6, top: 6),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: urls[index],
                        style: const TextStyle(color: Colors.blue),
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