import 'dart:io';

String getAdmobAppId() {
  if (Platform.isIOS) {
    return "ca-app-pub-2186575813138730~8844046895";
  } else if (Platform.isAndroid) {
    return "ca-app-pub-2186575813138730~5866529768";
  }
  return null;
}

// String getBannerAdUnitId() {
//   if (Platform.isIOS) {
//     return IOS_AD_UNIT_BANNER;
//   } else if (Platform.isAndroid) {
//     return ANDROID_AD_UNIT_BANNER;
//   }
//   return null;
// }

String getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return "ca-app-pub-2186575813138730/8053709400";
  } else if (Platform.isAndroid) {
    return "ca-app-pub-2186575813138730/4290009623";
  }
  return null;
}

String getRewardInteriorAdUnitId() {
  if (Platform.isIOS) {
    return "ca-app-pub-2186575813138730/8133917689";
  } else if (Platform.isAndroid) {
    return "ca-app-pub-2186575813138730/6930654837";
  }
  return null;
}

String getRewardGardenAdUnitId() {
  if (Platform.isIOS) {
    return "ca-app-pub-2186575813138730/5316182659";
  } else if (Platform.isAndroid) {
    return "ca-app-pub-2186575813138730/3789200769";
  }
  return null;
}