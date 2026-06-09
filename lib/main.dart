import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const BmiCalculatorApp());
}

class BmiCalculatorApp extends StatelessWidget {
  const BmiCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6C63FF),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: const BmiHomePage(),
    );
  }
}

enum Gender {
  male,
  female,
}

class BmiHomePage extends StatefulWidget {
  const BmiHomePage({super.key});

  @override
  State<BmiHomePage> createState() => _BmiHomePageState();
}

class _BmiHomePageState extends State<BmiHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  Gender? _selectedGender;
  double? _bmi;
  String _classification = '';

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  double? _parseNumber(String value) {
    final normalizedValue = value.trim().replaceAll(',', '.');
    return double.tryParse(normalizedValue);
  }

  String? _validateNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o $fieldName';
    }

    final number = _parseNumber(value);

    if (number == null) {
      return 'Digite um número válido';
    }

    if (number <= 0) {
      return 'O valor deve ser maior que zero';
    }

    return null;
  }

  void _calculateBmi() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final weight = _parseNumber(_weightController.text)!;
    final heightCm = _parseNumber(_heightController.text)!;

    final heightMeters = heightCm / 100;
    final calculatedBmi = weight / (heightMeters * heightMeters);

    setState(() {
      _bmi = calculatedBmi;
      _classification = _getClassification(calculatedBmi);
    });

    _showCategoriesModal(calculatedBmi);
  }

  String _getClassification(double bmi) {
    if (bmi < 18.5) {
      return 'Abaixo do peso';
    }

    if (bmi < 25) {
      return 'Normal';
    }

    if (bmi < 30) {
      return 'Sobrepeso';
    }

    return 'Obesidade';
  }

  String _getMessage(double bmi) {
    if (bmi < 18.5) {
      return 'Seu IMC está abaixo da faixa considerada normal.';
    }

    if (bmi < 25) {
      return 'Seu IMC está dentro da faixa considerada normal.';
    }

    if (bmi < 30) {
      return 'Seu IMC indica sobrepeso.';
    }

    return 'Seu IMC indica obesidade.';
  }

  Color _getResultColor(double bmi) {
    if (bmi < 18.5) {
      return Colors.blue;
    }

    if (bmi < 25) {
      return Colors.green;
    }

    if (bmi < 30) {
      return Colors.orange;
    }

    return Colors.red;
  }

  void _showCategoriesModal(double currentBmi) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Categorias do IMC',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _CategoryRow(
                title: 'Abaixo do peso',
                range: 'Menor que 18.5',
                isActive: currentBmi < 18.5,
                color: Colors.blue,
              ),
              _CategoryRow(
                title: 'Normal',
                range: '18.5 a 24.9',
                isActive: currentBmi >= 18.5 && currentBmi < 25,
                color: Colors.green,
              ),
              _CategoryRow(
                title: 'Sobrepeso',
                range: '25 a 29.9',
                isActive: currentBmi >= 25 && currentBmi < 30,
                color: Colors.orange,
              ),
              _CategoryRow(
                title: 'Obesidade',
                range: '30 ou mais',
                isActive: currentBmi >= 30,
                color: Colors.red,
              ),
            ],
          ),
        );
      },
    );
  }

  void _clearFields() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _selectedGender = null;
      _bmi = null;
      _classification = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultColor = _bmi == null ? Colors.black : _getResultColor(_bmi!);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BMI Calculator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Calcule seu Índice de Massa Corporal',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Informe seu peso e sua altura para descobrir sua classificação.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 28),

                Row(
                  children: [
                    Expanded(
                      child: _GenderCard(
                        label: 'Masculino',
                        icon: Icons.male,
                        isSelected: _selectedGender == Gender.male,
                        onTap: () {
                          setState(() {
                            _selectedGender = Gender.male;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _GenderCard(
                        label: 'Feminino',
                        icon: Icons.female,
                        isSelected: _selectedGender == Gender.female,
                        onTap: () {
                          setState(() {
                            _selectedGender = Gender.female;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                _InputCard(
                  title: 'Peso',
                  subtitle: 'em kg',
                  child: TextFormField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9,.]'),
                      ),
                    ],
                    decoration: const InputDecoration(
                      hintText: 'Ex: 70',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => _validateNumber(value, 'peso'),
                  ),
                ),

                const SizedBox(height: 16),

                _InputCard(
                  title: 'Altura',
                  subtitle: 'em cm',
                  child: TextFormField(
                    controller: _heightController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9,.]'),
                      ),
                    ],
                    decoration: const InputDecoration(
                      hintText: 'Ex: 175',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => _validateNumber(value, 'altura'),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _calculateBmi,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'CALCULAR',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: _clearFields,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('LIMPAR'),
                  ),
                ),

                const SizedBox(height: 28),

                if (_bmi != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Seu resultado',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _bmi!.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: resultColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _classification,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: resultColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getMessage(_bmi!),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            _showCategoriesModal(_bmi!);
                          },
                          child: const Text('Ver categorias do IMC'),
                        ),
                      ],
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

class _GenderCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = const Color(0xFF6C63FF);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 22,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.black12,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 46,
              color: isSelected ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _InputCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String title;
  final String range;
  final bool isActive;
  final Color color;

  const _CategoryRow({
    required this.title,
    required this.range,
    required this.isActive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.12) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? color : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.circle_outlined,
            color: isActive ? color : Colors.black38,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? color : Colors.black87,
              ),
            ),
          ),
          Text(
            range,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}