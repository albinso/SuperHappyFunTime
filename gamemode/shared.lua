GM.Name = "Super Happy Fun Time"
GM.Author = "Dark Lord Albin"
GM.Email = "N/A"
GM.Website = "N/A"

function GM:Initialize()
end

function GM:SetupTeams()
	team.SetUp(1, "Doods", Color(150, 150, 150))
	team.SetUp(2, "Dawdes", Color(26, 120, 245))
end
GM:SetupTeams()