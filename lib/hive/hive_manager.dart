import 'package:flutter/foundation.dart';
import 'package:fluttercaching/hive/models/quote_model.dart';

import 'package:hive_flutter/hive_flutter.dart';

class HiveManager {
  static Box<Quote> get quoteBox => Hive.box<Quote>(HiveBoxes.quote.inString);

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(QuoteAdapter()); // typeId: 1

    await _openAllBoxes();
  }

  static Future<List<dynamic>> _openAllBoxes() async {
    return Future.wait(
      [
        _openQuoteBox(),
      ],
    );
  }

  static Future<bool> _isBoxReady(HiveBoxes hiveBox) async {
    return (await Hive.boxExists(hiveBox.inString)) && Hive.isBoxOpen(hiveBox.inString);
  }

  //
  //* QuoteBox
  //

  static Future _openQuoteBox() async {
    HiveBoxes hiveBox = HiveBoxes.quote;

    try {
      if (await _isBoxReady(hiveBox)) {
        return quoteBox;
      } else {
        return await Hive.openBox<Quote>(hiveBox.inString);
      }
    } catch (e) {
      await Hive.deleteBoxFromDisk(hiveBox.inString);
      return await Hive.openBox<Quote>(hiveBox.inString);
    }
  }

  static void updateQuoteBox(Quote updatedValue) async {
    Quote newQuote = updatedValue;

    quoteBox.put(HiveBoxes.quote.inString, newQuote);
  }

  static Quote? getQuote() {
    return quoteBox.get(HiveBoxes.quote.inString);
  }
}

enum HiveBoxes { quote }

extension HiveBoxesEx on HiveBoxes {
  String get inString => describeEnum(this);
}
