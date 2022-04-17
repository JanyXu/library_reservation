import 'package:flutter/cupertino.dart';
import 'package:library_reservation/ui/pages/scan/scan_frame.dart';

class Components {
  // normal border
  static Widget defaultScanBorder(scanFrameSize, frameColor, frameWidth) {
    return Center(
      child: ScanFrame()
      // Container(
      //   width: scanFrameSize.width,
      //   height: scanFrameSize.height,
      //   decoration: BoxDecoration(
      //     border: Border.all(
      //       width: frameWidth,
      //       color: frameColor,
      //     ),
      //     borderRadius: BorderRadius.circular(0),
      //   ),
      //),
    );
  }
}
