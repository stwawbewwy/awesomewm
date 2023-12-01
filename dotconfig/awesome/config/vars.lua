local _M = {}

local awful = require'awful'
local l = awful.layout.suit

_M.tags = {
        " Work", 
        "󰙯 Messaging", 
        " Terminal", 
        " Misc", 
        "󰎄 Music", 
        "󰊗 Game"
}

_M.defaultlayouts = {
        l.fair, 
        l.fair, 
        l.fair, 
        l.floating, 
        l.floating, 
        l.floating
}

_M.layouts = {
        awful.layout.suit.floating,
        awful.layout.suit.fair,
        awful.layout.suit.max,
}

return _M
