import '../models/task_model.dart';
import '../models/user_model.dart';
import '../models/notification_model.dart';

/// Centralized mock data provider for all screens.
/// Contains realistic dummy data for tasks, users, and notifications.
class MockData {
  MockData._();

  // ── Current User ──────────────────────────────────────────────────────
  static const UserModel currentUser = UserModel(
    id: 'usr_001',
    fullName: 'Hassan Malik',
    email: 'hassan.malik@taskify.io',
    avatarUrl: 'https://i.pravatar.cc/300?img=11',
    role: 'Product Manager',
    joinedAt: null, // Set in getter below
    tasksCompleted: 147,
    tasksInProgress: 12,
    streakDays: 23,
  );

  static UserModel get user => UserModel(
        id: 'usr_001',
        fullName: 'Hassan Malik',
        email: 'hassan.malik@taskify.io',
        avatarUrl: 'https://i.pravatar.cc/300?img=11',
        role: 'Product Manager',
        joinedAt: DateTime(2024, 3, 15),
        tasksCompleted: 147,
        tasksInProgress: 12,
        streakDays: 23,
      );

  // ── Team Members (for assignees) ──────────────────────────────────────
  static final List<UserModel> teamMembers = [
    UserModel(
      id: 'usr_002',
      fullName: 'Sarah Chen',
      email: 'sarah.chen@taskify.io',
      avatarUrl: 'https://i.pravatar.cc/300?img=5',
      role: 'UI Designer',
      joinedAt: DateTime(2024, 5, 20),
      tasksCompleted: 89,
      tasksInProgress: 5,
      streakDays: 14,
    ),
    UserModel(
      id: 'usr_003',
      fullName: 'Alex Rivera',
      email: 'alex.rivera@taskify.io',
      avatarUrl: 'https://i.pravatar.cc/300?img=12',
      role: 'Flutter Developer',
      joinedAt: DateTime(2024, 4, 10),
      tasksCompleted: 203,
      tasksInProgress: 8,
      streakDays: 31,
    ),
    UserModel(
      id: 'usr_004',
      fullName: 'Emma Wilson',
      email: 'emma.wilson@taskify.io',
      avatarUrl: 'https://i.pravatar.cc/300?img=9',
      role: 'Marketing Lead',
      joinedAt: DateTime(2024, 6, 1),
      tasksCompleted: 67,
      tasksInProgress: 3,
      streakDays: 9,
    ),
  ];

  // ── Tasks ─────────────────────────────────────────────────────────────
  static final List<TaskModel> tasks = [
    TaskModel(
      id: 'task_001',
      title: 'Redesign Dashboard UI',
      description:
          'Create a modern, responsive dashboard with new stat cards, charts, and improved navigation. Include dark mode support and micro-animations for enhanced UX.',
      category: TaskCategory.design,
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      dueDate: DateTime.now().add(const Duration(days: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      progress: 0.65,
      assigneeName: 'Hassan Malik',
      assigneeAvatar: 'https://i.pravatar.cc/300?img=11',
      tags: ['UI', 'Dashboard', 'Priority'],
      comments: [
        TaskComment(
          id: 'cmt_001',
          userName: 'Sarah Chen',
          avatarUrl: 'https://i.pravatar.cc/300?img=5',
          content: 'Love the new card designs! Can we also add gradient backgrounds?',
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        TaskComment(
          id: 'cmt_002',
          userName: 'Alex Rivera',
          avatarUrl: 'https://i.pravatar.cc/300?img=12',
          content: 'I\'ve implemented the responsive grid. Ready for review.',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ],
      attachments: [
        const TaskAttachment(id: 'att_001', name: 'dashboard_mockup.fig', type: 'figma', size: '4.2 MB'),
        const TaskAttachment(id: 'att_002', name: 'color_palette.pdf', type: 'pdf', size: '1.1 MB'),
      ],
    ),
    TaskModel(
      id: 'task_002',
      title: 'Implement Authentication Flow',
      description:
          'Build complete auth flow including login, registration, forgot password, and social login. Use Firebase Auth with proper error handling.',
      category: TaskCategory.development,
      priority: TaskPriority.high,
      status: TaskStatus.todo,
      dueDate: DateTime.now().add(const Duration(days: 5)),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      progress: 0.0,
      assigneeName: 'Alex Rivera',
      assigneeAvatar: 'https://i.pravatar.cc/300?img=12',
      tags: ['Auth', 'Backend', 'Security'],
      comments: [],
      attachments: [
        const TaskAttachment(id: 'att_003', name: 'auth_flow_diagram.png', type: 'image', size: '800 KB'),
      ],
    ),
    TaskModel(
      id: 'task_003',
      title: 'Create Marketing Campaign',
      description:
          'Design and launch Q3 marketing campaign including social media posts, email newsletters, and landing page updates.',
      category: TaskCategory.marketing,
      priority: TaskPriority.medium,
      status: TaskStatus.inProgress,
      dueDate: DateTime.now().add(const Duration(days: 7)),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      progress: 0.40,
      assigneeName: 'Emma Wilson',
      assigneeAvatar: 'https://i.pravatar.cc/300?img=9',
      tags: ['Marketing', 'Q3', 'Campaign'],
      comments: [
        TaskComment(
          id: 'cmt_003',
          userName: 'Emma Wilson',
          avatarUrl: 'https://i.pravatar.cc/300?img=9',
          content: 'Draft for email newsletter is ready. Please review.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      attachments: [],
    ),
    TaskModel(
      id: 'task_004',
      title: 'User Research Interviews',
      description:
          'Conduct 10 user interviews to gather feedback on the new features. Compile findings into a report with actionable insights.',
      category: TaskCategory.research,
      priority: TaskPriority.medium,
      status: TaskStatus.completed,
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
      progress: 1.0,
      assigneeName: 'Sarah Chen',
      assigneeAvatar: 'https://i.pravatar.cc/300?img=5',
      tags: ['UX Research', 'Interviews'],
      comments: [],
      attachments: [
        const TaskAttachment(id: 'att_004', name: 'research_findings.pdf', type: 'pdf', size: '2.3 MB'),
      ],
    ),
    TaskModel(
      id: 'task_005',
      title: 'Setup CI/CD Pipeline',
      description:
          'Configure GitHub Actions for automated testing, building, and deployment. Include staging and production environments.',
      category: TaskCategory.development,
      priority: TaskPriority.low,
      status: TaskStatus.todo,
      dueDate: DateTime.now().add(const Duration(days: 10)),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      progress: 0.0,
      assigneeName: 'Alex Rivera',
      assigneeAvatar: 'https://i.pravatar.cc/300?img=12',
      tags: ['DevOps', 'CI/CD'],
      comments: [],
      attachments: [],
    ),
    TaskModel(
      id: 'task_006',
      title: 'Sprint Planning Meeting',
      description:
          'Organize and lead sprint planning for the next 2-week cycle. Prepare backlog, estimate stories, and assign tasks to team members.',
      category: TaskCategory.management,
      priority: TaskPriority.high,
      status: TaskStatus.overdue,
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      progress: 0.30,
      assigneeName: 'Hassan Malik',
      assigneeAvatar: 'https://i.pravatar.cc/300?img=11',
      tags: ['Sprint', 'Planning', 'Team'],
      comments: [
        TaskComment(
          id: 'cmt_004',
          userName: 'Alex Rivera',
          avatarUrl: 'https://i.pravatar.cc/300?img=12',
          content: 'Can we prioritize the API integration stories this sprint?',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
      attachments: [],
    ),
    TaskModel(
      id: 'task_007',
      title: 'Design System Documentation',
      description:
          'Document all design tokens, components, and patterns in a comprehensive design system guide.',
      category: TaskCategory.design,
      priority: TaskPriority.low,
      status: TaskStatus.inProgress,
      dueDate: DateTime.now().add(const Duration(days: 14)),
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      progress: 0.55,
      assigneeName: 'Sarah Chen',
      assigneeAvatar: 'https://i.pravatar.cc/300?img=5',
      tags: ['Design System', 'Documentation'],
      comments: [],
      attachments: [
        const TaskAttachment(id: 'att_005', name: 'design_tokens.json', type: 'json', size: '45 KB'),
      ],
    ),
    TaskModel(
      id: 'task_008',
      title: 'API Integration Testing',
      description:
          'Write comprehensive integration tests for all API endpoints. Ensure proper error handling and edge cases.',
      category: TaskCategory.development,
      priority: TaskPriority.medium,
      status: TaskStatus.todo,
      dueDate: DateTime.now().add(const Duration(days: 4)),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      progress: 0.0,
      assigneeName: 'Alex Rivera',
      assigneeAvatar: 'https://i.pravatar.cc/300?img=12',
      tags: ['Testing', 'API', 'QA'],
      comments: [],
      attachments: [],
    ),
    TaskModel(
      id: 'task_009',
      title: 'Onboarding Flow Redesign',
      description:
          'Redesign the onboarding experience with new illustrations, smoother transitions, and better conversion tracking.',
      category: TaskCategory.design,
      priority: TaskPriority.medium,
      status: TaskStatus.completed,
      dueDate: DateTime.now().subtract(const Duration(days: 3)),
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      progress: 1.0,
      assigneeName: 'Sarah Chen',
      assigneeAvatar: 'https://i.pravatar.cc/300?img=5',
      tags: ['Onboarding', 'UX'],
      comments: [],
      attachments: [],
    ),
    TaskModel(
      id: 'task_010',
      title: 'Update Privacy Policy',
      description:
          'Review and update privacy policy to comply with new GDPR regulations. Coordinate with legal team.',
      category: TaskCategory.management,
      priority: TaskPriority.low,
      status: TaskStatus.todo,
      dueDate: DateTime.now().add(const Duration(days: 21)),
      createdAt: DateTime.now(),
      progress: 0.0,
      assigneeName: 'Hassan Malik',
      assigneeAvatar: 'https://i.pravatar.cc/300?img=11',
      tags: ['Legal', 'Privacy', 'GDPR'],
      comments: [],
      attachments: [],
    ),
    TaskModel(
      id: 'task_011',
      title: 'Performance Optimization',
      description:
          'Optimize app performance including reducing startup time, lazy loading images, and improving scrolling performance.',
      category: TaskCategory.development,
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      dueDate: DateTime.now().add(const Duration(days: 3)),
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      progress: 0.75,
      assigneeName: 'Alex Rivera',
      assigneeAvatar: 'https://i.pravatar.cc/300?img=12',
      tags: ['Performance', 'Optimization'],
      comments: [],
      attachments: [],
    ),
    TaskModel(
      id: 'task_012',
      title: 'Social Media Content Calendar',
      description:
          'Plan and create content for all social media channels for the next month. Include graphics and captions.',
      category: TaskCategory.marketing,
      priority: TaskPriority.low,
      status: TaskStatus.completed,
      dueDate: DateTime.now().subtract(const Duration(days: 5)),
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      progress: 1.0,
      assigneeName: 'Emma Wilson',
      assigneeAvatar: 'https://i.pravatar.cc/300?img=9',
      tags: ['Social Media', 'Content'],
      comments: [],
      attachments: [],
    ),
  ];

  // ── Today's Tasks ─────────────────────────────────────────────────────
  static List<TaskModel> get todaysTasks => tasks
      .where((t) =>
          t.status != TaskStatus.completed &&
          t.dueDate.difference(DateTime.now()).inDays <= 1)
      .toList();

  // ── Upcoming Tasks ────────────────────────────────────────────────────
  static List<TaskModel> get upcomingTasks => tasks
      .where((t) =>
          t.status != TaskStatus.completed &&
          t.dueDate.difference(DateTime.now()).inDays > 1)
      .toList();

  // ── Dashboard Stats ───────────────────────────────────────────────────
  static int get completedCount =>
      tasks.where((t) => t.status == TaskStatus.completed).length;

  static int get pendingCount =>
      tasks.where((t) => t.status == TaskStatus.todo || t.status == TaskStatus.inProgress).length;

  static int get overdueCount =>
      tasks.where((t) => t.status == TaskStatus.overdue).length;

  static double get productivityScore =>
      (completedCount / tasks.length * 100).roundToDouble();

  // ── Weekly Progress Data (for chart) ──────────────────────────────────
  static final List<Map<String, dynamic>> weeklyProgress = [
    {'day': 'Mon', 'completed': 5, 'total': 8},
    {'day': 'Tue', 'completed': 7, 'total': 9},
    {'day': 'Wed', 'completed': 4, 'total': 7},
    {'day': 'Thu', 'completed': 8, 'total': 10},
    {'day': 'Fri', 'completed': 6, 'total': 8},
    {'day': 'Sat', 'completed': 3, 'total': 4},
    {'day': 'Sun', 'completed': 2, 'total': 3},
  ];

  // ── Notifications ─────────────────────────────────────────────────────
  static final List<NotificationModel> notifications = [
    NotificationModel(
      id: 'notif_001',
      title: 'New Task Assigned',
      message: 'Sarah Chen assigned you "Redesign Dashboard UI"',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: false,
      type: NotificationType.taskAssigned,
      relatedTaskId: 'task_001',
    ),
    NotificationModel(
      id: 'notif_002',
      title: 'Task Completed',
      message: 'Alex Rivera completed "API Integration Testing"',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      type: NotificationType.taskCompleted,
      relatedTaskId: 'task_008',
    ),
    NotificationModel(
      id: 'notif_003',
      title: 'Upcoming Deadline',
      message: '"Sprint Planning Meeting" is due tomorrow',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
      type: NotificationType.reminder,
      relatedTaskId: 'task_006',
    ),
    NotificationModel(
      id: 'notif_004',
      title: 'New Comment',
      message: 'Sarah Chen commented on "Redesign Dashboard UI"',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
      type: NotificationType.comment,
      relatedTaskId: 'task_001',
    ),
    NotificationModel(
      id: 'notif_005',
      title: 'You were mentioned',
      message: 'Emma Wilson mentioned you in "Create Marketing Campaign"',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      isRead: true,
      type: NotificationType.mention,
      relatedTaskId: 'task_003',
    ),
    NotificationModel(
      id: 'notif_006',
      title: 'Task Overdue',
      message: '"Sprint Planning Meeting" is 2 days overdue',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      type: NotificationType.reminder,
      relatedTaskId: 'task_006',
    ),
    NotificationModel(
      id: 'notif_007',
      title: 'New Task Assigned',
      message: 'You have been assigned "Update Privacy Policy"',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      isRead: true,
      type: NotificationType.taskAssigned,
      relatedTaskId: 'task_010',
    ),
    NotificationModel(
      id: 'notif_008',
      title: 'Weekly Report Ready',
      message: 'Your weekly productivity report is available',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      type: NotificationType.reminder,
    ),
  ];

  static List<NotificationModel> get unreadNotifications =>
      notifications.where((n) => !n.isRead).toList();

  static List<NotificationModel> get todayNotifications =>
      notifications.where((n) => n.createdAt.day == DateTime.now().day).toList();

  static List<NotificationModel> get earlierNotifications =>
      notifications.where((n) => n.createdAt.day != DateTime.now().day).toList();

  // ── Categories for filter ─────────────────────────────────────────────
  static const List<String> categories = [
    'All',
    'Design',
    'Development',
    'Marketing',
    'Research',
    'Management',
    'Personal',
  ];

  // ── Onboarding Data ───────────────────────────────────────────────────
  static const List<Map<String, String>> onboardingPages = [
    {
      'title': 'Organize Your Tasks',
      'subtitle':
          'Effortlessly manage all your tasks in one place. Prioritize, categorize, and never miss a deadline.',
      'icon': 'checklist',
    },
    {
      'title': 'Track Your Progress',
      'subtitle':
          'Visualize your productivity with beautiful charts and insights. Stay motivated with streak tracking.',
      'icon': 'chart',
    },
    {
      'title': 'Collaborate Seamlessly',
      'subtitle':
          'Work together with your team. Assign tasks, share updates, and achieve goals faster.',
      'icon': 'team',
    },
  ];
}
