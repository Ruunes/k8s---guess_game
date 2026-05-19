CREATE TABLE IF NOT EXISTS game (
    game_id TEXT PRIMARY KEY,
    password TEXT,
    attempts INTEGER
);