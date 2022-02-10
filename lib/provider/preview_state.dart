import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isave/models.dart';

class PreviewState with ChangeNotifier {
  PreviewData data = PreviewData(
    profile: ProfileData(),
    post: [],
  );
  bool isEditing = false;
  bool show = false;

  void setData(final d) {
    data.post.clear();

    final profile = d['profile'];
    final profileImage = const Base64Decoder().convert(profile['image_url']);

    data.profile = ProfileData(
      followers: profile['followers'],
      followings: profile['following'],
      name: profile['name'],
      profileImage: profileImage,
      posts: profile['post'],
      bio: profile['bio'],
      username: profile['username'],
      downloadLink: profile['profile_image'],
    );

    for (var i in d['posts']) {
      Uint8List decodedBytes = const Base64Decoder().convert(i['image_url']);
      data.post.add(decodedBytes);
    }

    if (!show) {
      show = true;
    }
    notifyListeners();
  }

  void updateProfileImage(List<XFile> image) async {
    if (image.isEmpty) return;

    data.profile.profileImage = await image[0].readAsBytes();

    notifyListeners();
  }

  void toggleEdit() {
    isEditing = !isEditing;

    notifyListeners();
  }

  void reorder(oldIndex, newIndex) {
    final item = data.post.removeAt(oldIndex);
    data.post.insert(newIndex, item);

    notifyListeners();
  }

  void addNewImage(List<XFile> d) async {
    if (d.isEmpty) return;

    for (var i in d) {
      final bytes = await i.readAsBytes();
      data.post.insert(0, bytes);
    }

    notifyListeners();
  }

  void deleteImage(int index) {
    data.post.removeAt(index);

    notifyListeners();
  }
}
