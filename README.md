# Danhee Cake

Aplicación Flutter para explorar pasteles, gestionar un carrito y solicitar citas con reposteros. Por ahora los flujos principales funcionan con repositorios de demostración locales; no necesitan un backend.

## Requisitos

- Flutter compatible con Dart 3.8.1 o superior.
- Dependencias instaladas con `flutter pub get`.

## Ejecutar

```shell
flutter pub get
flutter run
```

La app muestra datos locales de pasteles, carrito y citas. Las cuentas disponibles son:

| Rol | Correo | Contraseña |
|---|---|---|
| Cliente | `cliente@danhee.test` | `cliente123` |
| Repostero | `repostero@danhee.test` | `repostero123` |

También se pueden crear cuentas desde la pantalla de registro. La sesión se conserva en almacenamiento seguro.

## Organización

- `lib/screens/`: pantallas y flujos de interfaz.
- `lib/providers/`: estado de autenticación y carrito.
- `lib/repositories/`: contratos de acceso a datos y sus implementaciones mock.
- `lib/api/api_service.dart`: cliente HTTP para futuras implementaciones remotas.
- `lib/config/api_config.dart`: URL base y endpoints del backend.

Los contratos `CakeRepository`, `CartRepository`, `AppointmentRepository` y `AuthRepository` separan las pantallas de la fuente de datos. Los providers/pantallas usan los mocks por defecto. Cuando esté disponible el backend, se puede implementar cada contrato usando `ApiService` e inyectar esas implementaciones sin cambiar las pantallas.

## Validación

```shell
flutter analyze --no-pub
flutter test --no-pub
```

## Firebase, permisos y seguridad

La app inicia con autenticación demo local. `FirebaseAuthRepository` es una
implementación opcional: configura Firebase con FlutterFire fuera del código
fuente y pásala a `AuthProvider(repository: ...)` después de inicializar Firebase.
No se incluyen archivos de configuración Firebase ni credenciales. Para autorizar
reposteros, inyecta un `bakerRoleProvisioner` respaldado por un servicio confiable;
la app solo acepta el rol desde claims de Firebase y no debe asignarlo localmente.

El registro valida correo, contraseña (12-128 caracteres, mayúscula, minúscula,
número y símbolo) y confirmación. Los tokens se almacenan mediante almacenamiento
seguro; cerrar sesión elimina la sesión, los datos locales del usuario, el carrito
demo y la caché de imágenes. Cámara e imágenes requieren permiso en tiempo de
ejecución; Android e iOS incluyen sus declaraciones y textos de uso.

La única URL configurada por defecto es `http://localhost:4000/api`, destinada al
desarrollo y centralizada en `lib/config/api_config.dart`. Se puede sustituir al
compilar con `--dart-define=API_BASE_URL=https://tu-api`; usa HTTPS en producción.
No guardes secretos ni claves privadas en la app móvil.
