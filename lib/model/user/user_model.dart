import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.updatedAtAlt,
    this.location,
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
    this.image,
    this.loveLanguage,
    this.relationshipStatus,
    this.partnerCode,
    this.isPremium,
    this.subscriptionActive,
    this.mineinvitationCode,
    this.mineParterCode,
    this.referrals,
    this.totalPoints,
    this.totalReferralPoints, // ✅ Added
    this.stripeCustomerId,
    this.v,
    this.ideas,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  final Location? location;

  @JsonKey(name: '_id')
  final String id;

  final String name;
  final String email;
  final bool? verified;
  final List<String>? interests;
  final List<String>? giftPreferences;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  // ✅ Handle both updatedAt and updated_at
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAtAlt;

  final DateTime? anniversaryDate;
  final String? apologyLanguage;
  final String? budgetLevel;
  final String? communicationStyle;
  final DateTime? dateOfBirth;
  final String? image;

  @JsonKey(name: 'total_points')
  final int? totalPoints;

  @JsonKey(name: 'total_referral_points')
  final int? totalReferralPoints; // ✅ New field (nullable)

  final String? loveLanguage;
  final String? relationshipStatus;
  final int? partnerCode;
  final bool? isPremium;

  @JsonKey(name: 'subscription')
  final Subscription? subscriptionActive;

  final String? mineinvitationCode;
  final int? mineParterCode;
  final List<dynamic>? referrals;

  final String? stripeCustomerId;

  @JsonKey(name: '__v')
  final int? v;

  final List<Idea>? ideas;

  /// Custom getter: prefer updatedAt over updatedAtAlt
  DateTime? get effectiveUpdatedAt => updatedAt ?? updatedAtAlt;
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
}

@JsonSerializable()
class Subscription {
  Subscription({
    this.status,
    this.plan,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionToJson(this);

  final String? status;
  final String? plan;
}

@JsonSerializable()
class Idea {
  Idea({
    required this.type,
    required this.title,
    required this.description,
    required this.cost,
    required this.location,
  });

  factory Idea.fromJson(Map<String, dynamic> json) => _$IdeaFromJson(json);

  Map<String, dynamic> toJson() => _$IdeaToJson(this);

  final String type;
  final String title;
  final String description;
  final int cost;
  final String location;
}
