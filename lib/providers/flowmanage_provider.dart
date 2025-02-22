import 'package:cookethflow/core/utils/utils.dart';
import 'package:cookethflow/models/flow_manager.dart';
import 'package:cookethflow/models/user.dart';

class FlowmanageProvider extends StateHandler {
  UserModel user = UserModel();
  Map<String, FlowManager> _flowList = {"1": FlowManager(flowId: "1")};
  String _newFlowId = "";
  FlowmanageProvider(): super();

  Map<String, FlowManager> get flowList => _flowList;
  String get newFlowId => _newFlowId;

  void recentFlowId(String val) {
    _newFlowId = val;
    notifyListeners();
  }

  // void updateList() {
  //   flowManager.nodes.addAll(_nodeList);
  //   connections = flowManager.connections.toList();
  // flowManager.connections.addAll(connections);
  // print("Updated Connections: ${flowManager.connections}");
  //   print(flowManager.exportFlow());
  //   notifyListeners();
  // }

  void addFlow() {
    FlowManager flowm = FlowManager(flowId: (_flowList.length + 1).toString());
    user.createFlow(flowm);
    _flowList.addAll({flowm.flowId: flowm});
    print(user.exportUser());
    notifyListeners();
  }
}
