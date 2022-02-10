import 'package:flutter/material.dart';
import 'package:isave/custom_route.dart';
import 'package:isave/screens/all_downloads.dart';
import 'package:isave/screens/check_for_update.dart';
import 'package:isave/screens/help.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

// custom
import 'package:isave/utils/snack_bar.dart';
import 'package:isave/constraint.dart';
import 'package:isave/provider/preview_state.dart';
import 'package:isave/models.dart';
import 'package:isave/screens/home/widgets/input_preview.dart';
import 'package:isave/screens/home/widgets/intro.dart';

class Preview extends StatefulWidget {
  const Preview({Key? key}) : super(key: key);

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  bool _isTextFieldOpen = true;

  Future<List<XFile>?> _pickImages() async {
    if (!Provider.of<PreviewState>(context, listen: false).show) {
      snackBar(context, "Enter username");
      return null;
    }

    try {
      ImagePicker _picker = ImagePicker();

      List<XFile>? images = await _picker.pickMultiImage();

      if (images == null) return [];

      return images;
    } catch (_) {
      snackBar(context, "Unable to pick image");
    }

    return null;
  }

  void _reorder(int oldIndex, int newIndex) {
    Provider.of<PreviewState>(context, listen: false)
        .reorder(oldIndex, newIndex);
  }

  void _delete(int index) {
    Provider.of<PreviewState>(context, listen: false).deleteImage(index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Menu> menu = [
      Menu(name: "Downloads", widget: const AllDownloads()),
      Menu(name: "Check for update", widget: const CheckForUpdate()),
      Menu(name: "Help & Feedback", widget: const Help()),
    ];

    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    final size = MediaQuery.of(context).size;

    final _data = Provider.of<PreviewState>(context).data;

    final _isEditing = Provider.of<PreviewState>(context).isEditing;

    final _show = Provider.of<PreviewState>(context).show;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: _data.post.isNotEmpty
          ? FloatingActionButton(
              onPressed:
                  Provider.of<PreviewState>(context, listen: false).toggleEdit,
              child: Icon(
                Icons.edit_rounded,
                color: isDarkMode ? Colors.black : Colors.white,
              ),
            )
          : null,
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            snap: true,
            elevation: 0,
            title: const Text(
              'isave',
              style: TextStyle(fontSize: 25.0),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  final images = await _pickImages();
                  Provider.of<PreviewState>(context, listen: false)
                      .addNewImage(images!);
                },
                icon: const Icon(
                  Icons.add_outlined,
                  semanticLabel: "image picker",
                ),
                iconSize: 30.0,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isTextFieldOpen = !_isTextFieldOpen;
                  });
                },
                icon: const Icon(Icons.open_in_new_outlined),
                iconSize: 25.0,
              ),
              PopupMenuButton(
                onSelected: (Widget item) =>
                    Navigator.of(context).push(customRouteAnimation(item)),
                itemBuilder: (_) => menu
                    .map(
                      (e) => PopupMenuItem(
                        value: e.widget,
                        child: Text(
                          e.name,
                        ),
                      ),
                    )
                    .toList(),
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                InputPreview(isTextFieldOpen: _isTextFieldOpen),
                _show
                    ? Container(
                        padding: const EdgeInsets.all(kDefaultPadding * 2),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? kDarkBackgroundColor
                              : kBackgroundColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    if (_isEditing) {
                                      final image = await _pickImages();
                                      Provider.of<PreviewState>(context,
                                              listen: false)
                                          .updateProfileImage(image!);
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: size.width * 0.13,
                                    backgroundImage: MemoryImage(
                                        _data.profile.profileImage!),
                                  ),
                                ),
                                Column(
                                  children: <Text>[
                                    Text(
                                      "${_data.profile.posts!}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: isDarkMode
                                              ? kDarkTextColor
                                              : kTextColor),
                                    ),
                                    Text(
                                      'Post',
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? kDarkTextColor
                                            : kTextColor,
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Text>[
                                    Text(
                                      "${_data.profile.followers}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: isDarkMode
                                            ? kDarkTextColor
                                            : kTextColor,
                                      ),
                                    ),
                                    Text(
                                      'Followers',
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? kDarkTextColor
                                            : kTextColor,
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Text>[
                                    Text(
                                      "${_data.profile.followings}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: isDarkMode
                                              ? kDarkTextColor
                                              : kTextColor),
                                    ),
                                    Text(
                                      'Followings',
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? kDarkTextColor
                                            : kTextColor,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: kDefaultPadding * 2,
                            ),
                            Text(
                              _data.profile.name!,
                              style: TextStyle(
                                color: isDarkMode ? kDarkTextColor : kTextColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: kDefaultPadding),
                            Text(
                              _data.profile.bio!,
                              style: TextStyle(
                                color: isDarkMode ? kDarkTextColor : kTextColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Intro(text: "preview"),
              ],
            ),
          ),
          !_isEditing
              ? SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Image.memory(
                      _data.post[index],
                      fit: BoxFit.cover,
                    ),
                    childCount: _data.post.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: kDefaultPadding * 0.2,
                    mainAxisSpacing: kDefaultPadding * 0.2,
                  ),
                )
              : ReorderableSliverGridView.count(
                  crossAxisCount: 3,
                  onReorder: _reorder,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: kDefaultPadding * 0.2,
                  mainAxisSpacing: kDefaultPadding * 0.2,
                  children: _data.post
                      .map(
                        (e) => Stack(
                          key: ValueKey('${_data.post.indexOf(e) * 2}'),
                          children: <Widget>[
                            SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: Image.memory(
                                e,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                height: 30.0,
                                width: 30.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100.0),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.85),
                                      blurRadius: 10.0,
                                      offset: const Offset(0.0, 2.0),
                                    )
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close_outlined,
                                    color: Colors.black,
                                    size: 15.0,
                                  ),
                                  onPressed: () {
                                    _delete(_data.post.indexOf(e));
                                  },
                                  iconSize: 30.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),

          // extra space for floating action button
          if (_data.post.isNotEmpty)
            SliverList(
              delegate: SliverChildListDelegate(
                <SizedBox>[
                  const SizedBox(height: kDefaultPadding * 10),
                ],
              ),
            )
        ],
      ),
    );
  }
}
