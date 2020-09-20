import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Models/transaction.dart';

import './bars_chart.dart';

class Chart extends StatelessWidget {
  final List<Transactionn> recentTransactions;

  // defining a contructor to initialise my chart

  Chart({this.recentTransactions});

// Below is a getter method to accumulate the recentTransactions(Last seven Transactions)
// ReturnType FunctionIdentifier TheAccumulator(Or Variable in data has to be stored)
  List<Map<String, Object>> get addGroupedTransactionValues {
    return List.generate(7, (index) {
      // Declaring a variable to group different dates
      final weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0.0; // To store the toatl expenses of a particular date
      String d1, d2;
      d1 = DateFormat.yMMMd().format(weekDay);
      for (var i = 0; i < recentTransactions.length; i++) {
        d2 = DateFormat.yMMMd().format(recentTransactions[i].date);
        if (d1 == d2) totalSum += recentTransactions[i].amount;
      }

      //   print(totalSum);
      // print(DateFormat.E().format(weekDay));

      // THe below method of DateFormat.E() gives the first character for day name
      // It is from the intl package
      return {
        'Day': DateFormat.E().format(weekDay).substring(0, 3),
        'Amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpendings {
    return addGroupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['Amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(addGroupedTransactionValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: addGroupedTransactionValues.map((data) {
            // Wrapping the Bar with a Flexible Widget
            return Flexible(
              fit: FlexFit.tight,
              child: Bar(
                  data['Day'],
                  data['Amount'],
                  totalSpendings == 0.0
                      ? 0
                      : ((data['Amount']) as double) /
                          totalSpendings /*This value here will generate a Invalid value if we have no transactions */),
            );
          }).toList(),
        ),
      ),
    );
  }
}
