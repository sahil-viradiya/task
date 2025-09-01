import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class AddVehicleFlow extends StatelessWidget {
  final String title;
  final List<String> flowLabel;
  final Function() onClose;

  const AddVehicleFlow({super.key, required this.title, required this.flowLabel, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlowCard(
        title: title,
        onClose: () {onClose();}, // inject close action
        child: ResponsiveFlowCanvas(
          height: 100,
          props: FlowCanvasProps(
            steps: _generateSteps(),
            dashColor: const Color(0xFFD15A6E),
            strokeWidth: 1,
            dashArray: const [2, 2],
            cornerRadius: 27,
            chipColor: const Color(0xFFE5E7EB),
            textStyle:  TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  List<FlowStep> _generateSteps() {
    List<Map<String, double>> positions = [
      {'dx': 0.01, 'dy': 0.15},
      {'dx': 0.40, 'dy': 0.15},
      {'dx': 0.01, 'dy': 0.65},
      {'dx': 0.6, 'dy': 0.65},
      {'dx': 0.33, 'dy': 0.65},
    ];
    List<FlowStep> steps = [];
    for (int i = 0; i < flowLabel.length && i < positions.length; i++) {
      steps.add(FlowStep(
        label: flowLabel[i],
        dx: positions[i]['dx']!,
        dy: positions[i]['dy']!,
      ));
    }
    return steps;
  }
}

/// Each step in flow
class FlowStep {
  final String label;
  final double dx;
  final double dy;

  FlowStep({required this.label, required this.dx, required this.dy});
}

class FlowCard extends StatelessWidget {
  const FlowCard({
    super.key,
    required this.title,
    required this.child,
    this.onClose,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.margin = const EdgeInsets.all(16),
  });

  final String title;
  final Widget child;
  final VoidCallback? onClose;
  final EdgeInsets padding;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(80),
            blurRadius: 2,
            // offset: const Offset(0, 8),
          ),
        ],
      ),
      // constraints: const BoxConstraints(maxWidth: 680),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
              InkWell(
                onTap: onClose,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,

                    gradient: LinearGradient(
                      colors: [Color(0xFFEB5757), Color(0xFFB51E1E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}

/// Props updated with dynamic list
class FlowCanvasProps {
  const FlowCanvasProps({
    required this.steps,
    required this.dashColor,
    required this.strokeWidth,
    required this.dashArray,
    required this.cornerRadius,
    required this.textStyle,
    required this.chipColor,
  });

  final List<FlowStep> steps;

  final Color dashColor;
  final double strokeWidth;
  final List<double> dashArray;
  final double cornerRadius;

  final TextStyle textStyle;
  final Color chipColor;

  FlowCanvasProps copyWith({
    List<FlowStep>? steps,
    Color? dashColor,
    double? strokeWidth,
    List<double>? dashArray,
    double? cornerRadius,
    TextStyle? textStyle,
    Color? chipColor,
  }) {
    return FlowCanvasProps(
      steps: steps ?? this.steps,
      dashColor: dashColor ?? this.dashColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      dashArray: dashArray ?? this.dashArray,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      textStyle: textStyle ?? this.textStyle,
      chipColor: chipColor ?? this.chipColor,
    );
  }
}

class ResponsiveFlowCanvas extends StatelessWidget {
  const ResponsiveFlowCanvas({super.key, required this.props, this.height});

  final FlowCanvasProps props;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: _FlowCanvas(p: props),
    );
  }
}

class _FlowCanvas extends StatelessWidget {
  const _FlowCanvas({required this.p});

  final FlowCanvasProps p;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final chipH = 25.0;

        final double canvasWidth = c.maxWidth;
        final double canvasHeight = c.maxHeight;

        Widget chip(String text) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          height: chipH,
          decoration: BoxDecoration(
            color: p.chipColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              text,
              style: p.textStyle,
              softWrap: false,
              overflow: TextOverflow.fade,
              maxLines: 1,
            ),
          ),
        );

        return Stack(
          children: [
            Positioned.fill(
              top: -10,
              child: CustomPaint(
                painter: DashedConnectorPainter(
                  start: Offset(canvasWidth * 0.05, canvasHeight * 0.4),
                  via: Offset(canvasWidth * 0.45, canvasHeight * 0.4),
                  turnRightX: canvasWidth * 1,
                  turnDownY: canvasHeight * 0.9,
                  endLeftX: canvasWidth * 0.05,

                  dashColor: p.dashColor,
                  strokeWidth: p.strokeWidth,
                  dashArray: p.dashArray,
                  cornerRadius: p.cornerRadius,
                ),
              ),
            ),

            for (var step in p.steps)
              Positioned(
                left: c.maxWidth * step.dx,
                top: c.maxHeight * step.dy,
                child: chip(step.label),
              ),
          ],
        );
      },
    );
  }
}
/// Painter stays same
class DashedConnectorPainter extends CustomPainter {
  DashedConnectorPainter({
    required this.start,
    required this.via,
    required this.turnRightX,
    required this.turnDownY,
    required this.endLeftX,
    required this.dashColor,
    required this.strokeWidth,
    required this.dashArray,
    required this.cornerRadius,
  });

  final Offset start;
  final Offset via;
  final double turnRightX;
  final double turnDownY;
  final double endLeftX;
  final Color dashColor;
  final double strokeWidth;
  final List<double> dashArray;
  final double cornerRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(via.dx, via.dy)
      ..lineTo(turnRightX - cornerRadius, via.dy);

    final arcRect1 = Rect.fromCircle(
      center: Offset(turnRightX - cornerRadius, via.dy + cornerRadius),
      radius: cornerRadius,
    );
    path.arcTo(arcRect1, -1.5708, 1.5708, false);

    path.lineTo(turnRightX, turnDownY - cornerRadius);

    final arcRect2 = Rect.fromCircle(
      center: Offset(turnRightX - cornerRadius, turnDownY - cornerRadius),
      radius: cornerRadius,
    );
    path.arcTo(arcRect2, 0, 1.5708, false);

    path.lineTo(endLeftX, turnDownY);

    final paint = Paint()
      ..color = dashColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final dashed = dashPath(
      path,
      dashArray: CircularIntervalList<double>(dashArray),
    );
    canvas.drawPath(dashed, paint);
  }

  @override
  bool shouldRepaint(covariant DashedConnectorPainter old) {
    return start != old.start ||
        via != old.via ||
        turnRightX != old.turnRightX ||
        turnDownY != old.turnDownY ||
        endLeftX != old.endLeftX ||
        dashColor != old.dashColor ||
        strokeWidth != old.strokeWidth ||
        cornerRadius != old.cornerRadius ||
        dashArray.join(',') != old.dashArray.join(',');
  }
}
