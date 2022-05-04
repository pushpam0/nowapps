import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../event/React_on_event.dart';

class CartItem extends StatefulWidget {
  const CartItem({Key? key}) : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  List<Map> list = [];
  double total_price=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItemFromCart();
  }

  Future<void> getItemFromCart() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'cart.db');
    Database database = await openDatabase(path, version: 1);
    List<Map> list2 = await database.rawQuery('SELECT * FROM Cart');
    setState(() {
      list = list2;
    });
    print(list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:list.isEmpty!=true? ListView.builder(itemCount: list.length,itemBuilder: (context, index) {
        total_price+=double.parse(list[index]["Total_Price"]);
        return Card(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Product Name : ${list[index]["Product_Name"]}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Total Price : ${list[index]["Total_Price"]} /-",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Added Quantity : ${list[index]["Quantity"]}",
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                InkWell(
                    onTap: () {
                      deleteCartStatus(list[index]["id"]).then((value){
                        if(value==true){
                          getItemFromCart();
                        }
                      });
                      /* Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>ProductDetails(id: list[index]["id"])),
                    );*/
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    )),
              ]),
            ]),
          ),
        );
      }):const Center(child: Text("No Item please add")),
      floatingActionButton:FloatingActionButton.extended(
        onPressed: (){
          showAlertDialog(context,total_price,list.length);
        },
        label: Text("Take order"),

      ),
    );
  }
  showAlertDialog(BuildContext context,double price,int len) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("Check Out",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),),
      onPressed: () async{
        var databasesPath = await getDatabasesPath();
        String path = join(databasesPath, 'cart.db');
        Database database = await openDatabase(path, version: 1);
        await database.rawQuery("delete from Cart");

        String path2 = join(databasesPath, 'checkin.db');
        Database database2 = await openDatabase(path2, version: 1);
        await database2.rawQuery("delete from Check_In");
        getItemFromCart();
        price=0;
        total_price=0;
        Navigator.pop(context);
        finalAlertDialog(context,"You have Successfully placed an order. Your Retailer and cart item erased. Thank you Visit Again! ");

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(

      content: SizedBox(height: 100,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Total number of item : $len"),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Total cost of an item : $price"),
            ),
          ],
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  finalAlertDialog(BuildContext context,String msg) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Congratulation!!!"),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


}
