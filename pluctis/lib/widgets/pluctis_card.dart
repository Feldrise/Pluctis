import 'package:flutter/material.dart';

class PluctisCard extends StatelessWidget {
  const PluctisCard({
    Key key, 
    this.margin = const EdgeInsets.all(8.0),
    this.padding = const EdgeInsets.all(8.0),
    @required this.child
  }) : super(key: key);

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 30.0, // has the effect of softening the shadow
            spreadRadius: 10.0, // has the effect of extending the shadow
          )
        ],
      ),
      margin: margin,
      child: child,
    );
  }
}