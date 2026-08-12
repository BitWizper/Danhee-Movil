import 'package:json_annotation/json_annotation.dart';

part 'appointment.g.dart';

/// Modelo de cita
@JsonSerializable()
class Appointment {
  final String id;
  final String clientId;
  final String clientName;
  final String bakerId;
  final String bakerName;
  final DateTime date;
  final String timeSlot;
  final String status; // 'pendiente', 'confirmada', 'cancelada', 'completada'
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  Appointment({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.bakerId,
    required this.bakerName,
    required this.date,
    required this.timeSlot,
    required this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });
  
  factory Appointment.fromJson(Map<String, dynamic> json) => _$AppointmentFromJson(json);
  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
  
  /// Fecha formateada
  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  /// Verificar si está pendiente
  bool get isPending => status == 'pendiente';
  
  /// Verificar si está confirmada
  bool get isConfirmed => status == 'confirmada';
  
  /// Verificar si está cancelada
  bool get isCancelled => status == 'cancelada';
  
  /// Verificar si está completada
  bool get isCompleted => status == 'completada';
}
