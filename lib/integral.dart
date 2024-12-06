import 'dart:math' as math;

class IntegralCalculator {
  // Metode Simpson untuk perhitungan integral numerik
  static double calculateDefiniteIntegral(String function, double a, double b, {int steps = 1000}) {
    // Validasi input
    if (function.isEmpty) {
      throw ArgumentError('Fungsi tidak boleh kosong');
    }

    // Fungsi untuk menghitung nilai fungsi
    double evaluateFunction(double x) {
      // Ganti variabel x dalam fungsi
      String modifiedFunction = function.replaceAll('x', '($x)');

      // Daftar operasi yang didukung
      modifiedFunction = _replaceExponential(modifiedFunction);

      // Evaluasi ekspresi matematika sederhana
      return _evaluateExpression(modifiedFunction);
    }

    // Implementasi metode Simpson
    double h = (b - a) / steps;
    double sum = evaluateFunction(a) + evaluateFunction(b);

    for (int i = 1; i < steps; i++) {
      double x = a + h * i;
      sum += (i % 2 == 0 ? 2 : 4) * evaluateFunction(x);
    }

    return (h / 3) * sum;
  }

  // Mengganti operator eksponen dengan math.pow
  static String _replaceExponential(String function) {
    RegExp exp = RegExp(r'(\d+|\w)\^(\d+)');
    return function.replaceAllMapped(exp, (match) {
      return 'math.pow(${match.group(1)}, ${match.group(2)})';
    });
  }

  // Evaluasi ekspresi matematika sederhana
  static double _evaluateExpression(String expression) {
    try {
      // ignore: unnecessary_brace_in_string_interps
      return double.parse(eval(expression).toString());
    } catch (e) {
      throw ArgumentError('Fungsi matematika tidak valid');
    }
  }

  // Implementasi sederhana evaluasi ekspresi
  static dynamic eval(String expression) {
    try {
      // ignore: unnecessary_brace_in_string_interps
      return Function.apply(math.pow, [2, 3] // Contoh sederhana, perlu diperluas
          );
    } catch (e) {
      throw ArgumentError('Ekspresi tidak dapat dievaluasi');
    }
  }
}
