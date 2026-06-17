// lib/models/guide.dart
class Guide {
  final int id;
  final String name;
  final String? phone;
  final String? whatsapp;
  final String? telegram;
  final double rating;
  final int reviewsCount;
  final double pricePerDay;
  final double? pricePerHour;
  final double? pricePerUmrah;
  final String city;
  final List<String> languages;
  final String? photoUrl;
  final String? bio;
  final int? experienceYears;
  final int? groupsCount;
  final List<String>? specializations;
  final List<String>? services;
  final bool? hasCar;
  final String? carModel;
  final int? carCapacity;
  final String? instagram;
  final bool isVerified;
  final List<PricingItem> pricing;

  Guide({
    required this.id,
    required this.name,
    this.phone,
    this.whatsapp,
    this.telegram,
    required this.rating,
    required this.reviewsCount,
    required this.pricePerDay,
    this.pricePerHour,
    this.pricePerUmrah,
    required this.city,
    required this.languages,
    this.photoUrl,
    this.bio,
    this.experienceYears,
    this.groupsCount,
    this.specializations,
    this.services,
    this.hasCar = false,
    this.carModel,
    this.carCapacity,
    this.instagram,
    required this.isVerified,
    required this.pricing,
  });

  factory Guide.fromJson(Map<String, dynamic> json) {
    return Guide(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      whatsapp: json['whatsapp'],
      telegram: json['telegram'],
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: json['reviews_count'],
      pricePerDay: (json['price_per_day'] as num).toDouble(),
      pricePerHour: json['price_per_hour'] != null
          ? (json['price_per_hour'] as num).toDouble()
          : null,
      pricePerUmrah: json['price_per_umrah'] != null
          ? (json['price_per_umrah'] as num).toDouble()
          : null,
      city: json['city'],
      languages: List<String>.from(json['languages']),
      photoUrl: json['photo_url'],
      bio: json['bio'],
      experienceYears: json['experience_years'],
      groupsCount: json['groups_count'],
      specializations: json['specializations'] != null
          ? List<String>.from(json['specializations'])
          : null,
      services: json['services'] != null
          ? List<String>.from(json['services'])
          : null,
      hasCar: json['has_car'] ?? false,
      carModel: json['car_model'],
      carCapacity: json['car_capacity'],
      instagram: json['instagram'],
      isVerified: json['is_verified'] ?? true,
      pricing:
          (json['pricing'] as List?)
              ?.map((p) => PricingItem.fromJson(p))
              .toList() ??
          [],
    );
  }

  String get cityName {
    switch (city) {
      case 'makkah':
        return 'Мекка';
      case 'madinah':
        return 'Медина';
      case 'jeddah':
        return 'Джидда';
      default:
        return city;
    }
  }
}

class PricingItem {
  final int id;
  final String serviceType;
  final String name;
  final double price;
  final String currency;
  final String? unit;
  final String? description;

  PricingItem({
    required this.id,
    required this.serviceType,
    required this.name,
    required this.price,
    required this.currency,
    this.unit,
    this.description,
  });

  factory PricingItem.fromJson(Map<String, dynamic> json) {
    return PricingItem(
      id: json['id'],
      serviceType: json['service_type'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] ?? 'SAR',
      unit: json['unit'],
      description: json['description'],
    );
  }
}
