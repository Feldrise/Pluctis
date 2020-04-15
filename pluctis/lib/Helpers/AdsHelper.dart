import 'package:firebase_admob/firebase_admob.dart';
import 'package:pluctis/ApiKeys.dart';

class AdsHelper {
  AdsHelper._privateConstructor();
  static final AdsHelper instance = AdsHelper._privateConstructor();

  bool _initialized = false;

  MobileAdTargetingInfo _adTargetingInfo = MobileAdTargetingInfo(
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

  Future showRewardAd(RewardedVideoAdListener listener) async {
    if (!_initialized) {
      await _initAds();
    }

    bool loaded = await RewardedVideoAd.instance.load(adUnitId: getRewardInteriorAdUnitId(), targetingInfo: _adTargetingInfo);
    if (loaded) {
      RewardedVideoAd.instance.show();
      RewardedVideoAd.instance.listener = listener;
    }
  }
}