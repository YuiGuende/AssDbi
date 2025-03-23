CREATE DATABASE Billiard_Tournament
-- Bảng Tournament (Giải đấu)
CREATE TABLE Tournament (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('Upcoming', 'Ongoing', 'Finished') NOT NULL
);
--Bảng nhà tài trợ
CREATE TABLE Sponsorship (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL, -- Tên nhà tài trợ
    amount DECIMAL(12,2) NOT NULL, -- Số tiền tài trợ
    tournament_id INT NOT NULL, -- Mã giải đấu được tài trợ
    FOREIGN KEY (tournament_id) REFERENCES Tournament(id) ON DELETE CASCADE
);

-- Bảng Player (Người chơi)
CREATE TABLE Player (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	alias VARCHAR(255) ,
    date_of_birth DATE NOT NULL,
	height float NOT NULL,
	highest_rank int,
	major_won int DEFAULT 0,
	prize_money DOUBLE(10,3),
    country VARCHAR(100) NOT NULL,
    handedness ENUM('Left', 'Right') NOT NULL
);

-- Bảng Round (Vòng đấu)
CREATE TABLE Round (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tournament_id INT NOT NULL,
    round_number VARCHAR(50) NOT NULL, -- Có thể là số (1, 2) hoặc chữ (Tứ kết, Bán kết, Chung kết)
	
    FOREIGN KEY (tournament_id) REFERENCES Tournament(id) ON DELETE CASCADE,
);
-- Bảng trận đấu
CREATE TABLE tblMatch (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tournament_id INT NOT NULL,
    round_id INT NOT NULL,
    player1_id INT NOT NULL,
    player2_id INT NOT NULL,
	player1_score INT NOT NULL,--Điểm của người chơi 1
	player2_score INT NOT NULL,--Điểm của người chơi 2
    winner_id INT NULL, -- NULL khi trận chưa kết thúc
    match_date DATE NOT NULL,
    first_to INT NOT NULL, -- Số rack cần thắng để kết thúc trận
    status ENUM('Scheduled', 'Ongoing', 'Completed') NOT NULL,
    FOREIGN KEY (tournament_id) REFERENCES Tournament(id) ON DELETE CASCADE,
    FOREIGN KEY (round_id) REFERENCES Round(id) ON DELETE CASCADE,
    FOREIGN KEY (player1_id) REFERENCES Player(id) ON DELETE CASCADE,
    FOREIGN KEY (player2_id) REFERENCES Player(id) ON DELETE CASCADE,
    FOREIGN KEY (winner_id) REFERENCES Player(id) ON DELETE SET NULL
);

-- Bảng Rack (Tỷ số theo rack)
CREATE TABLE Rack (
    rack INT NOT NULL, -- Số thứ tự rack trong trận
    match_id INT NOT NULL,
    winner_id INT NULL, -- NULL khi rack chưa kết thúc
    PRIMARY KEY (rack, match_id), -- Một trận có nhiều rack, mỗi rack có thứ tự riêng
    FOREIGN KEY (match_id) REFERENCES tblMatch(id) ON DELETE CASCADE,
    FOREIGN KEY (winner_id) REFERENCES Player(id) ON DELETE SET NULL
);

-- Bảng thống kê theo rack
CREATE TABLE rack_statistic (
    rack INT NOT NULL,
    match_id INT NOT NULL,
    player_id INT NOT NULL,
    break_and_run INT  DEFAULT 0, -- Số ván break and run
    break_num INT  DEFAULT 0, -- Số lần phá bi
	balls_potted INT DEFAULT 0,
	missed_pots INT DEFAULT 0,
	fouls INT DEFAULT 0,
    PRIMARY KEY (rack, match_id, player_id),
    FOREIGN KEY (match_id) REFERENCES tblMatch(id) ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES Player(id) ON DELETE CASCADE
);

-- Bảng Prize (Giải thưởng)
CREATE TABLE Prize (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tournament_id INT NOT NULL,
    position VARCHAR(50) NOT NULL, -- Vô địch, Á quân, Hạng ba
    amount DECIMAL(10,2) NOT NULL, -- Giá trị tiền thưởng
    FOREIGN KEY (tournament_id) REFERENCES Tournament(id) ON DELETE CASCADE
);

-- Bảng Ranking (Xếp hạng)
CREATE TABLE Ranking (
    id INT PRIMARY KEY AUTO_INCREMENT,
    player_id INT NOT NULL,
    billiard_type ENUM('Carom', '9 Ball', '8 Ball') NOT NULL,
    ranking_points INT NOT NULL DEFAULT 0,
    rank_position INT NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (player_id) REFERENCES Player(id) ON DELETE CASCADE
);
