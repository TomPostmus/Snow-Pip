enum PACK {
	HELLO,					// packet from client to give intial info
	UPDATE_GAME,			// packet from server to give game information (non-realtime)
	UPDATE_PLAYER,			// packet from client containing info about players (name, visuals)
	UPDATE_MOVEMENT,		// update containing movement from players (realtime), both server and client
	UPDATE_ANIM,			// update animation state of player
	SPAWN_PLAYER,			// spawn player at location
	
	ERROR					// server error
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