
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:simple_s3/simple_s3.dart';

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

File? asset;
class _FilePickerDemoState extends State<FilePickerDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _userAborted = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = TextEditingController();
  SimpleS3 _simpleS3 = SimpleS3();
  //double getperc = 0.0;
  bool x = false;
  bool isLoading = false;
  bool uploaded = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
      _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });
  }


  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('File Picker example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: DropdownButton<FileType>(
                        hint: const Text('LOAD PATH FROM'),
                        value: _pickingType,
                        items: FileType.values
                            .map((fileType) => DropdownMenuItem<FileType>(
                          child: Text(fileType.toString()),
                          value: fileType,
                        ))
                            .toList(),
                        onChanged: (value) => setState(() {
                          _pickingType = value!;
                          if (_pickingType != FileType.custom) {
                            _controller.text = _extension = '';
                          }
                        })),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 100.0),
                    child: _pickingType == FileType.custom
                        ? TextFormField(
                      maxLength: 15,
                      autovalidateMode: AutovalidateMode.always,
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'File extension',
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                    )
                        : const SizedBox(),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 200.0),
                    child: SwitchListTile.adaptive(
                      title: Text(
                        'Pick multiple files',
                        //textAlign: TextAlign.right,
                      ),
                      onChanged: (bool value) =>
                          setState(() => _multiPick = value),
                      value: _multiPick,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                    child: Column(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () => _pickFiles(),
                          child: Text(_multiPick ? 'Pick files' : 'Pick file'),
                        ),
                        SizedBox(height: 10),
                        // ElevatedButton(
                        //   onPressed: () => _selectFolder(),
                        //   child: const Text('Pick folder'),
                        // ),
                      ],
                    ),
                  ),

                  Builder(
                    builder: (BuildContext context) => _isLoading
                        ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: const CircularProgressIndicator(),
                    )
                        : _userAborted
                        ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: const Text(
                        'User has aborted the dialog',
                      ),
                    )
                        : _directoryPath != null
                        ? ListTile(
                      title: const Text('Directory path'),
                      subtitle: Text(_directoryPath!),
                    )
                        : _paths != null
                        ? Container(
                      padding:
                      const EdgeInsets.only(bottom: 30.0),
                      height:
                      MediaQuery.of(context).size.height * 0.50,
                      child: Scrollbar(
                          child: ListView.builder(//itemBuilder: itemBuilder)  separated(
                            itemCount: _paths != null &&
                                _paths!.isNotEmpty
                                ? _paths!.length
                                : 1,
                            itemBuilder: (BuildContext context, int index) {
                              final bool isMultiPath =
                                  _paths != null && _paths!.isNotEmpty;
                              final String name =
                                  'File $index: ' +
                                      (isMultiPath
                                          ? _paths!
                                          .map((e) => e.name)
                                          .toList()[index]
                                          : _fileName ?? '...');
                              final path = kIsWeb
                                  ? null
                                  : _paths!
                                  .map((e) => e.path)
                                  .toList()[index]
                                  .toString();
                              print(path);
                              List<dynamic>  pathlist = _paths!.map((e) => e.path).toList();
                              print("pathlist");
                              print(pathlist);
                              print(pathlist.length);
                              // for(int i=0; i < pathlist.length;  i++){
                              //   asset = File(pathlist[i]);
                              //  _upload(asset!);
                              //    // return result;
                              // //  }
                              //  // if(x == true) {
                              //  //   i++;
                              //  // }
                              //  }
                               asset = File(path!);
                              _upload(asset!);
                             // List customers = [];
                             //  print("customers");
                             //  print(customers);
                             //  print(customers.length);
                              List<getfiledetails>_a = [
                               getfiledetails(pathlist, [0,1,2,3])
                                ];
                               print("getfiledetails");
                               print(_a);
                             //  print(getfiledetails);
                              // uploaded == false? _upload(asset!): null;
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      title: Text(name,),
                                      /*subtitle:StreamBuilder<dynamic>(
                                          stream: _simpleS3.getUploadPercentage,
                                          builder: (context, dynamic snapshot) {
                                            // _upload(asset!);
                                            _a=[
                                              getfiledetails(pathlist, snapshot.data)
                                            ];
                                            print("_a detail");
                                            print(_a);
                                            print(snapshot.data);
                                            double  getperc = snapshot.data == null? 0.0: snapshot.data/ 100;
                                            print(getperc);
                                            return Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                new LinearPercentIndicator(
                                                  width: 200.0,
                                                  lineHeight: 8.0,
                                                  percent:   snapshot.data/100.toDouble(), //getperc.toDouble(),
                                                  progressColor: Colors.green,
                                                ),
                                                SizedBox(width: 10,),
                                                // Text( snapshot.data == null? "0": snapshot.data.toString() + " %" , style: TextStyle(fontSize: 12), )
                                              ],
                                            );
                                          }),*/
                                     // Text(path ?? ''),
                                      leading: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minWidth: 44,
                                          minHeight: 44,
                                          maxWidth: 64,
                                          maxHeight: 64,
                                        ),
                                        child:  Image.file(asset!,fit: BoxFit.cover), //Image.asset(asset, fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                //  ListView.builder(
                                // itemCount:   3,
                                // itemBuilder: (context, int index ) {
                                // return
                                Padding(
                                    padding:  EdgeInsets.only(right: 2, left: 2, top: 5, bottom: 5),
                                    child: StreamBuilder<dynamic>(
                                     // initialData: 0.0,
                                        stream: _simpleS3.getUploadPercentage,
                                        builder: (context,  snapshot) {
                                          // snapshot.hasData? _a = [
                                          //   getfiledetails(pathlist, snapshot.data)
                                          // ]
                                          // : print("false");
                                          // print(_a);
                                         // _upload(asset!);
                                         //  snapshot.hasData?
                                         //  print(snapshot.data);
                                         //  print(snapshot);
                                         // double  getperc = snapshot.data == null? 0.0: snapshot.data/ 100;
                                         // print(getperc);
                                         //  if(snapshot.connectionState == ConnectionState.active){
                                         //    print("active");
                                         //  }else{
                                         //    print("not active");
                                         //  }
                                          return Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                           CircularPercentIndicator(
                                            radius: 55.0,
                                            lineWidth: 8.0,
                                            animation: true,
                                            percent: snapshot.data!=null?double.parse(snapshot.data.toString())/ 100:0.0, // here we're using the percentage to be in sync with the color of the text
                                            center:  Text(
                                              snapshot.data!=null?snapshot.data.toString()+ "%": "",
                                                style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11.0),
                                          ),
                                          circularStrokeCap: CircularStrokeCap.round,
                                          progressColor: Colors.green[700],
                                          ),
                                              //  new LinearPercentIndicator(
                                              //   width: 100.0,
                                              //   lineHeight: 8.0,
                                              //   percent:  percentage[index],//snapshot.data[index]/100.toDouble(),//0.1 ,//percentage[index],//snapshot.data/100.toDouble(), //getperc.toDouble(),
                                              //   progressColor: Colors.green,
                                              // ),
                                              SizedBox(width: 10,),
                                            // Text(per.toString())
                                             // Text( snapshot.data == null? "0": snapshot.data.toString() + " %" , style: TextStyle(fontSize: 12), )
                                            ],
                                          );
                                         // });
                                        }),
                                  )
                               // }),
                                ],
                              );
                            },
                            // separatorBuilder:
                            //     (BuildContext context,
                            //     int index) =>
                            // const Divider(),
                          )),
                    )
                        : _saveAsFileName != null
                        ? ListTile(
                      title: const Text('Save file'),
                      subtitle: Text(_saveAsFileName!),
                    )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _upload( File asset) async {
    String? result;
    print("upload"+asset.path);
    // File img = await getImageFileFromAssets(asset.identifier!);
    // if (result == null) {
      //print(asset.uri);
   // if (isLoading == false) {
    try {
      print("try upload");
      for(int i=0; i<1;i++) {
        result = await _simpleS3.uploadFile(
          asset,
          "poc-flutter",
          "us-east-1:c17b7c5f-a98f-45fc-bd64-9183a551e031",
          AWSRegions.usEast1,
          debugLog: true,
          s3FolderPath: "test",
          // useTimeStamp: true,
          accessControl: S3AccessControl.private,
        );
        print("result");
        if (result != null) {
          print("result not null");
          setState(() {
            x = true;
            uploaded = true;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print(e);
   // }
    }
    return result;
  }
}


class getfiledetails {
  List pathname;
  dynamic percentage;

  getfiledetails(this.pathname, this.percentage);

  @override
  String toString() {
    return '{ ${this.pathname}, ${this.percentage} }';
  }
}

