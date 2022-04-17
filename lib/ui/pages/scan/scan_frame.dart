import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScanFrame extends StatefulWidget {
  const ScanFrame({Key? key}) : super(key: key);

  @override
  State<ScanFrame> createState() => _ScanFrameState();
}

class _ScanFrameState extends State<ScanFrame> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  //起始之间的线性插值器 从 0.05 到 0.95 百分比。
  final Tween<double> _rotationTween = Tween(begin: 0.05, end: 0.95);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,     //实现 TickerProviderStateMixin
      duration: Duration(seconds: 3), //动画时间 3s
    );

    _animation = _rotationTween.animate(_controller)
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.repeat();
  }

  @override
  void dispose() {
    // 释放动画资源
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ScanFramePainter(lineMoveValue: _animation.value),
      child: Container(),
    );
  }
}


class _ScanFramePainter extends CustomPainter {
  final double cornerLength = 20.0;
  //默认定义扫描框为 260边长的正方形
  final Size frameSize = Size.square(200.0);
  _ScanFramePainter({required this.lineMoveValue}) : assert(lineMoveValue != null);

  // 百分比值，0 ~ 1，然后计算Y坐标
  final double lineMoveValue;
  @override
  void paint(Canvas canvas, Size size) {
    // 按扫描框居中来计算，全屏尺寸与扫描框尺寸的差集 除以 2 就是扫描框的位置
    Offset diff = (size - frameSize)as Offset;
    double leftTopX = diff.dx / 2;
    double leftTopY = diff.dy / 2;
    //根据左上角的坐标和扫描框的大小可得知扫描框矩形
    var rect =
    Rect.fromLTWH(leftTopX, leftTopY, frameSize.width, frameSize.height);
    // 4个点的坐标
    Offset leftTop = rect.topLeft;
    Offset leftBottom = rect.bottomLeft;
    Offset rightTop = rect.topRight;
    Offset rightBottom = rect.bottomRight;

    // //定义画笔
    // Paint paint = Paint()
    //   ..color = Colors.blue  //颜色
    //   ..strokeWidth = 4.0   //画笔线条宽度
    //   ..style = PaintingStyle.stroke; // 画笔的模式，填充还是只绘制边框

    //绘制正方形
   // canvas.drawRect(rect, paint);

    //绘制罩层
    //画笔
    Paint paint = Paint()
      ..color = Colors.black12 //透明灰
      ..style = PaintingStyle.fill; // 画笔的模式，填充
    //左侧矩形
    canvas.drawRect(Rect.fromLTRB(0, 0, leftTopX, size.height), paint);
    //右侧矩形
    canvas.drawRect(
      Rect.fromLTRB(rightTop.dx, 0, size.width, size.height),
      paint,
    );
    //中上矩形
    canvas.drawRect(Rect.fromLTRB(leftTopX, 0, rightTop.dx, leftTopY), paint);
    //中下矩形
    canvas.drawRect(
      Rect.fromLTRB(leftBottom.dx, leftBottom.dy, rightBottom.dx, size.height),
      paint,
    );
    //画笔
     paint = Paint()
      ..color = Colors.black12 //透明灰
      ..style = PaintingStyle.fill; // 画笔的模式，填充
    //左侧矩形
    canvas.drawRect(Rect.fromLTRB(0, 0, leftTopX, size.height), paint);
    //右侧矩形
    canvas.drawRect(
      Rect.fromLTRB(rightTop.dx, 0, size.width, size.height),
      paint,
    );
    //中上矩形
    canvas.drawRect(Rect.fromLTRB(leftTopX, 0, rightTop.dx, leftTopY), paint);
    //中下矩形
    canvas.drawRect(
      Rect.fromLTRB(leftBottom.dx, leftBottom.dy, rightBottom.dx, size.height),
      paint,
    );

    // 重新设置画笔
    paint
      ..color = Color(0x4042E8E0)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.square  // 解决因为线宽导致交界处不是直角的问题
      ..style = PaintingStyle.stroke;

    // 横向线条的坐标偏移
    Offset horizontalOffset = Offset(cornerLength, 0);
    // 纵向线条的坐标偏移
    Offset verticalOffset = Offset(0, cornerLength);
    // 左上角
    canvas.drawLine(leftTop, leftTop + horizontalOffset, paint);
    canvas.drawLine(leftTop, leftTop + verticalOffset, paint);
    // 左下角
    canvas.drawLine(leftBottom, leftBottom + horizontalOffset, paint);
    canvas.drawLine(leftBottom, leftBottom - verticalOffset, paint);
    // 右上角
    canvas.drawLine(rightTop, rightTop - horizontalOffset, paint);
    canvas.drawLine(rightTop, rightTop + verticalOffset, paint);
    // 右下角
    canvas.drawLine(rightBottom, rightBottom - horizontalOffset, paint);
    canvas.drawLine(rightBottom, rightBottom - verticalOffset, paint);

    //修改画笔线条宽度
    paint.strokeWidth = 1;
    // 扫描线的移动值
    var lineY = leftTopY + frameSize.height * lineMoveValue;
    // 10 为线条与方框之间的间距，绘制扫描线
    canvas.drawLine(
      Offset(leftTopX + 10.0, lineY),
      Offset(rightTop.dx - 10.0, lineY),
      paint,
    );
  }

  _paintRound(Canvas canvas) {
    //绘制罩层

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

