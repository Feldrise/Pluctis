import 'package:flutter/material.dart';

class PluctisTitle extends StatelessWidget {
  const PluctisTitle({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 16.0),
      child: Text(title, style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left,),
    );
  }

}