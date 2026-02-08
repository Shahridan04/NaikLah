import 'package:flutter/material.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  static const Color hotPink = Color(0xFFEC4899);
  static const Color emeraldGreen = Color(0xFF10B981);

  String _selectedColorblindMode = 'None';
  int _selectedFontSize = 1; // 0: Small, 1: Medium, 2: Large, 3: Extra Large
  bool _highContrast = false;
  bool _screenReader = false;
  bool _reduceMotion = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Accessibility Options',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Colorblind Mode
                _buildHeader(
                  Icons.palette_outlined,
                  'Colorblind Mode',
                  context,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedColorblindMode,
                      isExpanded: true,
                      items:
                          [
                            'None',
                            'Protanopia',
                            'Deuteranopia',
                            'Tritanopia',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedColorblindMode = value);
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Font Size
                _buildHeader(Icons.text_format, 'Font Size', context),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(4, (index) {
                    final isSelected = _selectedFontSize == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedFontSize = index),
                        child: Container(
                          height: 48,
                          margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'A',
                            style: TextStyle(
                              fontSize: 12.0 + (index * 4),
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 32),

                // High Contrast
                _buildSwitchRow(
                  Icons.visibility_outlined,
                  'High Contrast',
                  'Enhance visual clarity',
                  _highContrast,
                  (v) => setState(() => _highContrast = v),
                ),

                const Divider(height: 32),

                // Screen Reader
                _buildSwitchRow(
                  Icons.volume_up_outlined,
                  'Screen Reader Support',
                  'Optimize for screen readers',
                  _screenReader,
                  (v) => setState(() => _screenReader = v),
                ),

                const Divider(height: 32),

                // Reduce Motion
                _buildSwitchRow(
                  Icons.settings_outlined,
                  'Reduce Motion',
                  'Minimize animations',
                  _reduceMotion,
                  (v) => setState(() => _reduceMotion = v),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(IconData icon, String title, BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSwitchRow(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      children: [
        Icon(icon, color: Colors.orange, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged, activeColor: Colors.blue),
      ],
    );
  }
}
