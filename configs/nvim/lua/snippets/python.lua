local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
  -- Type:  ipdb<C-L>
  s("ipdb", {
    t("import ipdb; ipdb.set_trace()"),
  }),
}
