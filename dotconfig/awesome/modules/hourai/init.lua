local awful = require'awful'
local wibox = require'wibox'
local gears = require'gears'

local home = os.getenv('HOME')

local moon_icon = gears.color.recolor_image(home .. '/.config/awesome/awesome-buttons/icons/moon.svg', '#6f7e8e')
local sun_icon = gears.color.recolor_image(home .. '/.config/awesome/awesome-buttons/icons/sun.svg', '#f4e98c')

local eepy = wibox.widget{
    widget = wibox.widget.imagebox,
    forced_height = 20,
    forced_width = 20,
    valign = 'center',
}

gears.timer{
    timeout = 60,
    call_now = true,
    autostart = true,
    callback = function()
        local currenttime = tonumber(os.date("%H"))
        if currenttime >= 22 or currenttime <= 5 then
            eepy:set_image(moon_icon)
        else
            eepy:set_image(sun_icon)
        end
        collectgarbage()
    end
}

return eepy
