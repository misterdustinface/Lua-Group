--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

local TestReporter = require "/TestBoots/TestReporter"
local testReporter = TestReporter()

local reports = require "/TestBoots/reports/reports"
for name, reportSrc in pairs(reports) do
  local ReportClass = require("/TestBoots/reports/" .. reportSrc)
  local reportObj = ReportClass()
  testReporter:addReportType(name, reportObj)
end

testReporter:setReportType("DEFAULT")

local compare = require "/TestBoots/internal/compare"
local globalizeAllFunctions = require "/TestBoots/internal/globalizeAllFunctions"
local onGarbageCollection = require "/TestBoots/internal/onGarbageCollection"
local timeExecution__sec = require "/TestBoots/internal/timeExecution__sec"
local shuffler = require "/TestBoots/internal/shuffleList"

local clearEvaluationCounts, accumulateTestResults
local onTest, onTestPass, onTestFail, onTestExplode, onTestInvalid, createReportSummary, onEvaluationPass, onEvaluationFail
local isTest, addToTestListAtIndexIfIsTest, gatherTests, shuffleTests, executeTests, performTest
local executeTestsAndReportSummarizedResults, gather_shuffle_thenExecuteTestsAndReportSummarizedResults
local wrapTestWithInjectedSystemManipulator, cleanupExplosion, cleanupFailure
local recordExecutionTime_xpcall
local evaluate, testbootsEvaluateCurry, testbootsAssertCurry, performExtensiveEvaluationIfTableEntries
local ASSERT_LV
local init_testboots, init_testboots_data, init_testboots_functions

local DATA = {}
local testboots = {
  data = DATA,
}

function init_testboots(xTestboots)
  init_testboots_data(xTestboots)
  init_testboots_functions(xTestboots)
end

    function init_testboots_data(xTestboots)
      xTestboots.data.TEST_LABEL = "^test_.+"
      xTestboots.data.testCount = 0
      xTestboots.data.testPasses = 0
      xTestboots.data.testFailures = 0
      xTestboots.data.invalidTests = 0
      xTestboots.data.testExplosions = 0
      xTestboots.data.seed = math.random(math.random(os.time()))
      xTestboots.data.executionTime__sec = 0
    end

    function init_testboots_functions(xTestboots)
      
      xTestboots.expectEQ = testbootsEvaluateCurry("==")
      xTestboots.expectNE = testbootsEvaluateCurry("~=")
      xTestboots.expectLT = testbootsEvaluateCurry("<")
      xTestboots.expectGT = testbootsEvaluateCurry(">")
      xTestboots.expectLE = testbootsEvaluateCurry("<=")
      xTestboots.expectGE = testbootsEvaluateCurry(">=")

      xTestboots.assertEQ = testbootsAssertCurry("==")
      xTestboots.assertNE = testbootsAssertCurry("~=")
      xTestboots.assertLT = testbootsAssertCurry("<")
      xTestboots.assertGT = testbootsAssertCurry(">")
      xTestboots.assertLE = testbootsAssertCurry("<=")
      xTestboots.assertGE = testbootsAssertCurry(">=")
      
      xTestboots.addReportType = function(xNickname, xTestReportObject)
        testReporter:addReportType(xNickname, xTestReportObject)
      end

      xTestboots.setReportType = function(xNickname)
        testReporter:setReportType(xNickname)
      end

      xTestboots.restorePreviousReportType = function()
        testReporter:restorePreviousReportType()
      end

      xTestboots.setSeed = function(xSeed)
        xTestboots.data.seed = xSeed
      end

      xTestboots.suite = function(xTestList)
        for _, testfile in ipairs(xTestList) do
          require(testfile)
        end
      end

      globalizeAllFunctions(xTestboots)
      onGarbageCollection(xTestboots, gather_shuffle_thenExecuteTestsAndReportSummarizedResults)
    end

function gather_shuffle_thenExecuteTestsAndReportSummarizedResults()
  local tests = gatherTests()
  shuffleTests(tests)
  executeTestsAndReportSummarizedResults(tests)
end

    function gatherTests()
      local tests = {}
      for key, value in pairs(_G) do
        addToTestListAtIndexIfIsTest(tests, (#tests)+1, key, value)
      end
      return tests
    end

        function addToTestListAtIndexIfIsTest(xTestlist, xIndex, xName, xValue)
          if isTest(xName, xValue) then
            local testName, test = xName, xValue
            table.insert(xTestlist, xIndex, { name = testName, exec = test })
          end
        end
    
            function isTest(xName, xValue)
              return type(xValue) == "function" and string.match(xName, DATA.TEST_LABEL)
            end

    function shuffleTests(tests)
      math.randomseed(DATA.seed)
      shuffler(tests)
    end

    function executeTestsAndReportSummarizedResults(xTests)
      DATA.executionTime__sec = timeExecution__sec(executeTests, xTests)
      createReportSummary()
    end
  
        function executeTests(xTests)
          for index, test in ipairs(xTests) do
            local wrappedTest = wrapTestWithInjectedSystemManipulator(index, test, xTests)
            performTest(test.name, wrappedTest)
          end
        end
    
            function wrapTestWithInjectedSystemManipulator(xCurrentTestIndex, xCurrentTest, xTestList)
              return function()
                local xSystemManipulator = {
                  injectFollowupTest = function(xxTestName, xxTest)
                    addToTestListAtIndexIfIsTest(xTestList, (xCurrentTestIndex + 1), xxTestName, xxTest)
                  end,
                  cleanupExplosion = cleanupExplosion,
                  cleanupFailure = cleanupFailure,
                  gatherTests = gatherTests,
                  shuffleTests = shuffleTests,
                  executeTestsAndReportSummarizedResults = executeTestsAndReportSummarizedResults,
                  gather_shuffle_thenExecuteTestsAndReportSummarizedResults = gather_shuffle_thenExecuteTestsAndReportSummarizedResults,
                }
                xCurrentTest.exec(xSystemManipulator)
              end
            end
            
                function cleanupExplosion()
                  testboots.assertNE(0, DATA.testExplosions)
                  DATA.testExplosions = DATA.testExplosions - 1
                  DATA.testPasses = DATA.testPasses + 1
                end
                
                function cleanupFailure()
                  testboots.assertNE(0, DATA.testFailures)
                  DATA.testFailures = DATA.testFailures - 1
                  DATA.testPasses = DATA.testPasses + 1
                end
      
            function performTest(xTestName, xTest)
              clearEvaluationCounts()
              onTest(xTestName)
              
              local testDidNotExplode = recordExecutionTime_xpcall(xTest, onTestExplode)
              
              if testDidNotExplode then
                accumulateTestResults()
              end
            end
      
                function clearEvaluationCounts()
                  DATA.evaluationPassCount = 0
                  DATA.evaluationFailCount = 0
                end
        
                function onTest(xTestName)
                  DATA.testCount = DATA.testCount + 1
                  testReporter:reportHeader { title = xTestName }
                end
                
                function onTestExplode(xExplosiveResult)
                  DATA.testExplosions = DATA.testExplosions + 1
                  testReporter:reportExplosion { result = xExplosiveResult }
                end
                
                function recordExecutionTime_xpcall(xFunc, xExceptionHandler)
                  local callOK
                  DATA.executionTime__sec = timeExecution__sec(
                    function()
                      callOK = xpcall(xFunc, xExceptionHandler)
                    end
                  )
                  return callOK
                end
        
                function accumulateTestResults()
                  if DATA.evaluationFailCount > 0 then
                    onTestFail()
                  elseif DATA.evaluationPassCount > 0 then
                    onTestPass()
                  else
                    onTestFail()
                    onTestInvalid()
                  end
                end
        
                    function onTestPass()
                      DATA.testPasses = DATA.testPasses + 1
                      testReporter:reportPassedTest { executionTimeInSeconds = DATA.executionTime__sec, }
                    end

                    function onTestFail()
                      DATA.testFailures = DATA.testFailures + 1
                      testReporter:reportFailedTest { executionTimeInSeconds = DATA.executionTime__sec, }
                    end

                    function onTestInvalid()
                      DATA.invalidTests = DATA.invalidTests + 1
                      testReporter:reportInvalidTest()
                    end
  
        function createReportSummary()
          testReporter:reportSummary { 
            passes = DATA.testPasses, 
            failures = DATA.testFailures,
            invalidated = DATA.invalidTests,
            explosions = DATA.testExplosions,
            tests = DATA.testCount, 
            executionTimeInSeconds = DATA.executionTime__sec, 
            seed = DATA.seed,
          }
        end

function testbootsAssertCurry(xOp)
  local evaluator = testbootsEvaluateCurry(xOp)
  return function(xExpected, xGiven, xLabel)
    local resultant = evaluator(xExpected, xGiven, xLabel)
    ASSERT_LV(resultant, xLabel, 2)
  end
end

    function testbootsEvaluateCurry(xOp)
      return function(xExpected, xGiven, xLabel) 
        return evaluate(xExpected, xOp, xGiven, xLabel) 
      end
    end

        function evaluate(xExpected, xOpSymbol, xReceived, xLabel)
          local evaluationInfo = { expected = xExpected, received = xReceived, operation = xOpSymbol }
          local passed = compare(xExpected, xOpSymbol, xReceived)
          if passed then
            onEvaluationPass(xExpected, xOpSymbol, xReceived, xLabel)
          else 
            onEvaluationFail(xExpected, xOpSymbol, xReceived, xLabel)
            performExtensiveEvaluationIfTableEntries(xExpected, xOpSymbol, xReceived, xLabel)
          end

          return passed
        end

            function onEvaluationPass(xExpected, xOpSymbol, xReceived, xLabel)
              DATA.evaluationPassCount = DATA.evaluationPassCount + 1
              xLabel = xLabel or ""
              testReporter:reportPass { expected = xExpected, received = xReceived, operation = xOpSymbol, label = xLabel }
            end

            function onEvaluationFail(xExpected, xOpSymbol, xReceived, xLabel)
              DATA.evaluationFailCount = DATA.evaluationFailCount + 1
              xLabel = xLabel or ""
              testReporter:reportFail { expected = xExpected, received = xReceived, operation = xOpSymbol, label = xLabel }
            end
            
            function performExtensiveEvaluationIfTableEntries(xExpected, xOpSymbol, xReceived, xLabel)
              if type(xExpected) == "table" and type(xReceived) == "table" then
                local keySet = {}
                for k,_ in pairs(xExpected) do keySet[k] = true end
                for k,_ in pairs(xReceived) do keySet[k] = true end
                for k,_ in pairs(keySet) do
                  evaluate(xExpected[k], xOpSymbol, xReceived[k], ('['..k..']'))
                end
              end
            end
            
    function ASSERT_LV(xAssertion, xMessage, xLevel)
      if not xAssertion then
        error(xMessage, xLevel + 1)
      end
    end

init_testboots(testboots)

return testboots