import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bifrost/home/home.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const imageUrl = 'https://www.fnordware.com/superpng/pngtest16rgba.png';

  /// A suite of tests to ensure that the Avatar StatelessWidget works as intended.
  group('Avatar', () {
   setUpAll(() => HttpOverrides.global = null);

   /// A test to ensure that a CircleAvatar Widget is rendered
    testWidgets('renders CircleAvatar', (tester) async{
      await tester.pumpWidget(const MaterialApp(home: Avatar()));
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

  /// A test to ensure that the Avatar Widget has a background image if the photo is not null
   testWidgets('renders backgroundImage if photo is not null', (tester) async {
     await tester.pumpWidget(const MaterialApp(home: Avatar(photo: imageUrl)));
     final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
     expect(avatar.backgroundImage, isNotNull);
     await tester.pumpAndSettle();
   });

   /// A test to ensure that the Avatar Widget has an Icon if the photo is null
   testWidgets('renders icon if photo is null', (tester) async {
     await tester.pumpWidget(const MaterialApp(home: Avatar()));
     final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
     expect(avatar.backgroundImage, isNull);
     final icon = avatar.child! as Icon;
     expect(icon.icon, Icons.person_outline);
   });
  });
}


















