--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

require "/TestBoots/testboots"

local FailuresOnlyTextTestReport = require "/TestBoots/reports/FailuresOnlyTextTestReport"
addReportType("FAILURES ONLY", FailuresOnlyTextTestReport())
setReportType("FAILURES ONLY")

require "/TestBoots/reports/translate"
setLanguage("ENGLISH")

suite {
  "/TestBoots/tests/testboots_AT",
  "/TestBoots/tests/compare_UT",
  "/TestBoots/tests/API_AT",
  "/TestBoots/tests/spy_on_report_AT",
  "/TestBoots/tests/testboots_followupTests_AT",
  "/TestBoots/tests/testboots_public_UT",
  "/TestBoots/tests/testboots_private_UT",
}