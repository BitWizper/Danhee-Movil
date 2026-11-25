import 'package:permission_handler/permission_handler.dart' as handler;

enum PermissionAccess {
  granted,
  limited,
  denied,
  permanentlyDenied,
  restricted,
}

class PermissionService {
  Future<PermissionAccess> requestCameraAccess() async {
    return _request(handler.Permission.camera);
  }

  Future<PermissionAccess> requestGalleryAccess() async {
    return _request(handler.Permission.photos);
  }

  Future<bool> openSettings() => handler.openAppSettings();

  Future<PermissionAccess> _request(handler.Permission permission) async {
    final status = await permission.request();
    if (status.isGranted) return PermissionAccess.granted;
    if (status.isLimited) return PermissionAccess.limited;
    if (status.isPermanentlyDenied) {
      return PermissionAccess.permanentlyDenied;
    }
    if (status.isRestricted) return PermissionAccess.restricted;
    return PermissionAccess.denied;
  }
}
