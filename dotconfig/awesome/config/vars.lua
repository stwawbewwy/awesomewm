local _M = {}

local awful = require'awful'
local l = awful.layout.suit

_M.tags = {
    "󰌢 Work", -- 1
    "󰙯 Messaging", -- 2
    " Terminal", -- 3
    "󰎄 Music", -- 4
    " Misc", -- 5
    "󰊗 Games", --6
}

_M.defaultlayouts = {
    l.tile, -- 1
    l.tile, -- 2
    l.tile, -- 3
    l.floating, -- 4
    l.floating, -- 5
    l.floating --6
}

_M.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max,
}

return _M
