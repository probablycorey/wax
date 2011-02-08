function wax.autoload(folders, pattern)
  for i, folder in ipairs(folders) do
    local files = wax.filesystem.search(wax.root(folder), (pattern or "lua$"))
    for i, file in ipairs(files) do
      local requireString = file:match(wax.root() .. "/(.*)%.lua$") 
      requireString = requireString:gsub("/", ".")
      require(requireString)
    end
  end
end
