require("chatgpt").setup({
    api_key_cmd = "pass show openai_apikey"
})
require("which-key").register({
    p = {
        name = "ChatGPT",
        o = {
            function()
                require("chatgpt").openChat()
            end,
            "Open"
        },
        ac = {
            function()
                require("chatgpt").run_action()
            end,
            "Run action"
        },
        aw = {
            function()
                require("chatgpt").open_with_awesome_prompt()
            end,
            "Open with awesome prompt"
        },
        c = {
            function()
                require("chatgpt").complete()
            end,
            "Complete code"
        },
        e = {
            function()
                require("chatgpt").edit_with_instructions()
            end,
            "Edit with instructions"
        }
    }
})
