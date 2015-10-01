--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

local function globalizeAllFunctions(xTable)
  for k, v in pairs(xTable) do
    if type(v) == "function" then
      _G[k] = v
    end
  end  
end

return globalizeAllFunctions