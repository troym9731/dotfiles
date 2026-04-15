-- Load the IPC module for command line tool support
require("hs.ipc")
hs.ipc.cliInstall()

-- Basic configuration
hs.window.animationDuration = 0

-- Reload configuration hotkey
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function()
  hs.reload()
end)

hs.alert.show("Config loaded")

-- Window management helpers
local TOLERANCE = 20

local function isApprox(a, b)
  return math.abs(a - b) <= TOLERANCE
end

local function isLeftHalf(win, screen)
  local f = win:frame()
  local s = screen:frame()
  return isApprox(f.x, s.x) and isApprox(f.y, s.y) and isApprox(f.w, s.w / 2) and isApprox(f.h, s.h)
end

local function isRightHalf(win, screen)
  local f = win:frame()
  local s = screen:frame()
  return isApprox(f.x, s.x + s.w / 2) and isApprox(f.y, s.y) and isApprox(f.w, s.w / 2) and isApprox(f.h, s.h)
end

local function moveToLeftHalf(win, screen)
  win:moveToScreen(screen)
  local s = screen:frame()
  win:setFrame({ x = s.x, y = s.y, w = s.w / 2, h = s.h })
end

local function moveToRightHalf(win, screen)
  win:moveToScreen(screen)
  local s = screen:frame()
  win:setFrame({ x = s.x + s.w / 2, y = s.y, w = s.w / 2, h = s.h })
end

hs.hotkey.bind({ "cmd", "alt" }, "h", function()
  local win = hs.window.focusedWindow()
  if not win then return end

  local currentScreen = win:screen()
  local westScreen = currentScreen:toWest()

  if isLeftHalf(win, currentScreen) and westScreen then
    moveToRightHalf(win, westScreen)
  else
    moveToLeftHalf(win, currentScreen)
  end
end)

hs.hotkey.bind({ "cmd", "alt" }, "l", function()
  local win = hs.window.focusedWindow()
  if not win then return end

  local currentScreen = win:screen()
  local eastScreen = currentScreen:toEast()

  if isRightHalf(win, currentScreen) and eastScreen then
    moveToLeftHalf(win, eastScreen)
  else
    moveToRightHalf(win, currentScreen)
  end
end)

hs.hotkey.bind({ "cmd", "alt" }, "k", function()
  local win = hs.window.focusedWindow()
  if win then
    local screen = win:screen():frame()
    win:setFrame({ x = screen.x, y = screen.y, w = screen.w, h = screen.h })
  end
end)

-- Parse a file:// URL into a display path, replacing $HOME with ~
local function cwdFromUrl(url)
  if not url then return nil end
  local path = tostring(url):match("^file://[^/]*(/.+)$")
  if not path then return nil end
  -- URL-decode common sequences
  path = path:gsub("%%(%x%x)", function(h) return string.char(tonumber(h, 16)) end)
  -- Strip trailing slash
  path = path:gsub("/$", "")
  local home = os.getenv("HOME")
  if home and path:sub(1, #home) == home then
    path = "~" .. path:sub(#home + 1)
  end
  return path
end

-- Fuzzy matching function
local function fuzzyMatch(str, pattern)
  if pattern == "" then return true end

  local strLower = string.lower(str)
  local patternLower = string.lower(pattern)

  local strIdx = 1
  local patternIdx = 1

  while strIdx <= #strLower and patternIdx <= #patternLower do
    if string.sub(strLower, strIdx, strIdx) == string.sub(patternLower, patternIdx, patternIdx) then
      patternIdx = patternIdx + 1
    end
    strIdx = strIdx + 1
  end

  return patternIdx > #patternLower
end

-- Track tab focus times for sorting
local tabFocusTimes = {}

local function makeTabKey(windowId, tabIndex)
  return string.format("%d:%d", windowId, tabIndex)
end

-- Chooser-based Ghostty tab switcher
local allGhosttyTabs = {}

local ghosttyChooser = hs.chooser.new(function(choice)
  if not choice then return end
  local tabKey = makeTabKey(choice.windowId, choice.tabIndex)
  tabFocusTimes[tabKey] = os.time()
  selectGhosttyTab(choice.windowId, choice.tabIndex)
end)

ghosttyChooser:queryChangedCallback(function(query)
  if query == "" then
    ghosttyChooser:choices(allGhosttyTabs)
    return
  end

  local filtered = {}
  for _, choice in ipairs(allGhosttyTabs) do
    local searchText = choice.text .. " " .. choice.subText
    if fuzzyMatch(searchText, query) then
      table.insert(filtered, choice)
    end
  end

  ghosttyChooser:choices(filtered)
end)

function showGhosttyChooser()
  local now = os.time()

  local ghostty = hs.application.find("Ghostty")
  if not ghostty then
    hs.alert.show("Ghostty not running")
    return
  end

  local allGhosttyWindows = ghostty:allWindows()

  local focusOrder = {}
  for i, window in ipairs(hs.window.orderedWindows()) do
    focusOrder[window:id()] = i
  end

  table.sort(allGhosttyWindows, function(a, b)
    local orderA = focusOrder[a:id()] or math.huge
    local orderB = focusOrder[b:id()] or math.huge
    return orderA < orderB
  end)

  if #allGhosttyWindows == 0 then
    hs.alert.show("No Ghostty windows found")
    return
  end

  allGhosttyTabs = {}

  local windowsToShow = {}
  local childWindowTitles = {}
  local parentWindows = {}

  for _, window in ipairs(allGhosttyWindows) do
    local windowId = window:id()
    local windowTitle = window:title()

    local success, windowTabs = pcall(function()
      local tabs = {}
      local axWindow = hs.axuielement.windowElement(window)

      if axWindow then
        local children = axWindow:attributeValue("AXChildren")
        local foundTabGroup = false

        if children then
          for _, child in ipairs(children) do
            if child:attributeValue("AXRole") == "AXTabGroup" then
              foundTabGroup = true
              local axTabs = child:attributeValue("AXChildren")

              if axTabs then
                parentWindows[windowId] = true

                -- AXDocument is on the window and reflects the selected tab's CWD
                local winCwd = cwdFromUrl(axWindow:attributeValue("AXDocument"))

                for j, tab in ipairs(axTabs) do
                  local tabTitle = tab:attributeValue("AXTitle")
                  local tabSelected = tab:attributeValue("AXSelected")

                  if tabTitle then
                    childWindowTitles[tabTitle] = true
                    local tabKey = makeTabKey(windowId, j)
                    local focusTime = tabFocusTimes[tabKey] or 0

                    if tabSelected then
                      tabFocusTimes[tabKey] = now
                      focusTime = now
                    end

                    -- Only the selected tab has a known CWD
                    local cwd = tabSelected and winCwd or nil
                    local subText = cwd
                      and string.format("%s  |  %s", cwd, windowTitle)
                      or string.format("%s  |  Tab %d", windowTitle, j)

                    table.insert(tabs, {
                      text = tabTitle,
                      subText = subText,
                      windowId = windowId,
                      tabIndex = j,
                      focusTime = focusTime,
                    })
                  end
                end
              end
              break
            end
          end
        end

        if not foundTabGroup then
          local tabKey = makeTabKey(windowId, 1)
          tabFocusTimes[tabKey] = now

          local winDoc = axWindow:attributeValue("AXDocument")
          local cwd = cwdFromUrl(winDoc)
          local subText = cwd or string.format("Window: %s", windowTitle)

          table.insert(tabs, {
            text = windowTitle,
            subText = subText,
            windowId = windowId,
            tabIndex = 1,
            focusTime = now,
          })
        end
      end

      return tabs
    end)

    if success and windowTabs and #windowTabs > 0 then
      table.sort(windowTabs, function(a, b)
        return a.focusTime > b.focusTime
      end)

      table.insert(windowsToShow, {
        windowId = windowId,
        windowTitle = windowTitle,
        tabs = windowTabs,
      })
    end
  end

  for _, windowInfo in ipairs(windowsToShow) do
    local isParent = parentWindows[windowInfo.windowId]
    local titleIsChild = false

    for _, tab in ipairs(windowInfo.tabs) do
      if childWindowTitles[tab.text] then
        titleIsChild = true
        break
      end
    end

    if isParent then
      for _, tab in ipairs(windowInfo.tabs) do
        table.insert(allGhosttyTabs, tab)
      end
    elseif not titleIsChild then
      for _, tab in ipairs(windowInfo.tabs) do
        table.insert(allGhosttyTabs, tab)
      end
    end
  end

  if #allGhosttyTabs == 0 then
    hs.alert.show("No Ghostty tabs found")
    return
  end

  ghosttyChooser:choices(allGhosttyTabs)
  ghosttyChooser:show()
end

function selectGhosttyTab(windowId, tabIndex)
  local ghostty = hs.application.find("Ghostty")
  if not ghostty then
    return false
  end

  local targetWindow = nil
  for _, window in ipairs(ghostty:allWindows()) do
    if window:id() == windowId then
      targetWindow = window
      break
    end
  end

  if not targetWindow then
    return false
  end

  targetWindow:focus()

  local success, result = pcall(function()
    local axWindow = hs.axuielement.windowElement(targetWindow)
    if axWindow then
      local children = axWindow:attributeValue("AXChildren")
      local foundTabGroup = false

      if children then
        for _, child in ipairs(children) do
          local role = child:attributeValue("AXRole")
          if role == "AXTabGroup" then
            foundTabGroup = true
            local tabs = child:attributeValue("AXChildren")
            if tabs and tabs[tabIndex] then
              tabs[tabIndex]:performAction("AXPress")
              return true
            end
            break
          end
        end
      end

      if not foundTabGroup then
        return true
      end
    end
    return false
  end)

  return success and result
end

-- Debug: dump AX attributes from the first Ghostty tab
function debugGhosttyAX()
  local ghostty = hs.application.find("Ghostty")
  if not ghostty then print("Ghostty not running") return end

  local win = ghostty:mainWindow()
  if not win then print("No main window") return end

  local axWin = hs.axuielement.windowElement(win)
  print("=== Window attributes ===")
  for _, attr in ipairs(axWin:attributeNames() or {}) do
    local val = axWin:attributeValue(attr)
    if val ~= nil then print(attr .. " = " .. tostring(val)) end
  end

  local children = axWin:attributeValue("AXChildren") or {}
  for _, child in ipairs(children) do
    if child:attributeValue("AXRole") == "AXTabGroup" then
      local tabs = child:attributeValue("AXChildren") or {}
      local tab = tabs[1]
      if tab then
        print("=== First tab attributes ===")
        for _, attr in ipairs(tab:attributeNames() or {}) do
          local val = tab:attributeValue(attr)
          if val ~= nil then print(attr .. " = " .. tostring(val)) end
        end
      end
      break
    end
  end
end

-- Ghostty-only tab switcher hotkey (ctrl+p, only fires when Ghostty is focused)
local ghosttyModal = hs.hotkey.modal.new()
ghosttyModal:bind({"cmd"}, "p", showGhosttyChooser)

hs.application.watcher.new(function(name, event, _app)
  if name ~= "Ghostty" then return end
  if event == hs.application.watcher.activated then
    ghosttyModal:enter()
  elseif event == hs.application.watcher.deactivated then
    ghosttyModal:exit()
  end
end):start()
