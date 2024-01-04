local awful = require'awful'
local ruled = require'ruled'
local vars = require'config.vars'

ruled.client.connect_signal('request::rules', function()
    -- All clients will match this rule.
    ruled.client.append_rule{
        id         = 'global',
        rule       = {},
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.centered + awful.placement.no_offscreen
        }
    }

    -- Floating clients.
    ruled.client.append_rule{
        id = 'floating',
        rule_any = {
            instance = {'copyq', 'pinentry'},
            class = {
                'Arandr',
                'Blueman-manager',
                'Gpick',
                'Kruler',
                'Sxiv',
                'Tor Browser',
                'Wpa_gui',
                'veromix',
                'xtightvncviewer',
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                'Event Tester',  -- xev.
            },
            role = {
                'AlarmWindow',    -- Thunderbird's calendar.
                'ConfigManager',  -- Thunderbird's about:config.
                'pop-up',         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = {floating = true}
    }

    -- Set programs to launch in specific tags
    ruled.client.append_rule {
        rule       = {class = 'discord'},
        properties = {screen = 1, tag = vars.tags[2]}
    }
    ruled.client.append_rule {
        rule       = {class = 'PrismLauncher'},
        properties = {screen = 1, tag = vars.tags[6]}
    }
    ruled.client.append_rule{
        id = 'titlebars',
        rule_any = {type = {'normal', 'dialog'}},
        properties = {titlebars_enabled = false},
    }
end)



awful.spawn.with_shell("/home/notanyone/.config/awesome/autorun.sh")
