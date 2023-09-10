import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';

class OrderWidget extends StatefulWidget {
  final Order order;
  const OrderWidget({super.key, required this.order});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final itemsHeight = widget.order.products.length * 25.0 + 10;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded ? itemsHeight + 80 : 80,
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text('R\$ ${widget.order.total.toStringAsFixed(2)}'),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date)),
              trailing: IconButton(
                icon: Icon(Icons.expand_more),
                onPressed: (() {
                  setState(() {
                    _expanded = !_expanded;
                  });
                }),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _expanded ? itemsHeight : 0,
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              child: ListView(
                children: widget.order.products.map((e) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${e.quantity}x R\$ ${e.price}',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      )
                    ],
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
