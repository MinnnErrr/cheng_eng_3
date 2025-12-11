import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;

part 'image_service.g.dart';

@riverpod
ImageService imageService(Ref ref) {
  return ImageService();
}

class ImageService {
  final supabase = Supabase.instance.client;

  Future<String> uploadImage({
    required File photoFile,
    required String tableName,
    required String id,
  }) async {
    final ext = p.extension(photoFile.path);
    String path = "$tableName/$id$ext";

    await supabase.storage
        .from('images')
        .upload(
          path,
          photoFile,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );
    return path;
  }

  String retrieveImageUrl(String path) {
    return supabase.storage.from('images').getPublicUrl(path);
  }

  Future<void> deleteImages(
    List<String> photoPaths,
  ) async {
    await supabase.storage.from('images').remove(photoPaths);
  }
}
