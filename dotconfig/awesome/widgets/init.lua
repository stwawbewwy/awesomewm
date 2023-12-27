local _M = {}

local awful = require'awful'
local hotkeys_popup = require'awful.hotkeys_popup'
local beautiful = require'beautiful'
local wibox = require'wibox'
local gears = require'gears'

local apps = require'config.apps'
local mod = require'bindings.mod'
local lain = require'lain'
local modules = require'modules'

-- totally arbitrary variables
local home = os.getenv("HOME")

-- importing custom widgets
local cmus_widget = require'awesome-wm-widgets.cmus-widget.cmus'
local logout_popup = require'awesome-wm-widgets.logout-popup-widget.logout-popup'
local todo_widget = require'awesome-wm-widgets.todo-widget.todo'
local calendar_widget = require'awesome-wm-widgets.calendar-widget.calendar'

-- using lain widgets
local markup = lain.util.markup

--[[
local mycpu = lain.widget.cpu{
        timeout = 1,
        settings = function()
                widget:set_markup(" " .. cpu_now.usage .. "%")
        end
}

local mymem = lain.widget.mem{
        settings = function()
                widget:set_markup(" " .. mem_now.perc .. "%")
        end
}
--]]

local volume = lain.widget.alsa{
        settings = function()
                if volume_now.status == 'off' then
                        widget:set_markup(markup("#ff6961", "󰝟 ") .. volume_now.level .. "%")
                else
                        widget:set_markup(markup("#fbec77", "󰕾 ") .. volume_now.level .. "%")
                end
        end
}

local mybattery = lain.widget.bat{
        bat_notification_low_preset = {
                title = "Oh no...",
                text = "Charge thy battery",
                timeout = 15,
                fg = "#202020",
                bg = "#CDCDCD",
                icon = home .. "/.config/awesome/alicesleeping.jpg",
        },
        timeout = 1,
        settings = function()
                if bat_now.status == "N/A" then return end
                
                if bat_now.status == "Charging" then
                        widget:set_markup(markup("#02bf3c", "󰂄 ") .. bat_now.perc .. "%")
                else
                        if bat_now.perc <= 15 then
                                widget:set_markup(markup("#ff6961", "󰂃 ") .. bat_now.perc .. "%")
                        else
                                widget:set_markup(markup("#fbec77", "󰁹 ") .. bat_now.perc .. "%")
                        end
                end
        end
}

-- calendar widget
local mytextclock = wibox.widget.textclock('<span foreground="#fbec77">󰃭 </span>%a %d %b <span foreground="#fbec77">󰥔 </span>%H:%M:%S', 1)
local cw = calendar_widget({
        placement="bottom_right",
        radius=8,
})
mytextclock:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then cw.toggle() end
end)

local rofimenu = awful.widget.button{
        image = home .. "/.config/awesome/awesome-buttons/icons/search.svg",
        buttons = {
                awful.button({}, 1, nil, function()
                        awful.spawn('rofi -show drun')
                end
                )
        }
}

local tutorial = wibox.widget{
        markup = '<span foreground="#fbec77">Win+Shift+c to close a window</span>',
        widget = wibox.widget.textbox
}

_M.awesomemenu = {
        {'hotkeys', function() hotkeys_popup.show_help(nil, awful.screen.focused()) end},
        {'manual', apps.manual_cmd},
        {'edit config', apps.editor_cmd .. ' ' .. awesome.conffile},
        {'restart', awesome.restart},
        {'quit', function() awesome.quit() end},
}

_M.mainmenu = awful.menu{
        items = {
                {'awesome', _M.awesomemenu, beautiful.awesome_icon},
                {'open terminal', apps.terminal}
        }
}

_M.launcher = awful.widget.launcher{
        image = beautiful.awesome_icon,
        menu = _M.mainmenu
}

function _M.create_promptbox() return awful.widget.prompt() end

function _M.create_layoutbox(s)
        return awful.widget.layoutbox{
                screen = s,
                buttons = {
                        awful.button{
                                modifiers = {},
                                button    = 1,
                                on_press  = function() awful.layout.inc(1) end,
                        },
                        awful.button{
                                modifiers = {},
                                button    = 3,
                                on_press  = function() awful.layout.inc(-1) end,
                        },
                        --[[
                        awful.button{
                                modifiers = {},
                                button    = 4,
                                on_press  = function() awful.layout.inc(-1) end,
                        },
                        awful.button{
                                modifiers = {},
                                button    = 5,
                                on_press  = function() awful.layout.inc(1) end,
                        },
                        --]]
                }
        }
end

function _M.create_taglist(s)
        return awful.widget.taglist{
                screen = s,
                filter = awful.widget.taglist.filter.all,
                style = {
                        shape = gears.shape.rounded_bar,
                },
                layout   = {
                        spacing = 10,
                        spacing_widget = {
                                {
                                        forced_width = 5,
                                        shape        = gears.shape.circle,
                                        widget       = wibox.widget.separator
                                },
                                valign = 'center',
                                halign = 'center',
                                widget = wibox.container.place,
                        },
                        layout  = wibox.layout.fixed.horizontal
                },
                buttons = {
                        awful.button{
                                modifiers = {},
                                button    = 1,
                                on_press  = function(t) t:view_only() end,
                        },
                        awful.button{
                                modifiers = {mod.super},
                                button    = 1,
                                on_press  = function(t)
                                        if client.focus then
                                                client.focus:move_to_tag(t)
                                        end
                                end,
                        },
                        awful.button{
                                modifiers = {},
                                button    = 3,
                                on_press  = awful.tag.viewtoggle,
                        },
                        awful.button{
                                modifiers = {mod.super},
                                button    = 3,
                                on_press  = function(t)
                                        if client.focus then
                                                client.focus:toggle_tag(t)
                                        end
                                end
                        },
                        --[[
                        awful.button{
                                modifiers = {},
                                button    = 4,
                                on_press  = function(t) awful.tag.viewprev(t.screen) end,
                        },
                        awful.button{
                                modifiers = {},
                                button    = 5,
                                on_press  = function(t) awful.tag.viewnext(t.screen) end,
                        },
                        --]]
                }
        }
end

function _M.create_tasklist(s)
        return awful.widget.tasklist{
                screen = s,
                filter = awful.widget.tasklist.filter.currenttags,
                style = {
                        shape = gears.shape.rounded_bar,
                        bg_focus = "#535592",
                },
                layout   = {
                        spacing = 10,
                        forced_width = 640,
                        spacing_widget = {
                                {
                                        forced_width = 5,
                                        shape        = gears.shape.circle,
                                        widget       = wibox.widget.separator
                                },
                                valign = 'center',
                                halign = 'center',
                                widget = wibox.container.place,
                        },
                        layout  = wibox.layout.flex.horizontal
                },
                buttons = {
                        awful.button{
                                modifiers = {},
                                button    = 1,
                                on_press  = function(c)
                                        c:activate{context = 'tasklist', action = 'toggle_minimization'}
                                end,
                        },
                        awful.button{
                                modifiers = {},
                                button    = 3,
                                on_press  = function() awful.menu.client_list{theme = {width = 250}} end
                        },
                        --[[
                        awful.button{
                                modifiers = {},
                                button    = 4,
                                on_press  = function() awful.client.focus.byidx(-1) end
                        },
                        awful.button{
                                modifiers = {},
                                button    = 5,
                                on_press  = function() awful.client.focus.byidx(1) end
                        },
                        --]]
                }
        }
end

function _M.create_wibox(s)
        return awful.wibar{
                screen = s,
                position = 'top',
                bg = '#FFFFFF00',
                margins = {left=20, right=20, top=0, bottom=0},
                widget = {
                        layout = wibox.layout.align.horizontal,
                        expand = "none",
                        -- left widgets
                        {
                                layout = wibox.layout.fixed.horizontal,
                                spacing = 10,
                                s.taglist,
                        },
                        -- middle widgets
                        {
                                layout = wibox.layout.fixed.horizontal,
                                s.tasklist,
                        },
                        -- right widgets
                        {
                                layout = wibox.layout.fixed.horizontal,
                                spacing = 10,
                                todo_widget(),
                                wibox.container.margin(s.layoutbox, 0, 10),
                        }
                }
        }
end

function _M.create_wibox2(s)
        return awful.wibar{
                screen = s,
                position = 'bottom',
                shape = gears.shape.rounded_bar,
                margins = {top=0, bottom=20,left=20,right=20},
                widget = {
                        layout = wibox.layout.align.horizontal,
                        expand = "none",
                        --left widgets
                        {
                                layout = wibox.layout.fixed.horizontal,
                                spacing = 10,
                                wibox.container.margin(rofimenu, 10, 0),
                                logout_popup.widget{},
                                tutorial,
                                --[[
                                mycpu,
                                mymem,
                                --]]
                        },
                        -- middle widgets
                        {
                                layout = wibox.layout.fixed.horizontal,
                                cmus_widget({timeout=1, space=10}),
                        },
                        -- right widgets
                        {
                                layout = wibox.layout.fixed.horizontal,
                                spacing = 10,
                                modules.aliceyay,
                                volume,
                                mybattery,
                                wibox.container.margin(mytextclock, 0, 10),
                        }
                }
        }
end

beautiful.useless_gap = 10

volume.widget:buttons(awful.util.table.join{
        awful.button({}, 1, function()
                awful.spawn(string.format("%s -e alsamixer", terminal))
        end),
        awful.button({}, 3, function()
                os.execute(string.format("%s set %s toggle", volume.cmd, volume.togglechannel or volume.channel))
                volume.update()
        end),
        awful.button({}, 4, function()
                os.execute(string.format("%s set %s 1%%+", volume.cmd, volume.channel))
                volume.update()
        end),
        awful.button({}, 5, function()
                os.execute(string.format("%s set %s 1%%-", volume.cmd, volume.channel))
                volume.update()
        end),
})

awful.keyboard.append_global_keybindings{
        awful.key({}, "XF86AudioRaiseVolume", function()
                os.execute(string.format("amixer set %s 5%%+", volume.channel))
                volume.update()
        end),
        awful.key({}, "XF86AudioLowerVolume", function()
                os.execute(string.format("amixer set %s 5%%-", volume.channel))
                volume.update()
        end),
        awful.key({}, "XF86AudioMute", function()
                os.execute(string.format("amixer set %s toggle", volume.togglechannel or volume.channel))
                volume.update()
        end)
}

return _M
