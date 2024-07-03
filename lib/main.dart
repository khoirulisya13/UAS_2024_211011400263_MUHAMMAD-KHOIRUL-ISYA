import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> cryptoPrices = [];
  final double usdToIdrRate = 15000.0; // Kurs konversi USD ke IDR

  @override
  void initState() {
    super.initState();
    fetchCryptoPrices();
  }

  Future<void> fetchCryptoPrices() async {
    final response = await http.get(Uri.parse('https://api.coinlore.net/api/tickers/'));

    if (response.statusCode == 200) {
      setState(() {
        cryptoPrices = json.decode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to load crypto prices');
    }
  }

  String formatCurrency(double amount) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatCurrency.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'HARGA CRYPTO',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: cryptoPrices.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cryptoPrices.length,
              itemBuilder: (context, index) {
                double priceInIdr = double.parse(cryptoPrices[index]['price_usd']) * usdToIdrRate;
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(cryptoPrices[index]['name']),
                      Text(formatCurrency(priceInIdr)),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
