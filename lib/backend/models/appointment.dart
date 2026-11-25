/// Modelo de cita
/// Mapea con la tabla 'appointments' en PostgreSQL
class Appointment {
  final int id;
  final String clientId;
  final int bakerId;
  final DateTime date;
  final String timeSlot;
  final String? notes;
  final String status; // 'pending', 'confirmed', 'cancelled', 'completed'
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.clientId,
    required this.bakerId,
    required this.date,
    required this.timeSlot,
    this.notes,
    this.status = 'pending',
    required this.createdAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as int,
      clientId: json['client_id'] as String,
      bakerId: json['baker_id'] as int,
      date: DateTime.parse(json['date'] as String),
      timeSlot: json['time_slot'] as String,
      notes: json['notes'] as String?,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'baker_id': bakerId,
      'date': date.toIso8601String().split('T')[0], // Solo fecha
      'time_slot': timeSlot,
      'notes': notes,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isCancelled => status == 'cancelled';
  bool get isCompleted => status == 'completed';
}
