CREATE TABLE IF NOT EXISTS speedjumpsystem (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    speed_enabled BOOLEAN DEFAULT FALSE,
    jump_enabled BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (player_id) REFERENCES users(identifier)
);

INSERT INTO speedjumpsystem (player_id) SELECT identifier FROM users WHERE identifier NOT IN (SELECT player_id FROM speedjumpsystem);