// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:runners_hub/main.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = null;
  });

  testWidgets('MainScreen navigation test', (WidgetTester tester) async {
    // Set a realistic screen size to avoid overflow errors
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;

    // Override HTTP client to avoid NetworkImage errors
    HttpOverrides.global = _TestHttpOverrides();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the BottomNavigationBar is present.
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Verify that the tabs are present.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Latihan'), findsOneWidget);
    expect(find.text('Rekam'), findsOneWidget);
    expect(find.text('Rute'), findsOneWidget);
    expect(find.text('Lainnya'), findsOneWidget);

    // Reset screen size
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(() {
      HttpOverrides.global = null;
    });
  });
}

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _TestHttpClient();
  }
}

class _TestHttpClient extends Fake implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return _TestHttpClientRequest();
  }
}

class _TestHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async {
    return _TestHttpClientResponse();
  }
}

class _TestHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => 0;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    // Return an empty stream or a valid image byte stream if needed.
    // For NetworkImage, an empty stream might cause an error if it expects an image header.
    // Let's return a minimal 1x1 transparent GIF.
    final List<int> transparentGif = <int>[
      0x47,
      0x49,
      0x46,
      0x38,
      0x39,
      0x61,
      0x01,
      0x00,
      0x01,
      0x00,
      0x80,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x21,
      0xf9,
      0x04,
      0x01,
      0x00,
      0x00,
      0x00,
      0x00,
      0x2c,
      0x00,
      0x00,
      0x00,
      0x00,
      0x01,
      0x00,
      0x01,
      0x00,
      0x00,
      0x02,
      0x02,
      0x44,
      0x01,
      0x00,
      0x3b
    ];

    return Stream.value(transparentGif).listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}
