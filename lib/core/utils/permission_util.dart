
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  // 申请存储权限（适配 Android/iOS/桌面端）
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // Android 13+ 用 READ_MEDIA_FILES，低版本用 STORAGE
      Permission permission = Permission.storage;
      if (await Permission.storage.status.isDenied) {
        if (Platform.operatingSystemVersion.contains('13') ||
            Platform.operatingSystemVersion.contains('14') ||
            Platform.operatingSystemVersion.contains('15')) {
          permission = Permission.photos; // 适配 Android 13+ 媒体权限
        }
        var status = await permission.request();
        // 若用户拒绝且勾选"不再询问"，引导跳转到设置页
        if (status.isPermanentlyDenied) {
          await openAppSettings();
          return false;
        }
        return status.isGranted;
      }
      return true;
    } else if (Platform.isIOS) {
      var status = await Permission.photosAddOnly.request();
      if (status.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }
      return status.isGranted;
    }
    return true; // 桌面端（Windows/macOS/Linux）无需权限
  }
}