sentence --> noun_phrase, verb_phrase.

noun_phrase --> determiner, noun.

verb_phrase --> verb, noun_phrase.
verb_phrase --> verb.

determiner --> ["the"].

noun --> ["man"].
noun --> ["apple"].

verb --> ["eats"]. 
verb --> ["sings"]. 


?-
  add_rules,
  % read(String, "Give me a sentence: ", s), 
  makeList("the man eats the apple", L, 0), % String
  phrase(sentence,T,L),
  write(T),
  nl, nl,
  pretty_print(T),
  nl, nl.

include("Grammar Rules").
