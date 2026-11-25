class SecurityValidators {
  SecurityValidators._();

  static final RegExp _emailPattern = RegExp(
    r"^[A-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?(?:\.[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?)+$",
    caseSensitive: false,
  );
  static final RegExp _uppercasePattern = RegExp(r'[A-Z]');
  static final RegExp _lowercasePattern = RegExp(r'[a-z]');
  static final RegExp _digitPattern = RegExp(r'\d');
  static final RegExp _symbolPattern = RegExp(r'[^A-Za-z0-9]');

  static String? validateEmail(String? value) {
    final email = value?.trim();
    if (email == null || email.isEmpty) return 'Ingresa tu correo electrónico';
    if (email.length > 254 ||
        email != value ||
        email.contains('..') ||
        !_emailPattern.hasMatch(email)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) return 'Ingresa tu contraseña';
    if (value.length > 128) return 'La contraseña es demasiado larga';
    return null;
  }

  static String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) return 'Ingresa una contraseña';
    if (value.length < 12 ||
        value.length > 128 ||
        value.contains(RegExp(r'\s')) ||
        !_uppercasePattern.hasMatch(value) ||
        !_lowercasePattern.hasMatch(value) ||
        !_digitPattern.hasMatch(value) ||
        !_symbolPattern.hasMatch(value)) {
      return 'Usa 12-128 caracteres con mayúscula, minúscula, número y símbolo';
    }
    return null;
  }

  static String? validatePasswordConfirmation(
    String? confirmation,
    String password,
  ) {
    if (confirmation == null || confirmation.isEmpty) {
      return 'Confirma tu contraseña';
    }
    if (confirmation != password) return 'Las contraseñas no coinciden';
    return null;
  }
}
