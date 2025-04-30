import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiKey = '0d117a3aa85b456cb9b4ed71517ae509';

  static Future<Map<String, dynamic>> convertCurrency(String base) async {
    print('base: $base');

    final url =
        Uri.parse('https://api.currencyfreaks.com/latest?apikey=$_apiKey');

    print('url: $url');

    final response = await http.get(url);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final status = response.statusCode;
    if (status != 200) {
      throw Exception('http.get error: statusCode= $status');
    }

    final data = jsonDecode(response.body);
    final rates = data['rates'];

    // Conversão manual para base diferente de USD
    if (base.toUpperCase() != 'USD') {
      final baseRate = double.tryParse(rates[base.toUpperCase()]);
      if (baseRate == null || baseRate == 0) {
        throw Exception('Invalid or unsupported base currency: $base');
      }

      return {
        'usd': (1 / baseRate).toStringAsFixed(4),
        'eur': (double.parse(rates['EUR']) / baseRate).toStringAsFixed(4),
        'jpy': (double.parse(rates['JPY']) / baseRate).toStringAsFixed(4),
      };
    }

    // Se base for USD, retorna os valores diretamente
    return {
      'usd': '1.0000',
      'eur': rates['EUR'],
      'jpy': rates['JPY'],
    };
  }
}
