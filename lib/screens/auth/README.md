# Pantallas de Autenticación

Esta carpeta contiene las pantallas de autenticación con diseño responsive para móvil y web, integradas con Supabase Auth.

## Archivos

- **login_screen.dart** - Pantalla de inicio de sesión
- **register_screen.dart** - Pantalla de registro (Cliente y Repostero)
- **forgot_password_screen.dart** - Pantalla de recuperación de contraseña

## Características

### ✅ Login Screen
- Campo de correo electrónico con validación
- Campo de contraseña con opción de mostrar/ocultar
- Botón "¿Olvidaste tu contraseña?"
- Botón de inicio de sesión
- Enlace a registro
- Video de fondo (`festive-cake.mp4`)
- Diseño responsive
- Integrado con Supabase Auth

### ✅ Register Screen
- Tabs para seleccionar tipo de usuario (Cliente / Repostero)
- Campos para Cliente: Nombre, Email, Contraseña, Dirección
- Campos para Repostero: Nombre, Email, Contraseña, Nombre del negocio, Ubicación, Especialidad
- Validación de formularios
- Video de fondo (`festive-cake.mp4`)
- Diseño responsive
- Integrado con Supabase Auth

### ✅ Forgot Password Screen
- Flujo similar a Google
- Ingreso de correo electrónico
- Confirmación de envío de email
- Opción de reenviar correo
- Video de fondo (`festive-cake.mp4`)
- Diseño responsive
- Integrado con Supabase Auth (reset password)

## Video de Fondo

Coloca tu video en: `assets/videos/festive-cake.mp4`

Si no hay video, se usará un gradiente de fondo automáticamente.

## Colores del Tema

- **Primario (Dorado)**: `#D4AF37`
- **Fondo oscuro**: Gradiente de `#1a1a1a` a `#0d0d0d`
- **Texto blanco**: Para campos y etiquetas
- **Texto secundario**: `Colors.white70`

## Cómo Usar

### Navegar a Login
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const LoginScreen()),
);
```

### Navegar a Registro
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const RegisterScreen()),
);
```

### Navegar a Forgot Password
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
);
```

## Integración con Supabase

Las pantallas usan `SupabaseAuthProvider` que se integra con Supabase Auth:

### Provider
- **SupabaseAuthProvider** (`lib/providers/supabase_auth_provider.dart`)
  - Usa `AuthService` de Supabase
  - Maneja login, registro, logout, reset password
  - Compatible con la interfaz existente de `AuthProvider`

### Funcionalidades implementadas:
1. ✅ Login con Supabase Auth
2. ✅ Registro de Cliente
3. ✅ Registro de Repostero
4. ✅ Reset Password (envío de email de recuperación)
5. ✅ Logout
6. ✅ Actualización de perfil

### Nota importante:
El `AuthProvider` original (API REST) sigue disponible en `main.dart` para compatibilidad con el resto de la app. Las nuevas pantallas de auth usan `SupabaseAuthProvider` exclusivamente.
