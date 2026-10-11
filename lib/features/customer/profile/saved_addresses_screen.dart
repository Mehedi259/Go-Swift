import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/widgets/gs_button.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  void _showAddOrEditAddressSheet(BuildContext context, {String? currentStreet, String? currentCity}) {
    final streetCtrl = TextEditingController(text: currentStreet ?? '');
    final cityCtrl = TextEditingController(text: currentCity ?? 'Nassau & Paradise Island');
    final postalCtrl = TextEditingController(text: 'BS-NPA');
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Text('Save Primary Island Address', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 4),
              Text('Used for chauffeur pickups, dining deliveries, and charter bookings.', style: AppTextStyles.bodySmall),
              const SizedBox(height: 16),
              TextField(
                controller: streetCtrl,
                decoration: const InputDecoration(
                  labelText: 'Street Address / Villa Name',
                  hintText: 'e.g. 101 Ocean Club Drive, Villa 4',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cityCtrl,
                decoration: const InputDecoration(
                  labelText: 'City / District',
                  hintText: 'e.g. Paradise Island, Nassau',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: postalCtrl,
                decoration: const InputDecoration(
                  labelText: 'Postal / Island Code',
                  hintText: 'e.g. BS-NPA-2026',
                ),
              ),
              const SizedBox(height: 24),
              GSButton(
                label: isSaving ? 'Saving Address...' : 'Save Address',
                onTap: isSaving
                    ? () {}
                    : () async {
                        final street = streetCtrl.text.trim();
                        final city = cityCtrl.text.trim();
                        final postal = postalCtrl.text.trim();

                        if (street.isEmpty) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(content: Text('Please enter street address or villa name')),
                          );
                          return;
                        }

                        setModalState(() => isSaving = true);
                        final auth = context.read<AuthProvider>();
                        final success = await auth.updateProfile(
                          streetAddress: street,
                          city: city.isNotEmpty ? city : null,
                          postalCode: postal.isNotEmpty ? postal : null,
                        );

                        if (ctx.mounted) Navigator.pop(ctx);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success ? 'Address saved to profile!' : (auth.errorMessage ?? 'Failed to save address')),
                              backgroundColor: success ? AppColors.green : AppColors.red,
                            ),
                          );
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    final street = user?.streetAddress;
    final city = user?.city;
    final hasCustomAddress = street != null && street.isNotEmpty;
    final primaryStreet = hasCustomAddress ? street : 'The Ocean Club, Paradise Island';
    final primaryCity = (city != null && city.isNotEmpty) ? city : 'Nassau & Paradise Island';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Saved Addresses', style: AppTextStyles.titleLarge),
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
            Text(
              'PRIMARY REGISTERED ADDRESS',
              style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _addressTile(
              icon: Icons.home_outlined,
              label: hasCustomAddress ? 'Primary Residence / Villa' : 'Default Vacation Villa',
              address: '$primaryStreet, $primaryCity',
              isDefault: true,
              onEdit: () => _showAddOrEditAddressSheet(context, currentStreet: user?.streetAddress, currentCity: user?.city),
            ),
            const SizedBox(height: 20),
            Text(
              'SAVED DESTINATIONS',
              style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _addressTile(
              icon: Icons.work_outline,
              label: 'Corporate Office / Bay St Financial',
              address: 'Financial Center, Bay Street, Downtown Nassau',
              onEdit: () => _showAddOrEditAddressSheet(context, currentStreet: 'Financial Center, Bay Street', currentCity: 'Downtown Nassau'),
            ),
            const SizedBox(height: 12),
            _addressTile(
              icon: Icons.anchor_outlined,
              label: 'Lyford Cay Marina & Yacht Club',
              address: 'Lyford Cay Club Marina Slip #14, New Providence',
              onEdit: () => _showAddOrEditAddressSheet(context, currentStreet: 'Lyford Cay Club Marina Slip #14', currentCity: 'New Providence'),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => _showAddOrEditAddressSheet(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primaryTeal.withValues(alpha: 0.5)),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: AppColors.primaryTeal, size: 20),
                    const SizedBox(width: 8),
                    Text('Update / Add New Address', style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addressTile({
    required IconData icon,
    required String label,
    required String address,
    bool isDefault = false,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: AppColors.cardTouchpoint, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.primaryTeal, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(label, style: AppTextStyles.titleMedium),
                    if (isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.cyanPill, borderRadius: BorderRadius.circular(6)),
                        child: Text('PRIMARY', style: AppTextStyles.caption.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold, fontSize: 10)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(address, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primaryTeal, size: 20),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}
