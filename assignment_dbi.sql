CREATE DATABASE Billiard_Tournament;
GO
USE Billiard_Tournament;
GO

-- Bảng Tournament (Giải đấu)
CREATE TABLE Tournament (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    location NVARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status NVARCHAR(50) NOT NULL CHECK (status IN ('Upcoming', 'Ongoing', 'Finished'))
);
GO

-- Bảng nhà tài trợ
CREATE TABLE Sponsorship (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL, 
    amount DECIMAL(12,2) NOT NULL, 
    tournament_id INT NOT NULL,
    CONSTRAINT FK_Sponsorship_Tournament FOREIGN KEY (tournament_id) REFERENCES Tournament(id) ON DELETE CASCADE
);
GO

-- Bảng Player (Người chơi)
CREATE TABLE Player (
    id INT PRIMARY KEY IDENTITY(1,1),
    first_name NVARCHAR(255) NOT NULL,
    last_name NVARCHAR(255) NOT NULL,
    alias NVARCHAR(255) NULL,
    date_of_birth DATE NOT NULL,
    height FLOAT NOT NULL,
    highest_rank INT NULL,
    major_won INT DEFAULT 0,
    prize_money DECIMAL(10,3),
    country NVARCHAR(100) NOT NULL,
    handedness NVARCHAR(10) NOT NULL CHECK (handedness IN ('Left', 'Right'))
);
GO

-- Bảng Round (Vòng đấu)
CREATE TABLE Round (
    id INT PRIMARY KEY IDENTITY(1,1),
    tournament_id INT NOT NULL,
    round_number NVARCHAR(50) NOT NULL,
    CONSTRAINT FK_Round_Tournament FOREIGN KEY (tournament_id) REFERENCES Tournament(id) ON DELETE CASCADE
);
GO

-- Bảng trận đấu
CREATE TABLE tblMatch (
    id INT PRIMARY KEY IDENTITY(1,1),
    tournament_id INT NOT NULL,
    round_id INT NOT NULL,
    player1_id INT NOT NULL,
    player2_id INT NOT NULL,
    player1_score INT NOT NULL DEFAULT 0,
    player2_score INT NOT NULL DEFAULT 0,
    winner_id INT NULL,
    match_date DATE NOT NULL,
    first_to INT NOT NULL,
    status NVARCHAR(50) NOT NULL CHECK (status IN ('Scheduled', 'Ongoing', 'Completed')),
    CONSTRAINT FK_Match_Tournament FOREIGN KEY (tournament_id) REFERENCES Tournament(id) ON DELETE CASCADE,
    CONSTRAINT FK_Match_Round FOREIGN KEY (round_id) REFERENCES Round(id) ON DELETE CASCADE,
    CONSTRAINT FK_Match_Player1 FOREIGN KEY (player1_id) REFERENCES Player(id) ON DELETE CASCADE,
    CONSTRAINT FK_Match_Player2 FOREIGN KEY (player2_id) REFERENCES Player(id) ON DELETE CASCADE,
    CONSTRAINT FK_Match_Winner FOREIGN KEY (winner_id) REFERENCES Player(id) ON DELETE SET NULL
);
GO

-- Bảng Rack (Tỷ số theo rack)
CREATE TABLE Rack (
    rack INT NOT NULL, 
    match_id INT NOT NULL,
    winner_id INT NULL,
    PRIMARY KEY (rack, match_id),
    CONSTRAINT FK_Rack_Match FOREIGN KEY (match_id) REFERENCES tblMatch(id) ON DELETE CASCADE,
    CONSTRAINT FK_Rack_Winner FOREIGN KEY (winner_id) REFERENCES Player(id) ON DELETE SET NULL
);
GO

-- Bảng thống kê theo rack
CREATE TABLE rack_statistic (
    rack INT NOT NULL,
    match_id INT NOT NULL,
    player_id INT NOT NULL,
    break_and_run INT DEFAULT 0,
    break_num INT DEFAULT 0,
    balls_potted INT DEFAULT 0,
    missed_pots INT DEFAULT 0,
    fouls INT DEFAULT 0,
    PRIMARY KEY (rack, match_id, player_id),
    CONSTRAINT FK_Statistic_Match FOREIGN KEY (match_id) REFERENCES tblMatch(id) ON DELETE CASCADE,
    CONSTRAINT FK_Statistic_Player FOREIGN KEY (player_id) REFERENCES Player(id) ON DELETE CASCADE
);
GO

-- Bảng Prize (Giải thưởng)
CREATE TABLE Prize (
    id INT PRIMARY KEY IDENTITY(1,1),
    tournament_id INT NOT NULL,
    position NVARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Prize_Tournament FOREIGN KEY (tournament_id) REFERENCES Tournament(id) ON DELETE CASCADE
);
GO

-- Bảng Ranking (Xếp hạng)
CREATE TABLE Ranking (
    id INT PRIMARY KEY IDENTITY(1,1),
    player_id INT NOT NULL,
    billiard_type NVARCHAR(50) NOT NULL CHECK (billiard_type IN ('Carom', '9 Ball', '8 Ball')),
    ranking_points INT NOT NULL DEFAULT 0,
    rank_position INT NOT NULL,
    last_updated DATETIME2 DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Ranking_Player FOREIGN KEY (player_id) REFERENCES Player(id) ON DELETE CASCADE
);
GO
