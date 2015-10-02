--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

local function isMethod(xMethod)
  return type(xMethod) == 'function'
end

local function callMethodOf(xObj, xMethod, xArgs)
  local method = xObj[xMethod]
  if isMethod(method) then
    method(xObj, unpack(xArgs))
  end
end

local function iterativeDispatch(xGroup, ...)
  local args = {...}
  local method = xGroup.indexedMethod
  for index, element in ipairs(xGroup.elements) do
    callMethodOf(element, method, args)
  end
end

local DISPATCHERS = {
  ["iterative"] = iterativeDispatch,
  ["parallel"] = nil,
  ["future"] = nil, ["iterative future"] = nil,
  ["parallel future"] = nil,
}

local function groupMethodIndexer(xGroup, xIndex)
  xGroup.indexedMethod = xIndex
  return xGroup.dispatch
end

local function newAssignment(xGroup, xKey, xValue)
  -- Do not assign xValue to xKey of xGroup.
  return xGroup
end

local function setDispatch(xGroup, xType)
  xGroup.dispatch = DISPATCHERS[xType] or iterativeDispatch
end

local function addDispatch(xGroup, xType, xDispatchFunc)
  DISPATCHERS[xType] = xDispatchFunc
end

local function constructor(xElements)
  local group = {
    elements = xElements,
    setDispatch = setDispatch,
    dispatch = iterativeDispatch,
    indexedMethod = "",
  }
  
  setmetatable(group, {
    __index = groupMethodIndexer, 
    __newindex = newAssignment,
  })
  
  return group
end

return constructor
