import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import './user_transactions.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction({this.addTx});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = new TextEditingController();
  final _amountController = new TextEditingController();
  DateTime _date;

  void submitData() {
    final txTitle = _titleController.text;
    final txAmount = _titleController.text;

    if (txAmount.isEmpty || txTitle.isEmpty || _date == null) return;

    // the below snippet of code has been added because we needed
    // the addTx function pointer here but we have to get the constructors
    // of the classes which receives the input/input_data to be constructed inside the
    // Widget class not in the state class.

    widget.addTx(_titleController.text, _amountController.text, _date);
    // print(_titleController.text);
    // print(_amountController.text);

    // To pop off the modal sheet after we are done enterring our data
    Navigator.of(context).pop();
  }

  void addPresentDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(Duration(days: 30)),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null)
        return;
      else
        setState(() {
          _date = pickedDate;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Card(
        elevation: 6,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: mediaQuery.viewInsets.bottom + 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                  maxLength: 20,
                  decoration: InputDecoration(labelText: 'Title'),
                  autocorrect: true,
                  controller: _titleController,
                  onSubmitted: (_) => submitData(),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => submitData(),
                ),
                Container(
                  height: 70,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Text(_date == null
                                ? "No Date Choosen!!"
                                : 'Date:- ${DateFormat.yMMMd().format(_date)}')),
                        // SizedBox(width: 40,),
                        FlatButton(
                            textColor: Theme.of(context).primaryColor,
                            child: Text('PicDate'),
                            onPressed: addPresentDate)
                      ]),
                ),
                FlatButton(
                  child: Text(
                    'Save Transaction',
                    style: TextStyle(color: Colors.black),
                  ),
                  focusColor: Colors.green,
                  onPressed: submitData,
                ),
              ]),
        ),
      ),
    );
  }
}
