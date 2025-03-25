import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sorting Visualizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE5E5EA)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      home: const SortingVisualizer(),
    );
  }
}

class SortingVisualizer extends StatefulWidget {
  const SortingVisualizer({super.key});

  @override
  State<SortingVisualizer> createState() => _SortingVisualizerState();
}

class _SortingVisualizerState extends State<SortingVisualizer> {
  final List<int> _numbers = [];
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  String _sortTime = '';
  bool _isSorted = false;
  List<int> _originalNumbers = [];
  bool _isSorting = false;
  int _currentIndex = -1;
  int _nextIndex = -1;

  void _addNumber() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _numbers.add(int.parse(_numberController.text));
        _originalNumbers = List.from(_numbers);
        _numberController.clear();
      });
    }
  }

  Future<void> _bubbleSort() async {
    if (_isSorting) return;
    _isSorting = true;
    final stopwatch = Stopwatch()..start();

    for (int i = 0; i < _numbers.length - 1; i++) {
      for (int j = 0; j < _numbers.length - i - 1; j++) {
        setState(() {
          _currentIndex = j;
          _nextIndex = j + 1;
        });

        await Future.delayed(const Duration(milliseconds: 500));

        if (_numbers[j] > _numbers[j + 1]) {
          final temp = _numbers[j];
          _numbers[j] = _numbers[j + 1];
          _numbers[j + 1] = temp;
        }
      }
    }

    stopwatch.stop();
    setState(() {
      _sortTime = 'Bubble Sort: ${stopwatch.elapsed.inMilliseconds}ms';
      _isSorted = true;
      _currentIndex = -1;
      _nextIndex = -1;
    });
    _isSorting = false;
  }

  Future<void> _selectionSort() async {
    if (_isSorting) return;
    _isSorting = true;
    final stopwatch = Stopwatch()..start();

    for (int i = 0; i < _numbers.length - 1; i++) {
      int minIndex = i;
      setState(() {
        _currentIndex = i;
      });

      for (int j = i + 1; j < _numbers.length; j++) {
        setState(() {
          _nextIndex = j;
        });
        await Future.delayed(const Duration(milliseconds: 500));

        if (_numbers[j] < _numbers[minIndex]) {
          minIndex = j;
        }
      }

      final temp = _numbers[i];
      _numbers[i] = _numbers[minIndex];
      _numbers[minIndex] = temp;
    }

    stopwatch.stop();
    setState(() {
      _sortTime = 'Selection Sort: ${stopwatch.elapsed.inMilliseconds}ms';
      _isSorted = true;
      _currentIndex = -1;
      _nextIndex = -1;
    });
    _isSorting = false;
  }

  Future<void> _insertionSort() async {
    if (_isSorting) return;
    _isSorting = true;
    final stopwatch = Stopwatch()..start();

    for (int i = 1; i < _numbers.length; i++) {
      final key = _numbers[i];
      int j = i - 1;

      setState(() {
        _currentIndex = i;
        _nextIndex = j;
      });

      await Future.delayed(const Duration(milliseconds: 500));

      while (j >= 0 && _numbers[j] > key) {
        _numbers[j + 1] = _numbers[j];
        j--;
      }
      _numbers[j + 1] = key;
    }

    stopwatch.stop();
    setState(() {
      _sortTime = 'Insertion Sort: ${stopwatch.elapsed.inMilliseconds}ms';
      _isSorted = true;
      _currentIndex = -1;
      _nextIndex = -1;
    });
    _isSorting = false;
  }

  Future<void> _mergeSort() async {
    if (_isSorting) return;
    _isSorting = true;
    final stopwatch = Stopwatch()..start();
    await _mergeSortHelper(0, _numbers.length - 1);
    stopwatch.stop();
    setState(() {
      _sortTime = 'Merge Sort: ${stopwatch.elapsed.inMilliseconds}ms';
      _isSorted = true;
      _currentIndex = -1;
      _nextIndex = -1;
    });
    _isSorting = false;
  }

  Future<void> _mergeSortHelper(int left, int right) async {
    if (left < right) {
      int mid = (left + right) ~/ 2;
      setState(() {
        _currentIndex = mid;
      });
      await Future.delayed(const Duration(milliseconds: 500));

      await _mergeSortHelper(left, mid);
      await _mergeSortHelper(mid + 1, right);
      await _merge(left, mid, right);
    }
  }

  Future<void> _merge(int left, int mid, int right) async {
    final leftList = _numbers.sublist(left, mid + 1);
    final rightList = _numbers.sublist(mid + 1, right + 1);
    int i = 0, j = 0, k = left;

    while (i < leftList.length && j < rightList.length) {
      setState(() {
        _currentIndex = left + i;
        _nextIndex = mid + 1 + j;
      });
      await Future.delayed(const Duration(milliseconds: 500));

      if (leftList[i] <= rightList[j]) {
        _numbers[k] = leftList[i];
        i++;
      } else {
        _numbers[k] = rightList[j];
        j++;
      }
      k++;
    }

    while (i < leftList.length) {
      _numbers[k] = leftList[i];
      i++;
      k++;
    }

    while (j < rightList.length) {
      _numbers[k] = rightList[j];
      j++;
      k++;
    }
  }

  void _resetData() {
    setState(() {
      _numbers.clear();
      _originalNumbers.clear();
      _sortTime = '';
      _isSorted = false;
      _currentIndex = -1;
      _nextIndex = -1;
    });
  }

  void _unsortData() {
    setState(() {
      _numbers.clear();
      _numbers.addAll(_originalNumbers);
      _sortTime = '';
      _isSorted = false;
      _currentIndex = -1;
      _nextIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sorting Visualizer'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _resetData),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _numberController,
                          decoration: const InputDecoration(
                            labelText: 'Enter a number',
                            hintText: 'Type a number here',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a number';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _addNumber,
                          child: const Text('Add Number'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_numbers.isNotEmpty) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Visualization',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children:
                                _numbers.asMap().entries.map((entry) {
                                  final isCurrent = entry.key == _currentIndex;
                                  final isNext = entry.key == _nextIndex;
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: 30,
                                    height: entry.value * 10.0,
                                    decoration: BoxDecoration(
                                      color:
                                          isCurrent
                                              ? Colors.red
                                              : isNext
                                              ? Colors.blue
                                              : Colors.green,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(
                              const Color(0xFFF5F5F7),
                            ),
                            dataRowColor: MaterialStateProperty.all(
                              Colors.white,
                            ),
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'Index',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Value',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                            rows:
                                _numbers.asMap().entries.map((entry) {
                                  final isCurrent = entry.key == _currentIndex;
                                  final isNext = entry.key == _nextIndex;
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          entry.key.toString(),
                                          style: TextStyle(
                                            fontWeight:
                                                isCurrent || isNext
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            color:
                                                isCurrent
                                                    ? Colors.red
                                                    : isNext
                                                    ? Colors.blue
                                                    : Colors.black,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          entry.value.toString(),
                                          style: TextStyle(
                                            fontWeight:
                                                isCurrent || isNext
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            color:
                                                isCurrent
                                                    ? Colors.red
                                                    : isNext
                                                    ? Colors.blue
                                                    : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Sorting Algorithms',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _isSorting ? null : _bubbleSort,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(140, 45),
                              ),
                              child: const Text('Bubble Sort'),
                            ),
                            ElevatedButton(
                              onPressed: _isSorting ? null : _selectionSort,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(140, 45),
                              ),
                              child: const Text('Selection Sort'),
                            ),
                            ElevatedButton(
                              onPressed: _isSorting ? null : _insertionSort,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(140, 45),
                              ),
                              child: const Text('Insertion Sort'),
                            ),
                            ElevatedButton(
                              onPressed: _isSorting ? null : _mergeSort,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(140, 45),
                              ),
                              child: const Text('Merge Sort'),
                            ),
                          ],
                        ),
                        if (_isSorted) ...[
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _unsortData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Unsort Data'),
                          ),
                        ],
                        if (_sortTime.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _sortTime,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }
}
