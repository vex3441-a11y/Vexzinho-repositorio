local VexUI = {}
VexUI.__index = VexUI
VexUI.Windows = {}

local Theme = require("core/theme")
local Config = require("core/config")
local WindowClass = require("core/window")
local TabClass = require("core/tab")

function VexUI:CreateWindow(options)
    options = options or {}

    local window = WindowClass:Create(self, {
        Theme = Theme:Create(options.Theme),
        Config = Config:Merge(options)
    })

    function window:CreateTab(name)
        local tab = TabClass:Create(window, name)
        table.insert(window.Tabs, tab)

        if #window.Tabs == 1 then
            tab.Frame.Visible = true
        end

        return tab
    end

    table.insert(self.Windows, window)
    return window
end

return setmetatable({}, VexUI)