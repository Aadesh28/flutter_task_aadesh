
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multiple_images_picker/multiple_images_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_task_aadesh/ui/dashboard_bloc.dart';
import '../network/status_manger.dart';
import '../resuable_widget/divider.dart';
import '../resuable_widget/elevated_button.dart';
import '../resuable_widget/new_diary_list_card.dart';

import '../widget/common_function.dart';

class NewDiaryScreen extends StatefulWidget {
  const NewDiaryScreen({super.key});
  @override
  State<NewDiaryScreen> createState() => _NewDiaryScreenState();
}

class _NewDiaryScreenState extends State<NewDiaryScreen> {
  
  int index = 0;
  bool checked = false;
  bool checkedEvent = false;
  final bloc = DashboardBloc();
  List<Asset> images = <Asset>[];
  List<File> fileImages = <File>[];
 

// Function to request gallery permission
 void requestGalleryPermission() async {

    // Request permission if not granted
    final PermissionStatus result = await Permission.storage.request();

      if (result == PermissionStatus.granted) {
      pickAssets();
    } else if (result.isPermanentlyDenied) {
      if (mounted) {
        CommonFunction()
            .confirmationDialog(context, 195, '', () => null, content: '');
      }
    }
  }

  // Function to pick images from gallery
  Future<void> pickAssets() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultipleImagesPicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
      );
    } on Exception catch (e) {
      // ignore: avoid_print
      print('--image-picker-err--${e.toString()}');
    }
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  // Function to convert Assets to Files

  Future<List<File>> convertAssetsToFiles(List<Asset> assets) async {
    List<File> files = [];

    for (Asset asset in assets) {
      ByteData byteData = await asset.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();

      // Get a temporary directory for storing files
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      // Generate a unique file name
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Create a new File and write the image data to it
      File file = File('$tempPath/$fileName.png');
      await file.writeAsBytes(imageData);

      files.add(file);
    }

    return files;
  }
  
  @override
  Widget build(BuildContext context) {   
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        leading: IconButton(icon: const Icon(Icons.close), color: Colors.white, onPressed: (){},),
        title: const Text('New Diary', style: TextStyle(fontSize: 32),),
        foregroundColor:  Colors.white,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      ),


      // Create a StreamBuilder to listen for the status of the API call

      body: StreamBuilder<ApiResponse>(
      stream: bloc.responseStream,  
      builder: (context, snapshot) {
        if(snapshot.data?.status == Status.loading) {
        // If the API call is loading, show a loading indicator
          return const CircularProgressIndicator();
        }
        else if(snapshot.data?.status == Status.success) {
          // If the API call was successful, show the success message
          return const Text('Success!');  
        }
        return CustomScrollView(
           slivers: [
          SliverList(delegate: SliverChildListDelegate([
            _mainBody()
          ] )),
        ],
      );
      }
    ),
    );
  }

Widget _mainBody() {
  return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
           
            _locationDetail(),
          
            Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: Container(
                 width: MediaQuery.of(context).size.width,
                color: const Color.fromRGBO(220,220,220, 0.4),
                child: Column(children: [
                    _scaffoldHeader(),
                    _photoSelectionCard(),
                    _commentsCard(),
                    _detailsCard(),
                    _eventSelectionCard(),
                    _nextButton(),    
                ]),
              ),
            )
          ],
        );
}

//Location Detail Text Widget
Widget _locationDetail(){
  return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [
                 IconButton(icon: const Icon(Icons.location_on),onPressed: (){},),
                 const Text('20041075 | TAP-NS TAP-North Strathfield',style: TextStyle(color: Colors.grey),),
              ],);
}

// Add to diary Text header Widget
Widget _scaffoldHeader()
{
  return  const Padding(
                     padding: EdgeInsets.fromLTRB(20,20,0,0),
                     child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Add to site diary',style: TextStyle(fontSize: 26)),),
                   );
}


// Photo selection Card Widget
Widget _photoSelectionCard() {
    return Container(
      constraints: const BoxConstraints(minHeight: 240, maxHeight: 500),
      child: DiaryCard(
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Add Photos to site diary',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(97, 97, 97, 1)),
              ),
            ),
          ),
          const HorizontalDivider(
            paddingTop: 20,
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(images.length, (index) {
                Asset asset = images[index];
                return Stack(
                  children: [
                    AssetThumb(
                      asset: asset,
                      width: 300,
                      height: 300,
                    ),
                    Positioned(
                        top: 5,
                        right: 5,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                images.removeAt(index);
                              });
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 25,
                              maxHeight: 25),
                            alignment: Alignment.center,
                            icon: Container(
                                height: 20,
                                width: 20,
                                decoration: const BoxDecoration(
                                    color: Colors.white, shape: BoxShape.circle),
                                child: const Icon(Icons.clear, size: 15))))
                  ],
                );
              }),
            ),
          ),
        
        //If the list is empty then pass an empty widget
          if (images.isEmpty) const Spacer(),
          CustomElevatedButton(
              key: const Key('add_photo_button'), 
              text: 'Add a photo',
              width: MediaQuery.of(context).size.width * 0.8,
              onPressed: () {
                requestGalleryPermission();
              }),
        
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text('Include in photo gallery'),
                ),
                IconButton(
                    onPressed: () {
                      toggle();
                    },
                    icon: checked
                        ? const Icon(
                            Icons.check_box,
                            color: Color.fromRGBO(165, 212, 66, 1),
                          )
                        : const Icon(Icons.check_box_outline_blank)),
              ],
            ),
          )
        ]),
      ),
    );
  }

//CommentS Card Widget
Widget _commentsCard() {
  return   DiaryCard(
                    height: 140,
                    child: Column( 
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [          
                         const Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child:  Text('Comments', textAlign: TextAlign.left,
                           style: TextStyle(fontSize: 20,),)),),  
        
                           Padding(
                             padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                             child: Container(height: 1,color: const Color.fromRGBO(220,220, 220, 0.8),
                                                    width: MediaQuery.of(context).size.width * 0.8,
                                                    ),
                           ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: const TextField(
                                cursorColor: Colors.white,
                                 decoration: InputDecoration(hintText: 'Comments'),
                            ),
                          ),
                        ]),
                      );
}


//Details Card Widget
Widget _detailsCard(){
  return   DiaryCard(
                    height: 380,
                    child: Column(    
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [          
                      const Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                      child:  Text('Details', textAlign: TextAlign.start,
                           style: TextStyle(fontSize: 20),),)),
                           Padding(
                             padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                             child: Container(height: 1,color: const Color.fromRGBO(220,220, 220, 0.8),
                                                    width: MediaQuery.of(context).size.width * 0.8,),
                           ), 
                             
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                                          child: const TextField(
                                decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.keyboard_arrow_down), 
                                      hintText: '2020-06-29'
                                    ),
                                    readOnly: true,
                                    cursorColor: Colors.white,
                                ),),
                              ),
                              
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                            child: const TextField(
                              decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.keyboard_arrow_down), 
                                    hintText: 'Select Area'
                                  ),
                                  readOnly: true,
                                  cursorColor: Colors.white,
                              ),),),
                    
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                            child: const TextField(
                              decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.keyboard_arrow_down), 
                                    hintText: 'Task Category'
                                  ),
                                  readOnly: true,
                                  cursorColor: Colors.white,
                              ))),
                          
                    
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                            child: const TextField(
                              decoration: InputDecoration(
                                    hintText: 'Tags'
                                  ),
                                  cursorColor: Colors.white,
                              ))),
                    
                        ]),
                      );
}

//Event Selection Card Widget
Widget _eventSelectionCard() {
  return  DiaryCard(
              height: 160,
              child: Column( 
                mainAxisAlignment: MainAxisAlignment.start,
                 children: [  
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  [ 
                             const Padding(
                                padding:  EdgeInsets.fromLTRB(20,0,0,0),
                                child:   Align(
                                   alignment: Alignment.topLeft,
                                  child: Text('Link to existing event?', textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                ),),
                              IconButton(onPressed: (){
                                  toggleEventCheckBox();
                                }, icon: checkedEvent ? const Icon(Icons.check_box, color: Color.fromRGBO(165, 212, 66, 1) ,) : const Icon(Icons.check_box_outline_blank) ),
                               ],),                       
                           
                           Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                             child: Container(height: 1,color: const Color.fromRGBO(220,220, 220, 0.8),
                                                    width: MediaQuery.of(context).size.width * 0.8,),
                           ),
                            
                            //INSTEAD OF A DROPDOWN I HAVE USED A TEXTFIELD WITH
                            // DOWN ARROW ICON TO FOCUS ON THE MAIN FUNCTIONALITY IN THE TASK
                          Padding(
                            padding:  const EdgeInsets.fromLTRB(0, 12, 0, 0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                            child: const TextField(
                              decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.keyboard_arrow_down), 
                                    hintText: 'Select an event'
                                  ),
                                  readOnly: true,
                                  cursorColor: Colors.white,
                              ),),
                          ),
                        ]),
                      );
}

// Next Button Widget
Widget _nextButton(){
 
  return Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                child: CustomElevatedButton(
                  key: const Key('next_button'), 
                  width: MediaQuery.of(context).size.width * 0.9,
                        text: "Next",
                        onPressed: () { 
                          bloc.makeRequest(fileImages);
                        },
                      )
              );
}

//Toggle method for checkbox to include in gallery module
void toggle() {
  setState(() {
    checked = !checked; 
  });
}

//Toggle method for checkbox in the event card to ling to existing event
void toggleEventCheckBox() {
  setState(() {
    checkedEvent = !checkedEvent; 
  });
}
}
