import 'package:flutter/material.dart';
import '../models/landmark.dart';

class DetailScreen extends StatelessWidget {
  final Landmark landmark;
  final String language;

  const DetailScreen({
    super.key,
    required this.landmark,
    required this.language,
  });
  
  @override
  Widget build(BuildContext context) {
    final isRTL = language == 'ar';
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: landmark.imageUrl != null
                    ? (landmark.imageUrl!.startsWith('assets/')
                        ? Image.asset(
                            landmark.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      landmark.imageColor,
                                      landmark.imageColor.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    landmark.icon,
                                    size: 100,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                              );
                            },
                          )
                        : Image.network(
                            landmark.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      landmark.imageColor,
                                      landmark.imageColor.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    landmark.icon,
                                    size: 100,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                              );
                            },
                          ))
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              landmark.imageColor,
                              landmark.imageColor.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            landmark.icon,
                            size: 100,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      landmark.getName(language),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Category
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: landmark.imageColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        landmark.getCategory(language),
                        style: TextStyle(
                          color: landmark.imageColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Description
                    Text(
                      landmark.getDescription(language),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Access Information
                    _InfoSection(
                      icon: Icons.directions,
                      title: language == 'ar' ? 'كيفية الوصول' : 'How to Access',
                      content: landmark.getAccessInfo(language),
                    ),
                    const SizedBox(height: 24),
                    // Opening Hours
                    _InfoSection(
                      icon: Icons.access_time,
                      title: language == 'ar' ? 'ساعات العمل' : 'Opening Hours',
                      content: landmark.openingHours,
                    ),
                    const SizedBox(height: 24),
                    // Location
                    _InfoSection(
                      icon: Icons.location_on,
                      title: language == 'ar' ? 'الموقع' : 'Location',
                      content: landmark.location,
                    ),
                    const SizedBox(height: 24),
                    // Ticket Prices
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.confirmation_number,
                                  color: Color(0xFF1E88E5),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  language == 'ar' ? 'أسعار التذاكر' : 'Ticket Prices',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _PriceRow(
                              label: language == 'ar' ? 'بالغ' : 'Adult',
                              price: landmark.ticketPrices.adult,
                            ),
                            _PriceRow(
                              label: language == 'ar' ? 'طالب' : 'Student',
                              price: landmark.ticketPrices.student,
                            ),
                            _PriceRow(
                              label: language == 'ar' ? 'محلي' : 'Local',
                              price: landmark.ticketPrices.local,
                            ),
                            _PriceRow(
                              label: language == 'ar' ? 'أجنبي' : 'Foreign',
                              price: landmark.ticketPrices.foreign,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
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

class _InfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _InfoSection({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF1E88E5), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double price;

  const _PriceRow({
    required this.label,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            price == 0 ? 'Free' : '${price.toStringAsFixed(0)} EGP',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: price == 0 ? Colors.green : const Color(0xFF1E88E5),
            ),
          ),
        ],
      ),
    );
  }
}

