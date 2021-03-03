import 'package:flutter/material.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/storeActivity/storeActivityEdit.dart';

class StoreActivityAdd extends StatefulWidget {
  @override
  _StoreActivityAddState createState() => _StoreActivityAddState();
}

class _StoreActivityAddState extends State<StoreActivityAdd> {
  List title = ['充值优惠', '项目次卡'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1,
          brightness: Brightness.light,
          title: Text(
            '门店活动',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: ScrollConfiguration(
            behavior: NeverScrollBehavior(),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: title.length,
                itemBuilder: (BuildContext context, int item) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoreActivityEdite(
                                    title: item == 0 ? '充值优惠' : '项目次卡',
                                  )));
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 30,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    title[item],
                                    style: TextStyle(
                                        color: Color.fromRGBO(30, 30, 30, 1),
                                        fontSize: 15),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Color.fromRGBO(30, 30, 30, 1),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                })));
  }
}
