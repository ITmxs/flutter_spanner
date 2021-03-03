import 'package:flutter/material.dart';
import '../../cModel/recCarModel.dart';

class CarNameList extends StatefulWidget {
  final int type; //此处传 1 代表展示配件列表 传入其他代表的是二级服务列表
  final List dataList;
  final ValueChanged<Map> onChanged;
  const CarNameList({Key key, this.dataList, this.onChanged, this.type})
      : super(key: key);
  @override
  _CarNameListState createState() => _CarNameListState();
}

class _CarNameListState extends State<CarNameList> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(
                widget.dataList.length,
                (index) => InkWell(
                    onTap: () {
                      /* 点击后 集合上传数据 */
                      widget.onChanged(widget.dataList[index]);
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(child: SizedBox()),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                widget.type == 1
                                    ? widget.dataList[index]['goodsName']
                                    : RecCarModel.fromJson(
                                            widget.dataList[index])
                                        .dictName
                                        .toString(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ))),
          ),
        ),
      ],
    );
  }
}
