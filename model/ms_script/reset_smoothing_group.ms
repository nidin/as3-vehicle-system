for n in selection as array where isKindof n Editable_Poly do
(
	n.selectedfaces = #{1..n.numfaces}
	n.setSmoothingGroups 1 -1 1
)