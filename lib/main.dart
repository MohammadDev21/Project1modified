import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CurrencyConverter(),
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({Key? key});

  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter>
    with SingleTickerProviderStateMixin {
  double amount = 0.0;
  double result = 0.0;
  String selectedCurrency = 'LBP';
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Add a listener to reverse the animation when it completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    // Start the animation
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "\$ ",
              style: TextStyle(
                color: Colors.red,
                fontSize: 40,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              'Currency Converter',
              style: TextStyle(
                letterSpacing: 6,
                color: Colors.yellow,
                fontStyle: FontStyle.italic,
                fontSize: 40,
              ),
            ),
            Text(
              " £",
              style: TextStyle(
                color: Colors.red,
                fontSize: 40,
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _animation,
              child: const Text(
                "<<<<<WE ONLY CONVERT DOLLARS TO LBP, EUR, GPB>>>>>",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Image.asset(
              "images/currencyconversion.png",
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 30),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  amount = double.parse(value);
                });
              },
              decoration: const InputDecoration(
                labelText: "Enter amount in USD",
                labelStyle: TextStyle(
                  color: Colors.purple,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedCurrency,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCurrency = newValue!;
                });
              },
              items: <String>["LBP", "EUR", "GBP"]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (selectedCurrency == "GBP") {
                    result = amount * 1.5;
                  } else if (selectedCurrency == "EUR") {
                    result = amount * 0.85;
                  } else {
                    result = amount * 1500;
                  }
                });
              },
              child: const Text('Convert'),
            ),
            const SizedBox(height: 20),
            Text('Result: $result $selectedCurrency'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
