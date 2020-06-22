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
            padding: const EdgeInsets.only(
              top: 82,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            margin: const EdgeInsets.only(top: 66),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Text(
                  "Suppression",
                  style: Theme.of(context).textTheme.headline5
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "Voulez vous vraiment supprimer la plante ?",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
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
                padding: const EdgeInsets.all(24),
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