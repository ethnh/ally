// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LabelDataImpl _$$LabelDataImplFromJson(Map<String, dynamic> json) =>
    _$LabelDataImpl(
      name: json['name'] as String,
      properties: (json['properties'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      color: json['color'] as String? ?? 'ff4e6ef2',
    );

Map<String, dynamic> _$$LabelDataImplToJson(_$LabelDataImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'properties': instance.properties,
      'color': instance.color,
    };
