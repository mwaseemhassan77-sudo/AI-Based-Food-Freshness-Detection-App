import 'dart:math';
import 'package:flutter/material.dart';
import 'package:safebite/ChatBoat/boatMessageModel/messagemodel.dart';
import 'package:safebite/ChatBoat/services/groq_services.dart';
import 'package:safebite/core/theme/app_theme.dart';

class ChatBoatScreen extends StatefulWidget {
  const ChatBoatScreen({super.key});

  @override
  State<ChatBoatScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBoatScreen>
    with TickerProviderStateMixin {

  // ── Controllers ─────────────────────────────────────────
  final TextEditingController _msgCtrl    = TextEditingController();
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController      _scrollCtrl = ScrollController();
  final FocusNode             _focusNode  = FocusNode();

  // ── State ───────────────────────────────────────────────
  bool   _showSearch  = false;
  bool   _isTyping    = false;
  bool   _hasText     = false;
  String _searchQuery = '';

  late AnimationController _typingAnimCtrl;

  // final List<ChatMessage> _messages = [];
  final List<ChatMessage> _messages = [];

final GroqService _groqService = GroqService();

bool _isSending = false;

  // ════════════════════════════════════════════════════════
  //  LIFECYCLE
  // ════════════════════════════════════════════════════════
  @override
  void initState() {
    super.initState();

    _typingAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _msgCtrl.addListener(
      () => setState(() => _hasText = _msgCtrl.text.trim().isNotEmpty),
    );
  }

  @override
  void dispose() {
    _typingAnimCtrl.dispose();
    _msgCtrl.dispose();
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ── Scroll ──────────────────────────────────────────────
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ════════════════════════════════════════════════════════
  //  SEND MESSAGE
  // ════════════════════════════════════════════════════════
  // Future<void> _sendMessage() async {
  //   final text = _msgCtrl.text.trim();
  //   if (text.isEmpty) return;

  //   setState(() {
  //     _messages.add(ChatMessage(
  //       id: '${DateTime.now().millisecondsSinceEpoch}',
  //       text: text,
  //       isUser: true,
  //       time: DateTime.now(),
  //     ));
  //     _msgCtrl.clear();
  //     _hasText = false;
  //     _isTyping = true;
  //   });
  //   _scrollToBottom();

  //   await Future.delayed(const Duration(milliseconds: 900));
  //   if (!mounted) return;

  //   setState(() {
  //     _isTyping = false;
  //     _messages.add(ChatMessage(
  //       id: '${DateTime.now().millisecondsSinceEpoch}b',
  //       text: 'This is a design-only demo. Model logic has been removed.',
  //       isUser: false,
  //       time: DateTime.now(),
  //     ));
  //   });
  //   _scrollToBottom();
  // }

// Future<void> _sendMessage() async {
//   final text = _msgCtrl.text.trim();

//   if (text.isEmpty) return;

//   setState(() {
//     _messages.add(
//       ChatMessage(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         text: text,
//         isUser: true,
//         time: DateTime.now(),
//       ),
//     );

//     _msgCtrl.clear();
//     _hasText = false;
//     _isTyping = true;
//   });

//   _scrollToBottom();

//   try {
//     final response =
//         await _geminiService.generateResponse(text);

//     if (!mounted) return;

//     setState(() {
//       _isTyping = false;

//       _messages.add(
//         ChatMessage(
//           id:
//               '${DateTime.now().millisecondsSinceEpoch}_bot',
//           text: response,
//           isUser: false,
//           time: DateTime.now(),
//         ),
//       );
//     });

//     _scrollToBottom();
//   } catch (e) {
//     if (!mounted) return;

//     setState(() {
//       _isTyping = false;

//       _messages.add(
//         ChatMessage(
//           id:
//               '${DateTime.now().millisecondsSinceEpoch}_error',
//           text: 'Failed to get response.',
//           isUser: false,
//           time: DateTime.now(),
//         ),
//       );
//     });

//     _scrollToBottom();
//   }
// }
Future<void> _sendMessage() async {
  if (_isSending) return;

  final text = _msgCtrl.text.trim();
  if (text.isEmpty) return;

  _isSending = true;

  setState(() {
    _messages.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isUser: true,
        time: DateTime.now(),
      ),
    );

    _msgCtrl.clear();
    _hasText = false;
    _isTyping = true;
  });

  _scrollToBottom();

  try {
    // 🔥 prevent API spam (VERY IMPORTANT for 429 fix)
    await Future.delayed(const Duration(milliseconds: 700));

    final response = await _groqService.generateResponse(text);

    if (!mounted) return;

    setState(() {
      _isTyping = false;

      _messages.add(
        ChatMessage(
          id: '${DateTime.now().millisecondsSinceEpoch}_bot',
          text: response,
          isUser: false,
          time: DateTime.now(),
        ),
      );
    });

    _scrollToBottom();
  } on Exception {
    if (!mounted) return;

    setState(() {
      _isTyping = false;

      _messages.add(
        ChatMessage(
          id: '${DateTime.now().millisecondsSinceEpoch}_error',
          text:
              "⚠️ Too many requests or network issue.\nPlease wait a few seconds and try again.",
          isUser: false,
          time: DateTime.now(),
        ),
      );
    });
  } finally {
    _isSending = false;
  }
}


//   // ── Helpers ─────────────────────────────────────────────
  List<ChatMessage> get _filtered => _searchQuery.isEmpty
      ? _messages
      : _messages
          .where((m) => m.text.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _dayLabel(DateTime t) {
    final now = DateTime.now();
    if (_isSameDay(t, now)) return 'Today';
    if (_isSameDay(t, now.subtract(const Duration(days: 1)))) return 'Yesterday';
    return '${t.day}/${t.month}/${t.year}';
  }

  // ════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            child: _showSearch ? _buildSearchBar() : const SizedBox.shrink(),
          ),
          Expanded(child: _buildMessageList()),
          if (_isTyping) _buildTypingIndicator(),
          _buildInputArea(),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  APP BAR
  // ════════════════════════════════════════════════════════
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.appBar,
      foregroundColor: Colors.white,
      elevation: 1,
      leadingWidth: 44,
      leading: Padding(
        padding: const EdgeInsets.only(left: 4),
        child:InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20)),
      ),
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: AppColors.appBarLight,
                child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 20),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.onlineGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.appBar, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI Assistant',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              // Model status removed from app bar per user request.
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            _showSearch ? Icons.search_off_rounded : Icons.search_rounded,
            color: Colors.white,
          ),
          onPressed: () => setState(() {
            _showSearch = !_showSearch;
            if (!_showSearch) {
              _searchQuery = '';
              _searchCtrl.clear();
            }
          }),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onSelected: (v) {
            if (v == 'clear') setState(() => _messages.clear());
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'clear',    child: Text('Clear chat')),
            PopupMenuItem(value: 'model',    child: Text('Model info')),
            PopupMenuItem(value: 'settings', child: Text('Settings')),
          ],
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════
  //  SEARCH BAR
  // ════════════════════════════════════════════════════════
  Widget _buildSearchBar() {
    return Container(
      color: AppColors.appBar,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.searchBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: _searchCtrl,
          autofocus: true,
          onChanged: (v) => setState(() => _searchQuery = v),
          decoration: InputDecoration(
            hintText: 'Search messages…',
            hintStyle: const TextStyle(color: Color(0xFF8696A0), fontSize: 14),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF8696A0), size: 20),
            suffixIcon: _searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchCtrl.clear();
                      setState(() => _searchQuery = '');
                    },
                    child: const Icon(Icons.close, color: Color(0xFF8696A0), size: 18),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  MESSAGE LIST  (dot wallpaper via CustomPainter)
  // ════════════════════════════════════════════════════════
  Widget _buildMessageList() {
    final msgs = _filtered;
    return Stack(
      children: [
        CustomPaint(painter: _WallpaperPainter(), child: const SizedBox.expand()),
        msgs.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 8),
                    Text('No messages found',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 15)),
                  ],
                ),
              )
            : ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                itemCount: msgs.length,
                itemBuilder: (_, i) {
                  final msg      = msgs[i];
                  final showDate = i == 0 || !_isSameDay(msgs[i - 1].time, msg.time);
                  return Column(
                    children: [
                      if (showDate) _buildDateChip(msg.time),
                      _buildBubble(msg),
                    ],
                  );
                },
              ),
      ],
    );
  }

  // ── Date chip ────────────────────────────────────────────
  Widget _buildDateChip(DateTime t) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.dateChipBg,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            _dayLabel(t),
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF4A4A4A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  SINGLE CHAT BUBBLE
  // ════════════════════════════════════════════════════════
  Widget _buildBubble(ChatMessage msg) {
    final isUser = msg.isUser;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 13,
              backgroundColor: AppColors.appBarLight,
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 13),
            ),
            const SizedBox(width: 5),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              decoration: BoxDecoration(
                color: isUser ? AppColors.userBubble : AppColors.botBubble,
                borderRadius: BorderRadius.only(
                  topLeft:     const Radius.circular(12),
                  topRight:    const Radius.circular(12),
                  bottomLeft:  Radius.circular(isUser ? 12 : 2),
                  bottomRight: Radius.circular(isUser ? 2 : 12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.09),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(10, 7, 10, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        'AI Assistant',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.botLabel,
                        ),
                      ),
                    ),
                  Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 14.5,
                      color: isUser ? AppColors.userBubbleText : AppColors.botBubbleText,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(msg.time),
                        style: const TextStyle(fontSize: 10.5, color: AppColors.timeText),
                      ),
                      if (isUser) ...[
                        const SizedBox(width: 3),
                        Icon(
                          msg.isRead ? Icons.done_all : Icons.done,
                          size: 14,
                          color: msg.isRead ? AppColors.readTick : AppColors.timeText,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 5),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  TYPING INDICATOR  (3 animated dots)
  // ════════════════════════════════════════════════════════
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 2, 8, 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: AppColors.appBarLight,
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 13),
          ),
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.botBubble,
              borderRadius: const BorderRadius.only(
                topLeft:     Radius.circular(12),
                topRight:    Radius.circular(12),
                bottomRight: Radius.circular(12),
                bottomLeft:  Radius.circular(2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.09),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: _TypingDots(controller: _typingAnimCtrl),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  INPUT AREA
  // ════════════════════════════════════════════════════════
  Widget _buildInputArea() {
    return SafeArea(
      child: Container(
        color: AppColors.background,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 44, maxHeight: 120),
                decoration: BoxDecoration(
                  color: AppColors.inputBar,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        
                        controller: _msgCtrl,
                        focusNode: _focusNode,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _sendMessage(),
                        style: const TextStyle(fontSize: 15, color: AppColors.botBubbleText),
                        decoration: const InputDecoration(
                          
                          hintText: '   Ask me anything…',
                          hintStyle: TextStyle(color: Color(0xFF8696A0), fontSize: 15),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                         
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: _hasText ? _sendMessage : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.sendButton,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.sendButton.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  ANIMATED TYPING DOTS
// ════════════════════════════════════════════════════════════
class _TypingDots extends StatelessWidget {
  final AnimationController controller;
  const _TypingDots({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            final delay    = i * 0.28;
            final progress = ((controller.value - delay) % 1.0).clamp(0.0, 1.0);
            final scale    = 0.55 + 0.45 * sin(progress * pi).clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.5),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.appBarLight.withOpacity(0.75),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  WALLPAPER PAINTER  (subtle tiled dot pattern)
// ════════════════════════════════════════════════════════════
class _WallpaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF128C7E).withOpacity(0.05)
      ..style = PaintingStyle.fill;
    const spacing = 24.0;
    const radius  = 1.8;
    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_WallpaperPainter old) => false;
}