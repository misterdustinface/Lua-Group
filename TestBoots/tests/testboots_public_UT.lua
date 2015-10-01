--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

local testboots = require "/TestBoots/testboots"

function test_callSuiteWithListOfFiles_expectRequireOfEachFileInList()
  local list = { "/TestBoots/tests/testboots_public_UT_SupportFile_introduceGlobalVariableQQQsetToTrue" }
  expectEQ(nil, QQQ, "QQQ is nil")
  suite(list)
  expectEQ(true, QQQ, "QQQ is true")
end

function test_setSeed_expectChangesTestbootsSeed()
  local originalSeed = testboots.data.seed
  
  local expectedSeed = 1234
  setSeed(expectedSeed)
  expectEQ(expectedSeed, testboots.data.seed, "Seed should be set to 1234")
  
  testboots.data.seed = originalSeed
end
