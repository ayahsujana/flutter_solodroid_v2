
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:video_channels/helper/string.dart';

class Ads {
  static AdmobInterstitial _intersAds() {
    return AdmobInterstitial(
      adUnitId: Strings.admobInters,
    );
  }

  static AdmobInterstitial _interstitial;

  static init() {
    Admob.initialize(Strings.admobAppId);
  }

  static Widget bannerAds() {
    return Center(
      child: Container(
        child: AdmobBanner(
          adUnitId: Strings.admobBanner,
          adSize: AdmobBannerSize.BANNER,
        ),
      ),
    );
  }

  static Widget mediumBanner() {
    return Center(
      child: Container(
        width: 300.0,
        height: 250.0,
        child: AdmobBanner(
          adUnitId: Strings.admobBanner,
          adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
        ),
      ),
    );
  }

  static void showIntersAd() async {
    if (await _interstitial.isLoaded) {
      _interstitial.show();
    }
  }

  static void interstitialLoad() {
    if (_interstitial != null) {
      _interstitial.load();
    } else {
      _interstitial = _intersAds();
      _interstitial.load();
    }
  }

  static void interstitialDispose() {
    _interstitial.dispose();
  }
}
