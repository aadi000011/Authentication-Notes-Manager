import 'package:authentication_notes_manager/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:authentication_notes_manager/features/notes/presentation/controllers/bloc/notes_bloc/notes_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/responsive_center.dart';
import '../../domain/entities/note_entity.dart';
import '../widgets/note_editor_dialog.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _showMessage(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor:
              isError ? theme.colorScheme.error : theme.colorScheme.inverseSurface,
          content: Row(
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                color: isError
                    ? theme.colorScheme.onError
                    : theme.colorScheme.onInverseSurface,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: isError
                        ? theme.colorScheme.onError
                        : theme.colorScheme.onInverseSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  Future<void> _addNote(BuildContext context) async {
    final result = await showDialog<NoteEditorResult>(
      context: context,
      builder: (_) => const NoteEditorDialog(),
    );

    if (result == null || !context.mounted) {
      return;
    }

    context.read<NotesBloc>().add(
      NotesAddRequested(title: result.title, description: result.description),
    );
  }

  Future<void> _editNote(BuildContext context, NoteEntity note) async {
    final result = await showDialog<NoteEditorResult>(
      context: context,
      builder: (_) => NoteEditorDialog(
        isEditing: true,
        initialTitle: note.title,
        initialDescription: note.description,
      ),
    );

    if (result == null || !context.mounted) {
      return;
    }

    context.read<NotesBloc>().add(
      NotesUpdateRequested(
        noteId: note.id,
        title: result.title,
        description: result.description,
      ),
    );
  }

  Future<void> _deleteNote(BuildContext context, NoteEntity note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete note?'),
        content: Text('"${note.title}" will be removed for good.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    context.read<NotesBloc>().add(NotesDeleteRequested(note.id));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
            builder: (context, auth) {
              return IconButton(
                tooltip: 'Logout',
                onPressed: auth.isLoading
                    ? null
                    : () => context.read<AuthBloc>().add(AuthLogoutRequested()),
                icon: const Icon(Icons.logout_rounded),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addNote(context),
        label: const Text('New note'),
        icon: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 900,
          child: MultiBlocListener(
            listeners: [
              BlocListener<NotesBloc, NotesState>(
                listenWhen: (prev, curr) =>
                    curr.errorMessage != null &&
                    prev.errorMessage != curr.errorMessage,
                listener: (context, state) {
                  _showMessage(context, state.errorMessage!, isError: true);
                },
              ),
              BlocListener<NotesBloc, NotesState>(
                listenWhen: (prev, curr) =>
                    curr.successMessage != null &&
                    prev.successMessage != curr.successMessage,
                listener: (context, state) {
                  _showMessage(context, state.successMessage!);
                },
              ),
            ],
            child: BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (prev, curr) => prev.user != curr.user,
              builder: (context, auth) {
                final user = auth.user;
                final displayName = (user?.name.isNotEmpty == true)
                    ? user!.name
                    : (user?.email ?? 'there');

                return BlocBuilder<NotesBloc, NotesState>(
                  builder: (context, notesState) {
                    final items = notesState.notes;

                    return RefreshIndicator(
                      onRefresh: () async {},
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                              child: _Header(
                                displayName: displayName,
                                noteCount: items.length,
                                isLoading: notesState.isLoading,
                              ),
                            ),
                          ),
                          if (items.isEmpty && !notesState.isLoading)
                            const SliverFillRemaining(
                              hasScrollBody: false,
                              child: _EmptyState(),
                            )
                          else
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                              sliver: SliverList.separated(
                                itemCount: items.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (_, index) {
                                  final note = items[index];
                                  return _NoteCard(
                                    note: note,
                                    onEdit: () => _editNote(context, note),
                                    onDelete: () => _deleteNote(context, note),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.displayName,
    required this.noteCount,
    required this.isLoading,
  });

  final String displayName;
  final int noteCount;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.78),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, $displayName',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  noteCount == 0
                      ? 'No notes yet'
                      : '$noteCount ${noteCount == 1 ? 'note' : 'notes'} saved',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: theme.colorScheme.onPrimary,
              ),
            )
          else
            Icon(
              Icons.sticky_note_2_outlined,
              color: theme.colorScheme.onPrimary.withOpacity(0.9),
              size: 32,
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primaryContainer,
              ),
              child: Icon(
                Icons.note_add_outlined,
                size: 40,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Nothing here yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "New note" to write down your first one.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  final NoteEntity note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDescription = note.description.trim().isNotEmpty;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onEdit,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 40,
                margin: const EdgeInsets.only(top: 2, right: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasDescription ? note.description : 'No description',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: hasDescription
                            ? theme.colorScheme.onSurfaceVariant
                            : theme.colorScheme.outline,
                        fontStyle:
                            hasDescription ? FontStyle.normal : FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Edit'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline),
                      title: Text('Delete'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}