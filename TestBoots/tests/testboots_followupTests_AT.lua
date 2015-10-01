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

function test_errorThrown_createExplosion(xSys)
  local currentExplosions = testboots.data.testExplosions
  local expectedExplosionsAfterThisTest = currentExplosions + 1
  local expectedPasses = testboots.data.testPasses
  local expectedFailures = testboots.data.testFailures
  
  xSys.injectFollowupTest("test_errorThrown_expectAdditionalRecordedExplosion", function()
      local expectedExplosions = expectedExplosionsAfterThisTest
      local recordedExplosions = testboots.data.testExplosions
      expectEQ(expectedExplosions, recordedExplosions, "A exploded test is recorded by the system")
      expectEQ(expectedPasses, testboots.data.testPasses, "No additional passes should be recorded")
      expectEQ(expectedFailures, testboots.data.testFailures, "No additional failures should be recorded")
      xSys.cleanupExplosion()
  end)

  error("This error should create an explosion")
end

function test_assertionFailure_createExplosion(xSys)
  local currentExplosions = testboots.data.testExplosions
  local expectedExplosionsAfterThisTest = currentExplosions + 1
  local expectedPasses = testboots.data.testPasses
  local expectedFailures = testboots.data.testFailures
  
  xSys.injectFollowupTest("test_assertionFailureOccurred_expectAdditionalRecordedExplosion", function()
      local expectedExplosions = expectedExplosionsAfterThisTest
      local recordedExplosions = testboots.data.testExplosions
      expectEQ(expectedExplosions, recordedExplosions, "A exploded test is recorded by the system")
      expectEQ(expectedPasses, testboots.data.testPasses, "No additional passes should be recorded")
      expectEQ(expectedFailures, testboots.data.testFailures, "No additional failures should be recorded")
      xSys.cleanupExplosion()
  end)

  assertEQ(true, true, "This good assertion should pass")
  assertEQ(true, false, "This bad assertion should create an explosion after safe evaluation")
end

function test_forcePass_expectTestAfterThisTestToHaveOneAdditionalRecordedPass(xSys)
  local currentPasses = testboots.data.testPasses
  local expectedPassesAfterThisTest = currentPasses + 1
  
  xSys.injectFollowupTest("test_expectAdditionalRecordedPass", function()
      local expectedPasses = expectedPassesAfterThisTest
      local recordedPasses = testboots.data.testPasses
      expectEQ(expectedPasses, recordedPasses, "A passing test is recorded by the system")
  end)

  FORCE_PASS()
end

function test_forceFailure_expectTestAfterThisTestToHaveOneAdditionalRecordedFailure(xSys)
  local currentFailures = testboots.data.testFailures
  local expectedFailuresAfterThisTest = currentFailures + 1
  
  xSys.injectFollowupTest("test_expectAdditionalRecordedFail", function()
      local expectedFailures = expectedFailuresAfterThisTest
      local recordedFailures = testboots.data.testFailures
      expectEQ(expectedFailures, recordedFailures, "A failing test is recorded by the system")
      xSys.cleanupFailure()
  end)

  FORCE_FAIL()
end

function test_forcePass_expectTestAfterThisTestToHaveOneAdditionalRecordedPassAndNoAdditionalRecordedFailures(xSys)
  local currentPasses = testboots.data.testPasses
  local currentFailures = testboots.data.testFailures
  local expectedPassesAfterThisTest = currentPasses + 1
  local expectedFailuresAfterThisTest = currentFailures
  
  xSys.injectFollowupTest("test_expectAdditionalRecordedPassAndNoAdditionalRecordedFailures", function()
      local expectedPasses = expectedPassesAfterThisTest
      local recordedPasses = testboots.data.testPasses
      expectEQ(expectedPasses, recordedPasses, "A passing test is recorded by the system")
      local expectedFailures = expectedFailuresAfterThisTest
      local recordedFailures = testboots.data.testFailures
      expectEQ(expectedFailures, recordedFailures, "A passing test does not raise a failure in the system")
  end)

  FORCE_PASS()
end

function test_forceFailure_expectTestAfterThisTestToHaveOneAdditionalRecordedFailureAndNoAdditionalRecordedPasses(xSys)
  local currentPasses = testboots.data.testPasses
  local currentFailures = testboots.data.testFailures
  local expectedPassesAfterThisTest = currentPasses
  local expectedFailuresAfterThisTest = currentFailures + 1
  
  xSys.injectFollowupTest("test_expectAdditionalRecordedFailureAndNoAdditionalRecordedPasses", function()
      local expectedPasses = expectedPassesAfterThisTest
      local recordedPasses = testboots.data.testPasses
      expectEQ(expectedPasses, recordedPasses, "A failing test does not raise a PASS in the system")
      local expectedFailures = expectedFailuresAfterThisTest
      local recordedFailures = testboots.data.testFailures
      expectEQ(expectedFailures, recordedFailures, "A failing test is recorded by the system")
      xSys.cleanupFailure()
  end)

  FORCE_FAIL()
end

function test_forcePass_expectTestAfterThisTestToHaveIncrementedTestCount(xSys)
  local currentTestCount = testboots.data.testCount
  local expectedTestCountAfterThisTest = currentTestCount + 1
  
  xSys.injectFollowupTest("test_expectIncrementedTestCount", function()
      local expectedTestCount = expectedTestCountAfterThisTest
      local recordedTestCount = testboots.data.testCount
      expectEQ(expectedTestCount, recordedTestCount, "A test is recorded by the system")
  end)

  FORCE_PASS()
end

function test_testWithPassingAndFailingEvaluation_shouldFail(xSys)
  local currentFailures = testboots.data.testFailures
  local expectedFailuresAfterThisTest = currentFailures + 1
  
  xSys.injectFollowupTest("test_expectPreviousTestFailed", function()
      local expectedFailures = expectedFailuresAfterThisTest
      local recordedFailures = testboots.data.testFailures
      expectEQ(expectedFailures, recordedFailures, "A test with passing and failing evaluation should result in a Failed test")
      xSys.cleanupFailure()
  end)

  FORCE_PASS()
  FORCE_FAIL()
end

function test_invalidTest_expectIsFailure(xSys)
  local currentFailures = testboots.data.testFailures
  local expectedFailuresAfterThisTest = currentFailures + 1

  xSys.injectFollowupTest("test_expectPreviousTestFailedBecauseInvalid_cleanup", function()
    local expectedFailures = expectedFailuresAfterThisTest
    local recordedFailures = testboots.data.testFailures
    expectEQ(expectedFailures, recordedFailures, "An invalid test (with no evaluations) is a Failing test")
    xSys.cleanupFailure()
  end)

  RESET_EVALUATION_COUNTS()
end