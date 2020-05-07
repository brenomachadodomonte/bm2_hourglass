import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {

  AnimationController controller;
  double val = 0.0;
  bool isPlaying = false;

  String get timerString {
    Duration duration = controller.duration * (controller.value == 0.0 ? 1 : controller.value);
    return '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    controller.addStatusListener((status){
      if(status == AnimationStatus.dismissed){
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width - 20;
    double size = (width * 0.3125);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(10),
        child: AnimatedBuilder(
            animation: controller,
            builder: (context, child){
              return Container(
                padding: EdgeInsets.only(top: 80),
                child: Column(
                  children: <Widget>[
                    Text('BM2', style: TextStyle(color: Colors.grey)),
                    Text(timerString, style: TextStyle(fontSize: 100, color: Colors.grey)),
                    SizedBox(height: 20,),
                    Container(
                      width: width,
                      height: width,
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              SizedBox(height: (width * 0.125) + ((1.0 - controller.value) * size),),
                              Container(
                                color: Colors.amber,
                                width: width - 10,
                                height: size - ((1.0 - controller.value) * size),
                              ),
                              SizedBox(height: (width * 0.4375) - ((1.0 - controller.value) * size),),
                              Container(
                                color: Colors.amber,
                                width: width - 10,
                                height: (1.0 - controller.value) * size,
//                            height: width * 0.3125,
                              ),
                              SizedBox(height: width * 0.125,),
                            ],
                          ),
                          Image(
                            image: AssetImage('assets/hourglass.png'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        FloatingActionButton.extended(
                          label: Text('Reset', style: TextStyle(color: Colors.white),),
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: (){
                            controller.reset();
                            setState(() {
                              isPlaying = false;
                            });
                          },
                        ),
                        FloatingActionButton(
                          child: Icon(Icons.settings, color: Colors.white),
                          onPressed: (){
                            _showDialogSetup(context);
                          },
                        ),
                        FloatingActionButton.extended(
                          label: Text(isPlaying ? 'Pause' : 'Play', style: TextStyle(color: Colors.white),),
                          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                          onPressed: (){
                            if(controller.isAnimating) {
                              controller.stop();
                            } else {
                              controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
                            }
                            setState(() {
                              isPlaying = !isPlaying;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  void _showDialogSetup(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text('Setup'),
          ),
          content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.ms,
                    minuteInterval: 1,
                    secondInterval: 1,
                    initialTimerDuration: controller.duration,
                    onTimerDurationChanged: (Duration changedtimer) {
                      setState(() {
                        if(controller != null){
                          controller.duration = changedtimer;
                        }
                      });
                    },
                  ),
                  SizedBox(height: 10.0,),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: FlatButton(
                          child: Text(
                            "CLOSE",
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )
          ),
        );
      },
    );
  }
}
