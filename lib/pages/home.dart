import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_app/list_function/Model/list_model.dart';
import 'package:grocery_list_app/list_function/Service/grocery_database_service.dart';
import 'package:grocery_list_app/list_function/list_dialogue.dart';
import 'package:grocery_list_app/loader.dart';
import 'package:grocery_list_app/invite.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _GroceryListState();
}

class _GroceryListState extends State<HomeScreen> {
  TextEditingController groceryTitleController = TextEditingController();
  StreamSubscription<Uri>? _linkSub;

  @override
  void initState() {
    super.initState();
    InviteService.initLinkHandling(context).then((subscription) {
      _linkSub = subscription;
    });
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text('User Profile'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      })
                    ],
                    children: [
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child:
                              Image.asset('Icon_Images/Shopping Cart Icon.jpg'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: SafeArea(
            child: StreamBuilder<List<GroceryModel>>(
                stream: GroceryDatabaseService().listGrocery(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Loader();
                  }
                  List<GroceryModel>? grocery = snapshot.data;

                  return Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Grocery List",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Divider(color: Colors.black),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: grocery!.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: Key(grocery[index].uid),
                              background: Container(
                                alignment: Alignment.centerLeft,
                                color: Colors.red,
                                child: const Icon(Icons.delete),
                              ),
                              onDismissed: (direction) async {
                                await GroceryDatabaseService()
                                    .deleteItem(grocery[index].uid);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  child: ListTile(
                                    onTap: () {
                                      bool newCompleteItem =
                                          !grocery[index].isCompleted;
                                      GroceryDatabaseService().updateItem(
                                          grocery[index].uid, newCompleteItem);
                                    },
                                    leading: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: grocery[index].isCompleted
                                          ? const Icon(Icons.check,
                                              color: Colors.white)
                                          : Container(),
                                    ),
                                    title: Text(
                                      grocery[index].title,
                                      style: const TextStyle(
                                        fontSize: 23,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        Center(
                          // <-- NEW: Center the Invite Button
                          child: ElevatedButton.icon(
                            onPressed: () {
                              InviteService.shareInviteLink(
                                  context); // <-- NEW: share the universal link
                            },
                            icon: Icon(Icons.link),
                            label: Text('Share Invite Link'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: ((context) => ListDialogue(
                  groceryTitleController: groceryTitleController)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
