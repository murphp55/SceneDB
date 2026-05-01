// Migration tests for AppDatabase.
//
// These tests verify that data persists correctly when a user upgrades the
// app and the database goes through `MigrationStrategy.onUpgrade`.
//
// ──────────────────────────────────────────────────────────────────────────
// Setup before adding tests here:
//
// 1. Capture the v1 baseline schema (one-time):
//      dart run drift_dev schema dump lib/database/database.dart drift_schemas/
//
// 2. Generate per-version test helpers:
//      dart run drift_dev schema generate drift_schemas/ test/generated_migrations/
//
// 3. Add a test for each migration step. Example template (uncomment after
//    setup and adjust for the actual schema change):
//
//      import 'package:drift/drift.dart';
//      import 'package:drift_dev/api/migrations.dart';
//      import 'package:flutter_test/flutter_test.dart';
//      import 'package:scenedb/database/database.dart';
//      import 'generated_migrations/schema.dart';
//
//      void main() {
//        late SchemaVerifier verifier;
//
//        setUpAll(() {
//          verifier = SchemaVerifier(GeneratedHelper());
//        });
//
//        test('upgrade from v1 to v2 preserves tracked movies', () async {
//          final connection = await verifier.startAt(1);
//          final db = AppDatabase.forTesting(connection);
//          await verifier.migrateAndValidate(db, 2);
//          await db.close();
//        });
//      }
//
// Until snapshots exist, this file is intentionally empty so the test runner
// has nothing to fail on.

void main() {}
