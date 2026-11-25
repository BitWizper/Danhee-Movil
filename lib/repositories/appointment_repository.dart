import '../models/appointment.dart';

abstract interface class AppointmentRepository {
  Future<List<Appointment>> getAppointments({
    required String userId,
    required bool isBaker,
  });
  Future<Appointment> createAppointment({
    required String clientId,
    required String clientName,
    required String bakerId,
    required String bakerName,
    required DateTime date,
    required String timeSlot,
    String? notes,
  });
  Future<void> cancelAppointment(String appointmentId);
}

class MockAppointmentRepository implements AppointmentRepository {
  final List<Appointment> _appointments = [];
  int _nextId = 1;

  @override
  Future<List<Appointment>> getAppointments({
    required String userId,
    required bool isBaker,
  }) async {
    return _appointments.where((appointment) {
      return isBaker
          ? appointment.bakerId == userId
          : appointment.clientId == userId;
    }).toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  Future<Appointment> createAppointment({
    required String clientId,
    required String clientName,
    required String bakerId,
    required String bakerName,
    required DateTime date,
    required String timeSlot,
    String? notes,
  }) async {
    final now = DateTime.now();
    final appointment = Appointment(
      id: 'appointment-${_nextId++}',
      clientId: clientId,
      clientName: clientName,
      bakerId: bakerId,
      bakerName: bakerName,
      date: date,
      timeSlot: timeSlot,
      status: 'pendiente',
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );
    _appointments.add(appointment);
    return appointment;
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    final index = _appointments.indexWhere((item) => item.id == appointmentId);
    if (index != -1) {
      final appointment = _appointments[index];
      _appointments[index] = Appointment(
        id: appointment.id,
        clientId: appointment.clientId,
        clientName: appointment.clientName,
        bakerId: appointment.bakerId,
        bakerName: appointment.bakerName,
        date: appointment.date,
        timeSlot: appointment.timeSlot,
        status: 'cancelada',
        notes: appointment.notes,
        createdAt: appointment.createdAt,
        updatedAt: DateTime.now(),
      );
    }
  }
}

class MockAppointmentRepositories {
  MockAppointmentRepositories._();

  static final AppointmentRepository instance = MockAppointmentRepository();
}
