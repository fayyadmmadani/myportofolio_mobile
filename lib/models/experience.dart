import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

/// Portfolio experience synchronized with the Django REST Framework API.
@JsonSerializable(fieldRename: FieldRename.snake)
class Experience {
  const Experience({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    this.categoryDisplay,
    this.thumbnail = '',
    this.startedAt,
    this.endedAt,
    this.isOngoing = false,
  });

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;

  final String title;
  final String description;
  final String category;

  @JsonKey(includeToJson: false)
  final String? categoryDisplay;

  @JsonKey(defaultValue: '')
  final String thumbnail;

  @JsonKey(includeToJson: false)
  final DateTime? startedAt;

  final DateTime? endedAt;

  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isOngoing;

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}
