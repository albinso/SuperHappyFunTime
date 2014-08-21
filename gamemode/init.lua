AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("round.lua")

include("shared.lua")
include("round.lua")

-- local round = require("round.lua")
round.Begin()


function GM:PlayerInitialSpawn(ply)
	local tm = (team.NumPlayers(1) > team.NumPlayers(2)) and 2 or 1
	ply:SetTeam(tm)
	ply.victims = {}
end


function GM:PlayerSpawn(ply)
	self.BaseClass:PlayerSpawn( ply )   
 
    ply:SetGravity  ( 1 ) 
    ply:SetMaxHealth( 100, true )  
 
    ply:SetWalkSpeed( 325 )  
    ply:SetRunSpeed ( 1000 )
    ply:SetJumpPower(5000)
    ply:Give("weapon_rpg")
    ply:SetAmmo(10, "RPG_Round")
end

function GM:EntityTakeDamage(target, damageinfo)
	if damageinfo:IsFallDamage() then
		damageinfo:SetDamage(0)
	end
	return damageinfo
end

function GM:DoPlayerDeath(target, attacker, damageinfo)
	print("NOOBEN DOG!")
	if not attacker:IsPlayer() then
		RevivePlayer(target)
		return
	end
	-- table.insert(attacker.victims, target)

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
	print(round.active)
	if CheckVictoryCondition() and round.active then
		print("FORCED ROUND END")
		round.End()
	end
end

function GM:PlayerDeathThink(target)
	target:Spectate(OBS_MODE_ROAMING)
end

function CheckVictoryCondition()
	local tc = GetTeamAliveCounts()
	print(tc[1])
	print(tc[2])
	return not (tc[1] and tc[2])  -- If either value is zero - true
end

function GM:PlayerShouldTakeDamage(target, attacker)
	if attacker:IsPlayer() and attacker:Team() == target:Team() then
		return true
	end
	return true
end

function GetTeamAliveCounts()

	local TeamCounter = {}

	for k,v in pairs( player.GetAll() ) do
		if ( v:Alive() && v:Team() > 0 && v:Team() < 1000 ) then
			TeamCounter[ v:Team() ] = TeamCounter[ v:Team() ] or 0
			TeamCounter[ v:Team() ] = TeamCounter[ v:Team() ] + 1
		end
	end

	return TeamCounter
end

function RevivePlayer(victim)
	victim:UnSpectate()
	victim:Spawn()
	print("STOPPED SPECTATING")
end