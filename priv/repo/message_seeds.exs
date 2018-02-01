alias StuffSwap.Repo
alias StuffSwap.Types.Category
alias StuffSwap.Subtypes.Subcategory
alias StuffSwap.Store.Item
alias StuffSwap.Account.User
alias StuffSwap.Chat.Message

Repo.insert!(%Message{body: "from grigor to aram", is_red: false, author_id: 3, addressedto_id: 4, item_id: 16})
Repo.insert!(%Message{body: "from aram to grigor", is_red: false, author_id: 4, addressedto_id: 3, item_id: 16})