import 'package:flutter/material.dart';

class Landmark {
  final String id;
  final String nameEn;
  final String nameAr;
  final String categoryEn;
  final String categoryAr;
  final String descriptionEn;
  final String descriptionAr;
  final String accessInfoEn;
  final String accessInfoAr;
  final String openingHours;
  final TicketPrices ticketPrices;
  final Color imageColor;
  final IconData icon;
  final String? imageUrl;
  final String location;

  const Landmark({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.categoryEn,
    required this.categoryAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.accessInfoEn,
    required this.accessInfoAr,
    required this.openingHours,
    required this.ticketPrices,
    required this.imageColor,
    required this.icon,
    this.imageUrl,
    required this.location,
  });

  String getName(String language) => language == 'ar' ? nameAr : nameEn;
  String getCategory(String language) => language == 'ar' ? categoryAr : categoryEn;
  String getDescription(String language) => language == 'ar' ? descriptionAr : descriptionEn;
  String getAccessInfo(String language) => language == 'ar' ? accessInfoAr : accessInfoEn;
}

class TicketPrices {
  final double adult;
  final double student;
  final double local;
  final double foreign;

  const TicketPrices({
    required this.adult,
    required this.student,
    required this.local,
    required this.foreign,
  });
}

