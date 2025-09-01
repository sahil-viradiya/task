import 'package:flutter/material.dart';

void showCommonSnackbar({
  required BuildContext context,
  required String title,
  Widget? icon,
  Gradient? gradient,
  bool isError = false,
  Duration duration = const Duration(seconds: 3),
  Duration animationDuration = const Duration(milliseconds: 500),
}) {
  final overlayState = Overlay.of(context);
  final themeData = Theme.of(context);

  OverlayEntry? overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) {
        return _SnackbarWidget(
          title: title,
          icon: icon,
          gradient: gradient,
          duration: duration,
          animationDuration: animationDuration,
          themeData: themeData,
          isError: isError,
          onDismiss: () {
            overlayEntry?.remove();
            overlayEntry = null;
          },
        );
      },
    ),
  );

  overlayState.insert(overlayEntry!);

  Future.delayed(duration + animationDuration).then((_) {
    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
  });
}

class _SnackbarWidget extends StatefulWidget {
  final String title;
  final Widget? icon;
  final Gradient? gradient;
  final Duration duration;
  final Duration animationDuration;
  final ThemeData themeData;
  final VoidCallback onDismiss;
  final bool? isError;

  const _SnackbarWidget({
    required this.title,
    this.icon,
    this.gradient,
    this.isError,
    required this.duration,
    required this.animationDuration,
    required this.themeData,
    required this.onDismiss,
  });

  @override
  _SnackbarWidgetState createState() => _SnackbarWidgetState();
}

class _SnackbarWidgetState extends State<_SnackbarWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));

    _animationController.forward();

    Future.delayed(widget.duration).then((_) {
      if (mounted) {
        _animationController.reverse().then((_) {
          widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: widget.gradient ??
                  RadialGradient(
                    colors: widget.isError == false
                        ? [
                            Color(0xFFCEF3CB),
                            Color(0xFFFFFFFF),
                          ]
                        : [
                            Color(0xFFF3CBCC),
                            Color(0xFFFFFFFF),
                          ],
                    center: Alignment.topLeft,
                    radius: 2.0,
                  ),
              borderRadius: BorderRadius.circular(7.65),
              boxShadow: [
                BoxShadow(
                  color: widget.themeData.shadowColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                widget.icon ??
                    Icon(
                      widget.isError == false ? Icons.check_circle : Icons.info_outline,
                      color: widget.isError == false ? Colors.green : Colors.red,
                    ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(widget.title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: widget.isError == false ? Colors.green : Colors.red)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
