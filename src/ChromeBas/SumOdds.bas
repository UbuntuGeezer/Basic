'// SumOdds.bas
'// ----------------------------------------------------------------------------
'// SummOdds - compute sum of first n odd numbers.
'//     8/17/25.    wmk.
'//-----------------------------------------------------------------------------
FUNCTION SumOdds(I AS INTEGER) AS INTEGER

'// SummOdds - compute sum of first n odd numbers.
'//     8/17/25.    wmk.
'//
'// Usage.  isum = SumOdds(i)
'//
'//     i = any integer value
'//
'// Exit.   ivar = sum of first 'i' odd numbers.
'//


 RETURN i^2
END FUNCTION
'/**/

'// Main program
dim nodds    As Integer
input nodds
print "Sum of first " & nodds & " odd numbers is " & SumOdds(nodds)
'//END
