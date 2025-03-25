import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
        fontFamily: '.SF Pro Display',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: '.SF Pro Display',
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
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E5EA)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E5EA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: '.SF Pro Display',
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontFamily: '.SF Pro Display',
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

  void _addNumber() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _numbers.add(int.parse(_numberController.text));
        _originalNumbers = List.from(_numbers);
        _numberController.clear();
      });
    }
  }

  void _bubbleSort() {
    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < _numbers.length - 1; i++) {
      for (int j = 0; j < _numbers.length - i - 1; j++) {
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
    });
  }

  void _selectionSort() {
    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < _numbers.length - 1; i++) {
      int minIndex = i;
      for (int j = i + 1; j < _numbers.length; j++) {
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
    });
  }

  void _insertionSort() {
    final stopwatch = Stopwatch()..start();
    for (int i = 1; i < _numbers.length; i++) {
      final key = _numbers[i];
      int j = i - 1;
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
    });
  }

  void _mergeSort() {
    final stopwatch = Stopwatch()..start();
    _mergeSortHelper(0, _numbers.length - 1);
    stopwatch.stop();
    setState(() {
      _sortTime = 'Merge Sort: ${stopwatch.elapsed.inMilliseconds}ms';
      _isSorted = true;
    });
  }

  void _mergeSortHelper(int left, int right) {
    if (left < right) {
      int mid = (left + right) ~/ 2;
      _mergeSortHelper(left, mid);
      _mergeSortHelper(mid + 1, right);
      _merge(left, mid, right);
    }
  }

  void _merge(int left, int mid, int right) {
    final leftList = _numbers.sublist(left, mid + 1);
    final rightList = _numbers.sublist(mid + 1, right + 1);
    int i = 0, j = 0, k = left;

    while (i < leftList.length && j < rightList.length) {
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
    });
  }

  void _unsortData() {
    setState(() {
      _numbers.clear();
      _numbers.addAll(_originalNumbers);
      _sortTime = '';
      _isSorted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sorting Visualizer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetData,
          ),
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
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Add Number',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _addNumber,
                          child: const Text('Add Number'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_numbers.isNotEmpty) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Numbers',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(const Color(0xFFF5F5F7)),
                            dataRowColor: MaterialStateProperty.all(Colors.white),
                            columns: const [
                              DataColumn(
                                label: Text('Index', style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                              DataColumn(
                                label: Text('Value', style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                            ],
                            rows: _numbers.asMap().entries.map((entry) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(entry.key.toString())),
                                  DataCell(Text(entry.value.toString())),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Sorting Algorithms',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _bubbleSort,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(160, 50),
                              ),
                              child: const Text('Bubble Sort'),
                            ),
                            ElevatedButton(
                              onPressed: _selectionSort,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(160, 50),
                              ),
                              child: const Text('Selection Sort'),
                            ),
                            ElevatedButton(
                              onPressed: _insertionSort,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(160, 50),
                              ),
                              child: const Text('Insertion Sort'),
                            ),
                            ElevatedButton(
                              onPressed: _mergeSort,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(160, 50),
                              ),
                              child: const Text('Merge Sort'),
                            ),
                          ],
                        ),
                        if (_isSorted) ...[
                          const SizedBox(height: 20),
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
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
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