import 'package:hive_flutter/hive_flutter.dart';

part 'quote_model.g.dart';

@HiveType(typeId: 1)
class Quote extends HiveObject {
  @HiveField(0)
  String quote;
  @HiveField(1)
  String author;

  Quote({
    required this.quote,
    required this.author,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      quote: json['quote'],
      author: json['author'],
    );
  }
  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};

    data['quote'] = quote;
    data['author'] = author;

    return data;
  }
}
