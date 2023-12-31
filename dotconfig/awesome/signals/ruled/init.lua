local awful = require'awful'
local ruled = require'ruled'
local gears = require'gears'

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = {},
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
            border_color = "#7B55B4",
        }
    }
end)
