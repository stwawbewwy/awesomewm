local awful = require'awful'
local wibox = require'wibox'
local gears = require'gears'

local home = os.getenv('HOME')

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
            eepy:set_image(home .. '/.config/awesome/awesome-buttons/icons/moon.svg')
        else
            eepy:set_image(home .. '/.config/awesome/awesome-buttons/icons/sun.svg')
        end
        collectgarbage()
    end
}

return eepy
