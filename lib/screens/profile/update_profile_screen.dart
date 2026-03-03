import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../provider/profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<UpdateProfileScreen> createState() =>
      _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _accountNoController;
  late TextEditingController _bankNameController;
  late TextEditingController _branchNameController;
  late TextEditingController _ifscCodeController;
  late TextEditingController _passwordController;

  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedImagePath;
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (_controllersInitialized) return;
    
    final profile = ref.read(profileProvider);
    _nameController = TextEditingController(text: profile?.name ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _emailController = TextEditingController(text: profile?.email ?? '');
    _accountNoController =
        TextEditingController(text: profile?.bankAccountNo ?? '');
    _bankNameController = TextEditingController(text: profile?.bankName ?? '');
    _branchNameController =
        TextEditingController(text: profile?.branchName ?? '');
    _ifscCodeController = TextEditingController(text: profile?.ifscCode ?? '');
    _passwordController = TextEditingController(text: profile?.password ?? '');
    
    _controllersInitialized = true;
  }

  @override
  void dispose() {
    if (_controllersInitialized) {
      _nameController.dispose();
      _phoneController.dispose();
      _emailController.dispose();
      _accountNoController.dispose();
      _bankNameController.dispose();
      _branchNameController.dispose();
      _ifscCodeController.dispose();
      _passwordController.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image =
          await _imagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.camera, color: AppColors.primary),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.gallery, color: AppColors.primary),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      ref.read(profileProvider.notifier).updateAllDetails(
            name: _nameController.text,
            phone: _phoneController.text,
            email: _emailController.text,
            bankAccountNo: _accountNoController.text,
            bankName: _bankNameController.text,
            branchName: _branchNameController.text,
            ifscCode: _ifscCodeController.text,
            password: _passwordController.text.isNotEmpty
                ? _passwordController.text
                : null,
          );

      if (_selectedImagePath != null) {
        ref
            .read(profileProvider.notifier)
            .updateProfileImage(_selectedImagePath!);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate back to profile screen
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          context.pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    
    // Initialize controllers if not already done
    if (!_controllersInitialized && profile != null) {
      _initializeControllers();
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: 'Update Profile',
        subtitleText: 'Modify your profile information',
        onBack: () => context.pop(),
      ),
      body: profile == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : !_controllersInitialized
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Photo Section
                    Container(
                      margin: const EdgeInsets.all(AppSpacing.md),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _showImagePickerOptions,
                            child: Stack(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryLight,
                                    border: Border.all(
                                      color: AppColors.primary,
                                      width: 3,
                                    ),
                                  ),
                                  child: _selectedImagePath != null
                                      ? ClipOval(
                                          child: Image.file(
                                            File(_selectedImagePath!),
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : profile.profileImage != null
                                          ? ClipOval(
                                              child: Image.asset(
                                                profile.profileImage!,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.person,
                                              size: 60,
                                              color: AppColors.primary,
                                            ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary,
                                      border: Border.all(
                                        color: AppColors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Iconsax.camera,
                                      color: AppColors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Tap to change photo',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.quaternary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Personal Information Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Information',
                            style: AppTypography.tagline.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Name
                          TextFormField(
                            controller: _nameController,
                            decoration: _buildInputDecoration(
                              hintText: 'Full Name',
                              prefixIcon: Iconsax.user,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Phone
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: _buildInputDecoration(
                              hintText: 'Phone Number',
                              prefixIcon: Iconsax.call,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Email
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _buildInputDecoration(
                              hintText: 'Email Address',
                              prefixIcon: Iconsax.sms,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              if (!value.contains('@')) {
                                return 'Invalid email';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Designation and Territory (Read-only)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Company Information',
                            style: AppTypography.tagline.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Designation (Read-only)
                          TextFormField(
                            initialValue: profile.designation,
                            enabled: false,
                            decoration: _buildInputDecoration(
                              hintText: 'Designation',
                              prefixIcon: Iconsax.briefcase,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Territory (Read-only)
                          TextFormField(
                            initialValue: profile.territory,
                            enabled: false,
                            decoration: _buildInputDecoration(
                              hintText: 'Territory',
                              prefixIcon: Iconsax.location,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Bank Information Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bank Information',
                            style: AppTypography.tagline.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Account Number
                          TextFormField(
                            controller: _accountNoController,
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                              hintText: 'Account Number',
                              prefixIcon: Iconsax.bank,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Account number is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Bank Name
                          TextFormField(
                            controller: _bankNameController,
                            decoration: _buildInputDecoration(
                              hintText: 'Bank Name',
                              prefixIcon: Iconsax.bank,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Bank name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Branch Name
                          TextFormField(
                            controller: _branchNameController,
                            decoration: _buildInputDecoration(
                              hintText: 'Branch Name',
                              prefixIcon: Iconsax.building,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Branch name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // IFSC Code
                          TextFormField(
                            controller: _ifscCodeController,
                            decoration: _buildInputDecoration(
                              hintText: 'IFSC Code',
                              prefixIcon: Iconsax.code,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'IFSC code is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Password Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Security',
                            style: AppTypography.tagline.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Password
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: _buildInputDecoration(
                              hintText: 'Password',
                              prefixIcon: Iconsax.lock,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Update Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: _updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppBorderRadius.lg,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Iconsax.tick_circle),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  'Save Changes',
                                  style: AppTypography.tagline.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTypography.body.copyWith(
        color: AppColors.quaternary,
      ),
      prefixIcon: Icon(prefixIcon, color: AppColors.primary),
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
    );
  }
}
