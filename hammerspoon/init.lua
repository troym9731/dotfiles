require("hs.axuielement")

hs.window.animationDuration = 0

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function()
	hs.reload()
end)

hs.alert.show("Config loaded")

-- Parse a file:// URL into a display path, replacing $HOME with ~
local function cwdFromUrl(url)
	if not url then return nil end
	local path = tostring(url):match("^file://[^/]*(/.+)$")
	if not path then return nil end
	path = path:gsub("%%(%x%x)", function(h)
		return string.char(tonumber(h, 16))
	end)
	path = path:gsub("/$", "")
	local home = os.getenv("HOME")
	if home and path:sub(1, #home) == home then
		path = "~" .. path:sub(#home + 1)
	end
	return path
end

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

local tabFocusTimes = {}

local function makeTabKey(windowId, tabIndex)
	return string.format("%d:%d", windowId, tabIndex)
end

-- Cached Ghostty app reference, updated by the watcher
local cachedGhostty = hs.application.find("Ghostty")

local function getGhostty()
	if cachedGhostty and cachedGhostty:isRunning() then
		return cachedGhostty
	end
	cachedGhostty = hs.application.find("Ghostty")
	return cachedGhostty
end

local allGhosttyTabs = {}
local ghosttyChooser

ghosttyChooser = hs.chooser.new(function(choice)
	if not choice then return end
	ghosttyChooser:query("")
	tabFocusTimes[makeTabKey(choice.windowId, choice.tabIndex)] = os.time()
	hs.timer.doAfter(0.05, function()
		selectGhosttyTab(choice.windowId, choice.tabIndex)
	end)
end)

ghosttyChooser:queryChangedCallback(function(query)
	if query == "" then
		ghosttyChooser:choices(allGhosttyTabs)
		return
	end
	local filtered = {}
	for _, choice in ipairs(allGhosttyTabs) do
		if fuzzyMatch(choice.text .. " " .. choice.subText, query) then
			table.insert(filtered, choice)
		end
	end
	ghosttyChooser:choices(filtered)
end)

function showGhosttyChooser()
	local now = os.time()

	local ghostty = getGhostty()
	if not ghostty then
		hs.alert.show("Ghostty not running")
		return
	end

	local allGhosttyWindows = ghostty:allWindows()

	if #allGhosttyWindows == 0 then
		hs.alert.show("No Ghostty windows found")
		return
	end

	-- Build focus order from just Ghostty windows using the window filter
	local focusOrder = {}
	local orderedGhostty = hs.window.filter.new("Ghostty"):getWindows(hs.window.filter.sortByFocusedLast)
	for i, window in ipairs(orderedGhostty) do
		focusOrder[window:id()] = i
	end

	table.sort(allGhosttyWindows, function(a, b)
		local orderA = focusOrder[a:id()] or math.huge
		local orderB = focusOrder[b:id()] or math.huge
		return orderA < orderB
	end)

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
								local winCwd = cwdFromUrl(axWindow:attributeValue("AXDocument"))

								for j, tab in ipairs(axTabs) do
									local tabTitle = tab:attributeValue("AXTitle")
									local tabSelected = tab:attributeValue("AXSelected")

									if tabTitle and tabTitle ~= "" then
										childWindowTitles[tabTitle] = true
										local tabKey = makeTabKey(windowId, j)
										local focusTime = tabFocusTimes[tabKey] or 0

										if tabSelected then
											tabFocusTimes[tabKey] = now
											focusTime = now
										end

										local cwd = tabSelected and winCwd or nil
										local subText = cwd and string.format("%s  |  %s", cwd, windowTitle)
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
					local winCwd = cwdFromUrl(axWindow:attributeValue("AXDocument"))
					local subText = winCwd or windowTitle

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

		if isParent or not titleIsChild then
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
	local ghostty = getGhostty()
	if not ghostty then return false end

	local targetWindow = nil
	for _, window in ipairs(ghostty:allWindows()) do
		if window:id() == windowId then
			targetWindow = window
			break
		end
	end
	if not targetWindow then return false end

	targetWindow:focus()

	local success, result = pcall(function()
		local axWindow = hs.axuielement.windowElement(targetWindow)
		if axWindow then
			local children = axWindow:attributeValue("AXChildren")
			if children then
				for _, child in ipairs(children) do
					if child:attributeValue("AXRole") == "AXTabGroup" then
						local tabs = child:attributeValue("AXChildren")
						if tabs and tabs[tabIndex] then
							tabs[tabIndex]:performAction("AXPress")
							return true
						end
						break
					end
				end
			end
			return true
		end
		return false
	end)

	return success and result
end

-- cmd+p opens the picker only when Ghostty is focused
local ghosttyModal = hs.hotkey.modal.new()
ghosttyModal:bind({ "cmd" }, "p", showGhosttyChooser)

hs.application.watcher
	.new(function(name, event, app)
		if name ~= "Ghostty" then return end
		if event == hs.application.watcher.activated then
			cachedGhostty = app
			ghosttyModal:enter()
		elseif event == hs.application.watcher.deactivated then
			ghosttyModal:exit()
		end
	end)
	:start()

-- Enter modal immediately if Ghostty is already focused on load
local frontApp = hs.application.frontmostApplication()
if frontApp and frontApp:name() == "Ghostty" then
	ghosttyModal:enter()
end
