--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

local testboots = require "/TestBoots/testboots"
local SpyReport = require "/TestBoots/tests/SpyReport"

local function FORCE_PASS()
  expectEQ(true, true, "Forced Pass")
end

local function FORCE_FAIL()
  expectNE(true, true, "Forced Fail")
end

function test_spyReport_expectPassedEvaluationCallsReportPass()
  local spyReport = SpyReport()
  addReportType("SPY", spyReport)
  assertEQ(false, spyReport.wasCalled["pass"], "Spy should not yet record a call to PASS to the report")
  
  setReportType("SPY")
  expectEQ(true, true, "Should pass, and we shouldn't see this message output.")
  testboots.data.evaluationPassCount = 0
  restorePreviousReportType()
  
  expectEQ(true, spyReport.wasCalled["pass"], "Spy should record a call to PASS to the report")
end

function test_spyReport_expectFailedEvaluationCallsReportFail()
  local spyReport = SpyReport()  
  addReportType("SPY", spyReport)
  assertEQ(false, spyReport.wasCalled["fail"], "Spy should not yet record a call to FAIL to the report")
  
  setReportType("SPY")
  expectNE(true, true, "Should fail, and we shouldn't see this message output.")
  testboots.data.evaluationFailCount = 0
  restorePreviousReportType()
  
  expectEQ(true, spyReport.wasCalled["fail"], "Spy should record a call to FAIL to the report")
end

function test_spyReport_expectExplodedEvaluationCallsReportExplosion(xSys)
  local spyReport = SpyReport()  
  addReportType("SPY", spyReport)
  assertEQ(false, spyReport.wasCalled["explosion"], "Spy should not yet record a call to EXPLOSION to the report")
  
  setReportType("SPY")
  xSys.injectFollowupTest("test_spyReport_expectExplosionCalled_YOU_WILL_NOT_SEE_THIS_TEST_IN_OUTPUT", function()
      restorePreviousReportType()
      expectEQ(true, spyReport.wasCalled["explosion"], "Spy should record a call to EXPLOSION to the report")
      xSys.cleanupExplosion()
  end)
  
  error("Should explode, and we shouldn't see this message output.")
end

function test_spyOnReport_expectNewHeaderOnNewTest(xSys)
  local spyReport = SpyReport()  
  addReportType("SPY", spyReport)
  assertEQ(false, spyReport.wasCalled["header"], "Spy should not yet record a call to HEADER to the report")
  
  setReportType("SPY")
  xSys.injectFollowupTest("test_spyOnReport_expectHeaderCalled_YOU_WILL_NOT_SEE_THIS_TEST_IN_OUTPUT", function()
      restorePreviousReportType()
      expectEQ(true, spyReport.wasCalled["header"], "Spy should record a call to HEADER to the report")
  end)
end

function test_spyOnReport_expectTestbootsRunCallsSummaryAtEnd(xSys)
  local spyReport = SpyReport()  
  addReportType("SPY", spyReport)
  assertEQ(false, spyReport.wasCalled["summary"], "Spy should not yet record a call to SUMMARY to the report")
  
  setReportType("SPY")
  pcall(xSys.executeTestsAndReportSummarizedResults, {})
  restorePreviousReportType()
  
  expectEQ(true, spyReport.wasCalled["summary"], "Spy should record a call to SUMMARY to the report")
end

function test_spyOnReport_expectPassedTestCalled(xSys)
  local spyReport = SpyReport()  
  addReportType("SPY", spyReport)
  assertEQ(false, spyReport.wasCalled["passedTest"], "Spy should not yet record a call to PASSED TEST for the report")
  
  setReportType("SPY")
  xSys.injectFollowupTest("test_spyOnReport_expectPassedTestCalled_YOU_WILL_NOT_SEE_THIS_TEST_IN_OUTPUT", function()
      restorePreviousReportType()
      expectEQ(true, spyReport.wasCalled["passedTest"], "Spy should record a call to PASSED TEST for the report")
  end)

  FORCE_PASS()
end

function test_spyOnReport_expectFailedTestCalled(xSys)
  local spyReport = SpyReport()  
  addReportType("SPY", spyReport)
  assertEQ(false, spyReport.wasCalled["failedTest"], "Spy should not yet record a call to FAILED TEST for the report")
  
  setReportType("SPY")
  xSys.injectFollowupTest("test_spyOnReport_expectFailedTestCalled_YOU_WILL_NOT_SEE_THIS_TEST_IN_OUTPUT", function()
      restorePreviousReportType()
      expectEQ(true, spyReport.wasCalled["failedTest"], "Spy should record a call to FAILED TEST for the report")
      xSys.cleanupFailure()
  end)

  FORCE_FAIL()
end

function test_spyOnReport_expectInvalidTestCalled(xSys)
  local spyReport = SpyReport()  
  addReportType("SPY", spyReport)
  assertEQ(false, spyReport.wasCalled["invalidTest"], "Spy should not yet record a call to INVALID TEST for the report")
  
  setReportType("SPY")
  xSys.injectFollowupTest("test_spyOnReport_expectInvalidTestCalled_YOU_WILL_NOT_SEE_THIS_TEST_IN_OUTPUT", function()
      restorePreviousReportType()
      expectEQ(true, spyReport.wasCalled["invalidTest"], "Spy should record a call to INVALID TEST for the report")
      xSys.cleanupFailure()
  end)

  testboots.data.evaluationPassCount = 0
  testboots.data.evaluationFailCount = 0
end

local wasHolyShitCalled = false
function holyshit_thiswillblowyourmind()
  wasHolyShitCalled = true
  FORCE_PASS()
end

function test_gather_shuffle_thenExecuteTestsAndReportSummarizedResults_withNewTestLabel_expectTestWithNewLabelCalled(xSys)
  local originalTestLabel = testboots.data.TEST_LABEL
  
  local spyReport = SpyReport()  
  addReportType("SPY", spyReport)
  
  assertEQ(false, spyReport.wasCalled["header"], "Spy should not yet record a call to HEADER to the report")
  assertEQ(false, spyReport.wasCalled["pass"], "Spy should not yet record a call to PASS to the report")
  assertEQ(false, spyReport.wasCalled["summary"], "Spy should not yet record a call to SUMMARY to the report")
  
  setReportType("SPY")
  testboots.data.TEST_LABEL = "^holyshit_thiswillblowyourmind$"
  xSys.gather_shuffle_thenExecuteTestsAndReportSummarizedResults()
  restorePreviousReportType()
  
  expectEQ(true, spyReport.wasCalled["header"], "Spy should record a call to HEADER to the report")
  expectEQ(true, spyReport.wasCalled["pass"], "Spy should record a call to PASS to the report")
  expectEQ(true, spyReport.wasCalled["summary"], "Spy should record a call to SUMMARY to the report")
  expectEQ(true, wasHolyShitCalled, "Specified test with new label was called")
  
  testboots.data.TEST_LABEL = originalTestLabel
end

function test_spyReport_header_expectReceivesExpectedTestData(xSys)
  local spyReport = SpyReport()  
  addReportType("SPY", spyReport)
  assertEQ({}, spyReport.headerTestData, "HEADER Data should be empty")
  
  local injectedTestName = "test_spyReport_header_internal"
  local expectedTestData = { title = injectedTestName }
  
  setReportType("SPY")
  xSys.injectFollowupTest(injectedTestName, function()
      restorePreviousReportType()
      expectEQ(expectedTestData, spyReport.headerTestData, "HEADER Data should be as expected")
  end)
end

function test_spyReport_pass_expectReceivesExpectedTestData(xSys)
  local spyReport = SpyReport()  
  addReportType("SPY", spyReport)
  assertEQ({}, spyReport.passEvalData, "EVALUATION PASS Data should be empty")
  
  local expectedTestData = {expected = true, received = true, operation = "==", label = "true == true"}
  
  setReportType("SPY")
  xSys.injectFollowupTest("test_spyReport_pass_internal", function()
      restorePreviousReportType()
      expectEQ(expectedTestData, spyReport.passEvalData, "EVALUATION PASS Data should be as expected")
  end)

  expectEQ(true, true, "true == true")
end

function test_spyReport_fail_expectReceivesExpectedTestData(xSys)
  local spyReport = SpyReport()  
  addReportType("SPY", spyReport)
  assertEQ({}, spyReport.failEvalData, "EVALUATION FAIL Data should be empty")
  
  local expectedTestData = {expected = true, received = true, operation = "~=", label = "true ~= true"}
  
  setReportType("SPY")
  xSys.injectFollowupTest("test_spyReport_fail_internal", function()
      restorePreviousReportType()
      expectEQ(expectedTestData, spyReport.failEvalData, "EVALUATION FAIL Data should be as expected")
      xSys.cleanupFailure()
  end)

  expectNE(true, true, "true ~= true")
end

function test_spyReport_explosion_expectReceivesExpectedTestData(xSys)
  local spyReport = SpyReport()  
  addReportType("SPY", spyReport)
  assertEQ({}, spyReport.explosionData, "EXPLOSION Data should be empty")
  
  setReportType("SPY")
  xSys.injectFollowupTest("test_spyReport_explosion_internal", function()
      restorePreviousReportType()
      expectEQ("string", type(spyReport.explosionData.result), "EXPLOSION Data should be as expected")
      xSys.cleanupExplosion()
  end)

  error("THIS IS AN ERROR WHICH WILL CAUSE AN EXPLOSION")
end

function test_spyReport_summary_expectReceivesExpectedTestData(xSys)
  local spyReport = SpyReport()  
  addReportType("SPY", spyReport)
  assertEQ({}, spyReport.summaryData, "SUMMARY Data should be empty")
  
  setReportType("SPY")
  pcall(xSys.executeTestsAndReportSummarizedResults, {})
  restorePreviousReportType()

  local expectedTestData = {
    passes = testboots.data.testPasses, 
    failures = testboots.data.testFailures,
    invalidated = testboots.data.invalidTests,
    explosions = testboots.data.testExplosions,
    tests = testboots.data.testCount, 
    seed = testboots.data.seed,
    executionTimeInSeconds = testboots.data.executionTime__sec,
  }

  expectEQ(expectedTestData, spyReport.summaryData, "SUMMARY Data should be as expected")
end

function test_spyReport_passedTest_expectReceivesExpectedTestData(xSys)
  local spyReport = SpyReport()  
  addReportType("SPY", spyReport)
  assertEQ({}, spyReport.passedTestData, "PASSED TEST Data should be empty")
  
  setReportType("SPY")
  xSys.injectFollowupTest("test_spyReport_passedTest_internal", function()
      restorePreviousReportType()
      
      local expectedTestData = { executionTimeInSeconds = testboots.data.executionTime__sec, }
      expectEQ(expectedTestData, spyReport.passedTestData, "PASSED TEST Data should be as expected")
  end)

  FORCE_PASS()
end

function test_spyReport_failedTest_expectReceivesExpectedTestData(xSys)
  local spyReport = SpyReport()  
  addReportType("SPY", spyReport)
  assertEQ({}, spyReport.failedTestData, "FAILED TEST Data should be empty")
  
  setReportType("SPY")
  xSys.injectFollowupTest("test_spyReport_failedTest_internal", function()
      restorePreviousReportType()
      
      local expectedTestData = { executionTimeInSeconds = testboots.data.executionTime__sec, }
      expectEQ(expectedTestData, spyReport.failedTestData, "FAILED TEST Data should be as expected")
      xSys.cleanupFailure()
  end)

  FORCE_FAIL()
end