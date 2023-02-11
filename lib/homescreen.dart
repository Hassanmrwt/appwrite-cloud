import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:newjourney/client.dart';
import 'package:newjourney/getImage.dart';
import 'package:newjourney/login.dart';

class HomeScreen extends StatefulWidget {
  String email;
  HomeScreen({super.key, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // dynamic _image;
  String path = '';
  String name = '';
  bool loaded = false;
  File? file;

  String? imageName;

  _pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (result != null) {
      setState(() {
        isAvatarUpdatedEarlier = false;
        loaded = true;
        file = File(result.files.first.path!);
        imageName = result.files.first.name;
        path = result.files.first.path!;
      });
    }
  }

  Future? res;
  Storage storage = Storage(MyClient().myCleint);
  // bool showMore = false;
  // String fileId = '';
  uploadImage() async {
    String fileId = widget.email.replaceAll(RegExp('[^a-zA-Z0-9]'), '1');
    res = storage
        .createFile(
            bucketId: '63e526c56e046de379ad',
            fileId: fileId,
            file: InputFile(path: path, filename: imageName))
        .then((value) => updateAvatorId(fileId));
  }

  updateAvatorId(String fileId) async {
    print('File New saving file id is\n $fileId');
    String docId = await getDocuInWhichAvatorIdTobeUpdated();
    databases.updateDocument(
        databaseId: '63e66d9679c6efa71597',
        collectionId: "63e67ccc28b8cb918799",
        documentId: docId,
        data: {"avatorId": fileId});
  }

  String? result;
  getDocuInWhichAvatorIdTobeUpdated() async {
    String search = await databases.listDocuments(
        databaseId: '63e66d9679c6efa71597',
        collectionId: "63e67ccc28b8cb918799",
        queries: [
          Query.equal('email', widget.email)
        ]).then((res) => result = res.documents.first.$id);
    if (result != null) {
      return search;
    }
  }

  Databases databases = Databases(MyClient().myCleint);
  String? secResult;
  getUserDocIdForStoringFileId() async {
    String userdocId = await databases.listDocuments(
        databaseId: '63e66d9679c6efa71597',
        collectionId: "63e67ccc28b8cb918799",
        queries: [
          Query.equal('email', widget.email)
        ]).then((res) => secResult = res.documents.first.data["docId"]);
    if (secResult != null) {
      print('print user doc id \n $userdocId');
      return userdocId;
    }
  }

  dynamic myPic;
  bool isAvatarUpdatedEarlier = false;
  String? thridresult;
  checkIfAvatorWasUpdatedEarlier() async {
    String id = await getUserDocIdForStoringFileId();
    String avatarID = await databases
        .getDocument(
            databaseId: '63e66d9679c6efa71597',
            collectionId: "63e67ccc28b8cb918799",
            documentId: id)
        .then((res) => thridresult = res.data["avatorId"]);
    if (thridresult != null) {
      setState(() {
        isAvatarUpdatedEarlier = true;
      });
      print("print avator ID \n $id");
    } else {
      print('Nothing Found');
    }
  }

  Account account = Account(MyClient().myCleint);
  logOut() async {
    account.deleteSessions().whenComplete(() => Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen())));
  }

  @override
  void initState() {
    checkIfAvatorWasUpdatedEarlier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Appwrite Cloud'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              logOut();
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.blue),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  _pickImage();
                },
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  // maxRadius: 30,
                  radius: 100,
                  child: isAvatarUpdatedEarlier
                      ? CircleAvatar(
                          backgroundColor: Colors.cyanAccent,
                          radius: 110,
                          child: SizedBox(
                            width: 190,
                            height: 190,
                            child: ClipOval(
                                child: FutureBuilder(
                              future: storage.getFileView(
                                  bucketId: '63e526c56e046de379ad',
                                  fileId: widget.email.replaceAll(
                                      RegExp('[^a-zA-Z0-9]'),
                                      '1')), //works for both public file and private file, for private files you need to be logged in
                              builder: (context, snapshot) {
                                return snapshot.hasData && snapshot.data != null
                                    ? Image.memory(
                                        snapshot.data!,
                                        fit: BoxFit.fill,
                                      )
                                    : const Center(
                                        child: Text('Loading Avatar'));
                              },
                            )),
                          ),
                        )
                      : file != null
                          ? CircleAvatar(
                              backgroundColor: Colors.cyanAccent,
                              radius: 110,
                              child: SizedBox(
                                width: 190,
                                height: 190,
                                child: ClipOval(
                                  child: Image.file(
                                    file!,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            )
                          : const Center(child: Text('Avatar')),
                ),
              ),
              loaded
                  ? ElevatedButton(
                      onPressed: () {
                        uploadImage();
                      },
                      child: const Text('Save'))
                  : const SizedBox(),
              const Divider(
                height: 20,
              ),
              // BannerWidget()
            ],
          ),
        ),
      ),
    );
  }
}
