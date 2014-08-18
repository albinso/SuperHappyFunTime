AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

active_players = {}
function GM:PlayerInitialSpawn(ply)
	number_of_active_players = 1 + number_of_active_players
	ply:SetTeam(number_of_active_players % 2)
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
    table.insert(active_players, ply)
end

function GM:EntityTakeDamage(target, damageinfo)
	if damageinfo:IsFallDamage() then
		damageinfo:SetDamage(0)
	return damageinfo
end

function GM:DoPlayerDeath(target, attacker, damageinfo)
	print("NOOBEN DOG!")
	if not attacker:IsPlayer() or not attacker:IsBot() then
		return
	end
	table.insert(attacker.victims, target:UniqueID())
	table.remove(active_players, target)
	number_of_active_players = number_of_active_players - 1

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
	CheckVictoryCondition()
end

function GM:PlayerDeathThink(target)
	target:Spectate(OBS_MODE_ROAMING)
end

local function CheckVictoryCondition()
	if number_of_active_players == 1 then
		print("GUY WINS")
		GM:RoundEnd()
	end
end

function GM:PlayerShouldTakeDamage(target, attacker)
	if attacker:IsPlayer() and attacker:Team() == target:Team() then
		return false
	return true
end


local function RevivePlayer(victim)
	print(victim)
	player.GetByUniqueID(victim):UnSpectate()
	player.GetByUniqueID(victim):Spawn()
	number_of_active_players = number_of_active_players + 1
	print("STOPPED SPECTATING")
end