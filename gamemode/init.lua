AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

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
	if (attacker:IsPlayer() and not attacker.victims) then
		attacker.victims = {}
	end
	table.insert(attacker.victims, target:UniqueID())

	if not target.victims then
		print("INGA VICTIMS RETURNAR")
		return
	end
	print(target.victims)

	for k, victim in ipairs(target.victims) do
		print(victim)
		player.GetByUniqueID(victim):UnSpectate()
		print("STOPPED SPECTATING")
	end
	target.victims = {}
end

function GM:PlayerDeath(target, inflictor, attacker)
	print("STARTED SPECTATING")
	target:Spectate(OBS_MODE_ROAMING)
end

function GM:PlayerDeathThink(target)
	
end