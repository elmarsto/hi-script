


when put  glob:/* ? foo=|string|  & bar=|integer|
	|<>| -- this iterator will print one line of the put document to stdout every time it is run
end

	
when put  glob:/* ? foo=|string|  & bar=|integer|
	
	<< |<>| -- buffer putted document on stack as an array element
	
	|_ @/fun/scrambler ? 'reverse'| -- top of stack is now an iterator 

end	
-- n.b. remember that literals are just thunks that reproduce themselves when thunked. e.g. '1' is a thunk that returns 1. 
-- this also means that e.g. 1 == |1| == ||1|| ....
-- TODO explore consequences


--OMG look what I'm doing with 'put' here. TODO think about it. 'put' is an iterator

when put@path:/qux ? foo=|string|  & bar=|integer|
	
	|<| put thunk on top of the stack that always returns the next line. 
	
 	-- |@reverse| -- map 'reverse' over the iterator on the stack
end

--in addition, 'when' and 'end' are just synonyms for '|'
--for convenience, instead of the above (omitting arguments for clarity):
--match literals, such as path:/qux/, are compiled to filters that iterate over matches.
--put, get, delete, and post are themselves iterators over the request object
--it seems crazy to apply an iterator to an iterator, but it makes perfect sense when you remember
--that an array is just an applied iterator. 


|put@filterfunc!;|<|@reverse||


-- I think the ! can be dropped from the spec; let the line delimiter or the alternative line delimiter (;) close the call and stand for 'force' 

-- consequences to think about: mentioning a function now calls it. 

|put@filterfunc!;|<|@reverse||


Change the | to () for readability? TODO?


(put@filterfunc; (< | @reverse))
