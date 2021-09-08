import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = 'E20802F0-A704-4DCA-996D-D92959CF5B72';

class CoinData {
  Future<Map<String, String>> getCoinData(String selectedCurrency) async {
    Map<String,String> cryptoValues = Map();
    for(String crypto in cryptoList){
      var url = Uri.parse('$coinAPIURL/$crypto/$selectedCurrency?apikey=$apiKey');
      var response =  await http.get(url);
      if(response.statusCode==200){
        var jsonResponse = jsonDecode(response.body);
        double rate = jsonResponse['rate'];
        cryptoValues[crypto] = rate.toStringAsFixed(0);
      } else {
        print('Request failed with status code: ${response.statusCode}.');
      }
    }
    return cryptoValues;

  }
}
