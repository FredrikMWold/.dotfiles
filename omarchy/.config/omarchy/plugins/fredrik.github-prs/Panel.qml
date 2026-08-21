import QtQuick
import QtQuick.Controls
import Quickshell
import qs.Commons
import qs.Ui

Panel {
  id: root
  moduleName: "fredrik.github-prs"
  ipcTarget: "fredrik.github-prs"

  property var anchorItem: null
  property var hostWidget: null
  property var pullRequests: []
  property bool loading: false
  property string errorMessage: ""
  property int myCount: 0
  property int reviewCount: 0
  property int selectedIndex: -1

  readonly property var barIdentity: hostWidget || root

  function refresh() {
    if (hostWidget && hostWidget.refresh) hostWidget.refresh()
  }

  function open() {
    root.controller.show()
    selectedIndex = pullRequests.length > 0 ? 0 : -1
    if (pullRequests.length === 0 && !loading) refresh()
  }

  function close() { root.controller.hide() }

  function moveSelection(delta) {
    if (pullRequests.length === 0) return
    selectedIndex = Math.max(0, Math.min(pullRequests.length - 1, selectedIndex + delta))
  }

  function activateSelection() {
    if (selectedIndex < 0 || selectedIndex >= pullRequests.length) return
    openPullRequest(pullRequests[selectedIndex])
  }

  function openPullRequest(pullRequest) {
    if (!pullRequest || !pullRequest.url) return
    Qt.openUrlExternally(pullRequest.url)
    close()
  }

  function authorLabel(pullRequest) {
    if (pullRequest.type === "my") return "Your pull request"
    var login = pullRequest.author && pullRequest.author.login ? pullRequest.author.login : "unknown"
    return "Review · @" + login
  }

  onPullRequestsChanged: {
    if (pullRequests.length === 0) selectedIndex = -1
    else if (selectedIndex < 0) selectedIndex = 0
    else if (selectedIndex >= pullRequests.length) selectedIndex = pullRequests.length - 1
  }

  KeyboardPanel {
    id: panel
    anchorItem: root.anchorItem
    owner: root.barIdentity
    bar: root.bar
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(500))
    contentHeight: panel.fittedContentHeight(contentColumn.implicitHeight, Style.space(400))

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onMoveRequested: function(dx, dy) { if (dy !== 0) root.moveSelection(dy) }
      onActivateRequested: root.activateSelection()
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }
      onTextKey: function(text) { if (text === "r" || text === "R") root.refresh() }

      Column {
        id: contentColumn
        width: parent.width
        spacing: Style.space(4)

        Row {
          width: parent.width
          spacing: Style.space(8)

          Text {
            width: parent.width - refreshButton.width - parent.spacing
            anchors.verticalCenter: parent.verticalCenter
            text: "GitHub pull requests"
            color: root.bar.foreground
            font.family: root.bar.fontFamily
            font.pixelSize: Style.font.title
            font.bold: true
          }

          Button {
            id: refreshButton
            anchors.verticalCenter: parent.verticalCenter
            iconText: root.loading ? "󰦖" : ""
            iconSpinning: root.loading
            tooltipText: "Refresh pull requests"
            foreground: root.bar.foreground
            fontFamily: root.bar.fontFamily
            horizontalPadding: Style.spacing.controlPaddingX
            verticalPadding: Style.space(4)
            onClicked: root.refresh()
          }
        }

        Text {
          width: parent.width
          text: root.myCount + " yours · " + root.reviewCount + " to review"
          color: Qt.darker(root.bar.foreground, 1.35)
          font.family: root.bar.fontFamily
          font.pixelSize: Style.font.bodySmall
        }

        PanelSeparator {
          foreground: root.bar.foreground
        }

        Text {
          visible: root.errorMessage !== ""
          width: parent.width
          text: root.errorMessage
          color: root.bar.urgent
          font.family: root.bar.fontFamily
          font.pixelSize: Style.font.bodySmall
          wrapMode: Text.Wrap
        }

        Text {
          visible: root.loading && root.pullRequests.length === 0
          width: parent.width
          text: "Loading pull requests…"
          color: root.bar.foreground
          font.family: root.bar.fontFamily
          font.pixelSize: Style.font.body
        }

        Text {
          visible: !root.loading && root.pullRequests.length === 0 && root.errorMessage === ""
          width: parent.width
          text: "No matching pull requests"
          color: root.bar.foreground
          font.family: root.bar.fontFamily
          font.pixelSize: Style.font.body
        }

        ListView {
          id: pullRequestList
          visible: root.pullRequests.length > 0
          width: parent.width
          height: Math.min(contentHeight, Style.space(280))
          spacing: 0
          clip: true
          boundsBehavior: Flickable.StopAtBounds
          interactive: contentHeight > height
          model: root.pullRequests
          currentIndex: root.selectedIndex
          onCurrentIndexChanged: if (currentIndex >= 0) positionViewAtIndex(currentIndex, ListView.Contain)

          ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

          delegate: Item {
            id: delegateRoot
            required property var modelData
            required property int index
            width: ListView.view.width
            height: Style.space(48)

            Rectangle {
              anchors.fill: parent
              radius: Math.min(4, Style.cornerRadius)
              color: delegateRoot.index === root.selectedIndex
                ? Style.hoverFillFor(root.bar.foreground, Color.accent)
                : rowMouse.containsMouse
                  ? Style.hoverFillFor(root.bar.foreground, Color.accent)
                  : "transparent"

              Column {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: Style.space(8)
                anchors.rightMargin: Style.space(8)
                spacing: 0

                Text {
                  width: parent.width
                  text: delegateRoot.modelData.title
                  color: root.bar.foreground
                  font.family: root.bar.fontFamily
                  font.pixelSize: Style.font.body
                  font.bold: delegateRoot.index === root.selectedIndex
                  elide: Text.ElideRight
                }

                Text {
                  width: parent.width
                  text: delegateRoot.modelData.repositoryName + " #" + delegateRoot.modelData.number + " · " + root.authorLabel(delegateRoot.modelData)
                  color: Qt.darker(root.bar.foreground, 1.35)
                  font.family: root.bar.fontFamily
                  font.pixelSize: Style.font.bodySmall
                  elide: Text.ElideRight
                }
              }

              MouseArea {
                id: rowMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: root.selectedIndex = delegateRoot.index
                onClicked: root.openPullRequest(delegateRoot.modelData)
              }
            }
          }
        }
      }
    }
  }
}