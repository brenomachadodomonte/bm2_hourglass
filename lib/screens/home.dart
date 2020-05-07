import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {

  AnimationController controller;
  double val = 0.0;

  String get timerString {
    Duration duration = controller.duration * (controller.value == 0.0 ? 1 : controller.value);
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width - 20;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(10),
        child: AnimatedBuilder(
            animation: controller,
            builder: (context, child){
              return Container(
                padding: EdgeInsets.only(top: 200),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                          child: Text('reset'),
                          onPressed: (){
                            setState(() {
                              val = 0;
                            });
                          },
                        ),
                        RaisedButton(
                          child: Text('increment'),
                          onPressed: (){
                            if(controller.isAnimating) {
                              controller.stop();
                            } else {
                              controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
                            }
                            setState(() {
                              val += 1;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Container(
                      width: width,
                      height: width,
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              SizedBox(height: (width * 0.125) + val,),
                              Container(
                                color: Colors.amber,
                                width: width - 10,
                                height: (width * 0.3125) - val,
                              ),
                              SizedBox(height: (width * 0.4375) - val,),
                              Container(
                                color: Colors.amber,
                                width: width - 10,
                                height: (width * 0) + val,
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
                    Text(timerString, style: TextStyle(fontSize: 100, color: Colors.grey),)
                  ],
                ),
              );
            }),
      ),
    );
  }
}
