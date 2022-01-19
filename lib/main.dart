import 'package:flutter/material.dart';
import 'package:multiplevideo/imagepicker.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  FilePickerDemo() //MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   //List<XFile>? _imageFile;
//  // XFile? _imageFile;
//   final ImagePicker _picker = ImagePicker();
//    VideoPlayerController? _controller ;
//    PickedFile? _imageFile;
//    Future<void>? _initializeVideoPlayerFuture;
//    File? videoFile;
//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body:
//       Column(
//         children: <Widget>[
//           Visibility(
//             visible: _controller != null,
//             child: FutureBuilder(
//               future: _initializeVideoPlayerFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   // If the VideoPlayerController has finished initialization, use
//                   // the data it provides to limit the aspect ratio of the video.
//                   return AspectRatio(
//                     aspectRatio: _controller!.value.aspectRatio,
//                     // Use the VideoPlayer widget to display the video.
//                     child: VideoPlayer(_controller!),
//                   );
//                 } else {
//                   // If the VideoPlayerController is still initializing, show a
//                   // loading spinner.
//                   return Center(child: CircularProgressIndicator());
//                 }
//               },
//             ),
//           ),
//           RaisedButton(
//             child: Text("Video"),
//             onPressed: () {
//               getVideo();
//             },
//           ),
//         ],
//       ),
//       floatingActionButton: _controller == null
//           ? null
//           : FloatingActionButton(
//         onPressed: () {
//           // Wrap the play or pause in a call to `setState`. This ensures the
//           // correct icon is shown.
//           setState(() {
//             // If the video is playing, pause it.
//             if (_controller!.value.isPlaying) {
//               _controller!.pause();
//             } else {
//               // If the video is paused, play it.
//               _controller!.play();
//             }
//           });
//         },
//         // Display the correct icon depending on the state of the player.
//         child: Icon(
//           _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
//
//   Future getVideo() async {
//   //  final XFile? _videoFile = await _picker.pickVideo(source:  ImageSource.gallery);
//     Future<XFile?> _videoFile = _picker.pickVideo(source: ImageSource.camera);  //.pickVideo(source: ImageSource.gallery);
//     _videoFile.then((file) async {
//       setState(() {
//         XFile videoFile = file!;
//         //_controller = VideoPlayerController.file(videoFile!);
//
//         // Initialize the controller and store the Future for later use.
//         _initializeVideoPlayerFuture = _controller!.initialize();
//
//         // Use the controller to loop the video.
//         _controller!.setLooping(true);
//       });
//     });
//   }
// }

//       Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _imageFile == null
//                 ? CircleAvatar(
//                 radius: 60.0,
//                 backgroundColor: Colors.white,
//                 backgroundImage: NetworkImage(""))
//                 : CircleAvatar(radius: 60.0, ),//backgroundImage: FileImage(File(_imageFile!.path)),),
//              Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     width:2,),
//                   borderRadius: BorderRadius.all(
//                       Radius.circular(20.0)),
//                 ),
//                 child: FlatButton(
//                   onPressed:  () {
//                     takePhoto(ImageSource.gallery);
//                    // Navigator.pop(context);
//                   },
//                   child: Column(
//                       children: <Widget>[
//                         SizedBox(height: 20,),
//                         Icon(Icons.photo_album_rounded,size: 35,),
//                         SizedBox(height: 10,),
//                         Text("pickvideo"),]),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void takePhoto(ImageSource source) async{
//   //  XFile video = await _picker.pickVideo(...)
//     final xFile =await _picker.pickVideo(source: source);
//     //  final List<XFile>? images = await _picker.pickMultiImage(); //.getVideo(source: source);//  .getImage(source: source,);
//     setState(() {
//       _imageFile = xFile;
//     });
//   }
// }

/*import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'dart:async';
// import 'package:path_provider/path_provider.dart';
import 'package:simple_s3/simple_s3.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:multi_image_picker2/multi_image_picker2.dart';

void main() {
   runApp(const MyApp());
 }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<XFile> images = <XFile>[];
  String _error = 'No Error Dectected';
  SimpleS3 _simpleS3 = SimpleS3();
  bool isLoading = false;
  bool uploaded = false;

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        print("length od lost" +images[index].path);
        File asset =File(images[index].path);
        print(asset);

        _upload(asset);

        // _upload(asset);
        return Container(
          child: Stack(
            children: [
              //AssetThumb
              Container(
                child: Image.file(asset),
                width: 300,
                height: 300,
              ),
              uploaded?Container(padding:EdgeInsets.only(left: 110.0,top: 8.0),child:Icon(Icons.delete,color: Colors.red,)):Container(),
              isLoading?CircularProgressIndicator():Container()
              // isLoading?StreamBuilder<dynamic>(
              //     stream: _simpleS3.getUploadPercentage,
              //     builder: (context, snapshot) {
              //       print(snapshot.data);
              //       return snapshot.data!=null?Container(height:270,width:280,child: LinearProgressIndicator(value:snapshot.data.toDouble() ,color: Colors.blue,backgroundColor:Colors.white,),):Container();
              //     }):Container(),

              // Container(child: LinearProgressIndicator(value: ,color: Colors.blue,backgroundColor:Colors.white ,),),
              // Center(child: Text("99%",style: TextStyle(color: Colors.white)),)
            ],
          ),
        );

      }),
    );
  }
  Future<String?> _upload(File asset) async {
    String? result;
    print("upload"+asset.path);
    // File img = await getImageFileFromAssets(asset.identifier!);
    if (result == null) {
      try {
        setState(() {
          isLoading = true;
        });
        result = await _simpleS3.uploadFile(
          asset,
          "poc-flutter",
          "us-east-1:c17b7c5f-a98f-45fc-bd64-9183a551e031",
          AWSRegions.usEast1,
          debugLog: true,
          s3FolderPath: "test",
          accessControl: S3AccessControl.private,
        );
        if(result!=null){
          setState(() {
            uploaded = true;
            isLoading = false;
          });}
      } catch (e) {
        print(e);
      }
    }
    return result;
  }

  Future<void> loadAssets() async {
    List<XFile> resultList = <XFile>[];
    String error = 'No Error Detected';

    try {
      resultList = (await ImagePicker().pickMultiImage())!;
      images = resultList;
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Center(child: Text('Error: $_error')),
            ElevatedButton(
              child: Text("Pick images"),
              onPressed: loadAssets,
            ),
            Expanded(
        child: GridView.count(
    crossAxisCount: 3,
    children: List.generate(images.length, (index) {
      print("length od lost" +images[index].path);
      File asset =File(images[index].path);
      print(asset);
      _upload(asset);
      // _upload(asset);
      return Container(
        child: Stack(
          children: [
            //AssetThumb
            Container(
              child: Image.file(asset),
              width: 300,
              height: 300,
            ),
            uploaded?Container(padding:EdgeInsets.only(left: 110.0,top: 8.0),child:Icon(Icons.delete,color: Colors.red,)):Container(),
            isLoading?CircularProgressIndicator():Container()
            // isLoading?StreamBuilder<dynamic>(
            //     stream: _simpleS3.getUploadPercentage,
            //     builder: (context, snapshot) {
            //       print(snapshot.data);
            //       return snapshot.data!=null?Container(height:270,width:280,child: LinearProgressIndicator(value:snapshot.data.toDouble() ,color: Colors.blue,backgroundColor:Colors.white,),):Container();
            //     }):Container(),
            // Container(child: LinearProgressIndicator(value: ,color: Colors.blue,backgroundColor:Colors.white ,),),
            // Center(child: Text("99%",style: TextStyle(color: Colors.white)),)
          ],
        ),
      );
    }),
    )),
            // Expanded(
            //   child: buildGridView(),
            // )
          ],
        ),
      ),
    );
  }
}*/