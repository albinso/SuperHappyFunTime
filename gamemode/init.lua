AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

number_of_active_players = 0
function GM:PlayerInitialSpawn(ply)
	number_of_active_players = 1 + number_of_active_players
	ply.victims = {}
end


function GM:PlayerSpawn(ply)
	self.BaseClass:PlayerSpawn( ply )   
 
    ply:SetGravity  ( 3 )  -- Although I suggest 1, becuase .75 is just too low.
    ply:SetMaxHealth( 100, true )  
 
    ply:SetWalkSpeed( 325 )  
    ply:SetRunSpeed ( 1000 )
    ply:SetJumpPower(500000)
    ply:Give("weapon_crowbar")
end

function GM:EntityTakeDamage(target, damageinfo)
	if target:IsPlayer() and damageinfo:IsFallDamage() then
		damageinfo:SetDamage(0)
	end
	return damageinfo
end

function GM:DoPlayerDeath(target, attacker, damageinfo)
	print("NOOBEN DOG!")
	if not attacker:IsPlayer() then
		return
	end
	table.insert(attacker.victims, target:UniqueID())
	number_of_active_players = number_of_active_players - 1

	if not target.victims then
		print("INGA VICTIMS")
		return
	end
	print(target.victims)

	for k, victim in ipairs(target.victims) do
		print(victim)
		player.GetByUniqueID(victim):UnSpectate()
		player.GetByUniqueID(victim):Spawn()
		number_of_active_players = number_of_active_players + 1
		print("STOPPED SPECTATING")
	end
	target.victims = {}
	print(number_of_active_players)
	if number_of_active_players == 1 then
		print("GUY WINS")
		hook.Call("OnEndRound") -- DOS NUT WRK
	end
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

local function RevivePlayer(victim)
	print(victim)
	player.GetByUniqueID(victim):UnSpectate()
	player.GetByUniqueID(victim):Spawn()
	number_of_active_players = number_of_active_players + 1
	print("STOPPED SPECTATING")
end