function wax.autoload(...)
  for i, folder in ipairs({...}) do
    local files = wax.filesystem.search(wax.root(folder), "lua$")
    for i, file in ipairs(files) do
      local requireString = file:match(wax.root() .. "/(.*)%.lua$")
      requireString = requireString:gsub("/", ".")
      require(requireString)
    end
  end
end
