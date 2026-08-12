// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
  id: json['id'] as String,
  clientId: json['clientId'] as String,
  clientName: json['clientName'] as String,
  bakerId: json['bakerId'] as String,
  bakerName: json['bakerName'] as String,
  date: DateTime.parse(json['date'] as String),
  timeSlot: json['timeSlot'] as String,
  status: json['status'] as String,
  notes: json['notes'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'clientName': instance.clientName,
      'bakerId': instance.bakerId,
      'bakerName': instance.bakerName,
      'date': instance.date.toIso8601String(),
      'timeSlot': instance.timeSlot,
      'status': instance.status,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
