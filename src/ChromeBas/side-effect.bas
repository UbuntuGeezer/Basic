'// side-effect.bas - test for function side-effects.
'//     8/13/25.    wmk.
'//
'// Notes. var = f(x)
'//  f(x) should always be coded in such a way that 'x' remains unchanged. Some
'// Basic compilers will always ensure this cannot happen; others may not. This
'// program tests whether or not the compiler preserves 'x' across function
'// calls.
'//
'// ChromeBasic allows inum to be re-assigned within test1, but when returning
'// to the caller there is no "side-effect"; any changes have been rescinded on
'// return.
'// test1.bas
'//-----------------------------------------------------------------------------
'// test1 - test for function side-effect on passed parameter.
'//    8/13/25.    wmk.
'//-----------------------------------------------------------------------------
function testside(inum as integer) as String

'// testside - test for function side-effect on passed parameter.
'//
'// Usage.  svar = testside(inum)
'//
'//    inum = integer
'//
'// Exit. svar = "testside complete."
'//
'// Notes. testside reassigns the value of inum to 1 to see if there is a side-effect
'// when returning to the caller.
'//

print "in testside, inum = " & inum
inum = 1
print "in testside, after inum=, inum = " & inum
return "testside complete."
end function    '// end test1
'/**/
'// main.bas
dim intnum as integer
dim iresult as integer
dim sresult as string

iresult=0
intnum = 0
sresult = testside(intnum)
iresult = intnum
print "sresult = " & sresult
print "iresult = " & iresult
'// end main
'/**/'