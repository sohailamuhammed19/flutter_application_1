import 'package:flutter/material.dart';
import '../data/landmarks_data.dart';

class TripPlannerScreen extends StatefulWidget {
  final String language;

  const TripPlannerScreen({super.key, required this.language});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  final List<String> _selectedLandmarks = [];
  int _days = 1;

  @override
  Widget build(BuildContext context) {
    final isRTL = widget.language == 'ar';
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.language == 'ar' ? 'مخطط الرحلة بالذكاء الاصطناعي' : 'AI Trip Planner',
          ),
          backgroundColor: const Color(0xFF1E88E5),
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instructions
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_awesome, color: Color(0xFF1E88E5)),
                          const SizedBox(width: 8),
                          Text(
                            widget.language == 'ar'
                                ? 'خطط رحلتك المثالية'
                                : 'Plan Your Perfect Trip',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.language == 'ar'
                            ? 'اختر المواقع التي تريد زيارتها وعدد الأيام، وسنقوم بإنشاء مسار مخصص لك.'
                            : 'Select the sites you want to visit and number of days, and we\'ll create a customized itinerary for you.',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Days Selector
              Text(
                widget.language == 'ar' ? 'عدد الأيام:' : 'Number of Days:',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (_days > 1) {
                        setState(() {
                          _days--;
                        });
                      }
                    },
                  ),
                  Container(
                    width: 60,
                    alignment: Alignment.center,
                    child: Text(
                      '$_days',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _days++;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Landmarks Selection
              Text(
                widget.language == 'ar' ? 'اختر المواقع:' : 'Select Sites:',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...LandmarksData.landmarks.map((landmark) {
                final isSelected = _selectedLandmarks.contains(landmark.id);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: CheckboxListTile(
                    title: Text(landmark.getName(widget.language)),
                    subtitle: Text(landmark.getCategory(widget.language)),
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedLandmarks.add(landmark.id);
                        } else {
                          _selectedLandmarks.remove(landmark.id);
                        }
                      });
                    },
                  ),
                );
              }),
              const SizedBox(height: 24),

              // Generate Itinerary Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _selectedLandmarks.isEmpty
                      ? null
                      : () {
                          _showItinerary();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.language == 'ar'
                        ? 'إنشاء المسار'
                        : 'Generate Itinerary',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showItinerary() {
    final selected = LandmarksData.landmarks
        .where((l) => _selectedLandmarks.contains(l.id))
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          widget.language == 'ar' ? 'مسار رحلتك' : 'Your Itinerary',
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: selected.length,
            itemBuilder: (context, index) {
              final landmark = selected[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: landmark.imageColor,
                  child: Icon(landmark.icon, color: Colors.white),
                ),
                title: Text(landmark.getName(widget.language)),
                subtitle: Text(
                  '${widget.language == 'ar' ? 'اليوم' : 'Day'} ${index + 1}',
                ),
                trailing: Text(
                  '${landmark.ticketPrices.foreign} EGP',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E88E5),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(widget.language == 'ar' ? 'إغلاق' : 'Close'),
          ),
        ],
      ),
    );
  }
}

