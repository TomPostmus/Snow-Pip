enum PACK {
	HELLO,					// packet from client to give intial info
	UPDATE_GAME,			// packet from server to give game information (non-realtime)
	UPDATE_PLAYER,			// packet from client containing info about players (name, visuals)
	UPDATE_MOVEMENT,		// update containing movement from players (realtime), both server and client
	UPDATE_ANIM,			// update animation state of player
	SPAWN_PLAYER,			// spawn player at location
	PROJECTILE,				// created projectile at a location with speed
	PROJECTILE_ID,			// response by server to a projectile, giving its id
	DAMAGE,					// damage on a player (optionally giving projectile id that caused damage)
	
	ERROR					// server error
}

function pack_to_string(_type) {	// to string function of packet enum
	switch(_type) {
		case PACK.HELLO: return "HELLO"
		case PACK.UPDATE_GAME: return "UPDATE_GAME"
		case PACK.UPDATE_PLAYER: return "UPDATE_PLAYER"
		case PACK.UPDATE_MOVEMENT: return "UPDATE_MOVEMENT"
		case PACK.UPDATE_ANIM: return "UPDATE_ANIM"
		case PACK.SPAWN_PLAYER: return "SPAWN_PLAYER"
		case PACK.PROJECTILE: return "PROJECTILE"
		case PACK.PROJECTILE_ID: return "PROJECTILE_ID"
		case PACK.DAMAGE: return "DAMAGE"
		case PACK.ERROR: return "ERROR"
	}
	return ""
}

enum GAME_STATE {
	LOBBY,					// pre-game lobby
	GAME					// while game
}

enum NETWORK_ERROR {
	INVALID_PLAYID
}

enum ANIM_STATE {
	EMPTY,
	PICKUP,
	HOLD,
	BRACE,
	THROW,
	THROW_SPIN
}

enum ITEM {
	SNOWBALL,
	ICEBALL,
	FIREWORK
}