import 'package:fluttercaching/hive/hive_manager.dart';
import 'package:fluttercaching/hive/models/quote_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<Quote> getRandomQuote() async {
    //* The API call is delayed in order to show the process more clearly
    await Future.delayed(const Duration(seconds: 3));

    const url = 'https://strangerthings-quotes.vercel.app/api/quotes';
    var response = await http.Client().get(Uri.parse(url));
    final json = jsonDecode(response.body);
    HiveManager.updateQuoteBox(Quote.fromJson(json[0]));

    return Quote.fromJson(json[0]);
  }
}
