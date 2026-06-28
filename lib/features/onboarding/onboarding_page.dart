import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_settings.dart';
import '../../providers/settings_provider.dart';
import '../../repositories/settings_repository.dart';
import '../shell/main_shell.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = [
    _OnboardStep(
      icon: Icons.school,
      title: '科学记忆',
      description: '基于 SM-2 间隔重复算法，在最佳时间点提醒你复习。',
    ),
    _OnboardStep(
      icon: Icons.style,
      title: '多种学习模式',
      description: '速刷、完整学习、选择题、拼写、听音选义，满足不同场景需求。',
    ),
    _OnboardStep(
      icon: Icons.track_changes,
      title: '追踪进度',
      description: '每日目标、学习曲线、错题本与收藏夹，进步一目了然。',
    ),
  ];

  Future<void> _finish(UserSettings settings) async {
    settings.hasSeenOnboarding = true;
    await ref.read(settingsRepositoryProvider).saveSettings(settings);
    ref.invalidate(settingsProvider);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const MainShell()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    return settingsAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(body: Center(child: Text('加载失败: $error'))),
      data: (settings) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => _finish(settings),
                    child: const Text('跳过'),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageChanged: (index) => setState(() => _page = index),
                    itemBuilder: (context, index) {
                      final step = _pages[index];
                      return Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              step.icon,
                              size: 80,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 32),
                            Text(
                              step.title,
                              style: Theme.of(context).textTheme.headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              step.description,
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _page == index
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: FilledButton(
                    onPressed: () {
                      if (_page < _pages.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _finish(settings);
                      }
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                    child: Text(_page < _pages.length - 1 ? '下一步' : '开始使用'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OnboardStep {
  const _OnboardStep({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
