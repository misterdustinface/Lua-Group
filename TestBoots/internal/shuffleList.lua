--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

local function shuffleList(list)
  for i = 1, #list do
    local j = math.random(i, #list)
    list[i], list[j] = list[j], list[i]
  end
end

return shuffleList
