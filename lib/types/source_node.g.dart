// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SourceNodeImpl _$$SourceNodeImplFromJson(Map<String, dynamic> json) =>
    _$SourceNodeImpl(
      name: json['name'] as String,
      properties: json['properties'] as Map<String, dynamic>?,
      id: json['id'] as int,
      bio: json['bio'] as String,
      label: json['label'] as String,
      radius: (json['radius'] as num?)?.toDouble() ?? 20,
    );

Map<String, dynamic> _$$SourceNodeImplToJson(_$SourceNodeImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'properties': instance.properties,
      'id': instance.id,
      'bio': instance.bio,
      'label': instance.label,
      'radius': instance.radius,
    };
