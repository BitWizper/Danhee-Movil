import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/common/loading_indicator.dart';

/// Pantalla de registro
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  
  // Campos para repostero
  final _businessNameController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _locationController = TextEditingController();
  final _businessHoursController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _businessNameController.dispose();
    _specialtyController.dispose();
    _locationController.dispose();
    _businessHoursController.dispose();
    super.dispose();
  }
  
  Future<void> _handleRegisterClient() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.registerClient(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
      );
      
      if (success && mounted) {
        GoRouter.of(context).go(AppRoutes.home);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Error al registrarse'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
  
  Future<void> _handleRegisterBaker() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.registerBaker(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        businessName: _businessNameController.text.trim(),
        specialty: _specialtyController.text.trim(),
        location: _locationController.text.trim(),
        businessHours: _businessHoursController.text.trim(),
      );
      
      if (success && mounted) {
        GoRouter.of(context).go(AppRoutes.home);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Error al registrarse'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.isLoading) {
              return const LoadingIndicator(message: 'Registrando...');
            }
            
            return Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        '🎂',
                        style: TextStyle(fontSize: 48),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Crear Cuenta',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.cream,
                          fontFamily: 'Cormorant Garamond',
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Tabs
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.gold,
                  labelColor: AppColors.gold,
                  unselectedLabelColor: AppColors.muted,
                  tabs: const [
                    Tab(text: 'Cliente'),
                    Tab(text: 'Repostero'),
                  ],
                ),
                
                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildClientForm(),
                      _buildBakerForm(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildClientForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                hintText: 'Juan Pérez',
                prefixIcon: Icon(Icons.person_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                hintText: 'tu@email.com',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu correo electrónico';
                }
                if (!value.contains('@')) {
                  return 'Ingresa un correo válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                hintText: '+52 123 456 7890',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu teléfono';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                hintText: '••••••••',
                prefixIcon: Icon(Icons.lock_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu contraseña';
                }
                if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            PrimaryButton(
              text: 'Registrarse como Cliente',
              onPressed: _handleRegisterClient,
              isFullWidth: true,
            ),
            const SizedBox(height: 16),
            
            TextButton(
              onPressed: () => GoRouter.of(context).go(AppRoutes.login),
              child: const Text('¿Ya tienes cuenta? Inicia sesión'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBakerForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                hintText: 'Juan Pérez',
                prefixIcon: Icon(Icons.person_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                hintText: 'tu@email.com',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu correo electrónico';
                }
                if (!value.contains('@')) {
                  return 'Ingresa un correo válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                hintText: '+52 123 456 7890',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu teléfono';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _businessNameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del negocio',
                hintText: 'Pastelería Danhee',
                prefixIcon: Icon(Icons.store_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa el nombre de tu negocio';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _specialtyController,
              decoration: const InputDecoration(
                labelText: 'Especialidad',
                hintText: 'Pasteles de boda, infantiles, etc.',
                prefixIcon: Icon(Icons.star_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu especialidad';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Ubicación',
                hintText: 'Ciudad de México',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu ubicación';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _businessHoursController,
              decoration: const InputDecoration(
                labelText: 'Horario',
                hintText: 'Lun-Sab 9:00-19:00',
                prefixIcon: Icon(Icons.schedule_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu horario';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                hintText: '••••••••',
                prefixIcon: Icon(Icons.lock_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu contraseña';
                }
                if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            PrimaryButton(
              text: 'Registrarse como Repostero',
              onPressed: _handleRegisterBaker,
              isFullWidth: true,
            ),
            const SizedBox(height: 16),
            
            TextButton(
              onPressed: () => GoRouter.of(context).go(AppRoutes.login),
              child: const Text('¿Ya tienes cuenta? Inicia sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
