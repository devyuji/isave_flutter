import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Video extends StatefulWidget {
  const Video({Key? key, this.url, this.file}) : super(key: key);

  @override
  _VideoState createState() => _VideoState();

  final String? url;
  final File? file;
}

class _VideoState extends State<Video> with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;

  late AnimationController _animationController;
  bool _opacity = false;
  Timer t = Timer(const Duration(seconds: 3), () {});

  @override
  void initState() {
    super.initState();

    if (widget.file != null) {
      _controller = VideoPlayerController.file(widget.file!)
        ..initialize().then((value) => setState(() {}));
    } else {
      _controller = VideoPlayerController.network(widget.url!)
        ..initialize().then(
          (_) => setState(() {
            _controller.play();
          }),
        );
    }

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    t.cancel();

    super.dispose();
  }

  void _pauseplay() {
    if (!_opacity) {
      setState(_show);
    }
    if (_controller.value.isPlaying) {
      _animationController.forward();
      _controller.pause();
    } else {
      _animationController.reverse();
      _controller.play();
    }
  }

  void _tab() {
    t.cancel();

    setState(_show);
  }

  void _show() {
    _opacity = !_opacity;
    t = Timer(
      const Duration(seconds: 3),
      () => setState(() {
        _opacity = !_opacity;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return _controller.value.isInitialized
        ? Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: _tab,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              Positioned(
                child: AnimatedOpacity(
                  opacity: _opacity ? 1 : 0,
                  duration: const Duration(milliseconds: 450),
                  child: GestureDetector(
                    onTap: _pauseplay,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            offset: const Offset(0, 2.0),
                          ),
                        ],
                      ),
                      child: _controller.value.duration ==
                              _controller.value.position
                          ? Icon(
                              Icons.refresh_rounded,
                              color: Colors.white,
                              size: size.width * 0.2,
                            )
                          : AnimatedIcon(
                              icon: AnimatedIcons.pause_play,
                              progress: _animationController,
                              color: Colors.white,
                              size: size.width * 0.2,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : const CircularProgressIndicator(color: Colors.white);
  }
}
