import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FadingListViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 320,
        child: ShaderMask(
          shaderCallback: (Rect rect) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.purple,
                Colors.transparent,
                Colors.transparent,
                Colors.purple
              ],
              stops: [
                0.0,
                0.1,
                0.9,
                1.0
              ], // 10% purple, 80% transparent, 10% purple
            ).createShader(rect);
          },
          blendMode: BlendMode.dstOut,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  tileColor: Colors.blueGrey[800],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)),
                  title: Center(
                    child: Text("List $index"),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
