/*
   销售任务 首页 model 定义
*/
class SalesModel {
  final String taskName; //---> 任务名
  final double total; //---> 总任务量
  final double complete; //---> 已完成任务量

  SalesModel(this.taskName, this.total, this.complete);
  SalesModel.fromJson(Map<String, dynamic> json)
      : taskName = json['taskName'],
        total = json['total'],
        complete = json['complete'];
  Map<String, dynamic> toJson() =>
      {'taskName': taskName, 'total': total, 'complete': complete};
}

/*
   销售任务 审核 model 定义
*/
class SalesReviewModel {
  final String id; //---> id
  final String completeTime; //状态时间
  final String realName; //---> 员工姓名
  final String taskName; //任务名称
  final String amount; //销售额
  final String updateTime; //---> 完成时间
  final status; //状态

  SalesReviewModel(this.id, this.completeTime, this.realName, this.taskName,
      this.amount, this.updateTime, this.status);
  SalesReviewModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        completeTime = json['completeTime'],
        taskName = json['taskName'],
        amount = json['amount'].toString(),
        updateTime = json['updateTime'],
        status = json['status'],
        realName = json['realName'];
  Map<String, dynamic> toJson() => {
        'id': id,
        'completeTime': completeTime,
        'taskName': taskName,
        'amount': amount,
        'updateTime': updateTime,
        'status': status,
        'realName': realName
      };
}
