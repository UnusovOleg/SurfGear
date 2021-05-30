// Copyright (c) 2019-present,  SurfStudio LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ci_cd/ci.dart';

void main(List<String> args) {
  CommandRunner<void>('tools/ci', 'tools for automate some ci/cd cases')
    ..addCommand(CheckDevBranch())
    ..addCommand(BumpDevVersion())
    ..addCommand(PublishUnstableToPub())
    ..run(args);
}

class CheckDevBranch extends Command<void> {
  @override
  String get name => 'check-dev-branch';

  @override
  String get description =>
      'Validate developer branch for compliance with our conventions.';

  @override
  void run() {
    final changelogContent = readChangelog();
    final importance = getChangesImportanceForUnstable(changelogContent);
    if (importance == ChangesImportance.unknown) {
      printErrorMessage("Can't get changes importance.");
    }

    if (getDeveloperChangesCount(changelogContent) == 0) {
      printErrorMessage("Can't get introduces changes.");
    }
  }
}

class BumpDevVersion extends Command<void> {
  @override
  String get name => 'bump-dev-version';

  @override
  String get description => 'Bump package version.';

  @override
  void run() {
    final changelogContent = readChangelog();
    final pubspecContent = readPubspec();

    final importance = getChangesImportanceForUnstable(changelogContent);
    if (importance == ChangesImportance.unknown ||
        getDeveloperChangesCount(changelogContent) == 0) {
      printErrorMessage("Please run 'check-branch' command before.");
    }

    final packageVersion = getPackageVersion(pubspecContent);
    final updatedPackageVersion =
        bumpUnstablePackageVersion(packageVersion, importance);

    savePubspec(patchPubspec(pubspecContent, updatedPackageVersion));
    saveChangelog(
      patchUnstableChangelog(
        changelogContent,
        updatedPackageVersion,
        importance,
        DateTime.now(),
      ),
    );
  }
}

class PublishUnstableToPub extends Command<void> {
  @override
  String get name => 'publish-dev-version';

  @override
  String get description => 'Publish unstable version to pub.dev.';

  @override
  void run() {
    final changelogContent = readChangelog();
    final pubspecContent = readPubspec();

    final importance = getChangesImportanceForUnstable(changelogContent);
    if (importance == ChangesImportance.unknown) {
      exit(0);
    }

    if (getDeveloperChangesCount(changelogContent) == 0) {
      printErrorMessage("Please run 'check-branch' command before.");
    }

    final packageVersion = getPackageVersion(pubspecContent);
    final updatedPackageVersion =
        bumpUnstablePackageVersion(packageVersion, importance);

    savePubspec(patchPubspec(pubspecContent, updatedPackageVersion));
    saveChangelog(
      patchUnstableChangelog(
        changelogContent,
        updatedPackageVersion,
        importance,
        DateTime.now(),
      ),
    );

    pushNewVersion(
      version: updatedPackageVersion,
      packageName: getPackageName(pubspecContent),
    );

    publishToPub();
  }
}

void printErrorMessage(String verbose, {bool withDevChangelogExample = true}) {
  [
    '\u2757 Invalid changelog format. $verbose',
  ].forEach(stderr.writeln);

  if (withDevChangelogExample) {
    [
      'Changelog should look like:',
      '----------------------------',
      '# Changelog',
      '',
      '## MAJOR | MINOR | PATCH',
      '',
      '* change 1',
      '* change 2',
      '* ...',
      '',
      '## ....',
      '',
      '----------------------------',
    ].forEach(stdout.writeln);
  }

  exit(1);
}
