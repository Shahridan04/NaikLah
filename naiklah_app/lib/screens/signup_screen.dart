import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'home_screen.dart';

/// Multi-step signup screen
/// Step 1: Gender Selection
/// Step 2: Transport Preferences (+ Women-Only Pink Bus if female)
/// Step 3: Company Details
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Colors
  static const Color hotPink = Color(0xFFEC4899);
  static const Color maleBlue = Color(0xFF3B82F6);
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color lightPink = Color(0xFFFDF2F8);
  static const Color lightBlue = Color(0xFFEFF6FF);

  // Form Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State
  int _currentStep = 0;
  String? _selectedGender;
  final Set<String> _selectedTransport = {};
  bool _prefersWomenOnly = false;
  String? _selectedCompany;
  bool _isLoading = false;

  // Get theme color based on gender
  Color get _themeColor => _selectedGender == 'male' ? maleBlue : hotPink;
  Color get _bgColor => _selectedGender == 'male' ? lightBlue : lightPink;

  // Transport options
  final List<Map<String, dynamic>> _transportOptions = [
    {'id': 'bus', 'name': 'Bus', 'icon': Icons.directions_bus},
    {'id': 'train', 'name': 'Train/LRT', 'icon': Icons.train},
    {'id': 'bike', 'name': 'Bicycle', 'icon': Icons.pedal_bike},
    {'id': 'walk', 'name': 'Walking', 'icon': Icons.directions_walk},
    {'id': 'carpool', 'name': 'Carpool', 'icon': Icons.people},
    {'id': 'scooter', 'name': 'E-Scooter', 'icon': Icons.electric_scooter},
  ];

  // Companies
  final List<String> _companies = [
    'Select your company',
    'Grab Malaysia',
    'Petronas',
    'Maybank',
    'AirAsia',
    'Tenaga Nasional',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0 && _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your gender')),
      );
      return;
    }
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _completeSignup();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _completeSignup() async {
    setState(() => _isLoading = true);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    UserService().signUp(
      name: _nameController.text.isNotEmpty ? _nameController.text : 'User',
      email: _emailController.text.isNotEmpty
          ? _emailController.text
          : 'user@example.com',
      password: _passwordController.text,
      gender: _selectedGender ?? 'female',
      company: _selectedCompany,
      preferredTransport: _selectedTransport.toList(),
      prefersWomenOnlyTransport: _prefersWomenOnly,
    );

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgColor, Colors.white, _bgColor.withValues(alpha: 0.5)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              _buildProgressIndicator(),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _buildCurrentStep(),
                ),
              ),
              // Navigation buttons
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Step ${_currentStep + 1} of 3',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(3, (index) {
              final isActive = index <= _currentStep;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                  decoration: BoxDecoration(
                    color: isActive ? _themeColor : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildGenderStep();
      case 1:
        return _buildTransportStep();
      case 2:
        return _buildCompanyStep();
      default:
        return const SizedBox();
    }
  }

  /// Step 1: Gender Selection
  Widget _buildGenderStep() {
    return Column(
      children: [
        // Checkmark icon
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: emeraldGreen.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle, color: emeraldGreen, size: 48),
        ),
        const SizedBox(height: 24),
        const Text(
          'Tell Us About You',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Select your gender to personalize your experience',
          style: TextStyle(color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        // Gender options
        Row(
          children: [
            Expanded(
              child: _buildGenderCard('male', 'Male', Icons.male, maleBlue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGenderCard(
                'female',
                'Female',
                Icons.female,
                hotPink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Info text based on selection
        if (_selectedGender != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _themeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _themeColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: _themeColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedGender == 'female'
                        ? 'You\'ll see Women-Only Pink Bus options for safe travel! 🌸'
                        : 'We\'ll show you the best sustainable transport options! 🚌',
                    style: TextStyle(color: _themeColor),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildGenderCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: isSelected ? color : Colors.grey),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Step 2: Transport Preferences
  Widget _buildTransportStep() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: emeraldGreen.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle, color: emeraldGreen, size: 48),
        ),
        const SizedBox(height: 24),
        const Text(
          'Transport Preferences',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Which modes of transport do you use?',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 32),
        // Transport grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: _transportOptions.length,
          itemBuilder: (context, index) {
            final option = _transportOptions[index];
            final isSelected = _selectedTransport.contains(option['id']);
            return _buildTransportCard(option, isSelected);
          },
        ),
        const SizedBox(height: 24),
        // Tip
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.shade200),
          ),
          child: Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tip: You\'ll earn different point amounts based on the environmental impact of each transport mode.',
                  style: TextStyle(color: Colors.amber.shade900, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransportCard(Map<String, dynamic> option, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedTransport.remove(option['id']);
          } else {
            _selectedTransport.add(option['id']);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? _themeColor.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _themeColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              option['icon'] as IconData,
              color: isSelected ? _themeColor : Colors.grey,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              option['name'] as String,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? _themeColor : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Step 3: Company Details (with Women-Only option for females)
  Widget _buildCompanyStep() {
    final isFemale = _selectedGender == 'female';
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: emeraldGreen.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle, color: emeraldGreen, size: 48),
        ),
        const SizedBox(height: 24),
        const Text(
          'Company Details',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Help us personalize your experience',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 32),
        // Company dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButton<String>(
            value: _selectedCompany ?? _companies.first,
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down),
            items: _companies.map((company) {
              return DropdownMenuItem(value: company, child: Text(company));
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedCompany = value);
            },
          ),
        ),
        // Women-Only Pink Bus Option (only for females)
        if (isFemale) ...[
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: hotPink.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: hotPink.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: hotPink.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.directions_bus, color: hotPink),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Women-Only Pink Bus Option',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Safe, dedicated transport with female drivers, GPS tracking, and emergency SOS features. Perfect for night shifts and enhanced peace of mind.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 16),
                // Toggle
                GestureDetector(
                  onTap: () =>
                      setState(() => _prefersWomenOnly = !_prefersWomenOnly),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _prefersWomenOnly
                                ? hotPink
                                : Colors.grey.shade400,
                            width: 2,
                          ),
                          color: _prefersWomenOnly
                              ? hotPink
                              : Colors.transparent,
                        ),
                        child: _prefersWomenOnly
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Yes, I prefer Pink Bus options',
                        style: TextStyle(
                          color: _prefersWomenOnly
                              ? hotPink
                              : Colors.grey.shade700,
                          fontWeight: _prefersWomenOnly
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Back button
          Expanded(
            child: OutlinedButton(
              onPressed: _previousStep,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                side: BorderSide(color: Colors.grey.shade300),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Back'),
            ),
          ),
          const SizedBox(width: 16),
          // Next/Complete button
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: _themeColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(_currentStep == 2 ? 'Get Started' : 'Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
