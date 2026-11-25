import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import '../../providers/supabase_auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _specialtyController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String _userType = 'client';
  VideoPlayerController? _videoController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Validaciones de contraseña
  bool _hasMinLength = false;
  bool _hasLowerCase = false;
  bool _hasUpperCase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // Listener para validación de contraseña en tiempo real
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    final password = _passwordController.text;
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasLowerCase = password.contains(RegExp(r'[a-z]'));
      _hasUpperCase = password.contains(RegExp(r'[A-Z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset(
        'assets/videos/festive-cake.mp4',
      );
      await _videoController!.initialize();
      await _videoController!.setLooping(true);
      await _videoController!.play();
      if (mounted) setState(() {});
    } catch (e) {
      print('Video no encontrado: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _businessNameController.dispose();
    _locationController.dispose();
    _specialtyController.dispose();
    _videoController?.dispose();
    _animationController.dispose();
    _passwordController.removeListener(_onPasswordChanged);
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<SupabaseAuthProvider>(context, listen: false);

      if (_userType == 'client') {
        final success = await authProvider.register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          address: _addressController.text.trim(),
          role: 'client',
        );

        if (!success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.errorMessage ?? 'Error al registrar'),
              backgroundColor: Colors.red.shade400,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        final success = await authProvider.register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          businessName: _businessNameController.text.trim(),
          location: _locationController.text.trim(),
          specialty: _specialtyController.text.trim(),
          role: 'baker',
        );

        if (!success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.errorMessage ?? 'Error al registrar'),
              backgroundColor: Colors.red.shade400,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _videoController != null && _videoController!.value.isInitialized
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController!.value.size.width,
                      height: _videoController!.value.size.height,
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
                )
              : Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1a1a1a), Color(0xFF0d0d0d), Color(0xFF1a1a1a)],
                    ),
                  ),
                ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Crear Cuenta',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w300,
                              color: Color(0xFFD4AF37),
                              letterSpacing: 4,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Únete a nuestra comunidad',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.6),
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Tabs elegantes
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() => _userType = 'client');
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      padding: const EdgeInsets.symmetric(vertical: 18),
                                      decoration: BoxDecoration(
                                        gradient: _userType == 'client'
                                            ? const LinearGradient(
                                                colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
                                              )
                                            : null,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: _userType == 'client'
                                            ? [
                                                BoxShadow(
                                                  color: const Color(0xFFD4AF37).withOpacity(0.3),
                                                  blurRadius: 15,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Text(
                                        'CLIENTE',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: _userType == 'client'
                                              ? Colors.black
                                              : Colors.white.withOpacity(0.6),
                                          fontWeight: _userType == 'client'
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          fontSize: 13,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() => _userType = 'baker');
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      padding: const EdgeInsets.symmetric(vertical: 18),
                                      decoration: BoxDecoration(
                                        gradient: _userType == 'baker'
                                            ? const LinearGradient(
                                                colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
                                              )
                                            : null,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: _userType == 'baker'
                                            ? [
                                                BoxShadow(
                                                  color: const Color(0xFFD4AF37).withOpacity(0.3),
                                                  blurRadius: 15,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Text(
                                        'REPOSTERO',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: _userType == 'baker'
                                              ? Colors.black
                                              : Colors.white.withOpacity(0.6),
                                          fontWeight: _userType == 'baker'
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          fontSize: 13,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Campos con animación
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _userType == 'client'
                                ? _buildClientFields()
                                : _buildBakerFields(),
                          ),

                          const SizedBox(height: 32),

                          _buildElegantButton(
                            onPressed: _isLoading ? null : _register,
                            text: 'CREAR CUENTA',
                            isLoading: _isLoading,
                          ),
                          const SizedBox(height: 32),

                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'o',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '¿Ya tienes cuenta? ',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Inicia sesión',
                                  style: TextStyle(
                                    color: Color(0xFFD4AF37),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientFields() {
    return Column(
      key: const ValueKey('client'),
      children: [
        _buildElegantTextField(
          controller: _nameController,
          label: 'Nombre completo',
          icon: Icons.person_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu nombre completo';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildElegantTextField(
          controller: _emailController,
          label: 'Correo Electrónico',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu correo electrónico';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Ingresa un correo válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildElegantTextField(
          controller: _passwordController,
          label: 'Contraseña',
          icon: Icons.lock_outlined,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: const Color(0xFFD4AF37),
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu contraseña';
            }
            if (!_hasMinLength || !_hasLowerCase || !_hasUpperCase || !_hasNumber || !_hasSpecialChar) {
              return 'La contraseña debe cumplir todos los requisitos';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        _buildPasswordRequirements(),
        const SizedBox(height: 16),
        _buildElegantTextField(
          controller: _addressController,
          label: 'Dirección',
          icon: Icons.location_on_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu dirección';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBakerFields() {
    return Column(
      key: const ValueKey('baker'),
      children: [
        _buildElegantTextField(
          controller: _nameController,
          label: 'TU NOMBRE',
          icon: Icons.person_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu nombre';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildElegantTextField(
          controller: _emailController,
          label: 'CORREO ELECTRÓNICO',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu correo electrónico';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Ingresa un correo válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildElegantTextField(
          controller: _passwordController,
          label: 'CONTRASEÑA',
          icon: Icons.lock_outlined,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: const Color(0xFFD4AF37),
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu contraseña';
            }
            if (!_hasMinLength || !_hasLowerCase || !_hasUpperCase || !_hasNumber || !_hasSpecialChar) {
              return 'La contraseña debe cumplir todos los requisitos';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        _buildPasswordRequirements(),
        const SizedBox(height: 16),
        _buildElegantTextField(
          controller: _businessNameController,
          label: 'NOMBRE DEL NEGOCIO',
          icon: Icons.store_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa el nombre de tu negocio';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildElegantTextField(
          controller: _locationController,
          label: 'UBICACIÓN',
          icon: Icons.location_on_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu ubicación';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildElegantTextField(
          controller: _specialtyController,
          label: 'ESPECIALIDAD',
          icon: Icons.cake_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu especialidad';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildElegantTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          letterSpacing: 0.5,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          filled: false,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFFD4AF37).withOpacity(0.8),
            size: 22,
          ),
          suffixIcon: suffixIcon,
          floatingLabelStyle: const TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 12,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildElegantButton({
    required VoidCallback? onPressed,
    required String text,
    required bool isLoading,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Requisitos de contraseña:',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          _buildRequirementItem(
            'Mínimo 8 caracteres',
            _hasMinLength,
          ),
          const SizedBox(height: 8),
          _buildRequirementItem(
            'Una letra minúscula (a-z)',
            _hasLowerCase,
          ),
          const SizedBox(height: 8),
          _buildRequirementItem(
            'Una letra mayúscula (A-Z)',
            _hasUpperCase,
          ),
          const SizedBox(height: 8),
          _buildRequirementItem(
            'Un número (0-9)',
            _hasNumber,
          ),
          const SizedBox(height: 8),
          _buildRequirementItem(
            'Un carácter especial (!@#\$%^&*)',
            _hasSpecialChar,
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.circle_outlined,
          size: 16,
          color: isMet
              ? const Color(0xFF4CAF50)
              : Colors.white.withOpacity(0.4),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isMet
                ? const Color(0xFF4CAF50)
                : Colors.white.withOpacity(0.5),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
