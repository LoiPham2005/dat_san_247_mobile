// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_stg.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// generated_from: .env.stg
final class _EnvStg {
  static const String apiBaseUrl = 'https://staging-api.yourapp.com';

  static const String wsUrl = 'wss://ws-staging.yourapp.com';

  static const bool enableLogging = true;

  static const bool enableDebugTools = false;

  static const bool enableAnalytics = true;

  static const int connectTimeout = 30;

  static const int receiveTimeout = 30;

  static const List<int> _enviedkeygoogleMapsApiKey = <int>[
    2982498894,
    2722419368,
    3989124129,
    3981865761,
    3528252412,
    1714266453,
    4209708581,
    273074132,
    3651875904,
    2060910766,
    573452946,
    4201576195,
    604163793,
    1720431854,
    778814709,
    1265245449,
    3491095979,
    1889749629,
    1711344615,
    3710123286,
    252732520,
    30985314,
  ];

  static const List<int> _envieddatagoogleMapsApiKey = <int>[
    2982498831,
    2722419425,
    3989124187,
    3981865792,
    3528252335,
    1714266412,
    4209708662,
    273074080,
    3651875873,
    2060910793,
    573453051,
    4201576301,
    604163766,
    1720431793,
    778814654,
    1265245548,
    3491096018,
    1889749538,
    1711344559,
    3710123379,
    252732442,
    30985223,
  ];

  static final String googleMapsApiKey = String.fromCharCodes(
    List<int>.generate(
      _envieddatagoogleMapsApiKey.length,
      (int i) => i,
      growable: false,
    ).map(
      (int i) => _envieddatagoogleMapsApiKey[i] ^ _enviedkeygoogleMapsApiKey[i],
    ),
  );

  static const List<int> _enviedkeystripePublicKey = <int>[
    3426807202,
    1913681505,
    1227971293,
    486528562,
    367814236,
    3056656517,
    2204335605,
    939756267,
    3118527305,
    1473200183,
    3556870362,
    2451709597,
    1292693738,
    1388422112,
    2590383689,
    2098962378,
    350473965,
    97994134,
    4127217827,
  ];

  static const List<int> _envieddatastripePublicKey = <int>[
    3426807250,
    1913681418,
    1227971202,
    486528582,
    367814201,
    3056656630,
    2204335489,
    939756212,
    3118527290,
    1473200195,
    3556870331,
    2451709690,
    1292693635,
    1388422030,
    2590383662,
    2098962325,
    350473862,
    97994227,
    4127217882,
  ];

  static final String stripePublicKey = String.fromCharCodes(
    List<int>.generate(
      _envieddatastripePublicKey.length,
      (int i) => i,
      growable: false,
    ).map(
      (int i) => _envieddatastripePublicKey[i] ^ _enviedkeystripePublicKey[i],
    ),
  );
}
