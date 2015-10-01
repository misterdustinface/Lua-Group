--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

require "/TestBoots/testboots"
local group = require "/group/Group"

local newSpyElement

function test_groupConstructor_returnsTable()
  local testgroup = group()
  expectEQ("table", type(testgroup), "The group constructor returns a table")
end

function test_groupConstruction_expectGroupHasElementsAddedByConstruction()
  local testgroup = group { 1, 2, 3 }
  expectEQ({1, 2, 3}, testgroup.elements, "The group elements should be those which were defined on construction")
end

function test_groupMethodCall_withOneElement_expectElementOfGroupHaveMethodCall()
  local spyElement = newSpyElement()
  local testgroup = group { spyElement }
  
  assertEQ(false, spyElement.wasCalled, 
    "The method of the spy element has not yet been called")
  testgroup:someMethod()
  expectEQ(true, spyElement.wasCalled, 
    "The method of the spy element has been called")
end

function test_groupMethodCall_withManyElements_expectElementsOfGroupHaveMethodCall()
  local spyA, spyB, spyC = newSpyElement(), newSpyElement(), newSpyElement()
  local testgroup = group { spyA, spyB, spyC }
  
  assertEQ(false, spyA.wasCalled, "The method of spyA has not yet been called")
  assertEQ(false, spyB.wasCalled, "The method of spyB has not yet been called")
  assertEQ(false, spyC.wasCalled, "The method of spyC has not yet been called")
  
  testgroup:someMethod()
  expectEQ(true, spyA.wasCalled, "The method of spyA has been called")
  expectEQ(true, spyB.wasCalled, "The method of spyA has been called")
  expectEQ(true, spyC.wasCalled, "The method of spyA has been called")
end

function test_groupMethodCall_withExclusiveMethod_expectElementsOfGroupWithMethodReceiveMethodCall()
  local spyA, spyB, spyC = newSpyElement(), newSpyElement(), newSpyElement()
  local testgroup = group { spyA, spyB, spyC }
  
  spyB.exclusiveMethod = function(xSelf, ...)
    xSelf.wasCalled = true
  end
  
  assertEQ(false, spyA.wasCalled, "The method of spyA has not yet been called")
  assertEQ(false, spyB.wasCalled, "The method of spyB has not yet been called")
  assertEQ(false, spyC.wasCalled, "The method of spyC has not yet been called")
  
  testgroup:exclusiveMethod()
  expectEQ(false, spyA.wasCalled, "The method of spyA has NOT been called")
  expectEQ(true,  spyB.wasCalled, "The method of spyA has been called")
  expectEQ(false, spyC.wasCalled, "The method of spyA has NOT been called")
end

function test_groupMethodCall_withArgument_expectElementsOfGroupSeeArgumentWithinCall()
  local spyA, spyB, spyC = newSpyElement(), newSpyElement(), newSpyElement()
  local testgroup = group { spyA, spyB, spyC }
  local argument = 'X'
  
  testgroup:someMethod(argument)
  expectEQ(argument, spyA.argument, "spyA saw the argument")
  expectEQ(argument, spyB.argument, "spyB saw the argument")
  expectEQ(argument, spyC.argument, "spyC saw the argument")
end

function test_groupMethodCall_withExclusiveMethodWithArgument_expectElementsOfGroupSeeArgumentWithinCall()
  local spyA, spyB, spyC = newSpyElement(), newSpyElement(), newSpyElement()
  local testgroup = group { spyA, spyB, spyC }
  local argument = 'X'
  
  spyB.exclusiveMethod = function(xSelf, xArgument)
    xSelf.argument = xArgument
  end
  
  testgroup:exclusiveMethod(argument)
  expectEQ(nil, spyA.argument, "spyA did not see the argument")
  expectEQ(argument, spyB.argument, "spyB saw the argument")
  expectEQ(nil, spyC.argument, "spyC did not see the argument")
end

function newSpyElement()
  local spyElement = {
    wasCalled = false,
    argument = nil,
    someMethod = function(xSelf, xArgument)
      xSelf.wasCalled = true
      xSelf.argument = xArgument
    end,
  }
  return spyElement
end
