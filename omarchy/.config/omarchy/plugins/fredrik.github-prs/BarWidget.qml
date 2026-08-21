import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "fredrik.github-prs"

  property var pullRequests: []
  property var queryQueue: []
  property var activeQuery: null
  property string processOutput: ""
  property string processError: ""
  property string errorMessage: ""
  property bool loading: false
  property bool refreshQueued: false

  readonly property var defaultMyRepositories: [
    "equinor/prisma-decision-web",
    "equinor/subsurface-portal-web",
    "equinor/pressure-db-ingestion-web",
    "equinor/design-system",
    "equinor/warp-ui"
  ]
  readonly property var defaultReviewRepositories: [
    "equinor/prisma-decision-web",
    "equinor/subsurface-portal-web",
    "equinor/pressure-db-ingestion-web",
    "equinor/warp-ui"
  ]
  readonly property string defaultFilter: "-label:dependencies -label:\"autorelease: pending\""
  readonly property int myCount: countForType("my")
  readonly property int reviewCount: countForType("review")
  readonly property int refreshMinutes: Math.max(1, parseInt(setting("refreshMinutes", 5), 10) || 5)

  function repositories(name, fallback) {
    var configured = setting(name, fallback)
    return configured && configured.length !== undefined ? configured : fallback
  }

  function countForType(type) {
    var count = 0
    for (var i = 0; i < pullRequests.length; i++) {
      if (pullRequests[i].type === type) count++
    }
    return count
  }

  function enqueue(repositories, type) {
    for (var i = 0; i < repositories.length; i++) {
      var repository = String(repositories[i] || "").trim()
      if (repository !== "") queryQueue.push({ repository: repository, type: type })
    }
  }

  function refresh() {
    if (fetchProcess.running) {
      refreshQueued = true
      return
    }

    pullRequests = []
    queryQueue = []
    errorMessage = ""
    loading = true
    enqueue(repositories("myRepositories", defaultMyRepositories), "my")
    enqueue(repositories("reviewRepositories", defaultReviewRepositories), "review")
    runNextQuery()
  }

  function runNextQuery() {
    if (queryQueue.length === 0) {
      loading = false
      syncPanel()
      if (refreshQueued) {
        refreshQueued = false
        Qt.callLater(refresh)
      }
      return
    }

    activeQuery = queryQueue.shift()
    processOutput = ""
    processError = ""
    var authorFilter = activeQuery.type === "my" ? "author:@me" : "-author:@me"
    var search = String(setting("filter", defaultFilter)).trim()
    if (search !== "") search += " "
    search += authorFilter + " is:open"
    fetchProcess.command = [
      "gh", "pr", "list",
      "--repo", activeQuery.repository,
      "--state", "open",
      "--search", search,
      "--json", "number,title,url,author,isDraft"
    ]
    fetchProcess.running = true
  }

  function completeQuery(exitCode) {
    if (exitCode === 0) {
      try {
        var response = JSON.parse(processOutput || "[]")
        var next = pullRequests.slice()
        for (var i = 0; i < response.length; i++) {
          var item = response[i]
          if (item.isDraft === true) continue
          item.repository = activeQuery.repository
          item.repositoryName = activeQuery.repository.split("/").pop()
          item.type = activeQuery.type
          next.push(item)
        }
        pullRequests = next
      } catch (error) {
        errorMessage = "GitHub returned invalid PR data"
      }
    } else if (errorMessage === "") {
      errorMessage = processError.trim() || "Could not load GitHub pull requests"
    }

    syncPanel()
    Qt.callLater(runNextQuery)
  }

  function injectPanel() {
    var target = panelLoader.item
    if (!target) return
    target.bar = root.bar
    target.settings = root.settings
    target.anchorItem = button
    target.hostWidget = root
    syncPanel()
  }

  function syncPanel() {
    var target = panelLoader.item
    if (!target) return
    target.pullRequests = root.pullRequests
    target.loading = root.loading
    target.errorMessage = root.errorMessage
    target.myCount = root.myCount
    target.reviewCount = root.reviewCount
  }

  function togglePanel() {
    if (panelLoader.item) panelLoader.item.toggle()
  }

  readonly property bool opened: panelLoader.item ? panelLoader.item.opened === true : false
  readonly property bool popoutSwitchClosing: panelLoader.item ? panelLoader.item.popoutSwitchClosing === true : false

  function open() { if (panelLoader.item) panelLoader.item.open() }
  function close() { if (panelLoader.item) panelLoader.item.close() }
  function closeForPopoutSwitch() { if (panelLoader.item) panelLoader.item.closeForPopoutSwitch() }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  onBarChanged: injectPanel()
  onSettingsChanged: {
    injectPanel()
    refreshTimer.restart()
    refresh()
  }
  onPullRequestsChanged: syncPanel()
  onLoadingChanged: syncPanel()
  onErrorMessageChanged: syncPanel()

  Loader {
    id: panelLoader
    active: true
    source: Qt.resolvedUrl("Panel.qml")
    visible: false
    onLoaded: {
      root.injectPanel()
      Qt.callLater(root.injectPanel)
    }
  }

  Process {
    id: fetchProcess

    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.processOutput = String(text || "")
    }
    stderr: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.processError = String(text || "")
    }
    onExited: function(exitCode) { root.completeQuery(exitCode) }
  }

  Timer {
    id: refreshTimer
    interval: root.refreshMinutes * 60000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.loading && root.pullRequests.length === 0
      ? " loading"
      : " my " + root.myCount + " | review " + root.reviewCount
    tooltipText: root.errorMessage !== "" ? root.errorMessage : "GitHub pull requests"
    fontSize: Style.font.baseSize

    onPressed: function(mouseButton) {
      if (mouseButton === Qt.MiddleButton || mouseButton === Qt.RightButton) root.refresh()
      else root.togglePanel()
    }
  }
}