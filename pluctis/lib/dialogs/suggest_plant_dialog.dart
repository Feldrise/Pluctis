import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SuggestPlantDialog extends StatefulWidget {
  const SuggestPlantDialog({Key key, @required this.scaffoldContext}) : super(key: key);

  @override
  _SuggestPlantDialogState createState() => _SuggestPlantDialogState();

  final BuildContext scaffoldContext;
}

class _SuggestPlantDialogState extends State<SuggestPlantDialog> {
  String _plantName;

  Future sendSuggestion() async {
    if (_plantName == null || _plantName.isEmpty) {
      Scaffold.of(widget.scaffoldContext)..removeCurrentSnackBar()..showSnackBar(const SnackBar(content: Text("Vous ne pouvez pas envoyer un nom de plante vide.", style: TextStyle(color: Colors.white),), backgroundColor: Color(0xffd32f2f)));
      return;
    }

    try { 
      final http.Response response = await http.post(
        'https://pluctis.com/suggestion_app.php',
        body: jsonEncode(<String, String>{
          'name': _plantName
        }),
      );

      if (response.statusCode == 200) {
        Scaffold.of(widget.scaffoldContext)..removeCurrentSnackBar()..showSnackBar(const SnackBar(content: Text("Merci pour votre suggestion !", style: TextStyle(color: Colors.white)), backgroundColor: Color(0xff388e3c),));
      }
      else {
        Scaffold.of(widget.scaffoldContext)..removeCurrentSnackBar()..showSnackBar(const SnackBar(content: Text("Une erreur est survenue... Vérifiez votre connection.", style: TextStyle(color: Colors.white),), backgroundColor: Color(0xffd32f2f)));
      }
    }
    catch (exception) {
      Scaffold.of(widget.scaffoldContext)..removeCurrentSnackBar()..showSnackBar(const SnackBar(content: Text("Une erreur est survenue... Vérifiez votre connection.", style: TextStyle(color: Colors.white),), backgroundColor: Color(0xffd32f2f)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Suggestion de plante"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Veuillez nous donner le nom de la plante que vous voulez nous suggérer."),
          Expanded(
            child: TextField(
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  _plantName = value;
                });
              },
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        FlatButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await sendSuggestion();
          },
          child: const Text("Soumettre"),
        )
      ],
    );
  }
}