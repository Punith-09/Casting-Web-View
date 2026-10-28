// import 'package:aicc/core/constants/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../core/routes/app_routes.dart';
// import '../../../../core/theme/theme_provider.dart';
// import '../../data/models/audition_model.dart';
// import '../providers/auditions_provider.dart';
// import '../widgets/bottom_action_bar.dart';
//
// class AuditionDetails extends StatefulWidget {
//   final AuditionModel? audition;
//   final String? auditionId;
//
//   const AuditionDetails({
//     super.key,
//     this.audition,
//     this.auditionId,
//   });
//
//   @override
//   State<AuditionDetails> createState() => _AuditionDetailsState();
// }
//
// class _AuditionDetailsState extends State<AuditionDetails> {
//   static const Color _primaryOrange = Color(0xFFDC8B20);
//   static const Color _cardBg = Color(0xFF1B1B1F);
//   static const Color _labelGrey = Color(0xFF8E8E93);
//   static const Color _bodyGrey = Color(0xFF9E9E9E);
//
//   static final AuditionModel _defaultAudition = const AuditionModel(
//     id: "1",
//     title: "Female Lead - Short Film",
//     category: "Short Film",
//     role: "Acting",
//     language: "Telugu",
//     pay: "₹ 15,000",
//     location: "Hyderabad, Telangana",
//     deadline: "10 Oct 2026",
//     auditionDate: "12 Oct 2026",
//     age: "20 - 28 years",
//     gender: "Female",
//     experience: "0 - 2 years",
//     skills: "Acting, expressions, dialogue delivery",
//     description:
//         "We are looking for a female actor for the lead role in an upcoming short film. Candidates should be comfortable with dialogue delivery and expressive acting.",
//     director: "Pulse Studios",
//     phone: "+91 98765 43210",
//     email: "producer@email.com",
//   );
//
//   static const List<String> _monthNames = [
//     'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     final targetId = widget.auditionId ?? widget.audition?.id;
//     if (targetId != null && targetId.isNotEmpty) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         context.read<AuditionsProvider>().fetchAuditionById(
//               targetId,
//               initialData: widget.audition,
//             );
//       });
//     }
//   }
//
//   // ── Formatters & Derivations ──────────────────────────────────────────────
//
//   String _formatDate(String dateStr) {
//     if (dateStr.isEmpty) return 'N/A';
//     final trimmed = dateStr.trim();
//     try {
//       if (trimmed.contains('-')) {
//         final parts = trimmed.split('-');
//         if (parts.length == 3 && parts[0].length == 4) {
//           final year = int.parse(parts[0]);
//           final month = int.parse(parts[1]);
//           final day = int.parse(parts[2].split('T').first.split(' ').first);
//           if (month >= 1 && month <= 12) {
//             return '$day ${_monthNames[month - 1]} $year';
//           }
//         } else if (parts.length == 3 && parts[2].length == 4) {
//           final day = int.parse(parts[0]);
//           final month = int.parse(parts[1]);
//           final year = int.parse(parts[2].split('T').first.split(' ').first);
//           if (month >= 1 && month <= 12) {
//             return '$day ${_monthNames[month - 1]} $year';
//           }
//         }
//       }
//       final dt = DateTime.tryParse(trimmed);
//       if (dt != null) {
//         return '${dt.day} ${_monthNames[dt.month - 1]} ${dt.year}';
//       }
//     } catch (_) {}
//     return trimmed;
//   }
//
//   String _deriveAuditionDate(String auditionDate, String deadline) {
//     if (auditionDate.isNotEmpty) {
//       return _formatDate(auditionDate);
//     }
//     if (deadline.isNotEmpty) {
//       try {
//         final trimmed = deadline.trim();
//         DateTime? dt;
//         if (trimmed.contains('-')) {
//           final parts = trimmed.split('-');
//           if (parts.length == 3 && parts[0].length == 4) {
//             dt = DateTime.tryParse(trimmed.split('T').first);
//           } else if (parts.length == 3 && parts[2].length == 4) {
//             final day = int.parse(parts[0]);
//             final month = int.parse(parts[1]);
//             final year = int.parse(parts[2].split('T').first.split(' ').first);
//             dt = DateTime(year, month, day);
//           }
//         } else {
//           dt = DateTime.tryParse(trimmed);
//         }
//         if (dt != null) {
//           final audDt = dt.add(const Duration(days: 2));
//           return '${audDt.day} ${_monthNames[audDt.month - 1]} ${audDt.year}';
//         }
//       } catch (_) {}
//     }
//     return '12 Oct 2026';
//   }
//
//   String _formatPay(String payStr) {
//     if (payStr.isEmpty) return '₹ 15,000';
//     final trimmed = payStr.trim();
//     if (trimmed.startsWith('₹')) {
//       if (trimmed.length > 1 && trimmed[1] != ' ') {
//         return '₹ ${trimmed.substring(1)}';
//       }
//       return trimmed;
//     }
//     return '₹ $trimmed';
//   }
//
//   String _deriveAge(AuditionModel item) {
//     if (item.age.isNotEmpty) return item.age;
//     final role = item.role;
//     final desc = item.description;
//     final regExp = RegExp(r'(\d{2})\s*[-–]\s*(\d{2})');
//     final match = regExp.firstMatch(role) ?? regExp.firstMatch(desc);
//     if (match != null) {
//       return '${match.group(1)} - ${match.group(2)} years';
//     }
//     return '20 - 28 years';
//   }
//
//   String _deriveGender(AuditionModel item) {
//     if (item.gender.isNotEmpty) return item.gender;
//     final text = '${item.role} ${item.title} ${item.description}'.toLowerCase();
//     if (text.contains('female') || text.contains('actress') || text.contains('woman') || text.contains('girl')) {
//       return 'Female';
//     }
//     if (text.contains('male') || text.contains('actor') || text.contains('man') || text.contains('boy') || text.contains('hero')) {
//       return 'Male';
//     }
//     return 'Female';
//   }
//
//   String _deriveExperience(AuditionModel item) {
//     if (item.experience.isNotEmpty) return item.experience;
//     final text = '${item.role} ${item.description}'.toLowerCase();
//     final regExp = RegExp(r'(\d+)\s*[-–]\s*(\d+)\s*years?');
//     final match = regExp.firstMatch(text);
//     if (match != null) {
//       return '${match.group(1)} - ${match.group(2)} years';
//     }
//     return '0 - 2 years';
//   }
//
//   String _deriveLanguage(AuditionModel item) {
//     if (item.language.isNotEmpty && item.language != 'N/A') {
//       return item.language;
//     }
//     return 'Telugu';
//   }
//
//   String _deriveSkills(AuditionModel item) {
//     if (item.skills.isNotEmpty) return item.skills;
//     if (item.category.toLowerCase().contains('dance')) {
//       return 'Dance, expressions, rhythm';
//     }
//     return 'Acting, expressions, dialogue delivery';
//   }
//
//   String _getDisplayTitle(AuditionModel item) {
//     if (item.title.isNotEmpty) {
//       if (item.category.isNotEmpty &&
//           !item.title.toLowerCase().contains(item.category.toLowerCase()) &&
//           !item.title.contains('-')) {
//         return "${item.title} - ${item.category}";
//       }
//       return item.title;
//     }
//     if (item.role.isNotEmpty && item.category.isNotEmpty) {
//       return "${item.role} - ${item.category}";
//     }
//     return item.role.isNotEmpty ? item.role : "Audition Details";
//   }
//
//   String _getDisplaySubtitle(AuditionModel item) {
//     final category = item.category.isNotEmpty ? item.category : "Short Film";
//     String rolePart = "Acting";
//     if (item.role.isNotEmpty) {
//       final cleanRole = item.role.split('(').first.trim();
//       if (cleanRole.isNotEmpty && cleanRole.toLowerCase() != category.toLowerCase()) {
//         rolePart = cleanRole;
//       }
//     }
//     return "$category  |  $rolePart";
//   }
//
//   // ── UI Components ─────────────────────────────────────────────────────────
//
//   Widget _buildSectionHeader(String title) {
//     return Row(
//       children: [
//         Container(
//           width: 3.5,
//           height: 20,
//           decoration: BoxDecoration(
//             color: _primaryOrange,
//             borderRadius: BorderRadius.circular(2),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Text(
//           title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             letterSpacing: -0.2,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatItem({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             size: 20,
//             color: _primaryOrange,
//           ),
//           const SizedBox(height: 6),
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               color: _labelGrey,
//               fontSize: 11,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             value,
//             textAlign: TextAlign.center,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 11.5,
//               fontWeight: FontWeight.w600,
//               height: 1.25,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDivider() {
//     return VerticalDivider(
//       color: _primaryOrange.withValues(alpha: 0.35),
//       thickness: 1,
//       width: 1,
//       indent: 6,
//       endIndent: 6,
//     );
//   }
//
//   Widget _buildRequirementRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 115,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 color: _labelGrey,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//                 height: 1.3,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildApplicantCard(ApplicantModel applicant) {
//     Color statusColor;
//     switch (applicant.status.toUpperCase()) {
//       case 'APPROVED':
//       case 'ACCEPTED':
//         statusColor = Colors.greenAccent;
//         break;
//       case 'REJECTED':
//         statusColor = Colors.redAccent;
//         break;
//       case 'PENDING':
//       default:
//         statusColor = _primaryOrange;
//         break;
//     }
//
//     final dateStr = applicant.appliedDate.isNotEmpty
//         ? applicant.appliedDate.split('T').first
//         : '';
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _cardBg,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.white.withValues(alpha: 0.08),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 20,
//                 backgroundColor: _primaryOrange.withValues(alpha: 0.2),
//                 child: Text(
//                   applicant.name.isNotEmpty ? applicant.name[0].toUpperCase() : 'A',
//                   style: const TextStyle(
//                     color: _primaryOrange,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       applicant.name.isNotEmpty ? applicant.name : 'Applicant',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     if (dateStr.isNotEmpty) ...[
//                       const SizedBox(height: 2),
//                       Text(
//                         'Applied on $dateStr',
//                         style: const TextStyle(
//                           color: _labelGrey,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//               if (applicant.category.isNotEmpty) ...[
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: _primaryOrange.withValues(alpha: 0.15),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(
//                       color: _primaryOrange.withValues(alpha: 0.4),
//                     ),
//                   ),
//                   child: Text(
//                     applicant.category,
//                     style: const TextStyle(
//                       color: _primaryOrange,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//               ],
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: statusColor.withValues(alpha: 0.15),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: statusColor.withValues(alpha: 0.6)),
//                 ),
//                 child: Text(
//                   applicant.status,
//                   style: TextStyle(
//                     color: statusColor,
//                     fontSize: 11,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           if (applicant.coverLetter.isNotEmpty) ...[
//             const SizedBox(height: 12),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.black.withValues(alpha: 0.3),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Cover Letter:",
//                     style: TextStyle(
//                       color: _labelGrey,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     applicant.coverLetter,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 13,
//                       height: 1.4,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final auditionsProvider = context.watch<AuditionsProvider>();
//     final item = auditionsProvider.selectedAudition ?? widget.audition ?? _defaultAudition;
//     final isLoading = auditionsProvider.isDetailLoading && auditionsProvider.selectedAudition == null;
//     final errorMessage = auditionsProvider.detailErrorMessage;
//
//     final isMyAudition = item.createdByMe ||
//         auditionsProvider.myPostedAuditions.any((a) => a.id == item.id);
//
//     final displayTitle = _getDisplayTitle(item);
//     final displaySubtitle = _getDisplaySubtitle(item);
//     final displayLocation = item.location.isNotEmpty ? item.location : "Hyderabad,\nTelangana";
//     final displayPay = _formatPay(item.pay);
//     final displayDeadline = _formatDate(item.deadline.isNotEmpty ? item.deadline : "10 Oct 2026");
//     final displayAuditionDate = _deriveAuditionDate(item.auditionDate, item.deadline);
//     final displayAge = _deriveAge(item);
//     final displayGender = _deriveGender(item);
//     final displayExperience = _deriveExperience(item);
//     final displayLanguage = _deriveLanguage(item);
//     final displaySkills = _deriveSkills(item);
//     final displayDescription = item.description.isNotEmpty
//         ? item.description
//         : "We are looking for a female actor for the lead role in an upcoming short film. Candidates should be comfortable with dialogue delivery and expressive acting.";
//     final isDark = context.read<ThemeProvider>().isDarkMode;
//     return Scaffold(
//       backgroundColor: isDark?AppColors.black:AppColors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             /// Sleek Back Button Row
//             Padding(
//               padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       if (Navigator.of(context).canPop()) {
//                         context.pop();
//                       } else {
//                         context.go(AppRoutes.auditions);
//                       }
//                     },
//                     icon: const Icon(
//                       Icons.arrow_back_ios_new_rounded,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                     splashRadius: 20,
//                     tooltip: 'Back',
//                   ),
//                 ],
//               ),
//             ),
//
//             if (isLoading)
//               const Expanded(
//                 child: Center(
//                   child: CircularProgressIndicator(color: _primaryOrange),
//                 ),
//               )
//             else if (errorMessage != null && auditionsProvider.selectedAudition == null)
//               Expanded(
//                 child: Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           errorMessage,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(color: Colors.redAccent, fontSize: 16),
//                         ),
//                         const SizedBox(height: 16),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: _primaryOrange,
//                             foregroundColor: Colors.white,
//                           ),
//                           onPressed: () {
//                             final targetId = widget.auditionId ?? widget.audition?.id;
//                             if (targetId != null) {
//                               context.read<AuditionsProvider>().fetchAuditionById(targetId);
//                             }
//                           },
//                           child: const Text("Retry"),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//             else
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 8),
//
//                       /// Title
//                       Text(
//                         displayTitle,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: -0.3,
//                         ),
//                       ),
//
//                       const SizedBox(height: 6),
//
//                       /// Subtitle: Category  |  Role
//                       Text(
//                         displaySubtitle,
//                         style: const TextStyle(
//                           color: _primaryOrange,
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 0.2,
//                         ),
//                       ),
//
//                       const SizedBox(height: 22),
//
//                       /// 4-Column Card (Location | Pay | Deadline | Audition Date)
//                       Container(
//                         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
//                         decoration: BoxDecoration(
//                           color: _cardBg,
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: Colors.white.withValues(alpha: 0.08),
//                             width: 1,
//                           ),
//                         ),
//                         child: IntrinsicHeight(
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: _buildStatItem(
//                                   icon: Icons.location_on_outlined,
//                                   label: "Location",
//                                   value: displayLocation,
//                                 ),
//                               ),
//                               _buildDivider(),
//                               Expanded(
//                                 child: _buildStatItem(
//                                   icon: Icons.currency_rupee,
//                                   label: "Pay",
//                                   value: displayPay,
//                                 ),
//                               ),
//                               _buildDivider(),
//                               Expanded(
//                                 child: _buildStatItem(
//                                   icon: Icons.calendar_today_outlined,
//                                   label: "Deadline",
//                                   value: displayDeadline,
//                                 ),
//                               ),
//                               _buildDivider(),
//                               Expanded(
//                                 child: _buildStatItem(
//                                   icon: Icons.calendar_month_outlined,
//                                   label: "Audition Date",
//                                   value: displayAuditionDate,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 28),
//
//                       /// About the Audition Section
//                       _buildSectionHeader("About the Audition"),
//                       const SizedBox(height: 12),
//                       Text(
//                         displayDescription,
//                         style: const TextStyle(
//                           color: _bodyGrey,
//                           fontSize: 13.5,
//                           height: 1.55,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//
//                       const SizedBox(height: 28),
//
//                       /// Role Requirements Section
//                       _buildSectionHeader("Role Requirements"),
//                       const SizedBox(height: 16),
//                       _buildRequirementRow("Age", displayAge),
//                       _buildRequirementRow("Gender", displayGender),
//                       _buildRequirementRow("Experience", displayExperience),
//                       _buildRequirementRow("Language", displayLanguage),
//                       _buildRequirementRow("Skills", displaySkills),
//
//                       /// Show applicants section if this audition was created by the user or has applicants
//                       if (isMyAudition || item.applicants.isNotEmpty) ...[
//                         const SizedBox(height: 28),
//                         _buildSectionHeader("Applicants (${item.applicantsCount})"),
//                         const SizedBox(height: 14),
//                         if (item.applicants.isEmpty)
//                           const Padding(
//                             padding: EdgeInsets.symmetric(vertical: 8),
//                             child: Text(
//                               "No applicants yet.",
//                               style: TextStyle(
//                                 color: _labelGrey,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           )
//                         else
//                           ...item.applicants.map((a) => _buildApplicantCard(a)),
//                       ],
//
//                       const SizedBox(height: 30),
//                     ],
//                   ),
//                 ),
//               ),
//
//             /// Bottom Apply Bar (shown only if not created by me)
//             if (!isMyAudition)
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
//                 child: BottomActionBar(audition: item),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:aicc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/api/api_endpoints.dart';
import '../../../../core/responsive/responsive_breakpoints.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../apply_job/presentation/providers/apply_job_provider.dart';
import '../../../explore/presentation/providers/explore_provider.dart';
import '../../data/models/audition_model.dart';
import '../providers/auditions_provider.dart';
import '../widgets/bottom_action_bar.dart';

class AuditionDetails extends StatefulWidget {
  final AuditionModel? audition;
  final String? auditionId;

  const AuditionDetails({
    super.key,
    this.audition,
    this.auditionId,
  });

  @override
  State<AuditionDetails> createState() => _AuditionDetailsState();
}

class _AuditionDetailsState extends State<AuditionDetails> {
  // Track optimistic local status updates keyed by applicant (application) ID
  final Map<String, String> _localStatusOverrides = {};
  final Set<String> _updatingIds = {};
  // ---------------------------------------------------------------------------
  // THEME COLORS
  // ---------------------------------------------------------------------------

  static const Color _primaryOrange = Color(0xFFDC8B20);

  bool get _isDark => context.watch<ThemeProvider>().isDarkMode;

  Color get _cardBg {
    return _isDark
        ? const Color(0xFF1B1B1F)
        : const Color(0xFFF5F5F5);
  }

  Color get _primaryText {
    return _isDark
        ? Colors.white
        : const Color(0xFF1B1B1F);
  }

  Color get _secondaryText {
    return _isDark
        ? const Color(0xFF9E9E9E)
        : const Color(0xFF666666);
  }

  Color get _labelGrey {
    return _isDark
        ? const Color(0xFF8E8E93)
        : const Color(0xFF777777);
  }

  Color get _borderColor {
    return _isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.08);
  }

  Color get _innerCardBg {
    return _isDark
        ? Colors.black.withValues(alpha: 0.30)
        : Colors.black.withValues(alpha: 0.04);
  }

  // ---------------------------------------------------------------------------
  // DEFAULT AUDITION
  // ---------------------------------------------------------------------------

  static final AuditionModel _defaultAudition = const AuditionModel(
    id: "1",
    title: "Female Lead - Short Film",
    category: "Short Film",
    role: "Acting",
    language: "Telugu",
    pay: "₹ 15,000",
    location: "Hyderabad, Telangana",
    deadline: "10 Oct 2026",
    auditionDate: "12 Oct 2026",
    age: "20 - 28 years",
    gender: "Female",
    experience: "0 - 2 years",
    skills: "Acting, expressions, dialogue delivery",
    description:
    "We are looking for a female actor for the lead role in an upcoming short film. Candidates should be comfortable with dialogue delivery and expressive acting.",
    director: "Pulse Studios",
    phone: "+91 98765 43210",
    email: "producer@email.com",
  );

  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  // ---------------------------------------------------------------------------
  // INIT
  // ---------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    final targetId = widget.auditionId ?? widget.audition?.id;

    if (targetId != null && targetId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AuditionsProvider>().fetchAuditionById(
          targetId,
          initialData: widget.audition,
        );
      });
    }
  }

  // ---------------------------------------------------------------------------
  // FORMATTERS & DERIVATIONS
  // ---------------------------------------------------------------------------

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return 'N/A';

    final trimmed = dateStr.trim();

    try {
      if (trimmed.contains('-')) {
        final parts = trimmed.split('-');

        if (parts.length == 3 && parts[0].length == 4) {
          final year = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final day = int.parse(
            parts[2].split('T').first.split(' ').first,
          );

          if (month >= 1 && month <= 12) {
            return '$day ${_monthNames[month - 1]} $year';
          }
        } else if (parts.length == 3 && parts[2].length == 4) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(
            parts[2].split('T').first.split(' ').first,
          );

          if (month >= 1 && month <= 12) {
            return '$day ${_monthNames[month - 1]} $year';
          }
        }
      }

      final dt = DateTime.tryParse(trimmed);

      if (dt != null) {
        return '${dt.day} ${_monthNames[dt.month - 1]} ${dt.year}';
      }
    } catch (_) {}

    return trimmed;
  }

  String _deriveAuditionDate(
      String auditionDate,
      String deadline,
      ) {
    if (auditionDate.isNotEmpty) {
      return _formatDate(auditionDate);
    }

    if (deadline.isNotEmpty) {
      try {
        final trimmed = deadline.trim();

        DateTime? dt;

        if (trimmed.contains('-')) {
          final parts = trimmed.split('-');

          if (parts.length == 3 && parts[0].length == 4) {
            dt = DateTime.tryParse(
              trimmed.split('T').first,
            );
          } else if (parts.length == 3 && parts[2].length == 4) {
            final day = int.parse(parts[0]);
            final month = int.parse(parts[1]);
            final year = int.parse(
              parts[2].split('T').first.split(' ').first,
            );

            dt = DateTime(year, month, day);
          }
        } else {
          dt = DateTime.tryParse(trimmed);
        }

        if (dt != null) {
          final audDt = dt.add(const Duration(days: 2));

          return '${audDt.day} '
              '${_monthNames[audDt.month - 1]} '
              '${audDt.year}';
        }
      } catch (_) {}
    }

    return '12 Oct 2026';
  }

  String _formatPay(String payStr) {
    if (payStr.isEmpty) return '₹ 15,000';

    final trimmed = payStr.trim();

    if (trimmed.startsWith('₹')) {
      if (trimmed.length > 1 && trimmed[1] != ' ') {
        return '₹ ${trimmed.substring(1)}';
      }

      return trimmed;
    }

    return '₹ $trimmed';
  }

  String _deriveAge(AuditionModel item) {
    if (item.age.isNotEmpty) return item.age;

    final role = item.role;
    final desc = item.description;

    final regExp = RegExp(r'(\d{2})\s*[-–]\s*(\d{2})');

    final match =
        regExp.firstMatch(role) ?? regExp.firstMatch(desc);

    if (match != null) {
      return '${match.group(1)} - ${match.group(2)} years';
    }

    return '20 - 28 years';
  }

  String _deriveGender(AuditionModel item) {
    if (item.gender.isNotEmpty) return item.gender;

    final text =
    '${item.role} ${item.title} ${item.description}'.toLowerCase();

    if (text.contains('female') ||
        text.contains('actress') ||
        text.contains('woman') ||
        text.contains('girl')) {
      return 'Female';
    }

    if (text.contains('male') ||
        text.contains('actor') ||
        text.contains('man') ||
        text.contains('boy') ||
        text.contains('hero')) {
      return 'Male';
    }

    return 'Female';
  }

  String _deriveExperience(AuditionModel item) {
    if (item.experience.isNotEmpty) {
      return item.experience;
    }

    final text =
    '${item.role} ${item.description}'.toLowerCase();

    final regExp = RegExp(
      r'(\d+)\s*[-–]\s*(\d+)\s*years?',
    );

    final match = regExp.firstMatch(text);

    if (match != null) {
      return '${match.group(1)} - ${match.group(2)} years';
    }

    return '0 - 2 years';
  }

  String _deriveLanguage(AuditionModel item) {
    if (item.language.isNotEmpty && item.language != 'N/A') {
      return item.language;
    }

    return 'Telugu';
  }

  String _deriveSkills(AuditionModel item) {
    if (item.skills.isNotEmpty) {
      return item.skills;
    }

    if (item.category.toLowerCase().contains('dance')) {
      return 'Dance, expressions, rhythm';
    }

    return 'Acting, expressions, dialogue delivery';
  }

  String _getDisplayTitle(AuditionModel item) {
    if (item.title.isNotEmpty) {
      if (item.category.isNotEmpty &&
          !item.title
              .toLowerCase()
              .contains(item.category.toLowerCase()) &&
          !item.title.contains('-')) {
        return "${item.title} - ${item.category}";
      }

      return item.title;
    }

    if (item.role.isNotEmpty && item.category.isNotEmpty) {
      return "${item.role} - ${item.category}";
    }

    return item.role.isNotEmpty
        ? item.role
        : "Audition Details";
  }

  String _getDisplaySubtitle(AuditionModel item) {
    final category =
    item.category.isNotEmpty ? item.category : "Short Film";

    String rolePart = "Acting";

    if (item.role.isNotEmpty) {
      final cleanRole = item.role.split('(').first.trim();

      if (cleanRole.isNotEmpty &&
          cleanRole.toLowerCase() != category.toLowerCase()) {
        rolePart = cleanRole;
      }
    }

    return "$category  |  $rolePart";
  }

  // ---------------------------------------------------------------------------
  // UI COMPONENTS
  // ---------------------------------------------------------------------------

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 3.5,
          height: 20,
          decoration: BoxDecoration(
            color: _primaryOrange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color: _primaryText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: _primaryOrange,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _labelGrey,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _primaryText,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return VerticalDivider(
      color: _primaryOrange.withValues(alpha: 0.35),
      thickness: 1,
      width: 1,
      indent: 6,
      endIndent: 6,
    );
  }

  Widget _buildRequirementRow(
      String label,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 115,
            child: Text(
              label,
              style: TextStyle(
                color: _labelGrey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: _primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openApplicantProfile(ApplicantModel applicant) {
    String targetId = applicant.targetUserId;
    if (targetId.isEmpty) {
      try {
        final exploreProvider = context.read<ExploreProvider>();
        final match = exploreProvider.talents.firstWhere(
          (t) =>
              t.name.trim().toLowerCase() ==
              applicant.name.trim().toLowerCase(),
        );
        targetId = match.id;
      } catch (_) {}
    }

    if (targetId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Applicant profile information is unavailable"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final currentUserId = LocalStorage.instance.getUserId();
    if (currentUserId != null &&
        currentUserId.isNotEmpty &&
        targetId == currentUserId) {
      context.push(AppRoutes.artistProfile);
    } else {
      context.push(AppRoutes.exploreProfile, extra: targetId);
    }
  }

  Widget _buildApplicantAvatar(ApplicantModel applicant) {
    final picUrl = applicant.profilePicture.trim();
    final formattedPic =
        picUrl.isNotEmpty ? ApiEndpoints.formatMediaUrl(picUrl) : '';
    final hasValidPic = formattedPic.startsWith('http');

    if (hasValidPic) {
      return ClipOval(
        child: SizedBox(
          width: 40,
          height: 40,
          child: Image.network(
            formattedPic,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            errorBuilder: (_, error, stackTrace) =>
                _buildFallbackInitialAvatar(applicant),
          ),
        ),
      );
    }
    return _buildFallbackInitialAvatar(applicant);
  }

  Widget _buildFallbackInitialAvatar(ApplicantModel applicant) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: _primaryOrange.withValues(alpha: 0.2),
      child: Text(
        applicant.name.isNotEmpty ? applicant.name[0].toUpperCase() : 'A',
        style: const TextStyle(
          color: _primaryOrange,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Future<void> _updateApplicantStatus(
    ApplicantModel applicant,
    String newStatus,
  ) async {
    final applicationId = applicant.id;
    if (applicationId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application ID is missing. Cannot update status.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    if (_updatingIds.contains(applicationId)) return;

    setState(() {
      _updatingIds.add(applicationId);
    });

    final success = await context
        .read<ApplyJobProvider>()
        .updateApplicationStatus(
          applicationId: applicationId,
          status: newStatus,
        );

    if (!mounted) return;

    if (success) {
      setState(() {
        _localStatusOverrides[applicationId] = newStatus;
        _updatingIds.remove(applicationId);
      });

      // Update the badge on the auditions list card for the applicant
      final auditionId = widget.auditionId ??
          widget.audition?.id ??
          context.read<AuditionsProvider>().selectedAudition?.id ??
          '';
      if (auditionId.isNotEmpty) {
        context
            .read<AuditionsProvider>()
            .markAuditionApplicationStatus(auditionId, newStatus);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus == 'SHORTLISTED'
                ? 'Candidate shortlisted successfully!'
                : 'Candidate rejected.',
          ),
          backgroundColor:
              newStatus == 'SHORTLISTED' ? Colors.green : Colors.redAccent,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      setState(() {
        _updatingIds.remove(applicationId);
      });
      final err = context.read<ApplyJobProvider>().errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err ?? 'Failed to update status.'),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildApplicantCard(
      ApplicantModel applicant,
      ) {
    // Use local override if available (optimistic update)
    final effectiveStatus =
        _localStatusOverrides[applicant.id] ?? applicant.status;
    final isPending =
        effectiveStatus.toUpperCase() == 'PENDING';
    final isUpdating = _updatingIds.contains(applicant.id);

    Color statusColor;
    switch (effectiveStatus.toUpperCase()) {
      case 'APPROVED':
      case 'ACCEPTED':
      case 'SHORTLISTED':
        statusColor = Colors.green;
        break;
      case 'REJECTED':
        statusColor = Colors.redAccent;
        break;
      case 'PENDING':
      default:
        statusColor = _primaryOrange;
        break;
    }

    final dateStr = applicant.appliedDate.isNotEmpty
        ? applicant.appliedDate.split('T').first
        : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _borderColor,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openApplicantProfile(applicant),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildApplicantAvatar(applicant),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  applicant.name.isNotEmpty
                                      ? applicant.name
                                      : 'Applicant',
                                  style: TextStyle(
                                    color: _primaryText,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color: _labelGrey.withValues(alpha: 0.7),
                              ),
                            ],
                          ),
                          if (dateStr.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Applied on $dateStr',
                              style: TextStyle(
                                color: _labelGrey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ---- Action row ----
                if (isUpdating)
                  const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _primaryOrange,
                      ),
                    ),
                  )
                else if (isPending)
                  // Show Shortlist + Reject buttons for PENDING applicants
                  Row(
                    children: [
                      if (applicant.category.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _primaryOrange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _primaryOrange.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            applicant.category,
                            style: const TextStyle(
                              color: _primaryOrange,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      const Spacer(),
                      // Shortlist button
                      GestureDetector(
                        onTap: () => _updateApplicantStatus(
                          applicant,
                          'SHORTLISTED',
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _primaryOrange,
                              width: 1.4,
                            ),
                          ),
                          child: const Text(
                            'Shortlist',
                            style: TextStyle(
                              color: _primaryOrange,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Reject button
                      GestureDetector(
                        onTap: () => _updateApplicantStatus(
                          applicant,
                          'REJECTED',
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.redAccent,
                              width: 1.4,
                            ),
                          ),
                          child: const Text(
                            'Reject',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  // Already processed — show category chip + status badge
                  Row(
                    children: [
                      if (applicant.category.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _primaryOrange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _primaryOrange.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            applicant.category,
                            style: const TextStyle(
                              color: _primaryOrange,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: statusColor.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Text(
                          effectiveStatus,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                if (applicant.coverLetter.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _innerCardBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cover Letter:",
                          style: TextStyle(
                            color: _labelGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          applicant.coverLetter,
                          style: TextStyle(
                            color: _primaryText,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final auditionsProvider =
    context.watch<AuditionsProvider>();

    final item = auditionsProvider.selectedAudition ??
        widget.audition ??
        _defaultAudition;

    final isLoading =
        auditionsProvider.isDetailLoading &&
            auditionsProvider.selectedAudition == null;

    final errorMessage =
        auditionsProvider.detailErrorMessage;

    final isMyAudition = item.createdByMe ||
        auditionsProvider.myPostedAuditions
            .any((a) => a.id == item.id);

    final displayTitle = _getDisplayTitle(item);

    final displaySubtitle =
    _getDisplaySubtitle(item);

    final displayLocation = item.location.isNotEmpty
        ? item.location
        : "Hyderabad,\nTelangana";

    final displayPay = _formatPay(item.pay);

    final displayDeadline = _formatDate(
      item.deadline.isNotEmpty
          ? item.deadline
          : "10 Oct 2026",
    );

    final displayAuditionDate =
    _deriveAuditionDate(
      item.auditionDate,
      item.deadline,
    );

    final displayDescription =
    item.description.isNotEmpty
        ? item.description
        : "We are looking for a female actor for the lead role in an upcoming short film. Candidates should be comfortable with dialogue delivery and expressive acting.";

    final isDesktop = ResponsiveBreakpoints.isDesktop(context);

    if (isDesktop) {
      return Scaffold(
        backgroundColor:
            _isDark ? const Color(0xFF0B0F17) : const Color(0xFFF1F5F9),
        body: SafeArea(
          child: _buildDesktopLayout(
            context,
            item,
            isLoading,
            errorMessage,
            isMyAudition,
            displayTitle,
            displaySubtitle,
            displayLocation,
            displayPay,
            displayDeadline,
            displayAuditionDate,
            displayDescription,
            auditionsProvider,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
      _isDark ? AppColors.black : AppColors.white,

      body: SafeArea(
        child: Column(
          children: [
            // -----------------------------------------------------------------
            // BACK BUTTON
            // -----------------------------------------------------------------

            Padding(
              padding: const EdgeInsets.only(
                left: 12,
                top: 4,
                bottom: 4,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        context.pop();
                      } else {
                        context.go(
                          AppRoutes.auditions,
                        );
                      }
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: _primaryText,
                      size: 20,
                    ),
                    splashRadius: 20,
                    tooltip: 'Back',
                  ),
                ],
              ),
            ),

            // -----------------------------------------------------------------
            // LOADING
            // -----------------------------------------------------------------

            if (isLoading)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: _primaryOrange,
                  ),
                ),
              )

            // -----------------------------------------------------------------
            // ERROR
            // -----------------------------------------------------------------

            else if (errorMessage != null &&
                auditionsProvider.selectedAudition == null)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            _primaryOrange,
                            foregroundColor:
                            Colors.white,
                          ),
                          onPressed: () {
                            final targetId =
                                widget.auditionId ??
                                    widget.audition?.id;

                            if (targetId != null) {
                              context
                                  .read<
                                  AuditionsProvider>()
                                  .fetchAuditionById(
                                targetId,
                              );
                            }
                          },
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                ),
              )

            // -----------------------------------------------------------------
            // MAIN CONTENT
            // -----------------------------------------------------------------

            else
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // -------------------------------------------------------
                      // TITLE
                      // -------------------------------------------------------

                      Text(
                        displayTitle,
                        style: TextStyle(
                          color: _primaryText,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // -------------------------------------------------------
                      // SUBTITLE
                      // -------------------------------------------------------

                      Text(
                        displaySubtitle,
                        style: const TextStyle(
                          color: _primaryOrange,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),

                      const SizedBox(height: 22),

                      // -------------------------------------------------------
                      // 4 COLUMN STAT CARD
                      // -------------------------------------------------------

                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _cardBg,
                          borderRadius:
                          BorderRadius.circular(16),
                          border: Border.all(
                            color: _borderColor,
                            width: 1,
                          ),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildStatItem(
                                  icon: Icons
                                      .location_on_outlined,
                                  label: "Location",
                                  value:
                                  displayLocation,
                                ),
                              ),

                              _buildDivider(),

                              Expanded(
                                child: _buildStatItem(
                                  icon: Icons
                                      .currency_rupee,
                                  label: "Pay",
                                  value: displayPay,
                                ),
                              ),

                              _buildDivider(),

                              Expanded(
                                child: _buildStatItem(
                                  icon: Icons
                                      .calendar_today_outlined,
                                  label: "Deadline",
                                  value:
                                  displayDeadline,
                                ),
                              ),

                              _buildDivider(),

                              Expanded(
                                child: _buildStatItem(
                                  icon: Icons
                                      .calendar_month_outlined,
                                  label: "Audition Date",
                                  value:
                                  displayAuditionDate,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // -------------------------------------------------------
                      // ABOUT AUDITION
                      // -------------------------------------------------------

                      _buildSectionHeader(
                        "About the Audition",
                      ),

                      const SizedBox(height: 12),

                      Text(
                        displayDescription,
                        style: TextStyle(
                          color: _secondaryText,
                          fontSize: 13.5,
                          height: 1.55,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // -------------------------------------------------------
                      // ROLE REQUIREMENTS
                      // -------------------------------------------------------

                      // _buildSectionHeader(
                      //   "Role Requirements",
                      // ),
                      //
                      // const SizedBox(height: 16),
                      //
                      // _buildRequirementRow(
                      //   "Age",
                      //   displayAge,
                      // ),
                      //
                      // _buildRequirementRow(
                      //   "Gender",
                      //   displayGender,
                      // ),
                      //
                      // _buildRequirementRow(
                      //   "Experience",
                      //   displayExperience,
                      // ),
                      //
                      // _buildRequirementRow(
                      //   "Language",
                      //   displayLanguage,
                      // ),
                      //
                      // _buildRequirementRow(
                      //   "Skills",
                      //   displaySkills,
                      // ),

                      // -------------------------------------------------------
                      // APPLICANTS
                      // -------------------------------------------------------

                      if (isMyAudition ||
                          item.applicants.isNotEmpty) ...[
                        const SizedBox(height: 28),

                        _buildSectionHeader(
                          "Applicants (${item.applicantsCount})",
                        ),

                        const SizedBox(height: 14),

                        if (item.applicants.isEmpty)
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            child: Text(
                              "No applicants yet.",
                              style: TextStyle(
                                color: _labelGrey,
                                fontSize: 14,
                              ),
                            ),
                          )
                        else
                          ...item.applicants.map(
                                (a) =>
                                _buildApplicantCard(a),
                          ),
                      ],

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

            // -----------------------------------------------------------------
            // BOTTOM APPLY BAR
            // -----------------------------------------------------------------

            if (!isMyAudition)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  20,
                ),
                child: BottomActionBar(
                  audition: item,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // DESKTOP LAYOUT (Web View)
  // ===========================================================================

  Widget _buildDesktopLayout(
    BuildContext context,
    AuditionModel item,
    bool isLoading,
    String? errorMessage,
    bool isMyAudition,
    String displayTitle,
    String displaySubtitle,
    String displayLocation,
    String displayPay,
    String displayDeadline,
    String displayAuditionDate,
    String displayDescription,
    AuditionsProvider auditionsProvider,
  ) {
    if (isLoading) {
      return Column(
        children: [
          _buildDesktopTopBar(context, item, isMyAudition),
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(color: _primaryOrange),
            ),
          ),
        ],
      );
    }

    if (errorMessage != null && auditionsProvider.selectedAudition == null) {
      return Column(
        children: [
          _buildDesktopTopBar(context, item, isMyAudition),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryOrange,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        final targetId = widget.auditionId ?? widget.audition?.id;
                        if (targetId != null) {
                          context.read<AuditionsProvider>().fetchAuditionById(targetId);
                        }
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        _buildDesktopTopBar(context, item, isMyAudition),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1040),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Content (65% width)
                    Expanded(
                      flex: 65,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Role Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: _cardBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: _borderColor, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: _isDark ? 0.3 : 0.04),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _primaryOrange.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        item.category.isNotEmpty ? item.category : 'Audition',
                                        style: const TextStyle(
                                          color: _primaryOrange,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    if (item.role.isNotEmpty) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _isDark
                                              ? Colors.white.withValues(alpha: 0.08)
                                              : Colors.black.withValues(alpha: 0.05),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          item.role,
                                          style: TextStyle(
                                            color: _isDark ? Colors.white70 : const Color(0xFF475569),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  displayTitle,
                                  style: TextStyle(
                                    color: _primaryText,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  displaySubtitle,
                                  style: const TextStyle(
                                    color: _primaryOrange,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // 4 Column Stat Card
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                            decoration: BoxDecoration(
                              color: _cardBg,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: _borderColor, width: 1),
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildStatItem(
                                      icon: Icons.location_on_outlined,
                                      label: "Location",
                                      value: displayLocation,
                                    ),
                                  ),
                                  _buildDivider(),
                                  Expanded(
                                    child: _buildStatItem(
                                      icon: Icons.currency_rupee,
                                      label: "Pay",
                                      value: displayPay,
                                    ),
                                  ),
                                  _buildDivider(),
                                  Expanded(
                                    child: _buildStatItem(
                                      icon: Icons.calendar_today_outlined,
                                      label: "Deadline",
                                      value: displayDeadline,
                                    ),
                                  ),
                                  _buildDivider(),
                                  Expanded(
                                    child: _buildStatItem(
                                      icon: Icons.calendar_month_outlined,
                                      label: "Audition Date",
                                      value: displayAuditionDate,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // About Section
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: _cardBg,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: _borderColor, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader("About the Audition"),
                                const SizedBox(height: 12),
                                Text(
                                  displayDescription,
                                  style: TextStyle(
                                    color: _secondaryText,
                                    fontSize: 14,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Applicants section (if creator or has applicants)
                          if (isMyAudition || item.applicants.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                color: _cardBg,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: _borderColor, width: 1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildSectionHeader("Applicants (${item.applicantsCount})"),
                                      if (item.applicants.isNotEmpty)
                                        Text(
                                          "${item.applicants.length} reviewed",
                                          style: TextStyle(
                                            color: _labelGrey,
                                            fontSize: 12,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  if (item.applicants.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 24),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.people_outline_rounded,
                                              size: 40,
                                              color: _labelGrey.withValues(alpha: 0.6),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              "No applicants yet",
                                              style: TextStyle(
                                                color: _primaryText,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "When candidates apply, their profiles and audition reels will appear here.",
                                              style: TextStyle(
                                                color: _labelGrey,
                                                fontSize: 12.5,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  else
                                    ...item.applicants.map((a) => _buildApplicantCard(a)),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(width: 28),

                    // Right Sidebar (35% width)
                    Expanded(
                      flex: 35,
                      child: Column(
                        children: [
                          if (!isMyAudition) ...[
                            // Candidate Apply Box
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                color: _cardBg,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: _borderColor, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: _isDark ? 0.35 : 0.04),
                                    blurRadius: 18,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Ready to Apply?",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: _primaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Submit your profile and cover note to the casting team.",
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: _secondaryText,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Divider(color: _borderColor, height: 1),
                                  const SizedBox(height: 16),
                                  _buildSidebarInfoRow(Icons.currency_rupee, "Compensation", displayPay),
                                  const SizedBox(height: 12),
                                  _buildSidebarInfoRow(Icons.location_on_outlined, "Location", displayLocation),
                                  const SizedBox(height: 12),
                                  _buildSidebarInfoRow(Icons.schedule_outlined, "Deadline", displayDeadline),
                                  const SizedBox(height: 24),
                                  // BottomActionBar widget
                                  BottomActionBar(audition: item),
                                ],
                              ),
                            ),
                          ] else ...[
                            // Creator Management Box
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                color: _cardBg,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: _borderColor, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: _isDark ? 0.35 : 0.04),
                                    blurRadius: 18,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Audition Overview",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: _primaryText,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981).withValues(alpha: 0.14),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(radius: 3, backgroundColor: Color(0xFF10B981)),
                                            SizedBox(width: 5),
                                            Text(
                                              "Live",
                                              style: TextStyle(
                                                color: Color(0xFF10B981),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  Divider(color: _borderColor, height: 1),
                                  const SizedBox(height: 16),
                                  _buildSidebarInfoRow(Icons.people_outline_rounded, "Total Applicants", "${item.applicantsCount}"),
                                  const SizedBox(height: 12),
                                  _buildSidebarInfoRow(Icons.category_outlined, "Role Category", item.category.isNotEmpty ? item.category : 'General'),
                                  const SizedBox(height: 12),
                                  _buildSidebarInfoRow(Icons.calendar_today_outlined, "Application Deadline", displayDeadline),
                                  const SizedBox(height: 20),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _primaryOrange.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: _primaryOrange.withValues(alpha: 0.2)),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.info_outline_rounded, size: 16, color: _primaryOrange),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "You can shortlist or reject applicants on this page. Shortlisted artists will see the updated status.",
                                            style: TextStyle(
                                              color: _isDark ? Colors.white70 : const Color(0xFF334155),
                                              fontSize: 12,
                                              height: 1.4,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopTopBar(BuildContext context, AuditionModel item, bool isMyAudition) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: _isDark ? const Color(0xFF161C26) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: _isDark ? const Color(0xFF263040) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if (Navigator.of(context).canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.auditions);
                  }
                },
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: _primaryText,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Back to Auditions',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                isMyAudition ? 'My Posted Audition' : 'Audition Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _primaryText,
                ),
              ),
              if (isMyAudition)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: _primaryOrange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _primaryOrange.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '${item.applicantsCount} Applicants',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: _primaryOrange,
                    ),
                  ),
                )
              else
                const SizedBox(width: 140),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _primaryOrange),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: _labelGrey, fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: _primaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
