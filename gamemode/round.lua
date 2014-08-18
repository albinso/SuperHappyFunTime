
round = {}
round.BREAK = 5 -- Break between rounds.
round.DURATION = 20 -- Duration of a round

include("shared.lua")


function round.End()
	print("Ended round")
	timer.Simple(round.BREAK, round.Begin)
end
	
function round.Begin()
	print("Started round")
	for i, ply in pairs(player.GetAll()) do
		RevivePlayer(ply)
	end
	timer.Simple(round.DURATION, round.End)
end

round.Begin()
