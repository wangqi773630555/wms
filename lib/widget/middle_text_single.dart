import 'package:flutter/material.dart';
import 'package:wanma_print/common/style/wm_style.dart';

class MiddleTextSingle extends StatelessWidget {
  final dynamic text;
  final bool flag;
  final Alignment alignment;

  MiddleTextSingle(this.text, this.alignment, {this.flag = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
//       decoration: flag ? BoxDecoration(
// //        color: Colors.grey,
//         borderRadius: BorderRadius.circular(5.0),
//         border: Border.all(
//           width: 1.0
//         )
//       ) : null,
      child: Text(
        text?.toString() ?? '',
        style: TextStyle(fontSize: 15),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,

      ),
    );
  }
}
