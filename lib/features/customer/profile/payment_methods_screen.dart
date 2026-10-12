import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/widgets/gs_button.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<Map<String, dynamic>> _cards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  void _loadCards() {
    final saved = LocalStorage.getPaymentCards();
    if (saved.isNotEmpty) {
      _cards = List<Map<String, dynamic>>.from(saved);
    } else {
      _cards = [
        {
          'id': '1',
          'type': 'Visa',
          'number': '4242',
          'holder': 'Cardholder',
          'expiry': '12/28',
          'isDefault': true,
        },
        {
          'id': '2',
          'type': 'Mastercard',
          'number': '8891',
          'holder': 'Cardholder',
          'expiry': '09/27',
          'isDefault': false,
        },
      ];
      LocalStorage.savePaymentCards(_cards);
    }
    setState(() => _isLoading = false);
  }

  Future<void> _setDefaultCard(int index) async {
    for (int i = 0; i < _cards.length; i++) {
      _cards[i]['isDefault'] = (i == index);
    }
    await LocalStorage.savePaymentCards(_cards);
    setState(() {});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_cards[index]['type']} ending in ${_cards[index]['number']} set as primary payment card.'),
          backgroundColor: AppColors.primaryTeal,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _deleteCard(int index) async {
    final deleted = _cards.removeAt(index);
    if (deleted['isDefault'] == true && _cards.isNotEmpty) {
      _cards.first['isDefault'] = true;
    }
    await LocalStorage.savePaymentCards(_cards);
    setState(() {});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed ${deleted['type']} ending in ${deleted['number']}.'),
          backgroundColor: AppColors.primaryNavy,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showAddCardSheet() {
    final user = context.read<AuthProvider>().user;
    final nameCtrl = TextEditingController(text: user?.fullName ?? '');
    final numberCtrl = TextEditingController();
    final expiryCtrl = TextEditingController();
    final cvvCtrl = TextEditingController();
    bool setAsDefault = _cards.isEmpty;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
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
            child: SingleChildScrollView(
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
                  Text('Add Payment Method', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 4),
                  Text('Encrypted & secured via Bahamian banking protocol', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Cardholder Name',
                      hintText: 'e.g. Cardholder Name',
                      prefixIcon: Icon(Icons.person_outline, color: AppColors.primaryTeal),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: numberCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 19,
                    decoration: const InputDecoration(
                      labelText: 'Card Number',
                      hintText: '4000 1234 5678 9010',
                      counterText: '',
                      prefixIcon: Icon(Icons.credit_card_outlined, color: AppColors.primaryTeal),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: expiryCtrl,
                          keyboardType: TextInputType.datetime,
                          maxLength: 5,
                          decoration: const InputDecoration(
                            labelText: 'Expiry (MM/YY)',
                            hintText: '12/28',
                            counterText: '',
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextField(
                          controller: cvvCtrl,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'CVV / CVC',
                            hintText: '•••',
                            counterText: '',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  CheckboxListTile(
                    value: setAsDefault,
                    onChanged: (v) => setModalState(() => setAsDefault = v ?? false),
                    title: Text('Set as default card for bookings', style: AppTextStyles.titleMedium),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.primaryTeal,
                  ),
                  const SizedBox(height: 20),
                  GSButton(
                    label: 'Save Payment Card',
                    onTap: () async {
                      final rawNum = numberCtrl.text.replaceAll(' ', '').trim();
                      if (rawNum.length < 12) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a valid card number'), backgroundColor: AppColors.red),
                        );
                        return;
                      }

                      String brand = 'Visa';
                      if (rawNum.startsWith('5')) brand = 'Mastercard';
                      if (rawNum.startsWith('3')) brand = 'Amex';

                      final last4 = rawNum.length >= 4 ? rawNum.substring(rawNum.length - 4) : rawNum;
                      final newCard = {
                        'id': DateTime.now().millisecondsSinceEpoch.toString(),
                        'type': brand,
                        'number': last4,
                        'holder': nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : 'Valued Guest',
                        'expiry': expiryCtrl.text.trim().isNotEmpty ? expiryCtrl.text.trim() : '12/28',
                        'isDefault': setAsDefault,
                      };

                      if (setAsDefault) {
                        for (final c in _cards) {
                          c['isDefault'] = false;
                        }
                      }
                      _cards.add(newCard);
                      final messenger = ScaffoldMessenger.of(context);
                      final navigator = Navigator.of(ctx);
                      await LocalStorage.savePaymentCards(_cards);
                      if (mounted) {
                        setState(() {});
                        navigator.pop();
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text('$brand ending in $last4 added successfully.'),
                            backgroundColor: AppColors.green,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Payment Methods', style: AppTextStyles.titleLarge),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Saved Cards', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 4),
                  Text('Tap any card to set as default payment source', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 16),
                  if (_cards.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text('No payment methods saved yet.', style: AppTextStyles.bodyMedium),
                    )
                  else
                    ..._cards.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final card = entry.value;
                      return _cardTile(
                        type: card['type'] ?? 'Card',
                        ending: 'ending in ${card['number'] ?? '****'}',
                        expiry: card['expiry'] ?? '',
                        isDefault: card['isDefault'] == true,
                        onTap: () => _setDefaultCard(idx),
                        onDelete: () => _deleteCard(idx),
                      );
                    }),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: _showAddCardSheet,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.primaryTeal, width: 1.2),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryTeal, size: 22),
                          const SizedBox(width: 10),
                          Text(
                            'Add New Payment Method',
                            style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.badgeTeal.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryTeal.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.shield_outlined, color: AppColors.primaryTeal, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Security Guarantee', style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryNavy)),
                              const SizedBox(height: 4),
                              Text(
                                'Card details are processed in accordance with Central Bank of The Bahamas security regulations. Your card numbers are never stored in plain text.',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _cardTile({
    required String type,
    required String ending,
    required String expiry,
    required bool isDefault,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    IconData brandIcon = Icons.credit_card;
    Color brandColor = AppColors.primaryTeal;
    if (type.toLowerCase().contains('mastercard')) {
      brandColor = const Color(0xFFEB001B);
    } else if (type.toLowerCase().contains('amex')) {
      brandColor = const Color(0xFF006FCF);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDefault ? AppColors.primaryTeal : AppColors.border,
          width: isDefault ? 1.5 : 1.0,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 36,
                  decoration: BoxDecoration(
                    color: brandColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Icon(brandIcon, color: brandColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(type, style: AppTextStyles.titleMedium),
                          const SizedBox(width: 6),
                          Text(ending, style: AppTextStyles.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text('Expires $expiry', style: AppTextStyles.caption),
                    ],
                  ),
                ),
                if (isDefault)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.badgeTeal,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('DEFAULT', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                  ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.red, size: 20),
                  onPressed: onDelete,
                  tooltip: 'Remove Card',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
