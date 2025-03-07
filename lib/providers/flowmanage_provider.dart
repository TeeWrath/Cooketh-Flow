import 'dart:io';
import 'package:cookethflow/core/services/supabase_service.dart';
import 'package:cookethflow/core/utils/state_handler.dart';
import 'package:cookethflow/models/connection.dart';
import 'package:cookethflow/models/flow_manager.dart';
import 'package:cookethflow/models/flow_node.dart';
import 'package:cookethflow/models/user.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FlowmanageProvider extends StateHandler {
  late final SupabaseService supabaseService;
  late final SupabaseClient supabase;
  final Map<String, FlowManager> _flowList = {};
  String _newFlowId = "";
  bool _isLoading = true;

  FlowmanageProvider(this.supabaseService) : super() {
    supabase = supabaseService.supabase;
    _initializeUser();
  }

  Map<String, FlowManager> get flowList => _flowList;
  String get newFlowId => _newFlowId;
  bool get isLoading => _isLoading;

  void recentFlowId(String val) {
    if (_newFlowId != val) {
      _newFlowId = val;
      notifyListeners();
    }
  }

  Future<void> _initializeUser() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      var res = await supabaseService.fetchCurrentUserDetails();
      if (res == null) {
        print('No authenticated user found during initialization');
        _isLoading = false;
        notifyListeners();
        return;
      }

      if (res['flowList'] != null) {
        // Clear existing flow list to avoid duplicates
        _flowList.clear();
        
        // Parse the database flow list
        Map<String, dynamic> dbFlowList = Map<String, dynamic>.from(res['flowList']);
        
        print("Fetched flowList from DB: $dbFlowList");
        
        // Create FlowManager objects from each flow in the database
        dbFlowList.forEach((flowId, flowData) {
          try {
            FlowManager flowManager = FlowManager.fromJson(flowData, flowId);
            _flowList[flowId] = flowManager;
            
            // If we have at least one flow, set it as the current one
            if (_newFlowId.isEmpty) {
              _newFlowId = flowId;
            }
          } catch (e) {
            print('Error parsing flow $flowId: $e');
          }
        });
        
        print("Loaded ${_flowList.length} flows");
      } else {
        print("No flows found in user data");
      }
    } catch (e) {
      print('Error initializing user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateFlowList() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      var currentUser = supabase.auth.currentUser;

      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      // Create a serializable map of all flows
      final Map<String, dynamic> flowListJson = {};
      _flowList.forEach((key, value) {
        flowListJson[key] = value.exportFlow();
      });
      
      print("Updating flow list to Supabase: $flowListJson");

      // Update the database
      await supabase
          .from('User')
          .update({'flowList': flowListJson})
          .eq('id', currentUser.id);
          
      print("Flow list updated successfully");
    } catch (e) {
      print('Error updating flow list: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFlow() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      var currentUser = supabaseService.userData;

      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      // Generate a unique ID for the new flow
      final String newFlowId = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Create a new flow with the generated ID
      FlowManager flowManager = FlowManager(
        flowId: newFlowId,
        flowName: "New Project",
        // Create a default node for the new project
        nodes: {
          "1": FlowNode(
            id: "1",
            type: NodeType.rectangular,
            position: Offset(100, 100),
          )
        }
      );
      
      // Add the flow to the local list
      _flowList[newFlowId] = flowManager;
      
      // Set this as the current flow
      recentFlowId(newFlowId);
      
      // Update the database with the new flow
      await updateFlowList();
      
      print("New flow created with ID: $newFlowId");
    } catch (e) {
      print('Error adding flow: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshFlowList() async {
    await _initializeUser();
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}