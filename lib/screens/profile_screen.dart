import 'package:booking_stadium/auth/register_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Enhanced header
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.teal[400]!, Colors.teal[600]!],
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.white, size: 28),
                        const SizedBox(width: 12),
                        Text(
                          'الملف الشخصي',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'مدير النظام',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Profile info card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Icon(
                              Icons.admin_panel_settings,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'مدير الملعب',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'admin@stadium.com',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green[400],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'متصل',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Settings section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // App settings
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.settings,
                                  color: Colors.teal[600],
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'إعدادات التطبيق',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildSettingTile(
                            icon: Icons.notifications,
                            title: 'الإشعارات',
                            subtitle: 'تفعيل إشعارات الحجوزات',
                            trailing: Switch(
                              value: _notificationsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _notificationsEnabled = value;
                                });
                              },
                              activeColor: Colors.teal[600],
                            ),
                          ),
                          _buildSettingTile(
                            icon: Icons.dark_mode,
                            title: 'الوضع الليلي',
                            subtitle: 'تفعيل المظهر الداكن',
                            trailing: Switch(
                              value: _darkModeEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _darkModeEnabled = value;
                                });
                              },
                              activeColor: Colors.teal[600],
                            ),
                          ),
                          _buildSettingTile(
                            icon: Icons.language,
                            title: 'اللغة',
                            subtitle: 'العربية',
                            onTap: () {
                              // Language selection
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Stadium management
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.sports_soccer,
                                  color: Colors.teal[600],
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'إدارة الملاعب',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildSettingTile(
                            icon: Icons.add_business,
                            title: 'إضافة ملعب',
                            subtitle: 'إضافة ملعب جديد للنظام',
                            onTap: () {
                              _showAddStadiumDialog();
                            },
                          ),
                          _buildSettingTile(
                            icon: Icons.edit,
                            title: 'تعديل الملاعب',
                            subtitle: 'تعديل معلومات الملاعب',
                            onTap: () {
                              _showEditStadiumsDialog();
                            },
                          ),
                          _buildSettingTile(
                            icon: Icons.schedule,
                            title: 'ساعات العمل',
                            subtitle: 'تعديل ساعات العمل',
                            onTap: () {
                              _showWorkingHoursDialog();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // System settings
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.system_update,
                                  color: Colors.teal[600],
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'إعدادات النظام',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildSettingTile(
                            icon: Icons.backup,
                            title: 'النسخ الاحتياطي',
                            subtitle: 'إنشاء نسخة احتياطية من البيانات',
                            onTap: () {
                              _showBackupDialog();
                            },
                          ),
                          _buildSettingTile(
                            icon: Icons.restore,
                            title: 'استعادة البيانات',
                            subtitle: 'استعادة البيانات من نسخة احتياطية',
                            onTap: () {
                              _showRestoreDialog();
                            },
                          ),
                          _buildSettingTile(
                            icon: Icons.delete_forever,
                            title: 'مسح البيانات',
                            subtitle: 'مسح جميع البيانات',
                            onTap: () {
                              _showClearDataDialog();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // About section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info,
                                  color: Colors.teal[600],
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'حول التطبيق',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildSettingTile(
                            icon: Icons.description,
                            title: 'سياسة الخصوصية',
                            subtitle: 'قراءة سياسة الخصوصية',
                            onTap: () {
                              _showPrivacyPolicy();
                            },
                          ),
                          _buildSettingTile(
                            icon: Icons.description,
                            title: 'شروط الاستخدام',
                            subtitle: 'قراءة شروط الاستخدام',
                            onTap: () {
                              _showTermsOfService();
                            },
                          ),
                          _buildSettingTile(
                            icon: Icons.info_outline,
                            title: 'حول التطبيق',
                            subtitle: 'إصدار 1.0.0',
                            onTap: () {
                              _showAboutDialog();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Logout button
                    Container(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showLogoutDialog();
                          RegisterService.logout();
                          Navigator.pushNamed(context, '/auth');
                        },
                        icon: Icon(Icons.logout),
                        label: Text('تسجيل الخروج'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.teal[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.teal[600], size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _showAddStadiumDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('إضافة ملعب جديد'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'اسم الملعب',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'الوصف',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add stadium logic
                  Navigator.of(context).pop();
                },
                child: Text('إضافة'),
              ),
            ],
          ),
    );
  }

  void _showEditStadiumsDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('تعديل الملاعب'),
            content: Text('سيتم إضافة هذه الميزة قريباً'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('حسناً'),
              ),
            ],
          ),
    );
  }

  void _showWorkingHoursDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('ساعات العمل'),
            content: Text('سيتم إضافة هذه الميزة قريباً'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('حسناً'),
              ),
            ],
          ),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('النسخ الاحتياطي'),
            content: Text('سيتم إضافة هذه الميزة قريباً'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('حسناً'),
              ),
            ],
          ),
    );
  }

  void _showRestoreDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('استعادة البيانات'),
            content: Text('سيتم إضافة هذه الميزة قريباً'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('حسناً'),
              ),
            ],
          ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('مسح البيانات'),
            content: Text(
              'هل أنت متأكد من مسح جميع البيانات؟ هذا الإجراء لا يمكن التراجع عنه.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Clear data logic
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                ),
                child: Text('مسح'),
              ),
            ],
          ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('سياسة الخصوصية'),
            content: Text('سياسة الخصوصية الخاصة بالتطبيق...'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('إغلاق'),
              ),
            ],
          ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('شروط الاستخدام'),
            content: Text('شروط الاستخدام الخاصة بالتطبيق...'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('إغلاق'),
              ),
            ],
          ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('حول التطبيق'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('تطبيق إدارة الملاعب'),
                const SizedBox(height: 8),
                Text('الإصدار: 1.0.0'),
                const SizedBox(height: 8),
                Text('© 2024 جميع الحقوق محفوظة'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('إغلاق'),
              ),
            ],
          ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('تسجيل الخروج'),
            content: Text('هل أنت متأكد من تسجيل الخروج؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await RegisterService.logout();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/auth');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                ),
                child: Text('تسجيل الخروج'),
              ),
            ],
          ),
    );
  }
}
