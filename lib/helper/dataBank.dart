import 'package:flutter/cupertino.dart';

import './dataBaseManager.dart';

import '../Models/transaction.dart';
//import '../models/saving.dart';

class DataBank with ChangeNotifier {
  List<Transactionn> _transactions = [];
  //List<Saving> _savingSchemes = [];

  // getter to get the list of transactions
  List<Transactionn> get transactions {
    return [..._transactions];
  }

  /* List<Saving> get savingSchemes {
    return [..._savingSchemes];
  }
*/
  Future<void> fetchAndSetTransactions() async {
    final data = await DataBase.getData('expenses');
    final transactionData = data
        .map((trns) => Transactionn(
            id: trns['id'],
            title: trns['title'],
            amount: trns['amount'],
            date: DateTime.parse(trns['date'])))
        .toList();

    _transactions = transactionData;
    print(_transactions);

    notifyListeners();
  }

  Future<void> addTransaction(Transactionn trns) async {
    _transactions.add(trns);
    await DataBase.addTransaction('expenses', {
      'id': trns.id,
      'title': trns.title,
      'amount': trns.amount,
      'date': (trns.date).toString()
    });
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    await DataBase.deleteTransaction(id);
    _transactions.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<void> clearData() async {
    //await DataBase.deleteTransaction(id);
    _transactions.forEach((transaction) {
      DataBase.deleteTransaction(transaction.id);
    });
    _transactions.clear();
    notifyListeners();
  }

  /* Future<void> addSavingScheme(Saving scheme) async {
    await DataBase.addSavingScheme('saving', {
      'id': scheme.id,
      'savingFor': scheme.savingFor,
      'targetAmount': scheme.targetAmount,
      'amountSaved': scheme.amountSaved,
      'amountToBeSaved': scheme.amountToBeSaved,
      'startingDate': (scheme.startingDate).toString(),
      'endingDate': (scheme.endingDate).toString()
    });
    print(scheme);
    print(scheme.id);
    print(scheme.savingFor);
    print(scheme.targetAmount);
    print(scheme.amountSaved);
    print(scheme.amountToBeSaved);
    print(scheme.startingDate.toString());
    print(scheme.endingDate.toString());
  }

  Future<void> deleteSavingScheme(String id) async {
    await DataBase.deleteSavingPlan(id);
    notifyListeners();
  }

  Future<void> fetchAndSetSavingSchemes() async {
    final savingSchemeData = await DataBase.getSavingsData('saving');
    /*  final transactionData = data
        .map((trns) => Transactionn(
            id: trns['id'],
            title: trns['title'],
            amount: trns['amount'],
            date: DateTime.parse(trns['date'])))
        .toList();

    _transactions = transactionData;
    print(_transactions);*/

   final savingDataMap = savingSchemeData
        .map((savingScheme) => Saving(
            id: savingScheme['id'],
            amountSaved: savingScheme['amountSaved'],
            amountToBeSaved: savingScheme['amountToBeSaved'],
            endingDate: DateTime.parse(savingScheme['endingDate']),
            savingFor: savingScheme['savingFor'],
            startingDate: DateTime.parse(savingScheme['startingDate']),
            targetAmount: savingScheme['targetAmount']))
        .toList();
    _savingSchemes = savingDataMap;

    print(savingDataMap[0].amountSaved);

    notifyListeners();
  }*/
}
