import 'price_screen.dart';

import 'package:bitcoin_ticker/services/networking.dart';

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
const apiKey = '4FF55955-83C2-4D76-9FF2-AAF587BAADB6';

class CoinData {
  Future<dynamic> getCoinData(selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      NetWorkHelper netWorkHelper =
          NetWorkHelper('$coinAPIURL/$crypto/$selectedCurrency?apikey=$apiKey');
      var coinData = await netWorkHelper.getData();
      double coinRate = coinData['rate'];
      cryptoPrices[crypto] = coinRate.toStringAsFixed(0);
    }
    print('these are the crypto prices = $cryptoPrices');
    return cryptoPrices;
  }
}
