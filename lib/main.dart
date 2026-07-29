import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() => runApp(const PortfolioApp());

// ---------- THEME TOKENS ----------
class AppColors {
  static const bg = Color(0xFFFAFAF8);
  static const bgAlt = Color(0xFFF0F2F1);
  static const panel = Color(0xFFFFFFFF);
  static const ink = Color(0xFF0B0E13);
  static const inkSoft = Color(0xFF4B5563);
  static const inkFaint = Color(0xFF94A3B8);
  static const line = Color(0xFFE5E8EB);
  static const accent = Color(0xFF0D6E5C);
  static const accentBright = Color(0xFF17B892);
  static const accentDeep = Color(0xFF0A4F42);
  static const accentSoft = Color(0xFFE7F5F0);
  static const gold = Color(0xFFC08A1E);
  static const roleCustomer = Color(0xFF0D6E5C);
  static const roleStaff = Color(0xFFC08A1E);
  static const roleAdmin = Color(0xFF3C4CA8);

  static const accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentDeep, accent, accentBright],
  );

  static const pageWash = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFCFDFB), bg, bgAlt],
    stops: [0.0, 0.4, 1.0],
  );
}

TextStyle _heading = GoogleFonts.plusJakartaSans(color: AppColors.ink);
TextStyle _body = GoogleFonts.inter(color: AppColors.inkSoft);
TextStyle _mono = GoogleFonts.jetBrainsMono(color: AppColors.inkSoft);

// ---------- DATA ----------
class ProjectData {
  final String name;
  final String tag;
  final String description;
  final String status; // "In development" or "Earlier build"
  final List<String> stack;
  const ProjectData({
    required this.name,
    required this.tag,
    required this.description,
    required this.status,
    required this.stack,
  });
}

const projects = [
  ProjectData(
    name: 'Go Trimzy',
    tag: 'Premium salon & home-service booking — Lahore, Pakistan',
    description:
        'A booking platform connecting customers to salon and home-service '
        'staff, with a full admin backend for managing bookings, staff, and '
        'services across Lahore.',
    status: 'In development',
    stack: [
      'Flutter · Material 3',
      'Riverpod',
      'GoRouter',
      'Clean Architecture',
      'NestJS',
      'PostgreSQL'
    ],
  ),
  ProjectData(
    name: 'Tripme',
    tag: 'Tourism booking platform for foreign visitors to Pakistan',
    description:
        'An end-to-end travel platform for tourists visiting Pakistan — '
        'covering ride & car bookings, hotel stays, and curated lunch/tour '
        'plans, wired to a full NestJS/PostgreSQL backend handling auth, '
        'catalog, bookings, and payments.',
    status: 'In development',
    stack: [
      'React Native',
      'React JS (Admin)',
      'NestJS',
      'PostgreSQL',
      'Payments'
    ],
  ),
  ProjectData(
    name: 'GroomGo',
    tag: 'Premium salon & home-service booking — earlier platform',
    description:
        'The predecessor to Go Trimzy — a salon/home-service booking app '
        'featuring an in-app AI assistant, Uber-style live tracking, '
        'real-time chat, and push notification overlays across all three roles.',
    status: 'Earlier build',
    stack: [
      'Flutter · Material 3',
      'Riverpod',
      'Live tracking',
      'Real-time chat',
      'Push notifications'
    ],
  ),
];

// ---------- APP ----------
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muhammad Usman Bhatti — Portfolio',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const _SmoothScrollBehavior(),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const PortfolioHome(),
    );
  }
}

class _SmoothScrollBehavior extends MaterialScrollBehavior {
  const _SmoothScrollBehavior();
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});
  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final _scrollController = ScrollController();
  final _aboutKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _contactKey = GlobalKey();

  bool _scrolled = false;
  bool _showTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final scrolled = offset > 8;
    final showTop = offset > 480;
    if (scrolled != _scrolled || showTop != _showTop) {
      setState(() {
        _scrolled = scrolled;
        _showTop = showTop;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 650), curve: Curves.easeOutCubic);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 650), curve: Curves.easeOutCubic);
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 760;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.pageWash),
        child: Stack(
        children: [
          Column(
            children: [
              _NavBar(
                isMobile: isMobile,
                scrolled: _scrolled,
                onAbout: () => _scrollTo(_aboutKey),
                onProjects: () => _scrollTo(_projectsKey),
                onSkills: () => _scrollTo(_skillsKey),
                onContact: () => _scrollTo(_contactKey),
                onHire: () => _launch('mailto:usmanbhatti0822@gmail.com'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      _HeroSection(
                          isMobile: isMobile,
                          onViewProjects: () => _scrollTo(_projectsKey),
                          onEmail: () =>
                              _launch('mailto:usmanbhatti0822@gmail.com')),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1080),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 20 : 28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SectionDivider(),
                                _AboutSection(key: _aboutKey, isMobile: isMobile),
                                _SectionDivider(),
                                _ProjectsSection(key: _projectsKey),
                                _SectionDivider(),
                                _SkillsSection(key: _skillsKey, isMobile: isMobile),
                                _SectionDivider(),
                                _ContactFooter(
                                  key: _contactKey,
                                  isMobile: isMobile,
                                  onEmail: () => _launch(
                                      'mailto:usmanbhatti0822@gmail.com'),
                                  onPhone: () => _launch('tel:+923014414894'),
                                  onGithub: () => _launch(
                                      'https://github.com/usmanbhatti0822-ops'),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: isMobile ? 16 : 32,
            bottom: isMobile ? 16 : 32,
            child: IgnorePointer(
              ignoring: !_showTop,
              child: AnimatedSlide(
                offset: _showTop ? Offset.zero : const Offset(0, 0.5),
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                child: AnimatedOpacity(
                  opacity: _showTop ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: _HoverScale(
                    child: Material(
                      color: AppColors.ink,
                      shape: const CircleBorder(),
                      elevation: 6,
                      shadowColor: Colors.black26,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _scrollToTop,
                        child: const Padding(
                          padding: EdgeInsets.all(14),
                          child: Icon(Icons.arrow_upward_rounded,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

// ---------- SHARED INTERACTION HELPERS ----------

/// Reveals [child] with a fade + slide-up the first time it scrolls into view.
class _Reveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const _Reveal({required this.child, this.delay = Duration.zero});
  @override
  State<_Reveal> createState() => _RevealState();
}

class _RevealState extends State<_Reveal> {
  bool _shown = false;
  late final Key _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: (info) {
        if (!_shown && info.visibleFraction > 0.12 && mounted) {
          setState(() => _shown = true);
        }
      },
      child: widget.child
          .animate(target: _shown ? 1 : 0)
          .fadeIn(delay: widget.delay, duration: 550.ms, curve: Curves.easeOut)
          .slideY(
              begin: 0.08,
              end: 0,
              delay: widget.delay,
              duration: 550.ms,
              curve: Curves.easeOutCubic),
    );
  }
}

/// Scales [child] up slightly on hover/press — used for buttons & icons.
class _HoverScale extends StatefulWidget {
  final Widget child;
  final double scale;
  const _HoverScale({required this.child, this.scale = 1.05});
  @override
  State<_HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<_HoverScale> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Animated underline link used in the nav bar and footer.
class _UnderlineLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final TextStyle? style;
  const _UnderlineLink(this.label, this.onTap, {this.style});
  @override
  State<_UnderlineLink> createState() => _UnderlineLinkState();
}

class _UnderlineLinkState extends State<_UnderlineLink> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final style = widget.style ??
        _body.copyWith(fontSize: 14.5, color: AppColors.inkSoft);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.label,
                style: style.copyWith(
                    color: _hover ? AppColors.ink : style.color)),
            const SizedBox(height: 3),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              height: 2,
              width: _hover ? 16 : 0,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- NAV BAR ----------
class _NavBar extends StatelessWidget {
  final bool isMobile;
  final bool scrolled;
  final VoidCallback onAbout, onProjects, onSkills, onContact, onHire;
  const _NavBar({
    required this.isMobile,
    required this.scrolled,
    required this.onAbout,
    required this.onProjects,
    required this.onSkills,
    required this.onContact,
    required this.onHire,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 64,
          decoration: BoxDecoration(
            color: (scrolled ? AppColors.panel : AppColors.bg)
                .withValues(alpha: 0.78),
            border: Border(
                bottom: BorderSide(
                    color: scrolled ? AppColors.line : Colors.transparent)),
            boxShadow: scrolled
                ? [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4)),
                  ]
                : [],
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: _heading.copyWith(
                            fontWeight: FontWeight.w700, fontSize: 17),
                        children: const [
                          TextSpan(text: 'Usman'),
                          TextSpan(
                              text: '.',
                              style: TextStyle(color: AppColors.accent)),
                          TextSpan(text: 'Bhatti'),
                        ],
                      ),
                    ),
                    if (!isMobile)
                      Row(
                        children: [
                          _UnderlineLink('About', onAbout),
                          const SizedBox(width: 28),
                          _UnderlineLink('Projects', onProjects),
                          const SizedBox(width: 28),
                          _UnderlineLink('Skills', onSkills),
                          const SizedBox(width: 28),
                          _UnderlineLink('Contact', onContact),
                          const SizedBox(width: 28),
                        ],
                      ),
                    _HoverScale(
                      scale: 1.04,
                      child: ElevatedButton(
                        onPressed: onHire,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.ink,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          elevation: 0,
                        ),
                        child: Text('Hire me',
                            style: _body.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------- HERO ----------
class _HeroSection extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onViewProjects;
  final VoidCallback onEmail;
  const _HeroSection(
      {required this.isMobile,
      required this.onViewProjects,
      required this.onEmail});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: ClipRect(
              child: Stack(
                children: [
                  Positioned(
                    top: -140,
                    right: isMobile ? -160 : -80,
                    child: _GlowBlob(
                        color: AppColors.accentBright, size: isMobile ? 320 : 460),
                  ),
                  Positioned(
                    top: 40,
                    left: isMobile ? -180 : -120,
                    child: _GlowBlob(
                        color: AppColors.roleAdmin.withValues(alpha: 0.5),
                        size: isMobile ? 260 : 380),
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 28),
              child: Padding(
                padding: EdgeInsets.only(top: isMobile ? 56 : 100, bottom: 64),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                          color: AppColors.accentSoft,
                          borderRadius: BorderRadius.circular(999)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _PulsingDot(),
                          const SizedBox(width: 7),
                          Text('Available for full-stack Flutter projects',
                              style: _mono.copyWith(
                                  color: AppColors.accent, fontSize: 12.5)),
                        ],
                      ),
                    ).animate().fadeIn(duration: 500.ms).slideY(
                        begin: 0.3, end: 0, duration: 500.ms, curve: Curves.easeOut),
                    const SizedBox(height: 24),
                    Text.rich(
                      TextSpan(
                        style: _heading.copyWith(
                          fontSize: isMobile ? 32 : 48,
                          fontWeight: FontWeight.w700,
                          height: 1.12,
                          letterSpacing: -0.5,
                        ),
                        children: [
                          const TextSpan(text: 'Building '),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: ShaderMask(
                              shaderCallback: (bounds) =>
                                  AppColors.accentGradient.createShader(bounds),
                              child: Text(
                                'multi-role booking platforms',
                                style: _heading.copyWith(
                                  fontSize: isMobile ? 32 : 48,
                                  fontWeight: FontWeight.w700,
                                  height: 1.12,
                                  letterSpacing: -0.5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const TextSpan(
                              text:
                                  ' — one Flutter codebase, three apps every time.'),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 120.ms, duration: 600.ms)
                        .slideY(
                            begin: 0.25,
                            end: 0,
                            delay: 120.ms,
                            duration: 600.ms,
                            curve: Curves.easeOutCubic),
                    const SizedBox(height: 20),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Text(
                        "I'm Muhammad Usman Bhatti, a full-stack Flutter developer with 5+ years of "
                        "experience shipping Customer, Staff & Admin apps on a single feature-first "
                        "architecture, backed by NestJS + PostgreSQL — built for the Pakistani & South Asian market.",
                        style: _body.copyWith(fontSize: 16, height: 1.6),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 240.ms, duration: 600.ms)
                        .slideY(
                            begin: 0.25,
                            end: 0,
                            delay: 240.ms,
                            duration: 600.ms,
                            curve: Curves.easeOutCubic),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 14,
                      runSpacing: 12,
                      children: [
                        _HoverScale(
                          scale: 1.035,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: AppColors.accentGradient,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accent.withValues(alpha: 0.28),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: onViewProjects,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 15),
                                  child: Text('View projects',
                                      style: _body.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        _HoverScale(
                          scale: 1.035,
                          child: OutlinedButton(
                            onPressed: onEmail,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.ink,
                              backgroundColor: AppColors.panel,
                              side: const BorderSide(color: AppColors.line),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text('usmanbhatti0822@gmail.com',
                                style:
                                    _body.copyWith(fontWeight: FontWeight.w600, color: AppColors.ink)),
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: 360.ms, duration: 600.ms)
                        .slideY(
                            begin: 0.25,
                            end: 0,
                            delay: 360.ms,
                            duration: 600.ms,
                            curve: Curves.easeOutCubic),
                    const SizedBox(height: 44),
                    const Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _Chip('Flutter'),
                        _Chip('Dart'),
                        _Chip('Riverpod'),
                        _Chip('GoRouter'),
                        _Chip('Material 3'),
                        _Chip('Clean Architecture'),
                        _Chip('NestJS'),
                        _Chip('PostgreSQL'),
                        _Chip('React Native'),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: 480.ms, duration: 600.ms)
                        .slideY(
                            begin: 0.25,
                            end: 0,
                            delay: 480.ms,
                            duration: 600.ms,
                            curve: Curves.easeOutCubic),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowBlob({required this.color, required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.28), color.withValues(alpha: 0.0)],
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: 0, end: 18, duration: 4200.ms, curve: Curves.easeInOut)
        .then()
        .moveX(begin: 0, end: 10, duration: 3600.ms, curve: Curves.easeInOut);
  }
}

class _PulsingDot extends StatelessWidget {
  const _PulsingDot();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
          color: AppColors.accent, shape: BoxShape.circle),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fadeOut(duration: 900.ms, curve: Curves.easeInOut);
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.panel,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: _mono.copyWith(fontSize: 12.5)),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      height: 1,
      color: AppColors.line,
      margin: const EdgeInsets.symmetric(vertical: 8));
}

class _SectionHead extends StatelessWidget {
  final String label;
  final String title;
  final String? subtitle;
  const _SectionHead({required this.label, required this.title, this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40, top: 56),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(),
                style: _mono.copyWith(
                    color: AppColors.accent, fontSize: 12.5, letterSpacing: 1)),
            const SizedBox(height: 10),
            Text(title,
                style: _heading.copyWith(
                    fontSize: 26, fontWeight: FontWeight.w700)),
            if (subtitle != null) ...[
              const SizedBox(height: 10),
              Text(subtitle!,
                  style: _body.copyWith(fontSize: 15, height: 1.5)),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------- ABOUT ----------
class _AboutSection extends StatelessWidget {
  final bool isMobile;
  const _AboutSection({super.key, required this.isMobile});
  @override
  Widget build(BuildContext context) {
    final left = Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Over the last 5 years I've specialised in a specific kind of hard problem: "
            "booking platforms that need to work identically well for three different "
            "people — the customer requesting a service, the staff member fulfilling it, "
            "and the admin running the business behind it.",
            style: _body.copyWith(height: 1.6),
          ),
          const SizedBox(height: 14),
          Text(
            "My stack of choice is Flutter with Material 3, Riverpod for state, GoRouter "
            "for navigation, and a strict feature-first Clean Architecture — paired with a "
            "NestJS + PostgreSQL backend. That combination lets me take a platform from a "
            "single Dart codebase to production across Android, iOS and web without splitting logic three ways.",
            style: _body.copyWith(height: 1.6),
          ),
        ],
      ),
    );
    final right = Expanded(
      flex: 2,
      child: Column(
        children: [
          const _Reveal(child: _FactRow(num: '5+ yrs', label: 'Full-stack Flutter development')),
          const SizedBox(height: 18),
          _Reveal(
            delay: 80.ms,
            child: const _FactRow(
                num: '3',
                label: 'Multi-role platforms shipped (Customer / Staff / Admin)'),
          ),
          const SizedBox(height: 18),
          _Reveal(
            delay: 160.ms,
            child: const _FactRow(
                num: '159',
                label: 'Dart files across 80 screens — Go Trimzy alone'),
          ),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHead(
            label: '01 — About',
            title: 'Full-stack, feature-first, role-based.'),
        isMobile
            ? Column(children: [left, const SizedBox(height: 28), right])
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [left, const SizedBox(width: 48), right]),
      ],
    );
  }
}

class _FactRow extends StatefulWidget {
  final String num, label;
  const _FactRow({required this.num, required this.label});
  @override
  State<_FactRow> createState() => _FactRowState();
}

class _FactRowState extends State<_FactRow> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(
                    color: AppColors.accent, width: _hover ? 4 : 2))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.num,
                style: _mono.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink)),
            Text(widget.label,
                style: _body.copyWith(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// ---------- PROJECTS ----------
class _ProjectsSection extends StatelessWidget {
  const _ProjectsSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHead(
          label: '02 — Selected work',
          title: 'Projects',
          subtitle:
              'Every platform below ships as three coordinated apps sharing one backend — the pattern I keep refining project over project.',
        ),
        for (final entry in projects.asMap().entries) ...[
          _Reveal(
            delay: Duration(milliseconds: entry.key * 90),
            child: _ProjectCard(project: entry.value),
          ),
          const SizedBox(height: 24),
        ],
      ],
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectData project;
  const _ProjectCard({required this.project});
  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final isPast = project.status == 'Earlier build';
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.panel,
          border: Border.all(
              color: _hover ? AppColors.accent.withValues(alpha: 0.4) : AppColors.line),
          borderRadius: BorderRadius.circular(14),
          boxShadow: _hover
              ? [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 28,
                      offset: const Offset(0, 14)),
                ]
              : [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 16,
                      offset: const Offset(0, 6)),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.start,
              runSpacing: 10,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.name,
                        style: _heading.copyWith(
                            fontSize: 21, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 5),
                    Text(project.tag,
                        style: _mono.copyWith(fontSize: 12)),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color:
                        isPast ? const Color(0xFFF1F2F4) : AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isPast) ...[
                        const _PulsingDot(),
                        const SizedBox(width: 6),
                      ],
                      Text(project.status,
                          style: _mono.copyWith(
                              fontSize: 11.5,
                              color: isPast
                                  ? AppColors.inkSoft
                                  : AppColors.accent)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(project.description,
                style: _body.copyWith(height: 1.55)),
            const SizedBox(height: 20),
            const Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                _RolePill(label: 'Customer app', color: AppColors.roleCustomer),
                _RolePill(label: 'Staff app', color: AppColors.roleStaff),
                _RolePill(label: 'Admin panel', color: AppColors.roleAdmin),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [for (final s in project.stack) _Chip(s)]),
          ],
        ),
      ),
    );
  }
}

class _RolePill extends StatelessWidget {
  final String label;
  final Color color;
  const _RolePill({required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 7),
          Text(label, style: _mono.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}

// ---------- SKILLS ----------
class _SkillsSection extends StatelessWidget {
  final bool isMobile;
  const _SkillsSection({super.key, required this.isMobile});

  static const cols = {
    'Mobile / Frontend': [
      'Flutter · Dart',
      'Material 3',
      'Riverpod',
      'GoRouter',
      'React Native'
    ],
    'Backend / Data': [
      'NestJS',
      'PostgreSQL',
      'REST APIs',
      'Auth & payments',
      'React JS (admin panels)'
    ],
    'Architecture': [
      'Clean Architecture',
      'Feature-first structure',
      'Multi-role app design',
      'Real-time chat & tracking',
      'Push notifications'
    ],
  };

  @override
  Widget build(BuildContext context) {
    final entries = cols.entries.toList();
    final columns = [
      for (final e in entries.asMap().entries)
        _Reveal(
          delay: Duration(milliseconds: e.key * 90),
          child: _SkillColumn(title: e.value.key, items: e.value.value),
        )
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHead(label: '03 — Stack', title: 'Skills'),
        isMobile
            ? Column(children: [
                for (final w in columns)
                  Padding(padding: const EdgeInsets.only(bottom: 24), child: w)
              ])
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [for (final w in columns) Expanded(child: w)]),
      ],
    );
  }
}

class _SkillColumn extends StatelessWidget {
  final String title;
  final List<String> items;
  const _SkillColumn({required this.title, required this.items});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: _heading.copyWith(
                  fontWeight: FontWeight.w600, fontSize: 14.5)),
          const SizedBox(height: 14),
          for (final i in items) _SkillRow(label: i),
        ],
      ),
    );
  }
}

class _SkillRow extends StatefulWidget {
  final String label;
  const _SkillRow({required this.label});
  @override
  State<_SkillRow> createState() => _SkillRowState();
}

class _SkillRowState extends State<_SkillRow> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding:
            const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
        margin: const EdgeInsets.only(bottom: 9),
        decoration: BoxDecoration(
          color: _hover ? AppColors.accentSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: const Border(
              bottom: BorderSide(color: AppColors.line)),
        ),
        child: Text(widget.label,
            style: _mono.copyWith(
                fontSize: 13,
                color: _hover ? AppColors.accent : AppColors.inkSoft)),
      ),
    );
  }
}

// ---------- CONTACT / FOOTER ----------
class _ContactFooter extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onEmail, onPhone, onGithub;
  const _ContactFooter(
      {super.key,
      required this.isMobile,
      required this.onEmail,
      required this.onPhone,
      required this.onGithub});
  @override
  Widget build(BuildContext context) {
    final title = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Text("Have a booking platform in mind? Let's build it in Flutter.",
          style: _heading.copyWith(
              fontSize: isMobile ? 22 : 28, fontWeight: FontWeight.w700)),
    );
    final links = Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        _UnderlineLink('usmanbhatti0822@gmail.com', onEmail,
            style: _body.copyWith(fontSize: 14.5, color: AppColors.ink)),
        const SizedBox(height: 10),
        _UnderlineLink('+92 301 4414894', onPhone,
            style: _body.copyWith(fontSize: 14.5, color: AppColors.ink)),
        const SizedBox(height: 10),
        _UnderlineLink('github.com/usmanbhatti0822-ops', onGithub,
            style: _body.copyWith(fontSize: 14.5, color: AppColors.ink)),
      ],
    );
    return _Reveal(
      child: Padding(
        padding: const EdgeInsets.only(top: 56, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [title, const SizedBox(height: 24), links])
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [title, links]),
            const SizedBox(height: 48),
            Container(height: 1, color: AppColors.line),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 8,
              children: [
                Text('Muhammad Usman Bhatti — Full-Stack Flutter Developer',
                    style: _body.copyWith(fontSize: 12.5)),
                Text('Lahore, Pakistan', style: _body.copyWith(fontSize: 12.5)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
