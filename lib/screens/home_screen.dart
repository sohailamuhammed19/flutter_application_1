import 'package:flutter/material.dart';
import '../models/landmark.dart';
import '../data/landmarks_data.dart';
import '../services/auth_service.dart';
import '../services/language_service.dart';
import 'login_screen.dart';
import 'detail_screen.dart';
import 'trip_planner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _language = 'en';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final lang = await LanguageService.getLanguage();
    setState(() {
      _language = lang;
    });
  }

  Future<void> _toggleLanguage() async {
    final newLang = _language == 'en' ? 'ar' : 'en';
    await LanguageService.setLanguage(newLang);
    setState(() {
      _language = newLang;
    });
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  List<Landmark> get _filteredLandmarks {
    if (_selectedCategory == 'All') {
      return LandmarksData.landmarks;
    }
    return LandmarksData.landmarks.where((landmark) {
      return landmark.getCategory(_language) == _selectedCategory;
    }).toList();
  }

  List<String> get _categories {
    final categories = LandmarksData.landmarks
        .map((l) => l.getCategory(_language))
        .toSet()
        .toList();
    categories.insert(0, _language == 'ar' ? 'الكل' : 'All');
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = _language == 'ar';
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 80,
              floating: true,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E88E5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.landscape,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              title: Text(
                _language == 'ar' ? 'مستكشف مصر' : 'Egypt Explorer',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.auto_awesome, color: Color(0xFF1E88E5)),
                  tooltip: _language == 'ar' ? 'مخطط الرحلة' : 'AI Trip Planner',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TripPlannerScreen(language: _language),
                      ),
                    );
                  },
                ),
                TextButton(
                  onPressed: _toggleLanguage,
                  child: Text(
                    _language == 'ar' ? 'English' : 'العربية',
                    style: const TextStyle(color: Color(0xFF1E88E5)),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  tooltip: _language == 'ar' ? 'تسجيل الخروج' : 'Logout',
                  onPressed: _logout,
                ),
                const SizedBox(width: 8),
              ],
            ),

            // Main Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Section
                    Text(
                      _language == 'ar'
                          ? 'اكتشف عجائب مصر'
                          : 'Discover the Wonders of Egypt',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _language == 'ar'
                          ? 'استكشف المعابد القديمة والأهرامات المهيبة والتراث الإسلامي الغني.'
                          : 'Explore ancient temples, majestic pyramids, and rich Islamic heritage.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Category Filter
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = category == _selectedCategory;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              },
                              selectedColor: const Color(0xFF1E88E5),
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Landmarks Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _filteredLandmarks.length,
                      itemBuilder: (context, index) {
                        return _LandmarkCard(
                          landmark: _filteredLandmarks[index],
                          language: _language,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(
                                  landmark: _filteredLandmarks[index],
                                  language: _language,
                                ),
                              ),
                            );
                          },
                        );
                      },
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

class _LandmarkCard extends StatelessWidget {
  final Landmark landmark;
  final String language;
  final VoidCallback onTap;

  const _LandmarkCard({
    required this.landmark,
    required this.language,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image or Placeholder
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: landmark.imageUrl == null
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            landmark.imageColor,
                            landmark.imageColor.withOpacity(0.7),
                          ],
                        )
                      : null,
                  color: landmark.imageUrl != null ? null : landmark.imageColor,
                ),
                child: Stack(
                  children: [
                    if (landmark.imageUrl != null)
                      landmark.imageUrl!.startsWith('assets/')
                          ? Image.asset(
                              landmark.imageUrl!,
                              width: double.infinity,
                              height: double.infinity,
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
                                      size: 60,
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Image.network(
                              landmark.imageUrl!,
                              width: double.infinity,
                              height: double.infinity,
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
                                      size: 60,
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
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
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            )
                    else
                      Center(
                        child: Icon(
                          landmark.icon,
                          size: 60,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    // Category Badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          landmark.getCategory(language),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    // Price Badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E88E5).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${landmark.ticketPrices.foreign} EGP',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      landmark.getName(language),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        landmark.getDescription(language),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          landmark.openingHours,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
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

