--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

local equal
local equalTable
local compare

function equal(x, y)
  local result
  if type(x) ~= type(y) then 
    result = false
  elseif type(x) == "table" then
    result = equalTable(x, y)
  else
    result = (x == y)
  end
  return result
end

function equalTable(x, y)
  for k, v in pairs(x) do
    if not equal(y[k], v) then return false end
  end
  for k, v in pairs(y) do
    if not equal(x[k], v) then return false end
  end
  return true
end

local ops = {
  ["=="] = function(A, B) return equal(A, B) end,
  ["~="] = function(A, B) return not equal(A, B) end,
  ["<"]  = function(A, B) return A < B end,
  [">"]  = function(A, B) return A > B end,
  ["<="] = function(A, B) return A <= B end,
  [">="] = function(A, B) return A >= B end,
}

function compare(A, xOp, B)
  local comparator = ops[xOp]
  local result = false
  if comparator then
    result = comparator(A, B)
  end
  return result
end

return compare