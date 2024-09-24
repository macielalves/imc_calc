import 'package:flutter/material.dart';

void main() => runApp(const IMCApp());

class IMCApp extends StatelessWidget {
  const IMCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de IMC',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusColor: Colors.green,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(16.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
      home: const IMCCalculator(),
    );
  }
}

class IMCCalculator extends StatefulWidget {
  const IMCCalculator({super.key});

  @override
  IMCCalculatorState createState() => IMCCalculatorState();
}

class IMCCalculatorState extends State<IMCCalculator> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  double? _imcResult;
  String? _imcCategory;
  int? _imcGrau;
  Color? _categoryColor;

  // < 18.5: Magreza, obersidade 0
  // 18,5 a 24,9: Peso normal, obersidade 0
  // 25 a 29,9: Sobrepeso, obersidade 1
  // 30 a 34,9: Obesidade grau 1
  // 35 a 39,9: Obesidade grau 2
  // 40 ou mais: Obesidade grave grau 3
  void _obesityCategory(double imc) {
    if (imc < 18.5) {
      setState(() {
        _imcCategory = 'Magreza';
        _imcGrau = 0;
        _categoryColor = Colors.yellow;
      });
    } else if (imc >= 18.5 && imc <= 24.9) {
      setState(() {
        _imcCategory = 'Peso normal';
        _imcGrau = 0;
        _categoryColor = Colors.green;
      });
    } else if (imc >= 25 && imc <= 29.9) {
      setState(() {
        _imcCategory = 'Sobrepeso';
        _imcGrau = 1;
        _categoryColor = Colors.yellow;
      });
    } else if (imc >= 30 && imc <= 34.9) {
      setState(() {
        _imcCategory = 'Obesidade grau 1';
        _imcGrau = 1;
        _categoryColor = Colors.orange;
      });
    } else if (imc >= 35 && imc <= 39.9) {
      setState(() {
        _imcCategory = 'Obesidade grau 2';
        _imcGrau = 2;
        _categoryColor = Colors.deepOrange;
      });
    } else {
      setState(() {
        _imcCategory = 'Obesidade grave grau 3';
        _imcGrau = 3;
        _categoryColor = Colors.red;
      });
    }
  }

  void _calculateIMC() {
    final double? weight = double.tryParse(_weightController.text);
    final double? height = double.tryParse(_heightController.text);

    if (weight != null && height != null && height > 0) {
      setState(() {
        _imcResult = weight / (height * height);
        _obesityCategory(_imcResult!);
      });
    } else {
      setState(() {
        _imcResult = null;
        _imcCategory = null;
      });
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Tá errado isso aê!'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(children: [
              if (_imcResult != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Seu IMC é ${_imcResult!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              if (_imcCategory != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _imcCategory!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _categoryColor,
                    ),
                  ),
                ),
            ]),
            const SizedBox(height: 24),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Peso (kg)',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Altura (m)',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculateIMC,
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 24),
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                backgroundColor: Colors.green.shade300,
              ),
              child: const Text(
                'Calcular IMC',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
