'// magpi.bas
'//----------------------------------------------
'// magpi - iteratively calculate pi.
'//		8/5/25.	wmk.
'//----------------------------------------------
public function magpi(icount as Single) As Double

dim result As Double
dim i as Single

result = 0.

for i = 0 to icount
 result = result + (-1)^i/(2*i+1) 
next i

magpi = 4*result
end function '// end magpi
'/**/
'// Main.bas

dim iterations  As Single
dim piresult    As Double

iterations = 300000
piresult = magpi(iterations)
print "pi (" & iterations & ") = " & piresult

'// end Main