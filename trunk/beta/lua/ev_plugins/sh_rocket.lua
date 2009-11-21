/*-------------------------------------------------------------------------------------------------------------------------
	Rocket a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Rocket"
PLUGIN.Description = "Rocket a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "rocket"
PLUGIN.Usage = "[players]"

function evolve:Explode( ply )
	local explosive = ents.Create( "env_explosion" )
	explosive:SetPos( ply:GetPos() )
	explosive:SetOwner( ply )
	explosive:Spawn()
	explosive:SetKeyValue( "iMagnitude", "1" )
	explosive:Fire( "Explode", 0, 0 )
	explosive:EmitSound( "ambient/explosions/explode_4.wav", 500, 500 )
	
	ply:Kill()
end

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		local victims = evolve:FindPlayer( args, ply )
		if ( #victims > 0 and !victims[1]:IsValid() ) then victims = { } end
		
		for _, victim in ipairs( victims ) do
			victim:SetVelocity( Vector( 0, 0, 4000 ) )
			timer.Simple( 1, evolve.Explode, evolve, victim )
		end
		
		if ( #victims > 0 ) then
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has rocketed ", evolve.colors.red, evolve:CreatePlayerList( victims ), evolve.colors.white, "." )
		else
			evolve:Notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "rocket", unpack( players ) )
	else
		return "Rocket", evolve.category.punishment
	end
end

evolve:RegisterPlugin( PLUGIN )