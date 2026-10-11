import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/support_ticket_model.dart';
import '../../../core/services/support_service.dart';

class SupportScreen extends StatelessWidget {
  final bool embedded;
  const SupportScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {'q': 'How do I cancel a ride?', 'a': 'You can cancel a ride from the active ride screen before the driver arrives. Cancellations may incur a fee after driver acceptance.'},
      {'q': 'How is the fare calculated?', 'a': 'Fares are calculated based on distance, vehicle type, and island traffic conditions. All prices are in BSD/USD (1:1).'},
      {'q': 'Is my data secure?', 'a': 'All personal data is encrypted and stored securely in compliance with Bahamian data protection laws.'},
      {'q': 'How do I contact a driver?', 'a': 'Once a driver is assigned, you can call or message them directly from the ride tracking screen.'},
    ];

    final content = Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Support & Help', style: AppTextStyles.headlineLarge),
              Text("We're here to help you 24/7", style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Quick contact
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(child: _contactBtn(Icons.confirmation_number_outlined, 'New Ticket', AppColors.primaryTeal, () => _showCreateTicketSheet(context))),
              const SizedBox(width: 12),
              Expanded(child: _contactBtn(Icons.chat_outlined, 'Concierge Chat', AppColors.teal, () => _showCreateTicketSheet(context))),
              const SizedBox(width: 12),
              Expanded(child: _contactBtn(Icons.mail_outlined, 'My Tickets', const Color(0xFFC78400), () => _showMyTicketsSheet(context))),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Live chat banner
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: () => _showCreateTicketSheet(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardTouchpoint,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(color: AppColors.primaryTeal, shape: BoxShape.circle),
                    child: const Icon(Icons.support_agent, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Text('CONCIERGE ONLINE', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text('Open Support Request', style: AppTextStyles.titleLarge),
                        Text('Direct response from executive desk', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward, color: AppColors.primaryTeal, size: 20),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Frequently Asked Questions', style: AppTextStyles.headlineSmall),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: faqs.length,
            itemBuilder: (c, i) => _FAQTile(q: faqs[i]['q']!, a: faqs[i]['a']!),
          ),
        ),
      ],
    );

    return embedded ? content : Scaffold(backgroundColor: AppColors.background, body: SafeArea(child: content));
  }

  Widget _contactBtn(IconData icon, String label, Color color, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        ],
      ),
    ),
  );

  void _showCreateTicketSheet(BuildContext context) {
    final subjectController = TextEditingController();
    final messageController = TextEditingController();
    String category = 'general';
    bool isSubmitting = false;

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
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Create Concierge Ticket', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 4),
              Text('Our 24/7 executive team will resolve your request promptly.', style: AppTextStyles.bodySmall),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: const [
                  DropdownMenuItem(value: 'general', child: Text('General Inquiry')),
                  DropdownMenuItem(value: 'ride', child: Text('Ride & Chauffeur')),
                  DropdownMenuItem(value: 'food', child: Text('Dining & Delivery')),
                  DropdownMenuItem(value: 'courier', child: Text('Courier Dispatch')),
                  DropdownMenuItem(value: 'rental', child: Text('Car Rental Fleet')),
                  DropdownMenuItem(value: 'property', child: Text('Villa & Stay')),
                  DropdownMenuItem(value: 'billing', child: Text('Billing & Payment')),
                ],
                onChanged: (val) => setModalState(() => category = val ?? 'general'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: subjectController,
                decoration: const InputDecoration(labelText: 'Subject', hintText: 'Brief summary of issue'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: messageController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Message', hintText: 'Detailed description'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (subjectController.text.trim().isEmpty || messageController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill all fields'), backgroundColor: AppColors.red),
                            );
                            return;
                          }
                          setModalState(() => isSubmitting = true);
                          try {
                            await SupportService().submitTicket(
                              subject: subjectController.text.trim(),
                              message: messageController.text.trim(),
                              category: category,
                            );
                            if (ctx.mounted) Navigator.pop(ctx);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Ticket submitted successfully! An agent will respond shortly.'),
                                  backgroundColor: AppColors.primaryTeal,
                                ),
                              );
                            }
                          } catch (e) {
                            setModalState(() => isSubmitting = false);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.red),
                              );
                            }
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Submit Ticket', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMyTicketsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
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
            Text('My Support Tickets', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<SupportTicketModel>>(
                future: SupportService().getMyTickets(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Failed to load tickets: ${snapshot.error}', style: AppTextStyles.bodyMedium));
                  }
                  final tickets = snapshot.data ?? [];
                  if (tickets.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.inbox_outlined, size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 8),
                          Text('No support tickets found', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: tickets.length,
                    separatorBuilder: (_, _) => const Divider(color: AppColors.border),
                    itemBuilder: (context, i) {
                      final t = tickets[i];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: AppColors.badgeTeal,
                          child: const Icon(Icons.confirmation_number_outlined, color: AppColors.primaryTeal, size: 20),
                        ),
                        title: Text(t.subject, style: AppTextStyles.titleMedium),
                        subtitle: Text('${t.status.toUpperCase()} • ${(t.category ?? 'general').toUpperCase()}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryTeal)),
                        trailing: Text(t.createdAt != null && t.createdAt!.length >= 10 ? t.createdAt!.substring(0, 10) : 'Active', style: AppTextStyles.caption),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FAQTile extends StatefulWidget {
  final String q, a;
  const _FAQTile({required this.q, required this.a});
  @override State<_FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<_FAQTile> {
  bool _open = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _open = !_open),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _open ? AppColors.primaryTeal : AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(widget.q, style: AppTextStyles.titleMedium)),
                Icon(_open ? Icons.expand_less : Icons.expand_more, color: AppColors.primaryTeal, size: 20),
              ],
            ),
            if (_open) ...[
              const SizedBox(height: 10),
              Text(widget.a, style: AppTextStyles.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}
