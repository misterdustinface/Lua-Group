--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

local testboots = require "/TestBoots/testboots"

local function assert_testboots_exists()
  assertNE(nil, testboots, "testboots exists")
  assertEQ("table", type(testboots), "testboots is a table")
end

function test_API_expectContainsSpecifiedFunctions()  
  local expectTestBootsHasFunctions = {
    ["expectEQ"] = true,
    ["expectNE"] = true,
    ["expectLT"] = true,
    ["expectGT"] = true,
    ["expectLE"] = true,
    ["expectGE"] = true,
    ["assertEQ"] = true,
    ["assertNE"] = true,
    ["assertLT"] = true,
    ["assertGT"] = true,
    ["assertLE"] = true,
    ["assertGE"] = true,
    ["addReportType"] = true,
    ["setReportType"] = true,
    ["restorePreviousReportType"] = true,
    ["setSeed"] = true,
    ["suite"] = true,
  }
  
  assert_testboots_exists()
  
  for functionName, _ in pairs(expectTestBootsHasFunctions) do
    local value = testboots[functionName]
    expectNE(nil, value, "Contains " .. functionName)
    expectEQ("function", type(value), functionName .. " is a function")
  end
  
  for memberName, memberValue in pairs(testboots) do
    if type(memberValue) == "function" then
      expectEQ(true, expectTestBootsHasFunctions[memberName], memberName .. " has been accounted for in this test.")
    end
  end
end

function test_testbootsInternalData_expectContainsAsDesignatedType()  
  local expectTestBootsDataMemberTypes = {
    ["testCount"] = "number",
    ["testPasses"] = "number",
    ["testFailures"] = "number",
    ["invalidTests"] = "number",
    ["testExplosions"] = "number",
    ["evaluationPassCount"] = "number",
    ["evaluationFailCount"] = "number",
    ["seed"] = "number",
    ["executionTime__sec"] = "number",
    ["TEST_LABEL"] = "string",
  }
  
  assert_testboots_exists()
  
  for dataMember, expectedTypename in pairs(expectTestBootsDataMemberTypes) do
    local value = testboots.data[dataMember]
    expectNE(nil, value, "Contains " .. dataMember)
    expectEQ(expectedTypename, type(value), dataMember .. " is a number")
  end
  
  for memberName, memberValue in pairs(testboots.data) do
    local typename = type(memberValue)
    if typename ~= "function" then 
      expectEQ(typename, expectTestBootsDataMemberTypes[memberName], memberName .. " has been accounted for in this test.")
    end
  end
  
end

function test_injectedSystemManipulator_expectContainsSpecifiedFunctions(xSys)  
  local expectSystemManipulatorHasFunctions = {
    ["injectFollowupTest"] = true,
    ["cleanupFailure"] = true,
    ["cleanupExplosion"] = true,
    ["gatherTests"] = true,
    ["shuffleTests"] = true,
    ["executeTestsAndReportSummarizedResults"] = true,
    ["gather_shuffle_thenExecuteTestsAndReportSummarizedResults"] = true,
  }
  
  for functionName, _ in pairs(expectSystemManipulatorHasFunctions) do
    local value = xSys[functionName]
    assertNE(nil, value, "Contains " .. functionName)
    expectEQ("function", type(value), functionName .. " is a function")
  end
  
  for memberName, memberValue in pairs(xSys) do
    assertEQ("function", type(memberValue), memberName .. " is a function")
    expectEQ(true, expectSystemManipulatorHasFunctions[memberName], memberName .. " has been accounted for in this test.")
  end
  
end