import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart'; // Import paket math_expressions

void main() {
  runApp(const MathCalculatorApp());
}

class MathCalculatorApp extends StatelessWidget {
  const MathCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Math Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String input = ''; // Menyimpan input ekspresi
  String result = ''; // Menyimpan hasil perhitungan
  bool justCalculated = false; // Flag untuk melacak apakah user baru saja menekan '='

  void buttonPressed(String value) {
    setState(() {
      if (value == '=') {
        // Hitung hasil
        try {
          // Ganti simbol '×' dengan '*' untuk perhitungan
          Parser parser = Parser();
          Expression exp = parser.parse(input.replaceAll('÷', '/').replaceAll('×', '*'));
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);

          // Menghapus ".0" jika hasil adalah bilangan bulat
          result = eval == eval.toInt() ? eval.toInt().toString() : eval.toString();

          justCalculated = true; // Tandai bahwa user baru saja menghitung
        } catch (e) {
          result = "Error"; // Tampilkan pesan error jika ada kesalahan
        }
      } else if (value == 'C') {
        // Reset kalkulator
        input = '';
        result = '';
        justCalculated = false;
      } else {
        // Menambahkan input
        if (justCalculated) {
          // Jika baru saja menghitung, reset input untuk operator baru
          if (['+', '-', '×', '÷'].contains(value)) {
            input = result + value; // Mulai ekspresi baru dari hasil sebelumnya
          } else {
            input = value; // Ganti input dengan angka baru
          }
          result = ''; // Hapus hasil saat operator baru ditekan
          justCalculated = false; // Reset flag
        } else {
          // Tambahkan input secara normal
          input += value;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator'),
      ),
      body: Column(
        children: [
          // Menampilkan input ekspresi
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                input,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Menampilkan hasil
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                result,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
          ),
          const Divider(),
          // Tombol kalkulator
          Expanded(
            flex: 5,
            child: GridView.count(
              crossAxisCount: 4, // Jumlah tombol per baris
              padding: const EdgeInsets.all(8),
              mainAxisSpacing: 8, // Jarak vertikal antar tombol
              crossAxisSpacing: 8, // Jarak horizontal antar tombol
              children: [
                ...['7', '8', '9', '÷', '4', '5', '6', '×', '1', '2', '3', '-', '0', '.', '=', '+', 'C']
                    .map((e) => SizedBox(
                          height: 70, // Tinggi tombol
                          width: 70, // Lebar tombol
                          child: ElevatedButton(
                            onPressed: () => buttonPressed(e),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8), // Membuat sudut tombol membulat
                              ),
                              backgroundColor: Colors.white,
                            ),
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 20, color: Colors.purple), // Ubah warna teks
                            ),
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
