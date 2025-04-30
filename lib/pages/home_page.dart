import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conversor_moedas/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _valueController = TextEditingController();
  Map<String, dynamic>? conversionRates;
  bool _isLoading = false;
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  void _convert() async {
    String base = "brl";
    double? amount =
        double.tryParse(_valueController.text.trim().replaceAll(',', '.'));

    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um valor válido para conversão!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      var rates = await ApiService.convertCurrency(base);
      print('rates: $rates');

      setState(() {
        conversionRates = rates.map((key, value) {
          final doubleValue = value is double
              ? value
              : double.tryParse(value.toString()) ?? 0.0;
          return MapEntry(key.toUpperCase(), doubleValue * amount);
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao converter: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Conversor de Moedas', style: GoogleFonts.limelight()),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.email ?? "Email não encontrado",
                      style: GoogleFonts.dmSerifText(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _valueController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Digite o valor (R\$)',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white))
                              : conversionRates != null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'USD: \$${(conversionRates!['USD'] ?? 0.0).toStringAsFixed(2)}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16)),
                                        Text(
                                            'JPY: ¥${(conversionRates!['JPY'] ?? 0.0).toStringAsFixed(2)}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16)),
                                        Text(
                                            'EUR: €${(conversionRates!['EUR'] ?? 0.0).toStringAsFixed(2)}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16)),
                                      ],
                                    )
                                  : const Text(
                                      'Conversão aparecerá aqui',
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 14),
                                    ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _convert,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Converter'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
