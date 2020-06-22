import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum InAppPurchase { premium }

Map<InAppPurchase, String> inAppPurchaseId = {
  InAppPurchase.premium: "com.feldrise.pluctis.premium"
};

class InAppPurchaseHelper {
  StreamSubscription<List<PurchaseDetails>> _subscription;

  final Set<String> _productsIds = {
    inAppPurchaseId[InAppPurchase.premium]
  };
  List<ProductDetails> _products;

  bool _isPremium = false;

  InAppPurchaseHelper._privateConstructor();
  static final InAppPurchaseHelper instance = InAppPurchaseHelper._privateConstructor();

  ProductDetails get premiumProductDetails {
    for (final product in _products) {
      if (product.id == inAppPurchaseId[InAppPurchase.premium]) {
        return product;
      }
    }

    return null;
  }

  Future _initInAppPurchase() async {
    final Stream<List<PurchaseDetails>> purchaseUpdates = InAppPurchaseConnection.instance.purchaseUpdatedStream;
    
    _subscription = purchaseUpdates.listen((purchases) {
      _handlePurchaseUpdates(purchases);
    });

    final bool isAvailable = await InAppPurchaseConnection.instance.isAvailable();

    if (isAvailable) {
      await _loadProducts();
      await loadPreviousPurchase();
    }
    else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _isPremium = prefs.getBool("isPremium") ?? false;
    }
    
  }

  Future _loadProducts() async {  
    final ProductDetailsResponse response = await InAppPurchaseConnection.instance.queryProductDetails(_productsIds);

    _products = response.productDetails;
  }

  Future<bool> loadPreviousPurchase() async {
    if (_products == null || _subscription == null) {
      await _initInAppPurchase();
    }

    final QueryPurchaseDetailsResponse response = await InAppPurchaseConnection.instance.queryPastPurchases();

    for (final PurchaseDetails purchase in response.pastPurchases) {
      // Deliver the purchase to the user in your app.
      if (purchase.productID == inAppPurchaseId[InAppPurchase.premium]) {
        _isPremium = true;
      } 

      if (Platform.isIOS) {
          // Mark that you've delivered the purchase. Only the App Store requires
          // this final confirmation.
          InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }

    // If the user cancelled the premium purchase for exemple
    if (!_isPremium) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isPremium", false);
    }

    return _isPremium;
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails details) async {
      if (details.status == PurchaseStatus.error) {
        print("Pruchase error: ${details.error.message}");
        // TODO: show error
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: Text("Erreur"),
        //       content: Text("Votre achat n'a pas pu être complété. Si le problème persiste, veuillez nous contacter."),
        //       actions: <Widget>[
        //         FlatButton(
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //           child: Text("Ok", style: TextStyle(color: Theme.of(context).accentColor,)),
        //         )
        //       ],
        //     );
        //   }
        // );
      }
      else if (details.status == PurchaseStatus.purchased) {
        await _premiumBought();
      }
    });
  }

  Future _premiumBought() async {
    // TODO: check the actual purchase
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _isPremium = true;
    prefs.setBool("isPremium", true);
  }

  Future<bool> isPremium() async {
    if (_products == null || _subscription == null) {
      await _initInAppPurchase();
    }

    return _isPremium;
  }

  // Buy functions
  void buyPremium() {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: premiumProductDetails);
    InAppPurchaseConnection.instance.buyNonConsumable(purchaseParam: purchaseParam);
  }
}