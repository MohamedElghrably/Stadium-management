import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Stadium {
  String id;
  final String name;
  final String location;
  final String description;
  final double pricePerHour;
  final List<String> amenities;
  final List<String> images;
  final bool isAvailable;
  final int capacity;
  final String surfaceType; // grass, artificial, indoor, etc.
  final Map<String, dynamic> operatingHours;
  final double rating;
  final int reviewCount;
  final TimeOfDay openHour;
  final TimeOfDay closeHour;

  Stadium({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.pricePerHour,
    required this.amenities,
    required this.images,
    required this.isAvailable,
    required this.capacity,
    required this.surfaceType,
    required this.operatingHours,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.openHour,
    required this.closeHour,
  });

  factory Stadium.fromJson(Map<String, dynamic> json) {
    return Stadium(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      pricePerHour: (json['pricePerHour'] ?? 0.0).toDouble(),
      amenities: List<String>.from(json['amenities'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      isAvailable: json['isAvailable'] ?? true,
      capacity: json['capacity'] ?? 0,
      surfaceType: json['surfaceType'] ?? '',
      operatingHours: Map<String, dynamic>.from(json['operatingHours'] ?? {}),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      openHour: TimeOfDay(
        hour: json['openHour']['hour'],
        minute: json['openHour']['minute'],
      ),
      closeHour: TimeOfDay(
        hour: json['closeHour']['hour'],
        minute: json['closeHour']['minute'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'description': description,
      'pricePerHour': pricePerHour,
      'amenities': amenities,
      'images': images,
      'isAvailable': isAvailable,
      'capacity': capacity,
      'surfaceType': surfaceType,
      'operatingHours': operatingHours,
      'rating': rating,
      'reviewCount': reviewCount,
      'openHour': {'hour': openHour.hour, 'minute': openHour.minute},
      // Convert DateTime to Firestore Timestamp
      'closeHour': {'hour': closeHour.hour, 'minute': closeHour.minute},
    };
  }

  Stadium copyWith({
    String? id,
    String? name,
    String? location,
    String? description,
    double? pricePerHour,
    List<String>? amenities,
    List<String>? images,
    bool? isAvailable,
    int? capacity,
    String? surfaceType,
    Map<String, dynamic>? operatingHours,
    double? rating,
    int? reviewCount,
    TimeOfDay? openHour,
    TimeOfDay? closeHour,
  }) {
    return Stadium(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      description: description ?? this.description,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      amenities: amenities ?? this.amenities,
      images: images ?? this.images,
      isAvailable: isAvailable ?? this.isAvailable,
      capacity: capacity ?? this.capacity,
      surfaceType: surfaceType ?? this.surfaceType,
      operatingHours: operatingHours ?? this.operatingHours,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      openHour: openHour ?? this.openHour,
      closeHour: closeHour ?? this.closeHour,
    );
  }
}
