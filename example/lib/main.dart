import 'package:flutter/material.dart';
import 'package:simple_cached_value/simple_cached_value.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _memoryCacheRaw = '';
  String _prefsCacheRaw = '';

  late InMemoryCacheObject<String> _memoryCache;
  SharedPreferencesCacheObject<String>? _prefsCache;
  final TextEditingController _ttlController =
      TextEditingController(text: '10');

  @override
  void initState() {
    super.initState();
    _initializeCaches();
  }

  Duration _getUserTtl() {
    final text = _ttlController.text;
    final seconds = int.tryParse(text) ?? 10;
    return Duration(seconds: seconds);
  }

  Future<void> _initializeCaches() async {
    // In-memory cache
    _memoryCache = InMemoryCacheObject<String>(
      value: _getCurrentTimeString(),
      ttl: _getUserTtl(),
      valueProvider: () async => _getCurrentTimeString(),
    );

    // SharedPreferences cache
    _prefsCache = SharedPreferencesCacheObject<String>(
      cacheKeyPrefix: 'example',
      ttl: _getUserTtl(),
      fromString: (s) => s,
      toString: (s) => s,
      valueProvider: () async => _getCurrentTimeString(),
    );
  }

  Future<void> _loadMemoryCache() async {
    final value = await _memoryCache.getValue() ?? 'null';
    setState(() {
      _memoryCacheRaw = value;
    });
  }

  Future<void> _loadPrefsCache() async {
    if (_prefsCache != null) {
      final value = await _prefsCache!.getValue() ?? 'null';
      setState(() {
        _prefsCacheRaw = value;
      });
    }
  }

  String _getCurrentTimeString() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  void _invalidateMemoryCache() {
    _memoryCache.invalidate();
    setState(() {
      _memoryCacheRaw = '';
    });
  }

  void _invalidatePrefsCache() {
    _prefsCache?.invalidate();
    setState(() {
      _prefsCacheRaw = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Simple Cache Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TTL TextField (shared for both caches)
              Row(
                children: [
                  const Text('TTL 秒數:'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _ttlController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      ),
                      onSubmitted: (_) async {
                        await _initializeCaches();
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await _initializeCaches();
                      setState(() {});
                    },
                    child: const Text('設定 TTL'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'InMemoryCache',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('值: $_memoryCacheRaw'),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _loadMemoryCache,
                    child: const Text('讀取值'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _invalidateMemoryCache,
                    child: const Text('Invalidate'),
                  ),
                ],
              ),
              const Divider(height: 32, thickness: 2),
              const Text(
                'SharedPreferencesCache',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('值: $_prefsCacheRaw'),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _loadPrefsCache,
                    child: const Text('讀取值'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _invalidatePrefsCache,
                    child: const Text('Invalidate'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
