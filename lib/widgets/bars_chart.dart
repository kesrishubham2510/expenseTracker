import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// This is a  stateless widget because we don't need to render our ui again again for this.

class Bar extends StatelessWidget {
  final String label;
  final double spending;
  final double percentageOfSpend;

  Bar(this.label, this.spending, this.percentageOfSpend);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: <Widget>[
          Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                  child: Text('\u{20B9} ${spending.toStringAsFixed(0)}'))),
          SizedBox(height: constraints.maxHeight * 0.015),
          Container(
            height: constraints.maxHeight * 0.65,
            width: 10,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    color: Color.fromRGBO(
                        220, 220, 220, 1), // For Light Grey Color
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: percentageOfSpend,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor)),
                )
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.03,
          ),
          Text('$label'),
        ],
      );
    });
  }
}
