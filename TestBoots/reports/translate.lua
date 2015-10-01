--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

LANGUAGE = "ENGLISH"

local translations = {
  ["X"] = {
    ["TEST"] = "X",
    ["RESULT"] = "X", 
    ["EXPECTED"] = "X", 
    ["OPERATION"] = "X", 
    ["RECEIVED"] = "X", 
    ["LABEL"] = "X",
    ["PASS"] = "X",
    ["FAIL"] = "X",
    ["PASSED ALL TESTS"] = "X",
    ["RAN"] = "X",
    ["TESTS"] = "X",
    ["PASSED"] = "X",
    ["FAILED"] = "X",
    ["EXPLOSIONS"] = "X",
    ["TIME"] = "X",
    ["sec"] = "X",
    ["SEED"] = "X",
    ["TEST PASSED"] = "X",
    ["TEST FAILED"] = "X",
    ["INVALID TEST"] = "X",
    ["( X__X )"] = "( X__X )",
  },
  
  ["FRENCH"] = {
    ["TEST"] = "test",
    ["RESULT"] = "résultat", 
    ["EXPECTED"] = "attendu", 
    ["OPERATION"] = "opération", 
    ["RECEIVED"] = "reçu", 
    ["LABEL"] = "étiquette",
    ["PASS"] = "moyenne",
    ["FAIL"] = "manquer",
    ["PASSED ALL TESTS"] = "passé tous les tests",
    ["RAN"] = "courut",
    ["TESTS"] = "essais",
    ["PASSED"] = "passé",
    ["FAILED"] = "échoué",
    ["EXPLOSIONS"] = "explosions",
    ["TIME"] = "temps d'exécution",
    ["sec"] = "secondes",
    ["SEED"] = "graine",
    ["TEST PASSED"] = "test réussi",
    ["TEST FAILED"] = "test a échoué",
    ["INVALID TEST"] = "essai non valide",
    ["( X__X )"] = "( X__X )",
  }
}

function setLanguage(xLang)
  if translations[xLang] then
    LANGUAGE = xLang
  end
end

function T(xString)
  local translation
  if LANGUAGE == "ENGLISH" then
    translation = xString
  else
    translation = translations[LANGUAGE][xString] or xString
  end
  return translation
end