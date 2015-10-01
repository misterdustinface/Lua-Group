--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

local function header(xTestReport, xTestData)
  xTestReport.wasCalled["header"] = true
  xTestReport.headerTestData = xTestData
end

local function pass(xTestReport, xTestData)
  xTestReport.wasCalled["pass"] = true
  xTestReport.passEvalData = xTestData
end

local function fail(xTestReport, xTestData)
  xTestReport.wasCalled["fail"] = true
  xTestReport.failEvalData = xTestData
end

local function explosion(xTestReport, xTestData)
  xTestReport.wasCalled["explosion"] = true
  xTestReport.explosionData = xTestData
end

local function passedTest(xTestReport, xTestData)
   xTestReport.wasCalled["passedTest"] = true
   xTestReport.passedTestData = xTestData
end

local function failedTest(xTestReport, xTestData)
  xTestReport.wasCalled["failedTest"] = true
  xTestReport.failedTestData = xTestData
end

local function invalidTest(xTestReport, xTestData)
  xTestReport.wasCalled["invalidTest"] = true
end

local function summary(xTestReport, xTestData)
  xTestReport.wasCalled["summary"] = true
  xTestReport.summaryData = xTestData
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
    
    wasCalled = {
      header = false,
      pass = false,
      fail = false,
      explosion = false,
      passedTest = false,
      failedTest = false,
      invalidTest = false,
      summary = false,
    },
    
    headerTestData = {},
    passEvalData = {},
    failEvalData = {},
    explosionData = {},
    summaryData = {},
    passedTestData = {},
    failedTestData = {},
  }
end

return constructor