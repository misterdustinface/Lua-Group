--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

local function reportPass(xTestReporter, xTestData)
  xTestReporter.currentReportBuilder:pass(xTestData)
end

local function reportFail(xTestReporter, xTestData)
  xTestReporter.currentReportBuilder:fail(xTestData)
end

local function reportHeader(xTestReporter, xTestData)
  xTestReporter.currentReportBuilder:header(xTestData)
end

local function reportExplosion(xTestReporter, xTestData)
  xTestReporter.currentReportBuilder:explosion(xTestData)
end

local function reportSummary(xTestReporter, xTestData)
  xTestReporter.currentReportBuilder:summary(xTestData)
end

local function reportPassedTest(xTestReporter, xTestData)
  xTestReporter.currentReportBuilder:passedTest(xTestData)
end

local function reportFailedTest(xTestReporter, xTestData)
  xTestReporter.currentReportBuilder:failedTest(xTestData)
end

local function reportInvalidTest(xTestReporter, xTestData)
  xTestReporter.currentReportBuilder:invalidTest(xTestData)
end

local function addReportType(xTestReporter, xType, xReportBuilder)
  xTestReporter.reportBuilders[xType] = xReportBuilder
end

local function setReportType(xTestReporter, xType)
  xTestReporter.previousReportBuilder = xTestReporter.currentReportBuilder
  xTestReporter.currentReportBuilder = xTestReporter.reportBuilders[xType]
end

local function restorePreviousReportType(xTestReporter)
  xTestReporter.currentReportBuilder = xTestReporter.previousReportBuilder
end

local function constructor()
  return {
    reportBuilders = {},
    currentReportBuilder = nil,
    previousReportBuilder = nil,
    addReportType = addReportType,
    setReportType = setReportType,
    restorePreviousReportType = restorePreviousReportType,

    reportPass = reportPass,
    reportFail = reportFail,
    reportHeader = reportHeader,
    reportExplosion = reportExplosion,
    reportSummary = reportSummary,
    reportPassedTest = reportPassedTest,
    reportFailedTest = reportFailedTest,
    reportInvalidTest = reportInvalidTest,
  }
end

return constructor