'// test comment
'// Test.bas
'// ----------------------------------------------------------------------------
'// Test - initial test function for Basic coding.
'//     8/10/25.    wmk.
'//-----------------------------------------------------------------------------
FUNCTION TEST(I AS INTEGER) AS INTEGER

'// Test - initial test function for Basic coding.
'//     8/10/25.    wmk.
'//
'// Usage.  ivar = TEST(i)
'//
'//     i = any nteger value
'//
'// Exit.   ivar = i
'//

 PRINT I
 RETURN 0
END FUNCTION
'/**/

'// myMOD.bas
'// ----------------------------------------------------------------------------
'// myMOD - localized MOD function.
'//     8/10/25.    wmk.
'//-----------------------------------------------------------------------------
function myMOD(N AS INTEGER, B AS INTEGER) AS INTEGER

'// myMOD - localized MOD function.
'//     8/10/25.    wmk.
'//
'// Usage.  ivar = myMOD(n, b)
'//
'//     n = any nteger value (number)
'//     b = any integer value (base)
'//
'// Exit.   ivar = n MOD b
'//

'// local variables.
DIM RESULT AS INTEGER
DIM FRACT AS SINGLE
DIM IPROD AS INTEGER
DIM IWHOLE AS INTEGER

'// code
ON ERROR GOTO ErrHandler
FRACT = N/B
IWHOLE = INT(FRACT)
RESULT = N - IWHOLE * B
RETURN RESULT

ErrHandler:
print " in myMOD - unprocessed error."
return -1
END FUNCTION    '// end myMOD
'/**/
'// pi.bas
'// ----------------------------------------------------------------------------
'// pi - calculate pi with series sum..
'//     8/10/25.    wmk.
'//-----------------------------------------------------------------------------
function pi(icount as single) as double

'// pi - calculate pi with series sum..
'//     8/10/25.    wmk.
'//
'// Usage.  fvar = pi(itcount)
'//
'//     itcount = iteration count for series
'//
'// Exit.   ivar = pi calculated with Euler's series
'//     executed sum to itcount iterations
'//
'//Note. it takes ~400,000 iterations to attain 3.14159..

'// local variables.
 DIM result    as double    '// calculated result
 DIM fi        as single    '// loop counter
 DIM fcounter  as single
 DIM fmult     as double
 dim thispart  as double
 
 '// code.
 ON ERROR GOTO ErrorHandler

 '// calculate series 1 -1/3 +1/5 - 1/7 +... icount iterations
 result = 1.
 fcounter = 1
 while fcounter < icount
  if (myMOD(fcounter,2) = 1) then
   fmult = -1
  else
   fmult = 1
  endif
  thispart = fmult*1/((fcounter*2)+1)
  'print "in pi, this part = ", thispart
  result = result + thispart
  fcounter = fcounter + 1
 wend
 return result * 4
 exit function

ErrorHandler:
 return -1
end function    '// end pi
'/**/
'// Main program
DIM I AS INTEGER
DIM J AS INTEGER
dim nit AS SINGLE

'J = myMOD(14,2)
'PRINT "MOD 14,2 IS ", J
nit = 400000
print "pi (Euler's series) " & nit & " iterations = ",pi(nit)
FOR I = 1 TO 100
'PRINT I
NEXT I
END
