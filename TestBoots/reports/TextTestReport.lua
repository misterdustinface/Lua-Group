--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

require "/TestBoots/reports/translate"

local function header(xTestReport, xTestData)
  local title = xTestData.title
  io.write(string.format("\n  %s:  %s\n", T("TEST"), title))
  io.write(string.format("(%6s) %20s %10s %20s %80s\n", T("RESULT"), T("EXPECTED"), T("OPERATION"), T("RECEIVED"), T("LABEL")))
  xTestReport.currentTestName = title
end

local function pass(xTestReport, xTestData)
  local label, expected, operation, received = xTestData.label, xTestData.expected, xTestData.operation, xTestData.received
  io.write(string.format("[ %4s ] %20s %10s %20s %80s\n", T("PASS"), tostring(expected), operation, tostring(received), label))
end

local function fail(xTestReport, xTestData)
  local label, expected, operation, received = xTestData.label, xTestData.expected, xTestData.operation, xTestData.received
  io.write(string.format("[ %4s ] %20s %10s %20s %80s\n", T("FAIL"), tostring(expected), operation, tostring(received), label))
end

local function explosion(xTestReport, xTestData)
  local result = xTestData.result
  io.write(string.format("%s %s\n", T("( X__X )"), result))
end

local function passedTest(xTestReport, xTestData)
  local runtime__sec = xTestData.executionTimeInSeconds
  io.write(string.format("[ %s ] (%s: %s %s)\n", T("TEST PASSED"), T("RUNTIME"), runtime__sec, T("sec")))
end

local function failedTest(xTestReport, xTestData)
  local runtime__sec = xTestData.executionTimeInSeconds
  io.write(string.format("[ %s ] (%s: %s %s)\n", T("TEST FAILED"), T("RUNTIME"), runtime__sec, T("sec")))
end

local function invalidTest(xTestReport, xTestData)
  io.write(string.format("[ %s ]\n", T("INVALID TEST")))
end

local function summary(xTestReport, xTestData)
  local tests, passes, failures, explosions = xTestData.tests, xTestData.passes, xTestData.failures, xTestData.explosions
  local executionTime__sec, seed = xTestData.executionTimeInSeconds, xTestData.seed
  io.write("\n====================\n")
  if tests == passes and tests > 0 and explosions == 0 then
    io.write(string.format("%s\n", T("PASSED ALL TESTS")))
  else
    io.write(string.format("%s: %s %s\n", T("RAN"), tests, T("TESTS")))
    
    if passes > 0 then
      io.write(string.format("%s: %s\n", T("PASSED"), passes))
    end
    if failures > 0 then
      io.write(string.format("%s: %s\n", T("FAILED"), failures))
    end
    if explosions > 0 then
      io.write(string.format("%s: %s\n", T("EXPLOSIONS"), explosions))
    end
  end
  io.write(string.format("%s: %s %s\n", T("TIME"), executionTime__sec, T("sec")))
  io.write(string.format("%s: %s\n", T("SEED"), seed))
  io.write("====================\n")
end

local function constructor()
  return {
    header = header,
    pass = pass,
    fail = fail,
    explosion = explosion,
    passedTest = passedTest,
    failedTest = failedTest,
    invalidTest = invalidTest,
    summary = summary,
    
    currentTestName = "",
  }
end

return constructor