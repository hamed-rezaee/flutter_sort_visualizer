import 'dart:async';

enum SortType {
  bubble,
  heap,
  shell,
  quick,
  merge,
}

class Sort {
  Sort([this.delay = const Duration(milliseconds: 1)]);

  final Duration delay;

  final StreamController<List<int>> _controller = StreamController<List<int>>();

  Stream<List<int>> get stream => _controller.stream;

  Future<List<int>> sort(List<int> list, SortType type) async {
    switch (type) {
      case SortType.bubble:
        return bubbleSort(list);
      case SortType.heap:
        return heapSort(list);
      case SortType.shell:
        return shellSort(list);
      case SortType.quick:
        return quickSort(list, 0, list.length - 1);
      case SortType.merge:
        return mergeSort(list, 0, list.length - 1);
    }
  }

  Future<List<int>> bubbleSort(List<int> list) async {
    for (int i = 0; i < list.length; i++) {
      for (int j = 0; j < list.length - i - 1; j++) {
        if (list[j] > list[j + 1]) {
          final int temp = list[j];

          list[j] = list[j + 1];
          list[j + 1] = temp;
        }
      }

      _controller.add(list);
      await Future<void>.delayed(delay * 30);
    }

    return list;
  }

  Future<List<int>> heapSort(List<int> list) async {
    for (int i = list.length ~/ 2; i >= 0; i--) {
      await _heapify(list, list.length, i);
    }

    for (int i = list.length - 1; i >= 0; i--) {
      final int temp = list.first;

      list.first = list[i];
      list[i] = temp;

      await _heapify(list, i, 0);
    }

    return list;
  }

  Future<void> _heapify(List<int> list, int n, int i) async {
    int largest = i;
    final int left = 2 * i + 1;
    final int right = 2 * i + 2;

    if (left < n && list[left] > list[largest]) {
      largest = left;
    }

    if (right < n && list[right] > list[largest]) {
      largest = right;
    }

    if (largest != i) {
      final int temp = list[i];

      list[i] = list[largest];
      list[largest] = temp;

      await _heapify(list, n, largest);

      _controller.add(list);
      await Future<void>.delayed(delay);
    }
  }

  Future<List<int>> shellSort(List<int> list) async {
    for (int gap = list.length ~/ 2; gap > 0; gap ~/= 2) {
      for (int i = gap; i < list.length; i++) {
        final int temp = list[i];
        int j;

        for (j = i; j >= gap && list[j - gap] > temp; j -= gap) {
          list[j] = list[j - gap];
        }

        list[j] = temp;

        _controller.add(list);
        await Future<void>.delayed(delay);
      }
    }

    return list;
  }

  Future<List<int>> quickSort(List<int> list, int low, int high) async {
    if (low < high) {
      final int pi = await _partition(list, low, high);

      await quickSort(list, low, pi - 1);
      await quickSort(list, pi + 1, high);
    }

    return list;
  }

  Future<int> _partition(List<int> list, int low, int high) async {
    final int pivot = list[high];
    int i = low - 1;

    for (int j = low; j < high; j++) {
      if (list[j] < pivot) {
        i++;

        final int temp = list[i];

        list[i] = list[j];
        list[j] = temp;

        _controller.add(list);
        await Future<void>.delayed(delay);
      }
    }

    final int temp = list[i + 1];

    list[i + 1] = list[high];
    list[high] = temp;

    return i + 1;
  }

  Future<List<int>> mergeSort(List<int> list, int low, int high) async {
    if (low < high) {
      final int mid = (low + high) ~/ 2;

      await mergeSort(list, low, mid);
      await mergeSort(list, mid + 1, high);

      await _merge(list, low, mid, high);
    }

    return list;
  }

  Future<void> _merge(List<int> list, int low, int mid, int high) async {
    final int n1 = mid - low + 1;
    final int n2 = high - mid;

    final List<int> left = List<int>.filled(n1, 0);
    final List<int> right = List<int>.filled(n2, 0);

    for (int i = 0; i < n1; i++) {
      left[i] = list[low + i];
    }

    for (int i = 0; i < n2; i++) {
      right[i] = list[mid + 1 + i];
    }

    int i = 0;
    int j = 0;
    int k = low;

    while (i < n1 && j < n2) {
      if (left[i] <= right[j]) {
        list[k] = left[i];
        i++;
      } else {
        list[k] = right[j];
        j++;
      }

      k++;

      _controller.add(list);
      await Future<void>.delayed(delay);
    }

    while (i < n1) {
      list[k] = left[i];
      i++;
      k++;

      _controller.add(list);
      await Future<void>.delayed(delay);
    }

    while (j < n2) {
      list[k] = right[j];
      j++;
      k++;

      _controller.add(list);
      await Future<void>.delayed(delay);
    }
  }

  void dispose() => _controller.close();
}
