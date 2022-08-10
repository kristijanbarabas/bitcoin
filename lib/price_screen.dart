import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

String selectedCurrency = 'AUD';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coinData = CoinData();

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          // IMPORT THE CREATED METHOD TO REFRESH THE REQUEST WHEN CHANGING THE CURRENCY
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }

// METHOD FOR GETTING BITCOIN VALUE
  Map<String, String> coinValues = {};
  String bitcoinValue = '';
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      print('this is the data = $data');
      isWaiting = false;
      setState(() {
        coinValues = data;
        print('these are the coinValues = $coinValues');
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // BITCOIN BUTTON
          BitcoinButton(
              bitcoinValue: isWaiting ? '?' : coinValues['BTC'].toString(),
              selectedCurrency: selectedCurrency,
              selectedCrypto: 'BTC'),
          BitcoinButton(
            bitcoinValue: isWaiting ? '?' : coinValues['ETH'].toString(),
            selectedCurrency: selectedCurrency,
            selectedCrypto: 'ETH',
          ),
          BitcoinButton(
              bitcoinValue: isWaiting ? '?' : coinValues['LTC'].toString(),
              selectedCurrency: selectedCurrency,
              selectedCrypto: 'LTC'),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class BitcoinButton extends StatelessWidget {
  const BitcoinButton(
      {Key? key,
      required this.bitcoinValue,
      required this.selectedCurrency,
      required this.selectedCrypto})
      : super(key: key);

  final String bitcoinValue;
  final String selectedCurrency;
  final String selectedCrypto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $selectedCrypto = $bitcoinValue $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
