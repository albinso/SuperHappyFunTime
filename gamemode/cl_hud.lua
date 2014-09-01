function DisplayTeam( ply, x, y, font )
	draw.SimpleText(ply:Team(), font, x, y, COLOR_BLACK, 0, 0)
end

function DisplayTime(ply, x, y, font)
	active = timer.TimeLeft("active timer")
	break_time = timer.TimeLeft("break timer")
	print("Active " .. tostring(active))
	print("Break " .. tostring(break_time))
	display = active or break_time
	draw.SimpleText(tostring(display), font, x, y, COLOR_BLACK, 0, 0)
end

function GM:HUDPaint()
	DisplayTeam(LocalPlayer(), 200, 200, "Default")
	DisplayTime(LocalPlayer(), ScrW()-150, ScrH()-150, "Default")
end