'// magee.bas
'//----------------------------------------------
'//	magee.bas - iteratively calculate e.
'//		wmk.	8/5/25.
'//----------------------------------------------
public function magee(icount as Single) As Double

'// magee - iteratively calculate e.
'//		8/5/25.	wmk.
'//
'// Usage.	evar = magee(iterations)
'//
'//		iterations = integer count of iterations for series sum
'//
'// Exit.	evar = 'e' calculated using Euler's series run 'iterations' terms
'//
'// Note. To approximate pi to 4 places requires about 300000 iterations.
'//

dim result	as Double
dim i 		As Single
dim fact 	as Double
dim j 		as Single

result = 0.

'// loop calculating 1^i/i! and adding to accumulated sum.
for i = 0 to icount
 fact = 1.
 for j = i to 1 step -1
  fact=fact*j
 next j
 result = result + 1^i/fact
next i

magee = result
end function '// end magee
'/**/
'// main.bas
dim e    as Double
dim icount    As single

icount = 30.
e = magee(icount)
print "e (" & icount & " iterations) = " & e
'// end main