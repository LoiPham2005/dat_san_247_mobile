# Route Guide — Supporting Reference

## 1. Thêm constant

`lib/routes/constants/route_names.dart`:
```dart
static const String orders = '/orders';
static const String orderDetail = '/orders/:id';
```

## 2. Khai báo typed route

`lib/routes/config/app_routes.dart`:
```dart
@TypedGoRoute<OrdersRoute>(path: RouteNames.orders)
class OrdersRoute extends GoRouteData {
  const OrdersRoute();
  @override Widget build(BuildContext context, GoRouterState state) =>
      const OrdersScreen();
}

// Với params
@TypedGoRoute<OrderDetailRoute>(path: RouteNames.orderDetail)
class OrderDetailRoute extends GoRouteData {
  const OrderDetailRoute({required this.id});
  final int id;
  @override Widget build(BuildContext context, GoRouterState state) =>
      OrderDetailScreen(id: id);
}
```

## 3. Guard (nếu public)

`lib/routes/guards/route_guards.dart`:
```dart
static const _publicRoutes = {
  RouteNames.login,
  RouteNames.orders, // ← thêm nếu không cần auth
};
```

## 4. Build Runner → navigate

```dart
const OrdersRoute().go(context);
const OrderDetailRoute(id: 42).push(context);
```
