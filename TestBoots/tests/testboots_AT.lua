--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

local testboots = require "/TestBoots/testboots"

local function RESET_EVALUATION_COUNTS()
  testboots.data.evaluationPassCount = 0
  testboots.data.evaluationFailCount = 0
end

local function FORCE_PASS()
  expectEQ(true, true, "Forced Pass")
end

local function FORCE_FAIL()
  expectEQ(true, false, "Forced Failure")
end

function test_normalTests_expectPassingResults()
  assertEQ(10, 10, "Equal")
  assertNE(-10, 10, "Not Equal")
  assertLT(7, 10, "Less Than")
  assertGT(17, 10, "Greater Than")
  assertLE(7, 10, "Less Than or Equal To")
  assertLE(10, 10, "Less Than or Equal To")
  assertGE(17, 10, "Greater Than or Equal To")
  assertGE(10, 10, "Greater Than or Equal To")
  
  expectEQ(10, 10, "Equal")
  expectNE(-10, 10, "Not Equal")
  expectLT(7, 10, "Less Than")
  expectGT(17, 10, "Greater Than")
  expectLE(7, 10, "Less Than or Equal To")
  expectLE(10, 10, "Less Than or Equal To")
  expectGE(17, 10, "Greater Than or Equal To")
  expectGE(10, 10, "Greater Than or Equal To")
end

function test_evaluationPassCounter_expectIncrementsWithEachPassedEvaluation()
  assertEQ(0, testboots.data.evaluationPassCount, "pass count should be 0 at the start of each test")
  
  RESET_EVALUATION_COUNTS()
  FORCE_PASS()
  expectEQ(1, testboots.data.evaluationPassCount, "passCount++")
  
  RESET_EVALUATION_COUNTS()
  FORCE_FAIL()
  expectEQ(0, testboots.data.evaluationPassCount, "Pass Count Unchanged")
  
  assertEQ(1, testboots.data.evaluationFailCount, "Should have only one failure added")
  testboots.data.evaluationFailCount = 0
end

function test_evaluationFailCounter_expectIncrementsWithEachFailedEvaluation()
  assertEQ(0, testboots.data.evaluationFailCount, "fail count should be 0 at the start of each test")
  
  RESET_EVALUATION_COUNTS()
  FORCE_FAIL()
  expectEQ(1, testboots.data.evaluationFailCount, "failCount++")    
  
  RESET_EVALUATION_COUNTS()
  FORCE_PASS()
  expectEQ(0, testboots.data.evaluationFailCount, "Failure Count Unchanged") 
end

function test_evaluationCounts_shouldBeZeroAtTheStartOfEachTest()
  expectEQ(0, testboots.data.evaluationPassCount, "pass count should be 0 at the start of each test")
  expectEQ(0, testboots.data.evaluationFailCount, "fail count should be 0 at the start of each test")
end

function test_evaluation_expectEitherPassOrFailIsIncremented()
  RESET_EVALUATION_COUNTS()
  FORCE_FAIL()
  expectNE(testboots.data.evaluationPassCount, testboots.data.evaluationFailCount, "passcount ~= failcount")
  
  RESET_EVALUATION_COUNTS()
  FORCE_PASS()
  expectNE(testboots.data.evaluationPassCount, testboots.data.evaluationFailCount, "passcount ~= failcount")
  
  RESET_EVALUATION_COUNTS()
  FORCE_FAIL()
  expectEQ(0, testboots.data.evaluationPassCount, "passcount == 0") 
  expectEQ(1, testboots.data.evaluationFailCount, "failcount == 1")
  
  RESET_EVALUATION_COUNTS()
  FORCE_PASS()
  expectEQ(1, testboots.data.evaluationPassCount, "passcount == 1") 
  expectEQ(0, testboots.data.evaluationFailCount, "failcount == 0")
end

function test_tableComparison_expectTableIsEqualToSelf()
  local A = {}
  local B = A
  expectEQ(A, B, "Expect table is equal to self")
end

function test_tableComparison_expectTablesWithMatchingMembersEqual()
  local A = { [4] = "z", x = 1, y = "2", }
  local B = { [4] = "z", x = 1, y = "2", }
  expectEQ(A, B, "Tables with matching data members are equal")
  
  A.extended = { [1] = "first", two = "2", three = 3 }
  B.extended = { [1] = "first", two = "2", three = 3 }
  expectEQ(A, B, "Tables with matching inner tables are equal")
end

function test_tableComparison_expectTablesWithMismatchedMembersAreNotEqual()
  local A = { [4] = "z", x = 1, y = "2", }
  local B = { [3] = "w", x = 2, y = "1", }
  expectNE(A, B, "Tables with mismatched data members are not equal")
end

function test_()
  error("This should not be executed as a test")
end

function faketest_shouldNotBeExecuted_willExplodeIfExecuted()
  error("This should not be executed as a test")
end