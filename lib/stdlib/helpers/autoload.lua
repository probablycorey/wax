function wax.autoload(folders, pattern)
  for i, folder in ipairs(folders) do
    local files = wax.filesystem.search(wax.root("scripts", folder), (pattern or "lua$"))
    for i, file in ipairs(files) do
      file = file:match(wax.root("scripts") .. "/(.*)%.lua$") 
      file = file:gsub("/", ".")
      require(file)
    end
  end
end