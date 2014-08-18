AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("round.lua")

include("shared.lua")
include("round.lua")


function GM:PlayerInitialSpawn(ply)
	local tm = (team.NumPlayers(1) > team.NumPlayers(2)) and 2 or 1
	ply:SetTeam(tm)
	ply.victims = {}
end


function GM:PlayerSpawn(ply)
	self.BaseClass:PlayerSpawn( ply )   
 
    ply:SetGravity  ( 3 ) 
    ply:SetMaxHealth( 100, true )  
 
    ply:SetWalkSpeed( 325 )  
    ply:SetRunSpeed ( 1000 )
    ply:SetJumpPower(500000)
    ply:Give("weapon_crowbar")
end

function GM:EntityTakeDamage(target, damageinfo)
	if damageinfo:IsFallDamage() then
		damageinfo:SetDamage(0)
	end
	return damageinfo
end

function GM:DoPlayerDeath(target, attacker, damageinfo)
	print("NOOBEN DOG!")
	if not attacker:IsPlayer() or not attacker:IsBot() then
		RevivePlayer(target)
		return
	end
	table.insert(attacker.victims, target)

	if not target.victims then
		print("INGA VICTIMS")
		return
	end
	print(target.victims)

	for k, victim in ipairs(target.victims) do
		RevivePlayer(victim)
	end
	target.victims = {}
	print(number_of_active_players)
	if CheckVictoryCondition() then

end

function GM:PlayerDeathThink(target)
	target:Spectate(OBS_MODE_ROAMING)
end

local function CheckVictoryCondition()
	return not (team.NumPlayers(1) and team.NumPlayers(2))
end

function GM:PlayerShouldTakeDamage(target, attacker)
	if attacker:IsPlayer() and attacker:Team() == target:Team() then
		return false
	end
	return true
end


function RevivePlayer(victim)
	victim:UnSpectate()
	victim:Spawn()
	print("STOPPED SPECTATING")
end