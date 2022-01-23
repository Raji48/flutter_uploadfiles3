
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multiplevideo/pickfile/imagepicker.dart';
import 'package:multiplevideo/skeleton_container.dart';
import 'package:simple_s3/simple_s3.dart';

class Skeletonview extends StatefulWidget {
  const Skeletonview({Key? key}) : super(key: key);

  @override
  _SkeletonviewState createState() => _SkeletonviewState();
}

class _SkeletonviewState extends State<Skeletonview> {
  bool loading = true;
  SimpleS3 _simpleS3 = SimpleS3();
  @override
  void initState() {
    super.initState();
    loadData();
    //callupload();
  }

  callupload()async{
    if (pathlist!.length > 0)  {
      for (var path in pathlist!) {
        asset = File(path);
        await _upload(asset!);
        indexvalue = indexvalue+1;
        print(indexvalue);
        print("upload donee");
        print(path);
        // file.deleteSync();
      }
      print("completed successfully");
      setState(() {
        loading = false;
      });
    }
  }


  Future loadData() async {
    setState(() {
      loading = true;
    });

    await Future.delayed(Duration(seconds: 2), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("homepage"),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: loadData,
        ),
      ],
    ),
    body: ListView.separated(
      padding: const EdgeInsets.all(12),
      scrollDirection: Axis.vertical,
      separatorBuilder: (context, index) => Divider(),
      itemCount: pathlist!.length,
      itemBuilder: (BuildContext context, int index) =>
      loading ? buildSkeleton(context) : buildResult(index),
    ),
  );

  Widget buildSkeleton(BuildContext context) => Row(
    children: <Widget>[
      SkeletonContainer.square(
        width: 70,
        height: 70,
      ),
      const SizedBox(width: 16),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SkeletonContainer.rounded(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 25,
          ),
          const SizedBox(height: 8),
          SkeletonContainer.rounded(
            width: 60,
            height: 13,
          ),
        ],
      ),
    ],
  );

  Widget buildResult(int index) => Row(
    children: <Widget>[
      Container(
        child: //File assetimage = File(pathlist[index]);
        Image.file(File(pathlist![index]),
     //   Image.network(
       //   'https://images.unsplash.com/photo-1508697014387-db70aad34f4d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80',
          width: 70,
          height: 70,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(width: 16),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            pathName![index].toString(),
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            'updated',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    ],
  );

  Future<String?> _upload(File asset) async {
    String? result;
    print("upload" + asset.path);
    try {
      print("try upload");
      result = await _simpleS3.uploadFile(
        asset,
        "poc-flutter",
        "us-east-1:c17b7c5f-a98f-45fc-bd64-9183a551e031",
        AWSRegions.usEast1,
        debugLog: true,
        s3FolderPath: "test",
        useTimeStamp: true,
        accessControl: S3AccessControl.private,
      );
      print("result");

      if (result != null) {
        print("result not null");
        // setState(() {
        //   x = true;
        //   uploaded = true;
        //   isLoading = false;
        // });
      }
    } catch (e) {
      print(e);
      // }
    }
    return result;
  }
}