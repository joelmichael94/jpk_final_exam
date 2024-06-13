import 'package:quote_of_the_day/models/quote.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuoteAPI {
  final String quoteAPI = "https://fcapi-1y70.onrender.com/quotes";

  Future<List<Quote>> getQuote() async {
    final res = await http.get(Uri.parse(quoteAPI));

    if (res.statusCode == 200) {
      List<dynamic> jsonData = json.decode(res.body);
      return jsonData.map((json) => Quote.fromJson(json)).toList();
    } else {
      throw Exception('${res.statusCode}: Failed to fetch quotes');
    }
  }
}
