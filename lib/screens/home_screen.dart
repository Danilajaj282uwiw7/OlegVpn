import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isConnected = false;
  Timer? timer;
  Duration connectedTime = Duration.zero;
  
  // Пока только Россия
  final String currentServer = '🇷🇺 Россия (Москва)';
  final String serverEndpoint = 'ru.olegvpn.com:51820';

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void toggleConnection() async {
    setState(() {
      isConnected = !isConnected;
      if (isConnected) {
        connectedTime = Duration.zero;
        timer = Timer.periodic(const Duration(seconds: 1), (_) {
          setState(() {
            connectedTime += const Duration(seconds: 1);
          });
        });
      } else {
        timer?.cancel();
      }
    });
    
    // Показываем уведомление
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isConnected 
          ? '🛡️ Подключаемся к российскому серверу...' 
          : '🔓 Отключаемся...'),
        backgroundColor: isConnected ? Colors.green.shade700 : Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String formatDuration(Duration d) {
    return '${d.inHours.toString().padLeft(2, '0')}:'
        '${(d.inMinutes % 60).toString().padLeft(2, '0')}:'
        '${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Логотип
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: isConnected 
                          ? [Colors.green.shade400, Colors.green.shade700]
                          : [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isConnected 
                            ? Colors.green.withOpacity(0.4)
                            : Colors.purple.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shield,
                    size: 50,
                    color: Colors.white,
                  ),
                ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                
                const SizedBox(height: 24),
                
                // Заголовок
                Text(
                  'OlegVPN',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ).createShader(const Rect.fromLTWH(0, 0, 250, 80)),
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
                
                const SizedBox(height: 8),
                Text(
                  'Твой уютный VPN\nТолько Россия покачто',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14, height: 1.5),
                ).animate().fadeIn(delay: 300.ms),
                
                const SizedBox(height: 40),
                
                // Индикатор статуса
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isConnected 
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isConnected 
                          ? Colors.green.withOpacity(0.3)
                          : Colors.red.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isConnected ? Colors.green : Colors.red,
                          boxShadow: [
                            BoxShadow(
                              color: (isConnected ? Colors.green : Colors.red).withOpacity(0.8),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isConnected ? 'Подключен' : 'Не подключен',
                        style: TextStyle(
                          color: isConnected ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ).animate().scale(duration: 400.ms),
                
                const SizedBox(height: 30),
                
                // Трафик (заглушка)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTrafficItem('⬇️', '0.0 MB'),
                    const SizedBox(width: 40),
                    _buildTrafficItem('⬆️', '0.0 MB'),
                  ],
                ).animate().fadeIn(delay: 400.ms),
                
                const SizedBox(height: 30),
                
                // Информация о сервере
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.08),
                        Colors.white.withOpacity(0.03),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentServer,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.check_circle, color: Colors.green.shade400, size: 20),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        serverEndpoint,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Скоро: 🇰🇿 Казахстан, 🇹🇯 Таджикистан',
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 500.ms),
                
                const SizedBox(height: 40),
                
                // Кнопка подключения
                GestureDetector(
                  onTap: toggleConnection,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isConnected
                            ? [Colors.green.shade400, Colors.green.shade700]
                            : [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isConnected ? Colors.green : Colors.purple).withOpacity(0.5),
                          blurRadius: 40,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isConnected ? Icons.lock : Icons.lock_open,
                            color: Colors.white,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isConnected ? 'Отключиться' : 'Подключиться',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                
                const SizedBox(height: 24),
                
                // Таймер
                if (isConnected)
                  Column(
                    children: [
                      Text(
                        'Подключены: ${formatDuration(connectedTime)}',
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'IP: 185.147.80.5',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ).animate().fadeIn(),
                
                const SizedBox(height: 30),
                
                // Футер
                Text(
                  'made with ❤️ for Oleg',
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 12),
                ).animate().fadeIn(delay: 800.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrafficItem(String icon, String value) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
      ],
    );
  }
}
