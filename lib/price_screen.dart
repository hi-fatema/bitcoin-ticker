import 'package:bitcoin_ticker/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io'show Platform;


class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';


  Widget androidDropdown (){
    List <DropdownMenuItem<String>> dropdownItems = [];
    for(String currency in currenciesList){
      var newItem = DropdownMenuItem(child: Text(currency), value: currency,);
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value){
        setState(() {
          selectedCurrency = value;
          getData();
        });

      },
    );
  }

  CupertinoPicker iosPicker (){
    List <Widget> pickerItems = [];
    for(String currency in currenciesList){
      var newItem = Text(currency);
      pickerItems.add(newItem);
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (valueIndex){
        setState(() {
          selectedCurrency = currenciesList[valueIndex];
          getData();
        });
      },
      children: pickerItems,
    );
  }
  Map<String, String> cryptoRates = {};
  bool isWaiting = false;

  void getData ()async{
    isWaiting = true;
    try{
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        cryptoRates = data;
        });
    } catch(e){
      print(e);
    }
  }

  List<Widget> getCryptoCards(){
    List<Widget>cryptoCards = [];
    for(String crypto in cryptoList){
      var newItem = CryptoCard(value: isWaiting ? '?' : cryptoRates[crypto], selectedCurrency: selectedCurrency, cryptoCurrency: crypto);
      cryptoCards.add(newItem);
    }
    return cryptoCards;
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: getCryptoCards(),
          ),

          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker(): androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    @required this.value,
    @required this.selectedCurrency,
    @required this.cryptoCurrency,
  });
  final String cryptoCurrency;
  final String value;
  final String selectedCurrency;

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
            '1 $cryptoCurrency = $value $selectedCurrency',
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
