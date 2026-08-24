// Based on Qt Location's MapView.qml.
// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only

import QtQuick
import QtLocation as QL
import QtPositioning as QP
import Qt.labs.animation

Item {
  id: root

  property alias map: map
  property real minimumZoomLevel: map.minimumZoomLevel
  property real maximumZoomLevel: map.maximumZoomLevel

  QL.Map {
    id: map
    width: parent.width
    height: parent.height

    PinchHandler {
      id: pinch
      target: null
      rotationAxis.enabled: false
      property real startZoom: 0
      property QP.geoCoordinate lockedCenter

      onActiveChanged: {
        flickAnimation.stop()
        if (active) {
          startZoom = map.zoomLevel
          lockedCenter = map.center
        } else {
          var stableCenter = lockedCenter
          map.center = stableCenter
          Qt.callLater(function() { map.center = stableCenter })
        }
      }

      onScaleChanged: {
        if (!active || activeScale <= 0) return
        map.zoomLevel = Math.max(
          root.minimumZoomLevel,
          Math.min(root.maximumZoomLevel, startZoom + Math.log2(activeScale))
        )
        map.center = lockedCenter
      }

      grabPermissions: PointerHandler.TakeOverForbidden
    }

    WheelHandler {
      id: wheel
      acceptedDevices: PointerDevice.Mouse
      onWheel: function(event) {
        var location = map.toCoordinate(point.position)
        map.zoomLevel += event.angleDelta.y / 120
        map.alignCoordinateToPoint(location, point.position)
      }
    }

    DragHandler {
      id: drag
      target: null
      minimumPointCount: 1
      maximumPointCount: 1
      onTranslationChanged: function(delta) {
        map.pan(-delta.x, -delta.y)
      }
      onActiveChanged: {
        if (active) flickAnimation.stop()
        else flickAnimation.restart(centroid.velocity)
      }
    }

    property vector3d animationDestination
    onAnimationDestinationChanged: {
      if (!flickAnimation.running) return
      var delta = Qt.vector2d(
        animationDestination.x - flickAnimation.lastDestination.x,
        animationDestination.y - flickAnimation.lastDestination.y
      )
      map.pan(-delta.x, -delta.y)
      flickAnimation.lastDestination = animationDestination
    }

    Vector3dAnimation on animationDestination {
      id: flickAnimation
      property vector3d lastDestination
      from: Qt.vector3d(0, 0, 0)
      duration: 500
      easing.type: Easing.OutQuad

      function restart(velocity) {
        stop()
        map.animationDestination = Qt.vector3d(0, 0, 0)
        lastDestination = Qt.vector3d(0, 0, 0)
        to = Qt.vector3d(
          velocity.x / duration * 100,
          velocity.y / duration * 100,
          0
        )
        start()
      }
    }
  }
}
