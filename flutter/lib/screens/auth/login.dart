import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabSwitcherPage();
  }
}

class TabSwitcherPage extends StatefulWidget {
  const TabSwitcherPage({super.key});

  @override
  State<TabSwitcherPage> createState() => _TabSwitcherPageState();
}

class _TabSwitcherPageState extends State<TabSwitcherPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Кнопки переключения вкладок
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _selectedTab = 0),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedTab == 0
                          ? Theme.of(context).primaryColor
                          : Colors.grey[400],
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Телефон'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _selectedTab = 1),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedTab == 1
                          ? Theme.of(context).primaryColor
                          : Colors.grey[400],
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Email'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Плавное переключение форм
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: _selectedTab == 0
                    ? const FormOne(key: ValueKey(1))
                    : const FormTwo(key: ValueKey(2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Форма 1
class FormOne extends StatelessWidget {
  const FormOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Ваш номер телефона',
            hintText: '+7 (999) 999-99-99',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Пароль',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Войти'),
        ),
      ],
    );
  }
}

// Форма 2
class FormTwo extends StatelessWidget {
  const FormTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Ваш email',
            hintText: 'example@gmail.com',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Пароль',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Зарегистрироваться'),
        ),
      ],
    );
  }
}
