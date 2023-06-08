import 'package:flutter/material.dart';
import 'package:bifrost/app/app.dart';
import 'package:bifrost/home/home.dart';
import 'package:bifrost/login/login.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  /// A suite of tests to ensure that the onGenerateAppViews method
  /// generates page routes as expected.
  group('onGenerateAppViews', (){
    /// A test to ensure that the [HomePage] page is returned
    /// when the user is authenticated.
    test('returns HomePage when authenticated', (){
      expect(
        onGenerateAppViews(AppStatus.authenticated, []),
        [
          isA<MaterialPage<void>>().having(
              (p) => p.child,
            'child',
            isA<HomePage>()
          )
        ]
      );
    });

    /// A test to ensure that the [LoginPage] page is returned
    /// when the user is unauthenticated.
    test('returns LoginPage when unauthenticated', (){
      expect(
        onGenerateAppViews(AppStatus.unauthenticated, []),
        [isA<MaterialPage<void>>().having(
            (p) => p.child,
          'child',
          isA<LoginPage>()
        )]
      );
    });
  });
}
