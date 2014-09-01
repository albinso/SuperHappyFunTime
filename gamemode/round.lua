
round = {}
round.BREAK = 10 -- Break between rounds.
round.DURATION = 45 -- Duration of a round
round.active = false
include("shared.lua")


function End()
	print("Ended round")
	round.active = false
	timer.Stop("active timer")
	timer.Create("break timer", round.BREAK, 1, round.Begin)
end
	
function Begin()
	print("Started round")
	for i, ply in pairs(player.GetAll()) do
		RevivePlayer(ply)
	end
	round.active = true
	timer.Stop("break timer")
	timer.Create("active timer", round.DURATION, 1, round.End)
end

round.Begin = Begin
round.End = End
return round
