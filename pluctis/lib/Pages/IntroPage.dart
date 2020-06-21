import 'package:flutter/material.dart';
import 'package:nice_intro/nice_intro.dart';
import 'package:pluctis/Pages/MainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroPage extends StatefulWidget {
  @override
  IntroPageState createState() {
    return IntroPageState();
  }
}

class IntroPageState extends State<IntroPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var screens = IntroScreens(
      onDone: () async => _introductionDone(context),
      onSkip: () async => _introductionDone(context),
      footerBgColor: Color(0xffd81b60),
      activeDotColor: Colors.white,
      footerRadius: 18.0,
//      indicatorType: IndicatorType.CIRCLE,
      slides: [
        IntroScreen(
          title: 'Notification',
          imageAsset: 'assets/images/introduction/1.png',
          description: "Soyez toujours notifié pour vous rappeler d'arroser vos plantes",
          headerBgColor: Colors.white,
        ),
        IntroScreen(
          title: 'Plantes',
          headerBgColor: Colors.white,
          imageAsset: 'assets/images/introduction/2.png',
          description: "Enregistrez vos plantes parmis les 20 plantes disponibles",
        ),
        IntroScreen(
          title: 'Conseils',
          headerBgColor: Colors.white,
          imageAsset: 'assets/images/introduction/3.png',
          description: "Obtenez toutes les infos pour prendre soins de vos amis verts",
        ),
      ],
    );

    return Scaffold(
      body: screens,
    );
  }

  Future _introductionDone(BuildContext context) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setBool("introduced", true);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => MainPage(),)
    );
  }
}