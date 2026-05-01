# Drift Schema Snapshots

This folder holds JSON snapshots of every schema version the app has shipped.
Drift uses them to verify that migrations correctly upgrade an old database to
the current schema.

## When to create a snapshot

Every time you change a `Table` definition in `lib/database/database.dart`
(adding a column, adding a table, changing a constraint, etc.):

1. Bump `schemaVersion` in `AppDatabase`.
2. Add the upgrade step in `MigrationStrategy.onUpgrade`.
3. Dump the new schema into this folder:

   ```bash
   dart run drift_dev schema dump lib/database/database.dart drift_schemas/
   ```

   This produces a file like `drift_schema_v2.json` for the new version.

4. Regenerate the per-version test helpers:

   ```bash
   dart run drift_dev schema generate drift_schemas/ test/generated_migrations/
   ```

5. Add a migration test for the new step in `test/migration_test.dart`.

## First-time setup (v1 baseline)

Run this once to capture the current v1 schema:

```bash
dart run drift_dev schema dump lib/database/database.dart drift_schemas/
dart run drift_dev schema generate drift_schemas/ test/generated_migrations/
```

You should see `drift_schema_v1.json` appear in this folder. Commit it.

## Why this matters

Without snapshots, a schema change ships and existing user databases either
fail to open or silently lose data. Snapshots + migration tests give us a
mechanical proof that an upgrade from v(n) to v(n+1) succeeds.

## Reference

- Drift migrations: https://drift.simonbinder.eu/migrations/
- Schema management CLI: https://drift.simonbinder.eu/migrations/api/#exporting-the-schema
