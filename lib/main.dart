import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:image_gallery_saver/image_gallery_saver.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  final GlobalKey _key = GlobalKey();
  void _captureScreenshot()async {
    RenderRepaintBoundary boundary = _key.currentContext!
        .findRenderObject() as RenderRepaintBoundary;

    if (boundary.debugNeedsPaint) {
      Timer(const Duration(seconds: 2), () => _captureScreenshot());
      return null;
    }

    ui.Image image = await boundary.toImage();

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if(byteData != null){
      Uint8List pngint8 = byteData.buffer.asUint8List();

      final saveImage  = await ImageGallerySaver.saveImage(Uint8List.fromList(pngint8),quality: 90, name: "screenshot-${DateTime.now()}.png");
      print(saveImage);
    }
  }
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Screenshot Screen",style: TextStyle(color: Colors.white,fontSize: 20,fontStyle: ui.FontStyle.italic),),backgroundColor: Colors.purple,
        ),backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Center(
                child: Text("Honesty helps people to develop\n"
                    " a strong character, uplift their \n"
                    " morals, do the right thing, have\n"
                    " faith in others, and practice\n"
                    " discipline in life",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 18,color: Colors.purple)),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.pinkAccent)),
                    onPressed: (){
                  _captureScreenshot();
                }, child: const Text("CAPTURE",style: TextStyle(color: Colors.white),)),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(backgroundColor: Colors.pinkAccent,
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add,color: Colors.white),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
