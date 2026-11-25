# Guía de Configuración de Backend con Supabase

Esta guía te explica cómo conectar tu proyecto Flutter con Supabase.

## 📋 Requisitos Previos

- Cuenta en [Supabase](https://supabase.com)
- Proyecto Flutter configurado
- Conexión a internet

---

## 🚀 Paso 1: Crear Proyecto en Supabase

1. Ve a [https://supabase.com](https://supabase.com) e inicia sesión
2. Haz clic en **"New Project"**
3. Completa los campos:
   - **Name**: `danhee-cake-app`
   - **Database Password**: Genera una contraseña segura y guárdala
   - **Region**: Elige la región más cercana a tus usuarios
4. Haz clic en **"Create new project"**
5. Espera unos minutos mientras se crea el proyecto (2-3 minutos)

---

## 🔑 Paso 2: Obtener Credenciales

1. En el dashboard de Supabase, ve a **Settings** → **API**
2. Copia los siguientes valores:
   - **Project URL**: (ej: `https://xxxxxxxxxxxxx.supabase.co`)
   - **anon public key**: (ej: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`)

---

## 🔧 Paso 3: Configurar el Proyecto Flutter

### 3.1. Instalar Dependencias

```bash
flutter pub get
```

### 3.2. Configurar Variables de Entorno

Crea un archivo `.env` en la raíz del proyecto:

```bash
# Copia el archivo de ejemplo
cp .env.example .env
```

Edita `.env` con tus credenciales reales:

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

### 3.3. Configurar Credenciales en Código

Edita `lib/backend/config/supabase_config.dart`:

```dart
class SupabaseConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project-id.supabase.co', // ← Reemplaza esto
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key-here', // ← Reemplaza esto
  );
  // ...
}
```

O puedes establecer las credenciales directamente (para desarrollo):

```dart
static const String supabaseUrl = 'https://your-project-id.supabase.co';
static const String supabaseAnonKey = 'your-anon-key-here';
```

---

## 🗄️ Paso 4: Ejecutar Migraciones SQL

### 4.1. Crear Tablas

1. En el dashboard de Supabase, ve a **SQL Editor**
2. Crea un nuevo query
3. Copia el contenido de `backend/supabase/migrations/001_create_tables.sql`
4. Pega el SQL en el editor
5. Haz clic en **"Run"** o presiona `Ctrl + Enter`

### 4.2. Configurar Row-Level Security (RLS)

1. Crea un nuevo query en el SQL Editor
2. Copia el contenido de `backend/supabase/migrations/002_rls_policies.sql`
3. Pega el SQL en el editor
4. Haz clic en **"Run"**

### 4.3. Configurar Storage

1. Crea un nuevo query en el SQL Editor
2. Copia el contenido de `backend/supabase/migrations/003_storage_config.sql`
3. Pega el SQL en el editor
4. Haz clic en **"Run"**

---

## ✅ Paso 5: Verificar la Conexión

### 5.1. Ejecutar la App

```bash
flutter run
```

### 5.2. Probar la Conexión

Crea un archivo de prueba `lib/test_supabase.dart`:

```dart
import 'package:flutter/material.dart';
import 'backend/config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();

  print('✅ Supabase conectado!');
  print('URL: ${SupabaseConfig.client.supabaseUrl}');

  // Probar conexión simple
  try {
    final response = await SupabaseConfig.client
        .from('categories')
        .select();
    print('✅ Categorías encontradas: ${response.length}');
  } catch (e) {
    print('❌ Error: $e');
  }
}
```

---

## 📁 Estructura del Proyecto

```
danhee-movil/
├── lib/
│   ├── backend/                  # 🎯 Código de backend Supabase
│   │   ├── config/
│   │   │   └── supabase_config.dart
│   │   ├── models/               # Modelos de datos
│   │   │   ├── supabase_user.dart
│   │   │   ├── baker_profile.dart
│   │   │   ├── cake.dart
│   │   │   ├── category.dart
│   │   │   ├── chat_message.dart
│   │   │   ├── chat_session.dart
│   │   │   ├── review.dart
│   │   │   ├── cake_design.dart
│   │   │   └── appointment.dart
│   │   ├── services/             # Servicios Supabase
│   │   │   ├── auth_service.dart
│   │   │   ├── cake_service.dart
│   │   │   ├── baker_service.dart
│   │   │   ├── chat_service.dart
│   │   │   ├── storage_service.dart
│   │   │   ├── category_service.dart
│   │   │   └── review_service.dart
│   │   ├── repositories/         # Repository pattern (opcional)
│   │   └── utils/
│   ├── screens/                  # UI existente
│   ├── widgets/
│   └── main.dart                # ✅ Ya inicializa Supabase
├── backend/                      # 🎯 Migraciones SQL
│   └── supabase/
│       └── migrations/
│           ├── 001_create_tables.sql
│           ├── 002_rls_policies.sql
│           └── 003_storage_config.sql
├── .env.example                 # Plantilla de variables de entorno
├── .env                         # Tus credenciales (crear este archivo)
└── pubspec.yaml                 # ✅ Ya incluye supabase_flutter
```

---

## 🔌 Ejemplos de Uso

### Autenticación

```dart
import 'backend/services/auth_service.dart';

final authService = AuthService();

// Registrar usuario
await authService.signUp(
  email: 'cliente@example.com',
  password: 'password123',
  name: 'Juan Pérez',
  role: 'client',
);

// Iniciar sesión
await authService.signIn(
  email: 'cliente@example.com',
  password: 'password123',
);

// Obtener perfil
final user = await authService.getUserProfile();
```

### Obtener Pasteles

```dart
import 'backend/services/cake_service.dart';

final cakeService = CakeService();

// Obtener todos los pasteles
final cakes = await cakeService.getCakes();

// Obtener pasteles destacados
final featuredCakes = await cakeService.getCakes(featuredOnly: true);

// Obtener pastel por ID
final cake = await cakeService.getCakeById(1);
```

### Chat en Tiempo Real

```dart
import 'backend/services/chat_service.dart';

final chatService = ChatService();

// Crear sesión de chat
final session = await chatService.createChatSession(userId);

// Enviar mensaje
await chatService.sendMessage(
  conversationId: session.conversationId,
  senderRole: 'client',
  content: 'Hola, me interesa este pastel',
);

// Suscribirse a mensajes en tiempo real
chatService.subscribeToMessages(session.conversationId).listen((messages) {
  print('Nuevos mensajes: ${messages.length}');
});
```

### Subir Imágenes

```dart
import 'dart:io';
import 'backend/services/storage_service.dart';

final storageService = StorageService();

// Subir imagen de pastel
final imageUrl = await storageService.uploadCakeImage(imageFile);

// Subir avatar
final avatarUrl = await storageService.uploadAvatar(imageFile, userId);
```

---

## 🌐 Verificar en el Dashboard de Supabase

Después de ejecutar la app, puedes verificar los datos en:

- **Table Editor**: Ver las tablas y datos creados
- **Authentication**: Ver usuarios registrados
- **Storage**: Ver imágenes subidas
- **Realtime**: Ver conexiones activas de real-time

---

## 🐛 Solución de Problemas

### Error: "Invalid API key"

- Verifica que `SUPABASE_URL` y `SUPABASE_ANON_KEY` sean correctos
- Asegúrate de que el proyecto de Supabase esté activo

### Error: "Relation does not exist"

- Ejecuta las migraciones SQL en el orden correcto
- Verifica que las tablas se crearon en el Table Editor

### Error: "Permission denied"

- Verifica que las RLS policies estén activas
- Asegúrate de que el usuario esté autenticado

### Error: "Bucket not found"

- Ejecuta la migración `003_storage_config.sql`
- Verifica en Storage que los buckets existan

---

## 📚 Recursos Adicionales

- [Documentación de Supabase](https://supabase.com/docs)
- [Documentación de supabase_flutter](https://supabase.com/docs/guides/getting-started/flutter)
- [Guía de RLS](https://supabase.com/docs/guides/auth/row-level-security)
- [Guía de Storage](https://supabase.com/docs/guides/storage)

---

## 🎯 Próximos Pasos

1. ✅ Configurar Supabase
2. ✅ Ejecutar migraciones
3. ✅ Probar conexión
4. 🔄 Migrar tu lógica existente de API REST a Supabase
5. 🔄 Implementar autenticación con Supabase Auth
6. 🔄 Implementar chat real-time
7. 🔄 Implementar subida de imágenes con Storage

---

¿Necesitas ayuda con algún paso específico? Revisa la documentación o crea un issue en el repositorio.
