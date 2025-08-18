extension ListExt<T> on Iterable<T>? {
  List<T> validate() {
    if (this == null) {
      return [];
    } else {
      return this!.toList();
    }
  }
}