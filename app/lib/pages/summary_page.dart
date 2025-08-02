import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Summary (${today.day}/${today.month}/${today.year})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Transaksi: Rp 200.000'),
            SizedBox(height: 8),
            Text('Item Terjual: 25'),
            SizedBox(height: 8),
            Text('Jumlah Transaksi: 6'),
          ],
        ),
      ),
    );
  }
}
