import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'model/transaction_model.dart';

class TransactionDetail extends StatefulWidget {
  const TransactionDetail({super.key});

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  bool isRefunded = true;
  bool firstClick = true;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Record;
    List<Map> detailTile = [
      {'leading': 'Transaction Amount', 'trailing': '\$${args.transactionAmount}'},
      {'leading': 'Payment Method', 'trailing': '${args.paymentMethod}'},
      {'leading': 'Payment Type', 'trailing': '${args.paymentType}'},
      {'leading': 'Transaction Status', 'trailing':  isRefunded ? '${args.transactionStatus}' : 'Refunded'},
      {'leading': 'Transaction Date', 'trailing': '${args.transactionDate}'},
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text('${args.beneficiaryName}'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Image.network(
                  args.icon!,
                  width: 200.0,
                  height: 200.0,
                ),
                Material(
                  elevation: 0.8,
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...List.generate(detailTile.length, (index) {
                          final detail = detailTile[index];
                          return ListTile(
                            title: Text(
                              detail['leading'],
                            ),
                            trailing: Text(
                              detail['trailing'],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100.0,),
                GestureDetector(
                  onTap: firstClick ? (){
                    setState(() {
                      isRefunded = false;
                      firstClick = false;
                    });
                    Fluttertoast.showToast(msg: 'Amount has been Refunded!', toastLength: Toast.LENGTH_LONG);
                } : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Center(
                      child: Text('Refund'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
