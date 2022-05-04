import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../event/React_on_event.dart';
import '../models.dart';
import 'product_list.dart';

class HomePageDesign extends StatefulWidget {
  const HomePageDesign({Key? key}) : super(key: key);

  @override
  _HomePageDesignState createState() => _HomePageDesignState();
}

class _HomePageDesignState extends State<HomePageDesign> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: RetailerModel().retailers.length,
          itemBuilder: (context, index) {
            return Card(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Brand : ${RetailerModel().retailers[index]["Brand"]}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Shop Name : ${RetailerModel().retailers[index]["ShopName"]}",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Owner Name : ${RetailerModel().retailers[index]["OwnerName"]}",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Mobile : ${RetailerModel().retailers[index]["Mobile"]}",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "City : ${RetailerModel().retailers[index]["City"]}",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "State : ${RetailerModel().retailers[index]["State"]}",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Address : ${RetailerModel().retailers[index]["Address"]}",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: ()  async {

                               await insertCheckInStatus(index).then((value){
                                 if(value==true){
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) =>
                                         const ProductList()),
                                   );
                                 }
                                 else
                                   print("insert status exception");
                               });

                              },
                              child: Text(
                                "Check In",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ))
                        ],
                      )
                    ]),
              ),
            );
          }),
    );
  }
}
