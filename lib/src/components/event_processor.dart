import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_cluster/simple_cluster.dart';

import '../models/cluster_path.dart';
import '../models/page.dart';

/// Signature for the cluster layer scaling function
typedef ScaleFunction = double Function(double level, double scaleFactor);

/// Processes touch events into drawable path layers using clustering
class EventProcessor {
  /// [Config.uiElementSize]
  final double pointProximity;

  /// Specifies the cluster [Path] scale in relation to the [pointProximity]
  final double clusterScale; // 0.5 - 1.5
  /// [HeatMapPage] being processed
  final List<Offset> events;

  final _paths = <ClusterPath>[];
  DBSCAN _dbScan;

  /// Size of the largest cluster in this [HeatMapPage]
  late int largestCluster;

  /// Size of the smallest cluster in this [HeatMapPage]
  late int smallestCluster;

  /// Creates a [EventProcessor] that processes events into paths
  EventProcessor({
    required this.events,
    required this.pointProximity,
    this.clusterScale = 0.5,
  }) : _dbScan = DBSCAN(epsilon: pointProximity);

  Future<void> init() async {
    var dbPoints = events.map<List<double>>((e) => [e.dx, e.dy]).toList();

    _dbScan = await compute<List<List<double>>, DBSCAN>(
      (List<List<double>> args) async {
        _dbScan.run(args);

        return _dbScan;
      },
      dbPoints,
    );

    _createClusterPaths();

    var sizes = _dbScan.cluster.map((e) => e.length);
    largestCluster = sizes.isNotEmpty ? sizes.reduce(max) : 1;
    smallestCluster = _dbScan.noise.isNotEmpty ? 1 : sizes.reduce(min);
  }

  /// Creates a path for the given [layer] using a [scaleFunc]
  Path getPathLayer(
    double layer, {
    ScaleFunction scaleFunc = _logBasedLevelScale,
  }) {
    var joinedPath = Path();
    var paths = _paths.where((p) => p.clusterSize / largestCluster >= layer);
    for (var cluster in paths) {
      var scaleInput = cluster.clusterSize - layer * largestCluster;
      var transform = Matrix4.identity()
        ..translate(cluster.center.dx, cluster.center.dy)
        ..scale(scaleFunc(scaleInput, 1 / clusterScale))
        ..translate(-cluster.center.dx, -cluster.center.dy);
      var path = cluster.path.transform(transform.storage);
      joinedPath = Path.combine(PathOperation.union, joinedPath, path);
    }
    return joinedPath;
  }

  void _createClusterPaths() {
    var pointRadius = pointProximity * 0.75;
    for (var cluster in _dbScan.cluster) {
      var clusterPath = Path();
      for (var pointIndex in cluster) {
        var pointPath = _eventPath(events[pointIndex], pointRadius);
        clusterPath = Path.combine(PathOperation.union, clusterPath, pointPath);
      }
      _paths.add(ClusterPath(
        path: clusterPath,
        points: cluster.map((e) => events[e]).toList(),
      ));
    }
    ClusterPath simpleCluster(index) => ClusterPath(
          path: _eventPath(events[index], pointRadius),
          points: [events[index]],
        );
    _paths.addAll(_dbScan.noise.map(simpleCluster));
  }

  static double _logBasedLevelScale(double level, double scaleFactor) =>
      1 + log(level + 0.5 / scaleFactor) / scaleFactor;

  /// Creates a [Path] from this [Event]
  Path _eventPath(Offset location, double radius) =>
      Path()..addOval(Rect.fromCircle(center: location, radius: radius));
}
