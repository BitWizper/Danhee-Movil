import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../repositories/appointment_repository.dart';

/// Pantalla de agendar cita
class AppointmentScreen extends StatefulWidget {
  final String? bakerId;

  const AppointmentScreen({this.bakerId, super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  String _timeSlot = '10:00';
  bool _isSaving = false;

  static const _timeSlots = ['10:00', '11:30', '13:00', '15:00', '16:30'];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final user = context.read<AuthProvider>().user!;
    setState(() => _isSaving = true);
    try {
      await MockAppointmentRepositories.instance.createAppointment(
        clientId: user.id,
        clientName: user.name ?? user.email,
        bakerId: widget.bakerId ?? 'baker-1',
        bakerName: widget.bakerId == 'baker-2'
            ? 'Horno de Ana'
            : 'Dulce Atelier',
        date: _date,
        timeSlot: _timeSlot,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cita solicitada correctamente')),
      );
      GoRouter.of(context).go(AppRoutes.myAppointments);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo agendar la cita: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('Agendar Cita')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Solicita una asesoría con ${widget.bakerId == 'baker-2' ? 'Horno de Ana' : 'Dulce Atelier'}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Fecha'),
              subtitle: Text('${_date.day}/${_date.month}/${_date.year}'),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                final selected = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (selected != null) setState(() => _date = selected);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _timeSlot,
              decoration: const InputDecoration(labelText: 'Horario'),
              items: _timeSlots
                  .map(
                    (time) => DropdownMenuItem(value: time, child: Text(time)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _timeSlot = value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Cuéntanos qué necesitas (opcional)',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSaving ? null : _submit,
              child: Text(_isSaving ? 'Enviando...' : 'Solicitar cita'),
            ),
          ],
        ),
      ),
    );
  }
}
