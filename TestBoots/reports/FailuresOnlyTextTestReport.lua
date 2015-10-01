--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

require "/TestBoots/reports/translate"

local function createLine(xPattern, xReps)
  local line = {}
  for i = 1, xReps do
    table.insert(line, xPattern)
  end
  return table.concat(line, '')
end

local function header(xTestReport, xTestData)
  local title = xTestData.title
  io.write(string.format("  %s:  %s\n", T("TEST"), title))
  xTestReport.currentTestName = title
end

local function pass(xTestReport, xTestData)
  
end

local function fail(xTestReport, xTestData)
  local label, expected, operation, received = xTestData.label, xTestData.expected, xTestData.operation, xTestData.received
  io.write(string.format("(%6s) %20s %23s %80s\n", T("RESULT"), T("EXPECTED"), T("RECEIVED"), T("LABEL")))
  io.write(string.format("[ %4s ] %20s %s %20s %80s\n", T("FAIL"), tostring(expected), operation, tostring(received), label))
end

local function explosion(xTestReport, xTestData)
  local result = xTestData.result
  io.write(string.format("%s %s\n", T("( X__X )"), result))
end

local function passedTest(xTestReport, xTestData)
  
end

local function failedTest(xTestReport, xTestData)
  io.write(string.format("[ %s ]\n", T("TEST FAILED")))
end

local function invalidTest(xTestReport, xTestData)
  io.write(string.format("[ %s ]\n", T("INVALID TEST")))
end

local function summary(xTestReport, xTestData)
  local tests, passes, failures, explosions = xTestData.tests, xTestData.passes, xTestData.failures, xTestData.explosions
  local executionTime__sec, seed = xTestData.executionTimeInSeconds, xTestData.seed
  
  local passed = string.format("%s: %s / %s\n", T("PASSED"), passes, tests)
  local time   = string.format("%s: %s %s\n", T("TIME"), executionTime__sec, T("sec"))
  local seed   = string.format("%s: %s\n", T("SEED"), seed)
  local longestString = math.max(string.len(passed), string.len(time), string.len(seed))
  local line = createLine("=", longestString)
  
  io.write(string.format("%s\n", line))
  io.write(passed)
  io.write(time)
  io.write(seed)
  io.write(string.format("%s\n", line))
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