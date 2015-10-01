--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

require '/TestBoots/testboots'
local compare = require '/TestBoots/internal/compare'

function test_absentComparators_expectElegantFailure()
  local absentComparators = { '!', '#', '%', '@', '*', '+', '-', '=', '/', '..', '~', ',' }
  local expected = false
  for i = 1, #absentComparators do
    local received = compare(1, absentComparators[i], 1)
    expectEQ(expected, received, "Absent Operator comparisons return false")
  end
end

function test_compareEqualityOfValueToSelf_expectTrue()
  local values = { 1, 'string', function() end, {}, 0.01 }
  local expected = true
  for i = 1, #values do
    local received = compare(values[i], '==', values[i])
    expectEQ(expected, received, "Self Equality Comparison is True")
  end
end

function test_compareEqualityToValueOfDifferentType_expectFalse()
  local values = { 1, 'string', function() end, {}, 0.01 }
  local valsOfDifferentType = { 'string', 1, 0.01, function() end, {} }
  local expected = false
  for i = 1, #values do
    local received = compare(values[i], '==', valsOfDifferentType[i])
    expectEQ(expected, received, "Differing Type equality is False")
  end
end

function test_compareTableEqualityOnTablesWithMatchingEntries_expectTrue()
  local A = { first = '1', second = 2, third = {}, "testing" }
  local B = { first = '1', second = 2, third = {}, "testing" }  
  local expected = true
  local received = compare(A, '==', B)
  expectEQ(expected, received, "Equality of Tables with matching entries True")
end

function test_compareTableEqualityOnTablesWithMismatchedEntries_expectFalse()
  local A = { first = '1', second = 2, third = {}, "testing" }
  local B = { first = '2', second = 3, third = { 1 }, "incorrect" }  
  local expected = false
  local received = compare(A, '==', B)
  expectEQ(expected, received, "Equality of Tables with mismatched entries False")
end

function test_comparators_expectPermutationsThatReturnTrueForEachComparatorType()
  local truthfulComparisons = {
    ['=='] = { 1, 1 },
    ['~='] = { 1, 2 },
    ['<']  = { 1, 2 },
    ['<='] = { 1, 2 },
    ['>']  = { 2, 1 },
    ['>='] = { 2, 1 },
  }
  local expected = true
  for k,v in pairs(truthfulComparisons) do
    local received = compare(v[1], k, v[2])
    expectEQ(expected, received, "Truthful Comparisons are True")
  end
end