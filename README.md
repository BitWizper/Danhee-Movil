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

## Versionado

`pubspec.yaml` usa el formato `MAJOR.MINOR.PATCH+BUILD`; ahora está en `1.0.0+1`.
Incrementa MAJOR para cambios incompatibles, MINOR para funcionalidades compatibles
y PATCH para correcciones compatibles. Aumenta BUILD en cada binario distribuido;
Android lo utiliza como `versionCode`, que debe ser siempre mayor que el anterior.
Usa tags Git como `v1.0.0` para identificar las liberaciones.

## Firma y compilación Android

Desde la raíz del repositorio, genera una llave de publicación con `keytool`:

```shell
keytool -genkeypair -v -keystore android/app/upload-keystore.jks -alias upload -keyalg RSA -keysize 2048 -validity 10000
```

`keytool` solicitará las contraseñas y los datos del certificado. Después crea
`android/key.properties` localmente con este contenido y reemplaza los valores de
ejemplo por los datos que hayas elegido:

```properties
storePassword=REEMPLAZAR
keyPassword=REEMPLAZAR
keyAlias=upload
storeFile=app/upload-keystore.jks
```

No subas `android/key.properties`, `*.jks` ni `*.keystore` a GitHub. Conserva una
copia de respaldo segura de la llave y sus contraseñas: son necesarias para firmar
futuras actualizaciones de la misma app. Los builds debug no necesitan estos archivos;
los builds release se detienen con un error claro si faltan.

Con `android/key.properties` y la llave en su ruta, ejecuta uno de estos comandos:

```shell
flutter build appbundle --release
flutter build apk --release
```

El App Bundle queda en `build/app/outputs/bundle/release/app-release.aab` y el APK
en `build/app/outputs/flutter-apk/app-release.apk`. El AAB está destinado a Google
Play; el APK se puede instalar directamente para pruebas o distribución controlada.

## Distribución y conexión del backend

Para distribuir una versión, sube el código y un tag como `v1.0.0` a
[BitWizper/Danhee-Movil](https://github.com/BitWizper/Danhee-Movil), crea una GitHub
Release desde ese tag y adjunta el AAB o APK firmado. Como alternativa para pruebas
internas, comparte el APK mediante una carpeta compartida con acceso restringido.
Distribuye únicamente los artefactos compilados; nunca la llave ni `key.properties`.

La conexión real del backend queda desacoplada: su URL se configura mediante
`API_BASE_URL` en `lib/config/api_config.dart` (por ejemplo,
`--dart-define=API_BASE_URL=https://tu-api`). Los contratos e implementaciones de
datos están en `lib/repositories/`; ahí se conectará el backend real mediante
`ApiService`, sin cambiar ahora la lógica mock ni la base de datos.
