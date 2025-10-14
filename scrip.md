### Setup [`spider`](https://pub.dev/packages/spider)

```
dart pub global activate spider
```

### Generate Code
```
spider build
```

```
spider build --watch

# watching directories with verbose logs
spider build --watch --verbose
```



```
 fvm dart run  build_runner clean
 fvm dart run  build_runner build
```

# gen env

```dart run build_runner build --delete-conflicting-outputs
```