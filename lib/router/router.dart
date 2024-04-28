import 'package:barnaul_transport/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: const <RouteBase>[
        // GoRoute(
        //   path: 'details',
        //   builder: (BuildContext context, GoRouterState state) {
        //     return const DetailsScreen();
        //   },
        // ),
      ],
    ),
  ],
);