import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/widgets/gs_button.dart';
import '../../../../core/widgets/gs_text_field.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        _firstNameController.text = user.firstName;
        _lastNameController.text = user.lastName;
        _phoneController.text = user.phone;
        _streetController.text = user.streetAddress ?? '';
        _cityController.text = user.city ?? '';
      }
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final auth = context.read<AuthProvider>();
    final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'.trim();
    final success = await auth.updateProfile(
      fullName: fullName.isNotEmpty ? fullName : null,
      phoneNumber: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
      streetAddress: _streetController.text.trim().isNotEmpty ? _streetController.text.trim() : null,
      city: _cityController.text.trim().isNotEmpty ? _cityController.text.trim() : null,
    );

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: AppColors.primaryTeal,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Failed to update profile'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Personal Information', style: AppTextStyles.titleLarge),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GSTextField(
              controller: _firstNameController,
              label: 'First Name',
              hint: 'Marcus',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            GSTextField(
              controller: _lastNameController,
              label: 'Last Name',
              hint: 'Pendelton',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            GSTextField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: '+1 (242) 555-0199',
              prefixIcon: Icons.phone_outlined,
            ),
            const SizedBox(height: 16),
            GSTextField(
              controller: _streetController,
              label: 'Street Address / Villa',
              hint: 'e.g. 101 Ocean Club Drive, Villa 4',
              prefixIcon: Icons.home_outlined,
            ),
            const SizedBox(height: 16),
            GSTextField(
              controller: _cityController,
              label: 'City / Island',
              hint: 'Nassau & Paradise Island',
              prefixIcon: Icons.location_city_outlined,
            ),
            const SizedBox(height: 32),
            GSButton(
              label: 'Save Changes',
              isLoading: auth.isLoading,
              onTap: _handleSave,
            ),
          ],
        ),
      ),
    );
  }
}

