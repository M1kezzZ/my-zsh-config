return {
    "rcarriga/nvim-notify",
    keys = {
        {
            "<leader>un",
            function()
                require("notify").dismiss({ silent = true, pending = true })
            end,
            desc = "Dismiss All Notifications",
        },
    },
    opts = {
        stages = "static",
        render = "compact",
        timeout = 2000,
        level = 1,
        max_width = 30
    },
}
