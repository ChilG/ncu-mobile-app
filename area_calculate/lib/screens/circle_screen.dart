import 'package:flutter/material.dart';
import '../utils/area_calculator.dart';

class CircleScreen extends StatefulWidget {
  const CircleScreen({super.key});

  @override
  State<CircleScreen> createState() => _CircleScreenState();
}

class _CircleScreenState extends State<CircleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _radiusController = TextEditingController();
  double? _result;

  @override
  void dispose() {
    _radiusController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final radius = double.parse(_radiusController.text);
      setState(() {
        _result = AreaCalculator.calculateCircle(radius);
      });
    }
  }

  void _clear() {
    _formKey.currentState?.reset();
    _radiusController.clear();
    setState(() {
      _result = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              color: theme.colorScheme.tertiaryContainer.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: theme.colorScheme.tertiary.withOpacity(0.1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.circle_outlined,
                      size: 48,
                      color: theme.colorScheme.tertiary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'คำนวณพื้นที่วงกลม',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onTertiaryContainer,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'สูตร: π × r² (π ≈ 3.14159)',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onTertiaryContainer
                            .withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            TextFormField(
              key: const Key('radius_field'),
              controller: _radiusController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'ความยาวรัศมี (Radius)',
                hintText: 'ระบุตัวเลข เช่น 7.0',
                prefixIcon: const Icon(Icons.blur_circular),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'กรุณาระบุความยาวรัศมี';
                }
                final number = double.tryParse(value);
                if (number == null) {
                  return 'กรุณาระบุเป็นตัวเลขเท่านั้น';
                }
                if (number <= 0) {
                  return 'ค่าต้องมากกว่า 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    key: const Key('clear_button'),
                    onPressed: _clear,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('ล้างข้อมูล'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    key: const Key('calculate_button'),
                    onPressed: _calculate,
                    icon: const Icon(Icons.calculate_rounded),
                    label: const Text('คำนวณ'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: theme.colorScheme.tertiary,
                      foregroundColor: theme.colorScheme.onTertiary,
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            if (_result != null)
              Card(
                key: const Key('result_card'),
                elevation: 4,
                shadowColor: theme.colorScheme.tertiary.withOpacity(0.2),
                color: theme.colorScheme.tertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: 16.0,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'พื้นที่ผลลัพธ์',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onTertiary.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _result!
                            .toStringAsFixed(4)
                            .replaceAll(RegExp(r'\.?0+$'), ''),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onTertiary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'คำนวณจาก: π × (${_radiusController.text})²',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onTertiary.withOpacity(0.8),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
