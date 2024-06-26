/// Based on [`dijkstra`](https://pub.dev/packages/dijkstra) library

import 'package:flutter/material.dart';
import 'package:webspark_test/model/index.dart';
import 'package:webspark_test/screens/index.dart';
import 'package:webspark_test/widgets/index.dart';

class PathFinderWidget extends StatefulWidget {
  final Function(Screen screen) nextScreen;
  final List<Data> data;
  
  const PathFinderWidget({super.key, required this.data, required this.nextScreen});

  @override
  State<PathFinderWidget> createState() => _PathFinderWidgetState();
}

class _PathFinderWidgetState extends State<PathFinderWidget> {
  late List<Data> data;

  double completionPercentage = 0.0;
  int taskNumber = 0;
  int nodes = 1;
  int result = 0;
  String text = "";
  bool sendButton = false;

  @override 
  void initState() {
    super.initState();
    data = widget.data;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < data.length; i++) {
        taskNumber = i+1;

        List<Cell> shortestPath = findPath(data[i]);
        data[i].shortestPath = shortestPath;
      }
      
      completionPercentage = 1.0;
      text = "All calculations has finished, you can send your results to server\n\n100%";
      sendButton = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(child: Text('')),
              Text(text, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              CircularProgressIndicator(value: completionPercentage),
              sendButton
                ? BottomButton(
                    label: 'Send results to server', 
                    onPressed: () => widget.nextScreen(ResultScreen(
                      results: data,
                      nextScreen: widget.nextScreen,
                    )),
                  )
                : const Expanded(child: Text('')),
            ],
          )
        ],
      ),
    );
  }

  List<Cell> findPath(Data data) {
    return _findPath(data.grid.pairsRaw(), data.start, data.end).cast<Cell>();
  }

  List _findPath(List<List> list, start, end) {
    var graph = _pairsListToGraphMap(list);
    var predecessors = _singleSourceShortestPaths(graph, start, end);

    nodes = graph.length;
    result = 0;

    return _extractShortestPathFromPredecessorList(predecessors, end);
  }

  Map _singleSourceShortestPaths(graph, s, end) {
    /// Predecessor map for each node that has been encountered.
    /// node ID => predecessor nodsleep(Duration(seconds:1));e ID
    var predecessors = {};

    /// Costs of shortest paths from s to all nodes encountered.
    /// node ID => cost
    var costs = {};
    costs[s] = 0;

    /// Costs of shortest paths from s to all nodes encountered; differs from
    /// `costs` in that it provides easy access to the node that currently has
    /// the known shortest path from s.
    var open = PriorityQueue();
    open.add(s, 0);

    var closest,
        u,
        costOfSToU,
        adjacentNodes,
        costOfE,
        costOfSToUPlusCostOfE,
        costOfSToV,
        firstVisit;
    while (!open.empty()) {
      /// In the nodes remaining in graph that have a known cost from s,
      /// find the node, u, that currently has the shortest path from s.
      closest = open.pop();
      u = closest?["value"];
      costOfSToU = closest["cost"];

      /// Get nodes adjacent to u...
      adjacentNodes = graph[u] ?? {};

      /// ...and explore the edges that connect u to those nodes, updating
      /// the cost of the shortest paths to any or all of those nodes as
      /// necessary. v is the node across the current edge from u.
      (adjacentNodes as Map).forEach((v, value) {
        if (adjacentNodes?[v] != null) {
          /// Get the cost of the edge running from u to v.
          costOfE = adjacentNodes[v];

          /// Cost of s to u plus the cost of u to v across e--this is *a*
          /// cost from s to v that may or may not be less than the current
          /// known cost to v.
          costOfSToUPlusCostOfE = costOfSToU + costOfE;

          /// If we haven't visited v yet OR if the current known cost from s to
          /// v is greater than the new cost we just found (cost of s to u plus
          /// cost of u to v across e), update v's cost in the cost list and
          /// update v's predecessor in the predecessor list (it's now u).
          costOfSToV = costs[v];
          firstVisit = costs[v] == null;
          if (firstVisit || costOfSToV > costOfSToUPlusCostOfE) {
            costs[v] = costOfSToUPlusCostOfE;
            open.add(v, costOfSToUPlusCostOfE);
            predecessors[v] = u;
          }
        }
      });

      setState(() {
        result++;
        completionPercentage = result/nodes;
        text = "Task $taskNumber\n\n${(completionPercentage*100).toInt()}%";
      });

      Future.delayed(const Duration(milliseconds: 50));
    }

    return predecessors;
  }

  /// Extract shortest path from predecessor list
  List _extractShortestPathFromPredecessorList(predecessors, end) {
    var nodes = [];
    var u = end;
    while (u != null) {
      nodes.add(u);
      u = predecessors[u];
    }
    if (nodes.length == 1) return [];
    return nodes.reversed.toList();
  }

  /// Input: [[0, 2], [3, 4], [0, 6], [5, 6], [2, 3], [0, 1], [0, 4], [0, 113], [113, 114], [111, 112]]
  ///
  /// OutPut:  {0: {2: 1, 6: 1, 1: 1, 4: 1, 113: 1}, 2: {0: 1, 3: 1}, 6: {0: 1, 5: 1}, 1: {0: 1}, 4: {0: 1, 3: 1}, 113: {0: 1, 114: 1}, 3: {2: 1, 4: 1}, 5: {6: 1}, 114: {113: 1}, 111: {112: 1}, 112: {111: 1}}
  Map _pairsListToGraphMap(List<List> data) {
    Map layout = {};
    Map graph = {};
    Set ids = {};
    for (var element in data) {
      ids.addAll(element);
    }

    for (var id in ids) {
      layout[id] = data
          .where((e) => e.contains(id))
          .map((e) => e.firstWhere((x) => x != id))
          .toList();
    }

    layout.forEach((id, value) {
      if (graph[id] == null) graph[id] = {};
      layout[id].forEach((aid) {
        graph[id][aid] = 1;
        if (graph[aid] == null) graph[aid] = {};
        graph[aid][id] = 1;
      });
    });
    return graph;
  }
}

class PriorityQueue {
  List queue = [];
  PriorityQueue();

  /// Add a new item to the queue and ensure the highest priority element
  /// is at the front of the queue.
  add(value, cost) {
    var item = {"value": value, "cost": cost};
    queue.add(item);
    queue.sort((a, b) {
      return a["cost"] - b["cost"];
    });
  }

  ///
  /// Return the highest priority element in the queue.
  pop() {
    return queue.removeAt(0);
  }

  bool empty() {
    return queue.isEmpty;
  }
}
