import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  UserModel({
    this.location,
    required this.id,
    required this.name,
    required this.email,
    this.verified,
    this.interests,
    this.giftPreferences,
    this.createdAt,
    this.updatedAt,
    this.anniversaryDate,
    this.apologyLanguage,
    this.budgetLevel,
    this.communicationStyle,
    this.dateOfBirth,
    this.partnerCode,
    this.image,
    this.loveLanguage,
    this.relationshipStatus,
    this.partnerId,
    this.subscriptionActive,
    this.mineinvitationCode,
    this.mineParterCode,
    this.referrals,
    this.points,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  final Location? location;

  @JsonKey(name: '_id')
  String id;
  String name;
  final String email;
  final bool? verified;
  final List<String>? interests;
  final List<String>? giftPreferences;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? anniversaryDate;
  final String? apologyLanguage;
  final String? budgetLevel;
  final String? communicationStyle;
  final DateTime? dateOfBirth;
  final String? partnerCode;
  final String? image;
  final String? loveLanguage;
  final String? relationshipStatus;
  final String? partnerId;

  // 🔽 New fields
  @JsonKey(name: 'subscription')
  final Subscription? subscriptionActive;
  final String? mineinvitationCode;
  final int? mineParterCode;
  final List<dynamic>? referrals;
  final int? points;

  UserModel copyWith({
    Location? location,
    String? id,
    String? name,
    String? email,
    bool? verified,
    List<String>? interests,
    List<String>? giftPreferences,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? anniversaryDate,
    String? apologyLanguage,
    String? budgetLevel,
    String? communicationStyle,
    DateTime? dateOfBirth,
    String? partnerCode,
    String? image,
    String? loveLanguage,
    String? relationshipStatus,
    String? partnerId,
    Subscription? subscriptionActive,
    String? mineinvitationCode,
    int? mineParterCode,
    List<dynamic>? referrals,
    int? points,
  }) {
    return UserModel(
      location: location ?? this.location,
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      verified: verified ?? this.verified,
      interests: interests ?? this.interests,
      giftPreferences: giftPreferences ?? this.giftPreferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      anniversaryDate: anniversaryDate ?? this.anniversaryDate,
      apologyLanguage: apologyLanguage ?? this.apologyLanguage,
      budgetLevel: budgetLevel ?? this.budgetLevel,
      communicationStyle: communicationStyle ?? this.communicationStyle,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      partnerCode: partnerCode ?? this.partnerCode,
      image: image ?? this.image,
      loveLanguage: loveLanguage ?? this.loveLanguage,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      partnerId: partnerId ?? this.partnerId,
      subscriptionActive: subscriptionActive ?? this.subscriptionActive,
      mineinvitationCode: mineinvitationCode ?? this.mineinvitationCode,
      mineParterCode: mineParterCode ?? this.mineParterCode,
      referrals: referrals ?? this.referrals,
      points: points ?? this.points,
    );
  }
}

@JsonSerializable()
class Location {
  Location({
    this.city,
    this.state,
    this.country,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  final String? city;
  final String? state;
  final String? country;

  Location copyWith({
    String? city,
    String? state,
    String? country,
  }) {
    return Location(
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
    );
  }
}

@JsonSerializable()
class Subscription {
  Subscription({this.active});

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionToJson(this);

  final bool? active;
}
