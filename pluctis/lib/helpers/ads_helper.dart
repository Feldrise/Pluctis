import 'dart:math';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:pluctis/api_keys.dart';
import 'package:pluctis/helpers/in_app_purchase_helper.dart';

class AdsHelper {
  AdsHelper._privateConstructor();
  static final AdsHelper instance = AdsHelper._privateConstructor();

  bool _initialized = false;

  final MobileAdTargetingInfo _adTargetingInfo = const MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>[
      "3CCB99085B2ECB26CB04A224917DA40E",
    ], // Android emulators are considered test devices
  );

  Future _initAds() async {
    await FirebaseAdMob.instance.initialize(appId: getAdmobAppId());

    _initialized = true;
  }

  InterstitialAd _createInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: _adTargetingInfo,
      listener: (MobileAdEvent event) {
        // print("InterstitialAd event $event");
      },
    );
  }

  Future showRewardAd(RewardedVideoAdListener listener) async {
    if (!_initialized) {
      await _initAds();
    }

    await RewardedVideoAd.instance.load(adUnitId: getRewardInteriorAdUnitId(), targetingInfo: _adTargetingInfo);
    RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.loaded) {
        RewardedVideoAd.instance.listener = listener;
        RewardedVideoAd.instance.show();
      }
    };
  }

  Future showInterstitialAd({int chanceToShow}) async {
     if (!_initialized) {
      await _initAds();
    }

    final bool isPremium = await InAppPurchaseHelper.instance.isPremium();
    final Random random = Random();

    if (!isPremium && random.nextInt(chanceToShow) == 0) {
      final InterstitialAd interstitialAd = _createInterstitialAd();
      final bool loaded = await interstitialAd.load();

      if (loaded) { 
        interstitialAd.show();
      }
    }
  }
}