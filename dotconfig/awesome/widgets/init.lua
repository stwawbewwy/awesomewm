local _M = {}

local awful = require'awful'
local hotkeys_popup = require'awful.hotkeys_popup'
local beautiful = require'beautiful'
local wibox = require'wibox'
local gears = require'gears'

local apps = require'config.apps'
local mod = require'bindings.mod'
local lain = require'lain'

-- importing custom widgets
local cmus_widget = require'awesome-wm-widgets.cmus-widget.cmus'
local logout_popup = require'awesome-wm-widgets.logout-popup-widget.logout-popup'
local todo_widget = require'awesome-wm-widgets.todo-widget.todo'
local calendar_widget = require'awesome-wm-widgets.calendar-widget.calendar'

-- using lain widgets
local markup = lain.util.markup

local mycpu = lain.widget.cpu{
        timeout = 1,
        settings = function()
                widget:set_markup(" " .. cpu_now.usage .. "%")
        end
}

local volume = lain.widget.alsa{
        settings = function()
                if volume_now.status == 'off' then
                        widget:set_markup(markup("#FF0000", "󰝟 ") .. volume_now.level .. "%")
                else
                        widget:set_markup("󰕾 " .. volume_now.level .. "%")
                end
        end
}

local mymem = lain.widget.mem{
        settings = function()
                widget:set_markup(" " .. mem_now.perc .. "%")
        end
}

local home = os.getenv("HOME")
local mybattery = lain.widget.bat{
        bat_notification_low_preset = {
                title = "Oh no...",
                text = "Blessed be thee for thou art in a situation of thy battery dying...",
                timeout = 15,
                fg = "#202020",
                bg = "#CDCDCD",
                icon = "/home/notanyone/.config/awesome/alicesleeping.jpg",
        },
        timeout = 10,
        settings = function()
                widget:set_markup("󰁹 " .. bat_now.perc .. "%")
        end
}

-- calendar widget
local mytextclock = wibox.widget.textclock('%a %d %b, %H:%M:%S', 1)
local cw = calendar_widget({
        placement="bottom_right",
        radius=8,
})
mytextclock:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then cw.toggle() end
end)

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
                }
        }
end

function _M.create_wibox(s)
        return awful.wibar{
                screen = s,
                position = 'top',
                shape = gears.shape.rounded_bar,
                bg = '#FFFFFF00',
                widget = {
                        layout = wibox.layout.align.horizontal,
                        expand = "none",
                        -- left widgets
                        {
                                layout = wibox.layout.fixed.horizontal,
                                spacing = 10,
                                s.tasklist,
                        },
                        -- middle widgets
                        {
                                layout = wibox.layout.fixed.horizontal,
                                s.promptbox,
                        },
                        -- right widgets
                        {
                                layout = wibox.layout.fixed.horizontal,
                                spacing = 10,
                                s.taglist,
                                s.layoutbox,
                                todo_widget(),
                        }
                }
        }
end

function _M.create_wibox2(s)
        return awful.wibar{
                screen = s,
                position = 'bottom',
                widget = {
                        layout = wibox.layout.align.horizontal,
                        expand = "none",
                        --left widgets
                        {
                                layout = wibox.layout.fixed.horizontal,
                                spacing = 10,
                                logout_popup.widget{},
                                mycpu,
                                mymem,
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
                                volume,
                                mybattery,
                                mytextclock,
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

return _M
