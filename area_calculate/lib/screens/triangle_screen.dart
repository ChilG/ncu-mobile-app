import 'package:flutter/material.dart';
import '../utils/area_calculator.dart';

class TriangleScreen extends StatefulWidget {
  const TriangleScreen({super.key});

  @override
  State<TriangleScreen> createState() => _TriangleScreenState();
}

class _TriangleScreenState extends State<TriangleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _baseController = TextEditingController();
  final _heightController = TextEditingController();
  double? _result;

  @override
  void dispose() {
    _baseController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final base = double.parse(_baseController.text);
      final height = double.parse(_heightController.text);
      setState(() {
        _result = AreaCalculator.calculateTriangle(base, height);
      });
    }
  }

  void _clear() {
    _formKey.currentState?.reset();
    _baseController.clear();
    _heightController.clear();
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
              color: theme.colorScheme.secondaryContainer.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: theme.colorScheme.secondary.withOpacity(0.1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.change_history_rounded,
                      size: 48,
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'คำนวณพื้นที่สามเหลี่ยม',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'สูตร: 0.5 × ฐาน × สูง',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer
                            .withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            TextFormField(
              key: const Key('base_field'),
              controller: _baseController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'ความยาวฐาน (Base)',
                hintText: 'ระบุตัวเลข เช่น 6.0',
                prefixIcon: const Icon(Icons.align_horizontal_center_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'กรุณาระบุความยาวฐาน';
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
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('height_field'),
              controller: _heightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'ความสูง (Height)',
                hintText: 'ระบุตัวเลข เช่น 8.0',
                prefixIcon: const Icon(Icons.swap_vert_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'กรุณาระบุความสูง';
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
                      backgroundColor: theme.colorScheme.secondary,
                      foregroundColor: theme.colorScheme.onSecondary,
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
                shadowColor: theme.colorScheme.secondary.withOpacity(0.2),
                color: theme.colorScheme.secondary,
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
                          color: theme.colorScheme.onSecondary.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _result!
                            .toStringAsFixed(2)
                            .replaceAll(RegExp(r'\.00$'), ''),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'คำนวณจาก: 0.5 × ${_baseController.text} × ${_heightController.text}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSecondary.withOpacity(0.8),
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
