local awful = require'awful'
local wibox = require'wibox'
local gears = require'gears'

local home = os.getenv('HOME')

local search = wibox.widget{
    widget = wibox.widget.imagebox,
    forced_height = 20,
    forced_width = 20,
    valign = 'center',
    image = gears.color.recolor_image(home .. '/.config/awesome/awesome-buttons/icons/search.svg', '#fbec77')
}

search:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then 
        awful.spawn('rofi -show drun') 
    end
end)

return search
