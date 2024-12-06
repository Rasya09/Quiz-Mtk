import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/integral.dart';

class IntegralCalculatorScreen extends StatefulWidget {
  @override
  _IntegralCalculatorScreenState createState() => _IntegralCalculatorScreenState();
}

class _IntegralCalculatorScreenState extends State<IntegralCalculatorScreen> {
  final _functionController = TextEditingController();
  final _lowerBoundController = TextEditingController();
  final _upperBoundController = TextEditingController();
  double _result = 0.0;
  String _errorMessage = '';

  void _calculateIntegral() {
    try {
      final function = _functionController.text;
      final lowerBound = double.parse(_lowerBoundController.text);
      final upperBound = double.parse(_upperBoundController.text);

      final result = IntegralCalculator.calculateDefiniteIntegral(
        function,
        lowerBound,
        upperBound,
      );

      setState(() {
        _result = result;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: Masukkan fungsi atau batas integral tidak valid';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalkulator Integral'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _functionController,
              decoration: InputDecoration(
                labelText: 'Masukkan Fungsi (contoh: 3x^2 - 4x)',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d\+\-\*\/\^\(\)]')),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lowerBoundController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Batas Bawah',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _upperBoundController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Batas Atas',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateIntegral,
              child: Text('Hitung Integral'),
            ),
            SizedBox(height: 20),
            Text(
              _errorMessage.isNotEmpty ? _errorMessage : 'Hasil Integral: $_result',
              style: TextStyle(
                fontSize: 18,
                color: _errorMessage.isNotEmpty ? Colors.red : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
