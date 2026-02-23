import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionCard(
                title: 'PREFERENCES',
                children: [
                  _SettingTile(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: settings.language.name.toUpperCase(),
                    onTap: () => _showLanguageDialog(context, settings),
                  ),
                  _SettingTile(
                    icon: Icons.straighten,
                    title: 'Unit System',
                    subtitle: settings.unitSystem.name.toUpperCase(),
                    onTap: () => _showUnitDialog(context, settings),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'NOTIFICATIONS',
                children: [
                  SwitchListTile(
                    value: settings.notificationsEnabled,
                    onChanged: (value) => settings.toggleNotifications(value),
                    title: const Text('Push Notifications', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Receive alerts and updates', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    activeColor: const Color(0xFF00AAFF),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'DATA',
                children: [
                  SwitchListTile(
                    value: settings.offlineMode,
                    onChanged: (value) => settings.toggleOfflineMode(value),
                    title: const Text('Offline Mode', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Use cached data when offline', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    activeColor: const Color(0xFF00AAFF),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0A1628),
        title: const Text('Select Language', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppLanguage.values.map((lang) {
            return RadioListTile<AppLanguage>(
              value: lang,
              groupValue: settings.language,
              onChanged: (value) {
                if (value != null) settings.setLanguage(value);
                Navigator.pop(context);
              },
              title: Text(lang.name.toUpperCase(), style: const TextStyle(color: Colors.white)),
              activeColor: const Color(0xFF00AAFF),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showUnitDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0A1628),
        title: const Text('Select Unit System', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: UnitSystem.values.map((unit) {
            return RadioListTile<UnitSystem>(
              value: unit,
              groupValue: settings.unitSystem,
              onChanged: (value) {
                if (value != null) settings.setUnitSystem(value);
                Navigator.pop(context);
              },
              title: Text(unit.name.toUpperCase(), style: const TextStyle(color: Colors.white)),
              activeColor: const Color(0xFF00AAFF),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2872A1).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF00AAFF), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF00AAFF)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white70),
      onTap: onTap,
    );
  }
}
