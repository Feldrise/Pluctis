import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RemovePlantDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
      ),      
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 82,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            margin: EdgeInsets.only(top: 66),
            decoration: new BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Text(
                  "Suppression",
                  style: Theme.of(context).textTheme.headline
                ),
                SizedBox(height: 16.0),
                Text(
                  "Voulez vous vraiment supprimer la plante ?",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () async {
                            Navigator.of(context).pop(false);
                          },
                          child: Text("Non", style: TextStyle(color: Theme.of(context).accentColor))
                      ),
                      FlatButton(
                        onPressed: () async {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          "Oui",
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              radius: 66,
              child: Padding(
                padding: EdgeInsets.all(24),
                child: SvgPicture.asset(
                  'assets/svg/crying.svg',
                  semanticsLabel: "Icon",
                ),
              ),
            ),
          ),
        ],
      ),
    ); 
  }
}