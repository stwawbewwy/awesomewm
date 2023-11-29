local awful = require'awful'
local beautiful = require'beautiful'
local wibox = require'wibox'
local gears = require'gears'

local vars = require'config.vars'
local widgets = require'widgets'

screen.connect_signal('request::wallpaper', function(s)
        local offset = {x='0', y='-200'}

        gears.wallpaper.maximized("/home/notanyone/.config/awesome/wallpaper", '', false, offset)
end)

screen.connect_signal('request::desktop_decoration', function(s)
        awful.tag(vars.tags, s, awful.layout.layouts[2])
        s.promptbox           = widgets.create_promptbox()
        s.layoutbox           = widgets.create_layoutbox(s)
        s.taglist             = widgets.create_taglist(s)
        s.tasklist            = widgets.create_tasklist(s)
        s.wibox               = widgets.create_wibox(s)
        s.wibox2              = widgets.create_wibox2(s)
end)