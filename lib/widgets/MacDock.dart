import 'package:flutter/material.dart';

/// A stateful widget that represents the Mac-style Dock.
///
/// This widget allows users to drag icons from the Dock to a background area
/// and vice versa.
class MacDock extends StatefulWidget {
  const MacDock({super.key});

  @override
  State createState() => _MacDockState();
}

class _MacDockState extends State<MacDock> {
  /// List of app icons currently in the Dock.
  final List<IconData> _dockIcons = [
    Icons.ac_unit,
    Icons.access_alarm,
    Icons.accessibility_new,
  ];

  /// List of app icons that have been dropped on the background.
  final List<PositionedIcon> _backgroundIcons = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Stack(
        children: [
          // Background area as a drag target for dropping icons.
          DragTarget<IconData>(
            onAcceptWithDetails: (details) {
              setState(() {
                final droppedIcon = details.data;

                // Prevent adding the same icon again if dragged within the background.
                // If Dropped icon is not in the background icons.
                if (!_backgroundIcons.any((icon) => icon.icon == droppedIcon)) {
                  _dockIcons.remove(droppedIcon); // Remove from Dock.
                  _backgroundIcons.add(
                    PositionedIcon(
                      icon: droppedIcon,
                      offset: details
                          .offset, // Use the exact offset where it was dropped.
                    ),
                  ); // Add to Background.
                }
              });
            },
            builder: (context, candidateData, rejectedData) {
              return SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: _backgroundIcons.map((positionedIcon) {
                    return _buildBackgroundIcon(positionedIcon);
                  }).toList(),
                ),
              );
            },
          ),

          // Dock at the bottom of the screen.
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.grey,
              padding: const EdgeInsets.only(bottom: 30),
              child: _buildDock(),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the Dock widget.
  ///
  /// This widget contains the draggable icons that can be moved to the
  /// background or returned to the Dock.
  Widget _buildDock() {
    return DragTarget<IconData>(
      onWillAcceptWithDetails: (icon) => true,
      onAcceptWithDetails: (details) {
        setState(() {
          // Prevent adding the same icon again if dragged within the dock.
          if (!_dockIcons.contains(details.data)) {
            _backgroundIcons.removeWhere((element) =>
            element.icon == details.data); // Remove from Background.
            _dockIcons.add(details.data); // Add back to Dock.
          }
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ..._dockIcons.map((icon) {
              return Draggable<IconData>(
                data: icon,
                feedback: _buildAppIcon(icon),
                childWhenDragging: const Opacity(
                  opacity: 0,
                ),
                child: _buildAppIcon(icon),
              );
            }),
            // Display a placeholder icon when there are no icons in the Dock.
            // The Dock becomes invisible when dockIcons list is zero.
            // This place holder makes sure that does not happen.
            if (_dockIcons.isEmpty) _buildAppIcon(Icons.add),
          ],
        );
      },
    );
  }

  /// Builds the visual representation of an app icon.
  ///
  /// The [icon] parameter specifies the icon to display.
  Widget _buildAppIcon(IconData icon) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Builds icons for the background with their positions.
  ///
  /// The [positionedIcon] parameter specifies the icon and its position in the background.
  Widget _buildBackgroundIcon(PositionedIcon positionedIcon) {
    return Positioned(
      left: positionedIcon.offset.dx,
      top: positionedIcon.offset.dy,
      child: Draggable<IconData>(
        data: positionedIcon.icon,
        feedback: _buildAppIcon(positionedIcon.icon),
        childWhenDragging: const Opacity(
          opacity: 0,
        ),
        child: _buildAppIcon(positionedIcon.icon),
      ),
    );
  }
}

/// Represents an app icon's position in the background.
///
/// The [icon] parameter specifies the icon data, and the [offset] parameter
/// specifies the position of the icon in the background area.
class PositionedIcon {
  final IconData icon;
  final Offset offset;

  PositionedIcon({required this.icon, required this.offset});
}