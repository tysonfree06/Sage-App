import 'package:json_annotation/json_annotation.dart';

part 'redeem_model.g.dart';

@JsonSerializable()
class RedeemOfferDetails {
  const RedeemOfferDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsRequired,
    required this.isActive,
    required this.startDate,
    required this.endDate,
    this.campaignId,
    this.image,
    this.v,
    this.redeemedAt,
  });

  factory RedeemOfferDetails.fromJson(Map<String, dynamic> json) =>
      _$RedeemOfferDetailsFromJson(json);

  @JsonKey(name: '_id')
  final String id;

  final String title;

  final String description;

  @JsonKey(name: 'pointsRequired')
  final int pointsRequired;

  final String? campaignId;

  final bool isActive;

  @JsonKey(
    name: 'startDate',
    fromJson: _dateTimeFromJson,
    toJson: _dateTimeToJson,
  )
  final DateTime startDate;

  @JsonKey(
    name: 'endDate',
    fromJson: _dateTimeFromJson,
    toJson: _dateTimeToJson,
  )
  final DateTime endDate;

  @JsonKey(name: 'image')
  final String? image; // nullable now

  @JsonKey(name: '__v')
  final int? v; // nullable now

  @JsonKey(
    name: 'redeemedAt',
    fromJson: _nullableDateTimeFromJson,
    toJson: _nullableDateTimeToJson,
  )
  final DateTime? redeemedAt; // nullable already

  RedeemOfferDetails copyWith({
    String? id,
    String? title,
    String? description,
    int? pointsRequired,
    String? campaignId,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    String? image,
    int? v,
    DateTime? redeemedAt,
  }) {
    return RedeemOfferDetails(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      pointsRequired: pointsRequired ?? this.pointsRequired,
      campaignId: campaignId ?? this.campaignId,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      image: image ?? this.image,
      v: v ?? this.v,
      redeemedAt: redeemedAt ?? this.redeemedAt,
    );
  }

  Map<String, dynamic> toJson() => _$RedeemOfferDetailsToJson(this);

  static DateTime _dateTimeFromJson(String date) => DateTime.parse(date);

  static String _dateTimeToJson(DateTime date) => date.toIso8601String();

  static DateTime? _nullableDateTimeFromJson(String? date) =>
      date == null ? null : DateTime.parse(date);

  static String? _nullableDateTimeToJson(DateTime? date) =>
      date?.toIso8601String();
}
