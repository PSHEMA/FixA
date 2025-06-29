import 'package:fix_my_area/models/user_model.dart';
import 'package:fix_my_area/screens/provider/edit_profile_screen.dart';
import 'package:fix_my_area/screens/settings/help_screen.dart';
import 'package:fix_my_area/screens/settings/language_screen.dart';
import 'package:fix_my_area/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  Future<UserModel?>? _userDetailsFuture;

  @override
  void initState() {
    super.initState();
    _refreshUserDetails();
  }

  void _refreshUserDetails() {
    setState(() {
      _userDetailsFuture = _authService.getUserDetails();
    });
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? subtitle,
    Color? iconColor,
    bool showDivider = false,
  }) {
    final theme = Theme.of(context);
    final color = iconColor ?? theme.colorScheme.primary;
    
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      size: 26,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: theme.scaffoldBackgroundColor,
            indent: 90,
            endIndent: 20,
          ),
      ],
    );
  }

  Widget _buildSectionDivider() {
    return const SizedBox(height: 20);
  }

  Widget _buildProfileHeader(UserModel user) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: user.photoUrl.isNotEmpty 
                ? null 
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: user.photoUrl.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    user.photoUrl,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(
                  Icons.person_rounded,
                  size: 55,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            user.name,
            style: GoogleFonts.lato(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              user.email,
              style: GoogleFonts.lato(
                fontSize: 14,
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutButton() {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showSignOutDialog(context, _authService),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD32F2F).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    size: 26,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign Out',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFD32F2F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sign out of your account',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, AuthService authService) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Sign Out',
            style: GoogleFonts.lato(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out of your account?',
            style: GoogleFonts.lato(
              fontSize: 16,
              color: theme.colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.lato(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                authService.signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              child: Text(
                'Sign Out',
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FutureBuilder<UserModel?>(
        future: _userDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              ),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Could not load profile data.',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
          
          final user = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async => _refreshUserDetails(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Profile Header Section
                  _buildProfileHeader(user),
                  const SizedBox(height: 24),

                  // Settings Section
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildMenuTile(
                          icon: Icons.edit_rounded,
                          title: 'Edit Profile',
                          subtitle: 'Update your personal information',
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => EditProfileScreen(user: user)),
                            );
                            _refreshUserDetails();
                          },
                          showDivider: true,
                        ),
                        _buildMenuTile(
                          icon: Icons.language_rounded,
                          title: 'Language',
                          subtitle: 'English',
                          iconColor: theme.colorScheme.secondary,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LanguageScreen()),
                          ),
                          showDivider: true,
                        ),
                        _buildMenuTile(
                          icon: Icons.help_outline_rounded,
                          title: 'Help & FAQs',
                          subtitle: 'Get help and support',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const HelpScreen()),
                          ),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),

                  _buildSectionDivider(),

                  // Sign Out Section
                  _buildSignOutButton(),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}