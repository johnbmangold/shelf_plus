import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Allows minor cross-OS font hinting and anti-aliasing rasterization
/// differences between macOS (local baseline generation) and Linux (GitHub
/// Actions `ubuntu-latest`) while still catching real visual regressions.
const double _crossOsGoldenTolerance = 0.05;
const double _localGoldenTolerance = 0.005;

/// Configures a cross-platform tolerant [GoldenFileComparator] for all tests
/// under `test/golden/`.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final currentComparator = goldenFileComparator;
  if (currentComparator is LocalFileComparator) {
    goldenFileComparator = _TolerantGoldenFileComparator(
      currentComparator.basedir.resolve('golden_test.dart'),
      precisionTolerance: Platform.isMacOS
          ? _localGoldenTolerance
          : _crossOsGoldenTolerance,
    );
  }
  await testMain();
}

class _TolerantGoldenFileComparator extends LocalFileComparator {
  new(super.testFile, {required this.precisionTolerance});

  final double precisionTolerance;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    final passed = result.passed || result.diffPercent <= precisionTolerance;
    if (passed) {
      result.dispose();
      return true;
    }

    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}
