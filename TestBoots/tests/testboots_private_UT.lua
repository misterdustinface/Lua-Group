--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

local testboots = require "/TestBoots/testboots"

local function doesTestListContainTest(xTestList, xTest)
  for i, currentTest in ipairs(xTestList) do
    local containsTest = (currentTest.name == xTest.name) and (currentTest.exec == xTest.exec)
    if containsTest then 
      return true 
    end
  end
  return false
end

function test_gatherTests_expectThisTestIncluded(xSys)
  local thisTest = {
    name = "test_gatherTests_expectThisTestIncluded",
    exec = test_gatherTests_expectThisTestIncluded,
  }
  local testlist = xSys.gatherTests()
  local containsThisTest = doesTestListContainTest(testlist, thisTest)
  
  expectEQ(true, containsThisTest, "The gathered tests of testboots contains this test" )
end

function test_shuffleTests_expectShufflesSomeList(xSys)
  local originalSeed = testboots.data.seed
  
  local original  = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M"}
  local toShuffle = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M"}
  setSeed(1)
  xSys.shuffleTests(toShuffle)
  expectNE(original, toShuffle, "List is Shuffled with seed 1" )
  
  original  = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M"}
  toShuffle = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M"}
  setSeed(2)
  xSys.shuffleTests(toShuffle)
  expectNE(original, toShuffle, "List is Shuffled with seed 2" )
  
  setSeed(originalSeed)
end

function test_onTestbootsGarbageCollectionFunc_expectIsExpectedFunction(xSys)
  local onTestbootsGarbageCollectionFunc
  
  if _VERSION >= "Lua 5.2" then
    onTestbootsGarbageCollectionFunc = getmetatable(testboots).__gc
  else
    onTestbootsGarbageCollectionFunc = getmetatable(testboots.sentinel).__gc
  end
  
  expectEQ(xSys.gather_shuffle_thenExecuteTestsAndReportSummarizedResults, 
           onTestbootsGarbageCollectionFunc, 
           "The testboots garbage collection function is the function it is expected to be.")
end