' ----------------------------------------------
' Script Recorded by ANSYS Electronics Desktop Version 2018.0.0
' 12:49:52  Sep 03, 2019
' ----------------------------------------------
Dim oAnsoftApp
Dim oDesktop
Dim oProject
Dim oDesign
Dim oEditor
Dim oModule

' Get a reference to the Electronics Desktop program
Set oAnsoftApp = CreateObject("Ansoft.ElectronicsDesktop")
Set oDesktop = oAnsoftApp.GetAppDesktop()

' Create a new project called "metasurface" and get a reference to it
oDesktop.NewProject "metasurface"
Set oProject = oDesktop.GetActiveProject

' Insert a new HFSS design called "Top_Trace" and get a reference to it
oProject.InsertDesign "HFSS", "Top_Trace", "DrivenModal", ""
Set oDesign = oProject.SetActiveDesign("Top_Trace")

' -------------------- Set project parameters ---------------------------
' D:			5.0736	mm
' Ltop1:		3	mm
' Wtop1:		1.799	mm
' Lmid1:		3	mm
' Wmid1:		0.477	mm
' Lbot1:		3	mm
' Wbot1:		3.388	mm
' Substrate_Thickness	2.54	mm
' Trace_Width		0.2	mm
' f			10	GHz
' lambda		c0/f	m	0.029979245 @ 10GHz
' 

oProject.ChangeProperty Array("NAME:AllTabs",_
	Array("NAME:ProjectVariableTab",_
		Array("NAME:PropServers", "ProjectVariables"),_
			Array("NAME:NewProps",_
				Array("NAME:$D",_
					"PropType:=", "VariableProp",_
					"Value:=", "5.0736mm",_
					"Description:=", "Length of a unit cell"))))

oProject.ChangeProperty Array("NAME:AllTabs",_
	Array("NAME:ProjectVariableTab",_
		Array("NAME:PropServers", "ProjectVariables"),_
			Array("NAME:NewProps",_
				Array("NAME:$Substrate_Thickness",_
					"PropType:=", "VariableProp",_
					"Value:=", "2.54mm",_
					"Description:=", "Thickness of the substrate."))))

oProject.ChangeProperty Array("NAME:AllTabs",_
	Array("NAME:ProjectVariableTab",_
		Array("NAME:PropServers", "ProjectVariables"),_
			Array("NAME:NewProps",_
				Array("NAME:$Trace_Width",_
					"PropType:=", "VariableProp",_
					"Value:=", "0.2mm",_
					"Description:=", "Width of trace."))))

oProject.ChangeProperty Array("NAME:AllTabs",_
	Array("NAME:ProjectVariableTab",_
		Array("NAME:PropServers", "ProjectVariables"),_
			Array("NAME:NewProps",_
				Array("NAME:$Ltop1",_
					"PropType:=", "VariableProp",_
					"Value:=", "3mm",_
					"Description:=", "?"))))

oProject.ChangeProperty Array("NAME:AllTabs",_
	Array("NAME:ProjectVariableTab",_
		Array("NAME:PropServers", "ProjectVariables"),_
			Array("NAME:NewProps",_
				Array("NAME:$Wtop1",_
					"PropType:=", "VariableProp",_
					"Value:=", "1.799mm",_
					"Description:=", "?"))))

oProject.ChangeProperty Array("NAME:AllTabs",_
	Array("NAME:ProjectVariableTab",_
		Array("NAME:PropServers", "ProjectVariables"),_
			Array("NAME:NewProps",_
				Array("NAME:$lambda",_
					"PropType:=", "VariableProp",_
                    "Value:=", "0.029979245m",_
					"Description:=", "?"))))

' Define a new custom material called "Simple_Dielectric"
Set oDefinitionManager = oProject.GetDefinitionManager()
oDefinitionManager.AddMaterial Array("NAME:Simple_Dielectric")

' Get a reference to the 3D Model Editor so we can build a model
Set oEditor = oDesign.SetActiveEditor("3D Modeler")

' Create the bottom substrate layer (Box1)
oEditor.CreateBox Array("NAME:BoxParameters",_
		"XPosition:=", "0.8mm", "YPosition:=", "0.6mm", "ZPosition:=", "0mm", _
		"XSize:=", "-1.2mm", "YSize:=", "-1mm", "ZSize:=", "0.4mm"), _
	Array("NAME:Attributes", _
		"Name:=", "Box1", "Flags:=", "", "Color:=", "(143 175 143)", _
		"Transparency:=", 0, "PartCoordinateSystem:=", "Global", _
		"UDMId:=", "", "MaterialValue:=", Chr(34) & "vacuum" & Chr(34) , _
		"SurfaceMaterialValue:=", Chr(34) & "" & Chr(34), "SolveInside:=", true, _
		"IsMaterialEditable:=", true, "UseMaterialAppearance:=", false)

' Adjust the position and size of the bottom substrate layer (Box1)
oEditor.ChangeProperty Array("NAME:AllTabs", _
		Array("NAME:Geometry3DCmdTab", _
			Array("NAME:PropServers", "Box1:CreateBox:1"), _
			Array("NAME:ChangedProps", Array("NAME:Position", _
					"X:=", "-$D/2", "Y:=", "-$D/2", "Z:=", "-$Substrate_Thickness"), _
				Array("NAME:XSize", "Value:=", "$D"), _
				Array("NAME:YSize", "Value:=", "$D"), _
				Array("NAME:ZSize", "Value:=", "$Substrate_Thickness"))))

' Create the top substrate layer (Box2)
oEditor.CreateBox Array("NAME:BoxParameters", _
		"XPosition:=", "1mm", "YPosition:=", "-3.5mm", "ZPosition:=", "0mm", _
		"XSize:=", "-5mm", "YSize:=", "-2mm", "ZSize:=", "-12mm"), _
	Array("NAME:Attributes", _
		"Name:=", "Box2", "Flags:=", "", "Color:=", "(143 175 143)", _
		"Transparency:=", 0, "PartCoordinateSystem:=", "Global", _
		"UDMId:=", "", "MaterialValue:=", Chr(34) & "vacuum" & Chr(34), _
		"SurfaceMaterialValue:=", Chr(34) & "" & Chr(34), "SolveInside:=", true, _
		"IsMaterialEditable:=", true, "UseMaterialAppearance:=", false)

' Adjust the position and size of the top substrate layer (Box2)
oEditor.ChangeProperty Array("NAME:AllTabs", _
		Array("NAME:Geometry3DCmdTab", _
			Array("NAME:PropServers", "Box2:CreateBox:1"), _
			Array("NAME:ChangedProps", Array("NAME:Position", _
				"X:=", "-$D/2", "Y:=", "-$D/2", "Z:=", "0mm"), _
			Array("NAME:XSize", "Value:=", "$D"), _
			Array("NAME:YSize", "Value:=", "$D"), _
			Array("NAME:ZSize", "Value:=", "$Substrate_Thickness"))))

' Assign the material "Simple_Dielectric" to Box1
oEditor.AssignMaterial Array("NAME:Selections", _
		"AllowRegionDependentPartSelectionForPMLCreation:=", true, _
		"AllowRegionSelectionForPMLCreation:=", true, "Selections:=", "Box1"), _
	Array("NAME:Attributes", _
		"MaterialValue:=", Chr(34) & "Simple_Dielectric" & Chr(34), "SolveInside:=", true, _
		"IsMaterialEditable:=", true, "UseMaterialAppearance:=", false)

' Assign the material "Simple_Dielectric" to Box2
oEditor.AssignMaterial Array("NAME:Selections", _
		"AllowRegionDependentPartSelectionForPMLCreation:=", true, _
		"AllowRegionSelectionForPMLCreation:=", true, "Selections:=", "Box2"), _
Array("NAME:Attributes", _
		"MaterialValue:=", Chr(34) & "Simple_Dielectric" & Chr(34), "SolveInside:=", true, _
		"IsMaterialEditable:=", true, "UseMaterialAppearance:=", false)

' Make Box1 transparent
oEditor.ChangeProperty Array("NAME:AllTabs", _
		Array("NAME:Geometry3DAttributeTab", _
			Array("NAME:PropServers", "Box1"), _
			Array("NAME:ChangedProps", Array("NAME:Transparent", "Value:=", 0.7))))

' Make Box2 transparent
oEditor.ChangeProperty Array("NAME:AllTabs", _
		Array("NAME:Geometry3DAttributeTab", _
			Array("NAME:PropServers", "Box2"), _
			Array("NAME:ChangedProps", Array("NAME:Transparent", "Value:=", 0.7))))

' 
oEditor.CreatePolyline Array("NAME:PolylineParameters", _
		"IsPolylineCovered:=", true, "IsPolylineClosed:=", false, _
		Array("NAME:PolylinePoints", _
			Array("NAME:PLPoint", "X:=", "-5.5mm", "Y:=", "0.5mm", "Z:=", "0mm"), _
			Array("NAME:PLPoint", "X:=", "-8.5mm", "Y:=", "0.5mm", "Z:=", "0mm")), _
		Array("NAME:PolylineSegments", _
			Array("NAME:PLSegment", "SegmentType:=", "Line", "StartIndex:=", 0, "NoOfPoints:=", 2)), _
		Array("NAME:PolylineXSection", _
			"XSectionType:=", "None", "XSectionOrient:=", "Auto", "XSectionWidth:=", "0mm", _
			"XSectionTopWidth:=", "0mm", "XSectionHeight:=", "0mm", "XSectionNumSegments:=", "0", _
			"XSectionBendType:=", "Corner")), _
		Array("NAME:Attributes", _
			"Name:=", "Polyline1", "Flags:=", "", "Color:=", "(143 175 143)", _
			"Transparency:=", 0, "PartCoordinateSystem:=", "Global", "UDMId:=", "", _
			"MaterialValue:=", Chr(34) & "vacuum" & Chr(34), _
			"SurfaceMaterialValue:=", Chr(34) & "" & Chr(34), "SolveInside:=", true, _
			"IsMaterialEditable:=", true, "UseMaterialAppearance:=", false)

' 
oEditor.CreatePolyline Array("NAME:PolylineParameters", _
		"IsPolylineCovered:=", true, "IsPolylineClosed:=", false, _
		Array("NAME:PolylinePoints", _
			Array("NAME:PLPoint", "X:=", "-6.5mm", "Y:=",  "0.0mm", "Z:=", "0mm"), _
			Array("NAME:PLPoint", "X:=", "-7.0mm", "Y:=", "-1.5mm", "Z:=", "0mm")), _
Array("NAME:PolylineSegments", _
			Array("NAME:PLSegment", "SegmentType:=", "Line", "StartIndex:=", 0, "NoOfPoints:=", 2)), _
		Array("NAME:PolylineXSection", _
			"XSectionType:=", "None", "XSectionOrient:=", "Auto", "XSectionWidth:=", "0mm", _
			"XSectionTopWidth:=", "0mm", "XSectionHeight:=", "0mm", "XSectionNumSegments:=", "0", _
			"XSectionBendType:=", "Corner")), _
		Array("NAME:Attributes", _
			"Name:=", "Polyline2", "Flags:=", "", "Color:=", "(143 175 143)", _
			"Transparency:=", 0, "PartCoordinateSystem:=", "Global", "UDMId:=", "", _
			"MaterialValue:=", Chr(34) & "vacuum" & Chr(34), _
			"SurfaceMaterialValue:=", Chr(34) & "" & Chr(34), "SolveInside:=", true, _
			"IsMaterialEditable:=", true, "UseMaterialAppearance:=", false)

' 
oEditor.CreatePolyline Array("NAME:PolylineParameters", _
		"IsPolylineCovered:=", true, "IsPolylineClosed:=", false, _
		Array("NAME:PolylinePoints", _
			Array("NAME:PLPoint", "X:=", "-7.5mm", "Y:=", "-2.5mm", "Z:=", "0mm"), _
			Array("NAME:PLPoint", "X:=", "-5.0mm", "Y:=", "-2.0mm", "Z:=", "0mm")), _
		Array("NAME:PolylineSegments", _
			Array("NAME:PLSegment", "SegmentType:=", "Line", "StartIndex:=", 0, "NoOfPoints:=", 2)), _
		Array("NAME:PolylineXSection", _
			"XSectionType:=", "None", "XSectionOrient:=", "Auto", "XSectionWidth:=", "0mm", _
			"XSectionTopWidth:=", "0mm", "XSectionHeight:=", "0mm", "XSectionNumSegments:=", "0", _
			"XSectionBendType:=", "Corner")), _
		Array("NAME:Attributes", _
			"Name:=", "Polyline3", "Flags:=", "", "Color:=", "(143 175 143)", _
			"Transparency:=", 0, "PartCoordinateSystem:=", "Global", "UDMId:=", "", _
			"MaterialValue:=", Chr(34) & "vacuum" & Chr(34), _
			"SurfaceMaterialValue:=", Chr(34) & "" & Chr(34), "SolveInside:=", true, _
			"IsMaterialEditable:=", true, "UseMaterialAppearance:=", false)

' Move point 1 of Polyline1
oEditor.ChangeProperty Array("NAME:AllTabs", _
		Array("NAME:Geometry3DPolylineTab", _
			Array("NAME:PropServers", "Polyline1:CreatePolyline:2:Segment0"), _
			Array("NAME:ChangedProps", _
				Array("NAME:Point1", _
					"X:=", "0mm", _
					"Y:=", "($Ltop1/2) - $Trace_Width", _
					"Z:=", "$Substrate_Thickness"))))
' Move point 2 of Polyline1
oEditor.ChangeProperty Array("NAME:AllTabs", _
		Array("NAME:Geometry3DPolylineTab", _
			Array("NAME:PropServers", "Polyline1:CreatePolyline:2:Segment0"), _
			Array("NAME:ChangedProps", _
				Array("NAME:Point2", _
					"X:=", "0mm", _
					"Y:=", "(-$Ltop1/2) + $Trace_Width", _
					"Z:=", "$Substrate_Thickness"))))

' Move point 1 of Polyline2
oEditor.ChangeProperty Array("NAME:AllTabs", _
		Array("NAME:Geometry3DPolylineTab", _
			Array("NAME:PropServers", "Polyline2:CreatePolyline:2:Segment0"), _
			Array("NAME:ChangedProps", _
				Array("NAME:Point1", _
					"X:=", "-$Wtop1/2", _
					"Y:=", "-$Ltop1/2 + ($Trace_Width/2)", _
					"Z:=", "$Substrate_Thickness"))))

' Move point 2 of Polyline2
oEditor.ChangeProperty Array("NAME:AllTabs", _
		Array("NAME:Geometry3DPolylineTab", _
			Array("NAME:PropServers", "Polyline2:CreatePolyline:2:Segment0"), _
			Array("NAME:ChangedProps", _
				Array("NAME:Point2", _
					"X:=", "$Wtop1/2", _
					"Y:=", "-$Ltop1/2 + ($Trace_Width/2)", _
					"Z:=", "$Substrate_Thickness"))))

' Move point 1 of Polyline3
oEditor.ChangeProperty Array("NAME:AllTabs", _
		Array("NAME:Geometry3DPolylineTab", _
			Array("NAME:PropServers", "Polyline3:CreatePolyline:2:Segment0"), _
			Array("NAME:ChangedProps", _
				Array("NAME:Point1", _
					"X:=", "-$Wtop1/2", _
					"Y:=", "$Ltop1/2 - ($Trace_Width/2)", _
					"Z:=", "$Substrate_Thickness"))))
' Move point 2 of Polyline3
oEditor.ChangeProperty Array("NAME:AllTabs", _
		Array("NAME:Geometry3DPolylineTab", _
			Array("NAME:PropServers", "Polyline3:CreatePolyline:2:Segment0"), _
			Array("NAME:ChangedProps", _
				Array("NAME:Point2", _
					"X:=", "$Wtop1/2", _
					"Y:=", "$Ltop1/2 - ($Trace_Width/2)", _
					"Z:=", "$Substrate_Thickness"))))

' Change the type of Polyline1 to "Line"
oEditor.ChangeProperty Array("NAME:AllTabs", _
		Array("NAME:Geometry3DCmdTab", _
			Array("NAME:PropServers", "Polyline1:CreatePolyline:1"), _
			Array("NAME:ChangedProps", Array("NAME:Type", "Value:=", "Line"))))

' Change the type of Polyline2 to "Line"
oEditor.ChangeProperty Array("NAME:AllTabs", _
		Array("NAME:Geometry3DCmdTab", _
			Array("NAME:PropServers", "Polyline2:CreatePolyline:1"), _
			Array("NAME:ChangedProps", Array("NAME:Type", "Value:=", "Line"))))

' Change type of Polyline3 to "Line"
oEditor.ChangeProperty Array("NAME:AllTabs", _
		Array("NAME:Geometry3DCmdTab", _
			Array("NAME:PropServers", "Polyline3:CreatePolyline:1"), _
			Array("NAME:ChangedProps", Array("NAME:Type", "Value:=", "Line"))))

' Set the width of Polyline1 to Trace_Width
oEditor.ChangeProperty Array("NAME:AllTabs", _
		Array("NAME:Geometry3DCmdTab", _
			Array("NAME:PropServers", "Polyline1:CreatePolyline:1"), _
			Array("NAME:ChangedProps", Array("NAME:Width/Diameter", "Value:=", "$Trace_Width"))))


' Set the width of Polyline2 to Trace_Width
oEditor.ChangeProperty Array("NAME:AllTabs", _
		Array("NAME:Geometry3DCmdTab", _
			Array("NAME:PropServers", "Polyline2:CreatePolyline:1"), _
			Array("NAME:ChangedProps", Array("NAME:Width/Diameter", "Value:=", "$Trace_Width"))))

' Set the width of Polyline3 to Trace_Width
oEditor.ChangeProperty Array("NAME:AllTabs", Array("NAME:Geometry3DCmdTab", _
			Array("NAME:PropServers", "Polyline3:CreatePolyline:1"), _
			Array("NAME:ChangedProps", Array("NAME:Width/Diameter", "Value:=", "$Trace_Width"))))

' Group the 3 polylines into a single shape (called Polyline1) and remove the seperate polylines
oEditor.Unite Array("NAME:Selections", "Selections:=", "Polyline1,Polyline2,Polyline3"), _
		Array("NAME:UniteParameters", "KeepOriginals:=", false)

Set oModule = oDesign.GetModule("BoundarySetup")

' ???? What is PerfectE
oModule.AssignPerfectE Array("NAME:PerfE1", "Objects:=", Array("Polyline1"), "InfGroundPlane:=", false)

' Create a box (called Box3) of vacuum
oEditor.CreateBox Array("NAME:BoxParameters", _
			"XPosition:=", "4.5mm", "YPosition:=", "-4.5mm", "ZPosition:=", "0mm", _
			"XSize:=", "-5.5mm", "YSize:=", "-3mm", "ZSize:=", "2mm"), _
		Array("NAME:Attributes", _
			"Name:=", "Box3", "Flags:=", "", "Color:=", "(143 175 143)", "Transparency:=", 0, _
			"PartCoordinateSystem:=", "Global", "UDMId:=", "", _
			"MaterialValue:=", Chr(34) & "vacuum" & Chr(34), _
			"SurfaceMaterialValue:=", Chr(34) & "" & Chr(34), "SolveInside:=", true, _
			"IsMaterialEditable:=", true, "UseMaterialAppearance:=", false)

' Change Box3 from vacumm to air, set i's color to white, and make it transparent
oEditor.ChangeProperty Array("NAME:AllTabs", Array("NAME:Geometry3DAttributeTab", _
			Array("NAME:PropServers", "Box3"), _
			Array("NAME:ChangedProps", _
				Array("NAME:Material", "Value:=", Chr(34) & "air" & Chr(34)), _
				Array("NAME:Color", "R:=", 255, "G:=", 255, "B:=", 255), _
				Array("NAME:Transparent", "Value:=", 0.9))))

' Center Box3 (air) on the unit cell
oEditor.ChangeProperty Array("NAME:AllTabs", Array("NAME:Geometry3DCmdTab", _
		Array("NAME:PropServers", "Box3:CreateBox:1"), _
		Array("NAME:ChangedProps", Array("NAME:Position", _
			"X:=", "-$D/2", _
			"Y:=", "-$D/2", _
			"Z:=", "-((20*$lambda) + (2*$Substrate_Thickness))/2"))))

' Change the size of Box3 (air) to surround the unit cell with 20*lambda of air below the unit cell
oEditor.ChangeProperty Array("NAME:AllTabs", Array("NAME:Geometry3DCmdTab", _
		Array("NAME:PropServers", "Box3:CreateBox:1"), _
		Array("NAME:ChangedProps", Array("NAME:XSize", "Value:=", "$D"))))

oEditor.ChangeProperty Array("NAME:AllTabs", Array("NAME:Geometry3DCmdTab", _
		Array("NAME:PropServers", "Box3:CreateBox:1"), _
		Array("NAME:ChangedProps", Array("NAME:YSize", "Value:=", "$D"))))

oEditor.ChangeProperty Array("NAME:AllTabs", Array("NAME:Geometry3DCmdTab", _
		Array("NAME:PropServers", "Box3:CreateBox:1"), _
		Array("NAME:ChangedProps", Array("NAME:ZSize", _
				"Value:=", "(20*$lambda) + (2*$Substrate_Thickness)"))))

' Change the color of box3 to white
oEditor.ChangeProperty Array("NAME:AllTabs", Array("NAME:Geometry3DAttributeTab", _
		Array("NAME:PropServers", "Box3"), _
		Array("NAME:ChangedProps", Array("NAME:Color", "R:=", 255, "G:=", 255, "B:=", 255))))

' Make Box3 transparent
oEditor.ChangeProperty Array("NAME:AllTabs", Array("NAME:Geometry3DAttributeTab", _
		Array("NAME:PropServers", "Box3"), _
		Array("NAME:ChangedProps", Array("NAME:Transparent", "Value:=", 0.9))))


oModule.AssignMaster Array("NAME:Master1", _
		"Faces:=", Array(114), _
		Array("NAME:CoordSysVector", _
			"Origin:=", Array("2.5368mm", "2.5368mm", "2.83979245mm"), _
			"UPos:=", Array("-2.5368mm", "2.5368mm",  "2.83979245mm")), _
		"ReverseV:=", false)

oModule.AssignSlave Array("NAME:Slave1", _
		"Faces:=", Array(112), _
		Array("NAME:CoordSysVector", _
			"Origin:=", Array("2.5368mm", "-2.5368mm", "2.83979245mm"), _
			"UPos:=", Array("-2.5368mm", "-2.5368mm", "2.83979245mmm")), _
		"ReverseV:=", true, _
		"Master:=", "Master1", _
		"UseScanAngles:=", true, _
		"Phi:=", "0deg", _
		"Theta:=", "0deg")

oModule.AssignMaster Array("NAME:Master2", _
		"Faces:=", Array(113), _
		Array("NAME:CoordSysVector", _
			"Origin:=", Array("-2.5368mm", "2.5368mm", "302.332458mm"), _
			"UPos:=", Array("-2.5368mm", "-2.5368mm", "302.332458mm")), _
		"ReverseV:=", false)

oModule.AssignSlave Array("NAME:Slave2", _
		"Faces:=", Array(115), _
		Array("NAME:CoordSysVector", _
			"Origin:=", Array( "2.5368mm", "2.5368mm", "302.332458mm"),_
			"UPos:=", Array("2.5368mm", "-2.5368mm", "302.332458mm")),_
		"ReverseV:=", true, _
		"Master:=", "Master2", _
		"UseScanAngles:=", true, _
		"Phi:=", "0deg", _
		"Theta:=", "0deg")

oModule.AssignFloquetPort Array("NAME:FloquetPort1", _
		"Faces:=", Array(110), "NumModes:=", 2, "RenormalizeAllTerminals:=", true, _
		"DoDeembed:=", true, "DeembedDist:=", "10*$lambda", _
		Array("NAME:Modes", _
			Array("NAME:Mode1", "ModeNum:=", 1, "UseIntLine:=", false, "CharImp:=", "Zpi"), _
			Array("NAME:Mode2", "ModeNum:=", 2, "UseIntLine:=", false, "CharImp:=", "Zpi")), _
		"ShowReporterFilter:=", false, "ReporterFilter:=", Array(false, false), _
		"UseScanAngles:=", true, "Phi:=", "0deg", "Theta:=", "0deg", _
		Array("NAME:LatticeAVector", _
			"Start:=", Array("2.5368mm", "-2.5368mm", "302.332458mm"), _
			"End:=",   Array("2.5368mm",  "2.5368mm", "302.332458mm")), _
		Array("NAME:LatticeBVector", _
			"Start:=", Array( "2.5368mm", "-2.5368mm", "302.332458mm"), _
			"End:=",   Array("-2.5368mm", "-2.5368mm", "302.332458mm")), _
		Array("NAME:ModesList", _
			Array("NAME:Mode", "ModeNumber:=", 1, "IndexM:=", 0, "IndexN:=", 0, "KC2:=", 0, _
				"PropagationState:=", "Propagating", "Attenuation:=", 0, _
				"PolarizationState:=", "TE", "AffectsRefinement:=", true), _
			Array("NAME:Mode", "ModeNumber:=", 2, "IndexM:=", 0, "IndexN:=", 0, "KC2:=", 0, _
				"PropagationState:=", "Propagating", "Attenuation:=", 0, _
				"PolarizationState:=", "TM", "AffectsRefinement:=", true)))

oModule.AssignFloquetPort Array("NAME:FloquetPort2", _
		"Faces:=", Array(111), "NumModes:=", 2, "RenormalizeAllTerminals:=", true, _
		"DoDeembed:=", true, "DeembedDist:=", "10*$lambda", _
		Array("NAME:Modes", _
			Array("NAME:Mode1", "ModeNum:=", 1, "UseIntLine:=", false, "CharImp:=", "Zpi"), _
			Array("NAME:Mode2", "ModeNum:=", 2, "UseIntLine:=", false, "CharImp:=", "Zpi")), _
		"ShowReporterFilter:=", false, "ReporterFilter:=", Array(false, false), _
		"UseScanAngles:=", true, "Phi:=", "0deg", "Theta:=", "0deg", _
		Array("NAME:LatticeAVector", _
			"Start:=", Array("2.5368mm", "-2.5368mm", "-302.332458mm"), _
			"End:=",   Array("2.5368mm",  "2.5368mm", "-302.332458mm")), _
		Array("NAME:LatticeBVector", _
			"Start:=", Array( "2.5368mm", "-2.5368mm", "-302.332458mm"), _
			"End:=",   Array("-2.5368mm", "-2.5368mm", "-302.332458mm")), _
		Array("NAME:ModesList", _
			Array("NAME:Mode", "ModeNumber:=", 1, "IndexM:=", 0, "IndexN:=", 0, "KC2:=", 0, _
				"PropagationState:=", "Propagating", "Attenuation:=", 0, _
				"PolarizationState:=", "TE", "AffectsRefinement:=", true), _
			Array("NAME:Mode", "ModeNumber:=", 2, "IndexM:=", 0, "IndexN:=", 0, "KC2:=", 0, _
				"PropagationState:=", "Propagating", "Attenuation:=", 0, _
				"PolarizationState:=", "TM", "AffectsRefinement:=", true)))

Set oModule = oDesign.GetModule("AnalysisSetup")
oModule.InsertSetup "HfssDriven", Array("NAME:Setup1", _
		"AdaptMultipleFreqs:=", false, "Frequency:=", "10GHz", "MaxDeltaS:=", 0.01, _
		"PortsOnly:=", false, "UseMatrixConv:=", false, "MaximumPasses:=", 30, "MinimumPasses:=", 1, _
		"MinimumConvergedPasses:=", 1, "PercentRefinement:=", 30, "IsEnabled:=", true, _
		"BasisOrder:=", 1, "DoLambdaRefine:=", true, "DoMaterialLambda:=", true, _
		"SetLambdaTarget:=", false, "Target:=", 0.3333, "UseMaxTetIncrease:=", false, _
		"PortAccuracy:=", 2, "UseABCOnPort:=", false, "SetPortMinMaxTri:=", false, _
		"UseDomains:=", false, "UseIterativeSolver:=", false, "SaveRadFieldsOnly:=", false, _
		"SaveAnyFields:=", true, "IESolverType:=", "Auto", "LambdaTargetForIESolver:=", 0.15, _
		"UseDefaultLambdaTgtForIESolver:=", true)

oProject.Save

oDesign.AnalyzeAll

Set oModule = oDesign.GetModule("ReportSetup")
oModule.CreateReport "S Parameter Table 1", "Modal Solution Data", "Data Table",  _
  "Setup1 : LastAdaptive", Array(), Array("Freq:=", Array("All"), "$Ltop1:=", Array( _
  "Nominal"), "$Lmid1:=", Array("Nominal"), "$Lbot1:=", Array("Nominal"), "$Wtop1:=", Array( _
  "Nominal"), "$Wmid1:=", Array("Nominal"), "$Wbot1:=", Array("Nominal"), "$D:=", Array( _
  "Nominal"), "$Substrate_Thickness:=", Array("Nominal"), "$Trace_Width:=", Array( _
  "Nominal"), "$f:=", Array("Nominal"), "$Ltop2:=", Array("Nominal"), "$Wtop2:=", Array( _
  "Nominal"), "$Lmid2:=", Array("Nominal"), "$Lbot2:=", Array("Nominal"), "$Wmid2:=", Array( _
  "Nominal"), "$Wbot2:=", Array("Nominal"), "$Ltop3:=", Array("Nominal"), "$Wtop3:=", Array( _
  "Nominal"), "$Wmid3:=", Array("Nominal"), "$Wbot3:=", Array("Nominal"), "$Lmid3:=", Array( _
  "Nominal"), "$Lbot3:=", Array("Nominal"), "$Ltop4:=", Array("Nominal"), "$Lmid4:=", Array( _
  "Nominal"), "$Lbot4:=", Array("Nominal"), "$Wtop4:=", Array("Nominal"), "$Wmid4:=", Array( _
  "Nominal"), "$Wbot4:=", Array("Nominal"), "$Ltop5:=", Array("Nominal"), "$Lmid5:=", Array( _
  "Nominal"), "$Lbot5:=", Array("Nominal"), "$Ltop6:=", Array("Nominal"), "$Lmid6:=", Array( _
  "Nominal"), "$Lbot6:=", Array("Nominal"), "$Wtop5:=", Array("Nominal"), "$Wmid5:=", Array( _
  "Nominal"), "$Wbot5:=", Array("Nominal"), "$Wtop6:=", Array("Nominal"), "$Wmid6:=", Array( _
  "Nominal"), "$Wbot6:=", Array("Nominal")), Array("X Component:=", "$Wtop1", "Y Component:=", Array( _
  "mag(S(FloquetPort1:1,FloquetPort1:1))", "mag(S(FloquetPort1:1,FloquetPort2:1))",  _
  "mag(S(FloquetPort2:1,FloquetPort1:1))", "mag(S(FloquetPort2:1,FloquetPort2:1))")), Array()