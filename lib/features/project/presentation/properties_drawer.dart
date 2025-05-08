import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundnexus/features/project/presentation/project_page_view_model.dart';
import 'package:soundnexus/features/projects/domain/audio_file.dart';

class PropertiesDrawer extends StatefulWidget {
  const PropertiesDrawer(this.vm, {super.key});

  final ProjectPageViewModel vm;

  @override
  State<PropertiesDrawer> createState() => _PropertiesDrawerState();
}

class _PropertiesDrawerState extends State<PropertiesDrawer>
    with TickerProviderStateMixin {
  final nameController = TextEditingController();
  final pathController = TextEditingController();

  bool isEmptySelection = true;
  bool isEditingShortcut = false;
  bool? loop;
  List<String> oldEditingAudios = [];
  String shortcut = '[]';

  ProjectPageViewModel get vm => widget.vm;

  @override
  void initState() {
    super.initState();

    HardwareKeyboard.instance.addHandler(_onKeyEvent);
    vm.addListener(updateSelection);
    updateSelection();
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKeyEvent);
    nameController.dispose();
    pathController.dispose();
    vm.removeListener(updateSelection);
    super.dispose();
  }

  void updateSelection() {
    if (oldEditingAudios == vm.editingAudios) {
      return;
    }

    final editingAudiosPositions = vm.editingAudios;
    oldEditingAudios = [...vm.editingAudios];

    setState(() {});

    if (editingAudiosPositions.isEmpty) {
      isEmptySelection = true;
      nameController.text = '';
      pathController.text = '';
      loop = false;

      return;
    }

    isEmptySelection = false;

    final editingAudios = editingAudiosPositions
        .map((e) => vm.getAudioFileByString(vm.currentTab, e))
        .whereType<AudioFile>();
    final firstAudio = editingAudios.first;

    nameController.text = editingAudios.every((e) => e.name == firstAudio.name)
        ? firstAudio.name
        : '[Multiple Values]';

    pathController.text = editingAudios.every((e) => e.path == firstAudio.path)
        ? firstAudio.path
        : '[Multiple Values]';

    loop = editingAudios.every((e) => e.loop == firstAudio.loop)
        ? firstAudio.loop
        : null;

    shortcut = editingAudios.every((e) => e.shortcut == firstAudio.shortcut)
        ? firstAudio.shortcut
        : '[]';
  }

  bool _onKeyEvent(KeyEvent event) {
    final char = event.character;

    if (!isEditingShortcut || char == null) {
      return false;
    }

    vm.updateEditingAudios(
      (audio) => audio.copyWith(shortcut: char.toUpperCase()),
    );

    setState(() => isEditingShortcut = false);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final enabled = vm.editingAudios.isNotEmpty;

    return SizedBox(
      width: 360,
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Audio properties',
                  style: theme.textTheme.titleLarge,
                ),
              ),

              // Name
              ListTile(
                enabled: !isEmptySelection,
                title: const Text('Name'),
                subtitle: TextField(
                  controller: nameController,
                  enabled: enabled,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onEditingComplete: () => vm.updateEditingAudios(
                    (audio) => audio.copyWith(name: nameController.text),
                  ),
                ),
              ),

              // Path
              ListTile(
                enabled: !isEmptySelection,
                title: const Text('Path'),
                subtitle: TextField(
                  controller: pathController,
                  enabled: enabled,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onEditingComplete: () => vm.updateEditingAudios(
                    (audio) => audio.copyWith(path: pathController.text),
                  ),
                ),
              ),

              // Loop
              CheckboxListTile(
                enabled: enabled,
                title: const Text('Loop'),
                tristate: loop == null,
                value: loop,
                onChanged: (value) {
                  vm.updateEditingAudios(
                    (audio) => audio.copyWith(loop: value!),
                  );
                },
              ),

              // Shortcut
              ListTile(
                enabled: !isEmptySelection,
                title: const Text('Shortcut'),
                trailing: isEditingShortcut
                    ? FilledButton(
                        onPressed: isEmptySelection
                            ? null
                            : () => setState(() => isEditingShortcut = false),
                        child: Text(shortcut),
                      )
                    : FilledButton.tonal(
                        onPressed: isEmptySelection
                            ? null
                            : () => setState(() => isEditingShortcut = true),
                        child: Text(shortcut),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
