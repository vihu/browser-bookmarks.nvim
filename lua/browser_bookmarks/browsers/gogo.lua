local gogo = {}

local sqlite = require "sqlite"

-- Determine the directory path where the dbfile is stored.
-- The user must have set GOGODB_PATH environment variable.
--
---@return nil | string
local function get_gogo_db()
  local gogodb_path = os.getenv "GOGODB_PATH"
  if not gogodb_path then
    return nil
  end
  return gogodb_path
end

-- Collect all the bookmarks for gogo.
---@return Bookmark[]?
function gogo.collect_bookmarks()
  local dbpath = get_gogo_db()

  local db = sqlite.new(dbpath):open()
  local keys = { "key", "val" }
  local rows = db:select("mnemonic", { keys = keys })

  local bookmarks = {}
  for _, row in ipairs(rows) do
    local bookmark = {
      name = row.key,
      url = row.val,
    }
    table.insert(bookmarks, bookmark)
  end

  db:close()
  return bookmarks
end

return gogo
