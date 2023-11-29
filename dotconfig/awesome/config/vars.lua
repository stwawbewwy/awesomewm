local _M = {}

local awful = require'awful'

_M.layouts = {
        awful.layout.suit.floating,
        awful.layout.suit.fair,
}

_M.tags = {" Work", "󰙯 Messaging", " Terminal", " Misc", "󰎄 Music", "󰊗 Game"}

return _M
