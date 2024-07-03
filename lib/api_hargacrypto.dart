import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchData() async {
  final response = await http.get(Uri.parse('https://api.coinlore.net/api/tickers/'));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    // Lakukan sesuatu dengan data
    print(data);
  } else {
    throw Exception('Failed to load data');
  }
}
