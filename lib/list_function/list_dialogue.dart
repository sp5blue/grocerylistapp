import 'package:flutter/material.dart';
import 'package:grocery_list_app/list_function/Service/grocery_database_service.dart';

class ListDialogue extends StatelessWidget {
  const ListDialogue({super.key, required this.groceryTitleController});
  final TextEditingController groceryTitleController;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 19),
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Text(
            "Add Grocery Item",
            style: TextStyle(
                fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Spacer(),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.cancel,
                color: Colors.black,
              ))
        ],
      ),
      children: [
        TextFormField(
          controller: groceryTitleController,
          style: TextStyle(fontSize: 20, color: Colors.white),
          autofocus: true,
          decoration: const InputDecoration(
              hintText: "eg. Milk", hintStyle: TextStyle(color: Colors.white)),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 40,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
              onPressed: () async {
                if (groceryTitleController.text.isNotEmpty) {
                  await GroceryDatabaseService()
                      .createNewItem(groceryTitleController.text.trim());
                }

                Navigator.pop(context);

                groceryTitleController.clear();
              },
              child: const Text("Add")),
        )
      ],
    );
  }
}
