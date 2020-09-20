import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import './helper/dataBank.dart';

import './Models/transaction.dart';
import './helper/databaseManager.dart';

import './Widgets/new_transaction.dart';
import './Widgets/chart.dart';
import './Widgets/transaction_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => DataBank()),
      ],
      child: MaterialApp(
        title: 'Xpens',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.teal,
            fontFamily: 'Quicksand',
            textTheme: ThemeData.light().textTheme.copyWith(
                // This one is formatting my amount box
                headline6: TextStyle(fontFamily: 'OPenSans')),
            // Global theme for appBar
            appBarTheme: AppBarTheme(
                textTheme: ThemeData.light().textTheme.copyWith(
                    headline5: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 25,
                        fontWeight: FontWeight.w500)))),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // Initialising the list of transaction with an Empty List
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool _showChart = true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //print('State:- $state');
    //super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  final titleController = new TextEditingController();

  final amountController = new TextEditingController();

  void _addTransaction(String txTitle, String txAmount, DateTime date) async {
    // Creating a new Transaction object
    final transaction = new Transactionn(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: double.parse(txAmount),
      date: date,
    );

    Provider.of<DataBank>(context, listen: false).addTransaction(transaction);
  }

  void addTransactionSheet(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            // this catches the tap and executes the declared function
            onTap: () {},
            child: NewTransaction(addTx: _addTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void deleteTransaction(String id) {
    Provider.of<DataBank>(context, listen: false).deleteTransaction(id);
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        (MediaQuery.of(context).orientation == Orientation.landscape);
    final mediaQuery = MediaQuery.of(context);

    final appbar = AppBar(
      title: Text(
        'Xpens Tracker',
        style: TextStyle(color: Colors.yellow),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            Provider.of<DataBank>(context, listen: false).clearData();
          },
        ),
      ],
    );

    return Scaffold(
        appBar: appbar,
        body: FutureBuilder(
            future: Provider.of<DataBank>(context, listen: false)
                .fetchAndSetTransactions(),
            builder: (ctx, transactionSnapshot) {
              if (transactionSnapshot.connectionState == ConnectionState.done) {
                return Consumer<DataBank>(builder: (ctx, dataBank, _) {
                  return SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          if (isLandscape)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('ShowChart'),
                                Switch(
                                    value: _showChart,
                                    onChanged: (val) {
                                      setState(() {
                                        _showChart = val;
                                      });
                                    }),
                              ],
                            ),
                          Container(
                              height: (mediaQuery.size.height -
                                      appbar.preferredSize.height -
                                      mediaQuery.padding.top) *
                                  0.25,
                              child: Chart(
                                  recentTransactions: dataBank.transactions)),
                          Container(
                            height: (mediaQuery.size.height -
                                    appbar.preferredSize.height -
                                    mediaQuery.padding.top) *
                                0.7,
                            child: TransactionList(
                                transaction: dataBank.transactions,
                                deletingFunc: deleteTransaction),
                          ),
                        ]),
                  );
                });
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            addTransactionSheet(context);
          },
        ));
  }
}
