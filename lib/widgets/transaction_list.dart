import 'package:flutter/material.dart';
import '../Models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transactionn> transaction;
  final Function deletingFunc;

  TransactionList({this.transaction, this.deletingFunc});

  @override
  Widget build(BuildContext context) {
    return transaction.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(children: <Widget>[
              Text(
                'No Transactions SO far',
                style: Theme.of(context).textTheme.headline6,
              ),
              // the default size of the image is causing a rendering exception as
              // Sufficient space is not avavilable on screen
              // Sized Box is added to give a proper spacing between text and image
              SizedBox(
                height: 8,
              ),
              // Wrapping my image asset in a container so as to fit inside a given available height/space
              // BoxFit take sthe space availble to it's direct parent that's we wrapped the image asset with container
              Container(
                  height: constraints.maxHeight * 0.7,
                  child: Image.asset(
                    'Assets/Images/waiting.png',
                    fit: BoxFit.cover,
                  )),
            ]);
          })
        : ListView.builder(
            // ListView is By-Default Scrollable
            itemBuilder: (ctx, index) {
              // ctx is managed internally by Flutter
              // index value is alloted by Flutter for every widget it builds in the current time
              return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: ListTile(
                      leading: CircleAvatar(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: FittedBox(
                            child: Text(
                              '\u{20B9} ${transaction[index].amount}',
                            ),
                          ),
                        ),
                        radius: 30,
                      ),
                      title: Text(
                        '${transaction[index].title}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle: Text(
                          DateFormat.yMMMMd().format(transaction[index].date)),
                      //Adding Condition for Button Variation based on Width of the
                      trailing: MediaQuery.of(context).size.width > 450
                          ? FlatButton.icon(
                              onPressed: () =>
                                  deletingFunc(transaction[index].id),
                              icon: Icon(Icons.delete),
                              label: Text('Delete'))
                          : IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () =>
                                  deletingFunc(transaction[index].id))));
            },
            itemCount: transaction.length,
          );
  }
}

/*
   Card View Code
                   return Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                          children: <Widget>[
                             Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Text(
                              // Using Interpolation Concept
                              // Using a backSlash charcater to output it as Chara
                              //'\u{20B9}',
                              "\u{20B9} ${transaction[index].amount.round()}",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline6),
                        ),
                          
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            transaction[index].title,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            DateFormat.yMMMd().format(transaction[index].date),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )]),
                    ],

                  ),
                );
*/
