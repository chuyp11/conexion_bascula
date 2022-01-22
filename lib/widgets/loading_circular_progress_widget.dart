import 'package:flutter/material.dart';

class LoadingCircularProgressWidget extends StatelessWidget {
  LoadingCircularProgressWidget({
    Key? key,
    required this.streamMostrarCircularProgress,
    required this.child,
  }) : super(key: key);

  final Stream<bool> streamMostrarCircularProgress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: streamMostrarCircularProgress,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          bool mostrarCircularProgress = snapshot.data!;

          return Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: IgnorePointer(
                  ignoring: (mostrarCircularProgress) ? true : false,
                  child: Opacity(
                    opacity: (mostrarCircularProgress) ? 0.5 : 1.0,
                    child: child,
                  ),
                ),
              ),
              (mostrarCircularProgress)
                  ? Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Color(Colors.blue[200]!.value)),
                          ),
                        ),
                      ))
                  : Container()
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
