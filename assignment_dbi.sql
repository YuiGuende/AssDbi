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
INSERT INTO Tournament (name, location, start_date, end_date, status)  
VALUES  
('World Pool Championship', 'Kielce, Poland', '2024-06-06', '2024-06-11', 'Finished'),  
('US Open 9-Ball Championship', 'Atlantic City, USA', '2024-09-25', '2024-09-30', 'Upcoming'),  
('World Snooker Championship', 'Sheffield, England', '2024-04-20', '2024-05-06', 'Finished'),  
('Asian 3-Cushion Championship', 'Seoul, South Korea', '2024-08-10', '2024-08-14', 'Upcoming'),  
('Mosconi Cup', 'London, England', '2024-12-06', '2024-12-09', 'Upcoming');

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
INSERT INTO Sponsorship (name, amount, tournament_id)  
VALUES  
('Matchroom Sport', 500000.00, 1),  -- Nhà tổ chức và tài trợ chính của World Pool Championship  
('Caesars Entertainment', 300000.00, 2),  -- Nhà tài trợ của US Open 9-Ball Championship  
('Betfred', 1000000.00, 3),  -- Nhà tài trợ chính của World Snooker Championship  
('Korea Billiards Federation', 200000.00, 4),  -- Nhà tài trợ cho Asian 3-Cushion Championship  
('Sky Sports', 700000.00, 5);  -- Nhà tài trợ truyền hình chính của Mosconi Cup  
SELECT * FROM Sponsorship
GO
CREATE TABLE Register(
	playerId INT FOREIGN KEY(playerId) REFERENCES Player(id) ,
	tournamentId INT FOREIGN KEY(tournamentId) REFERENCES Tournament(id)
	constraint pk_r primary key(playerId,tournamentId)
)
GO
INSERT INTO Register values
(2,1),
(3,1),
(4,1),
(5,1),
(6,1),
(7,1),
(8,1),
(9,1)

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
INSERT INTO Player (first_name, last_name, alias, date_of_birth, height, highest_rank, major_won, prize_money, country, handedness)
VALUES
    ('Efren', 'Reyes', 'Bata', '1954-08-26', 1.73, 1, 70, 2000000.000, 'Philippines', 'Right'),
    ('Shane', 'Van Boening', NULL, '1983-07-14', 1.80, 1, 5, 1000000.000, 'USA', 'Right'),
    ('Ko', 'Pin Yi', NULL, '1989-05-31', 1.78, 1, 2, 500000.000, 'Taiwan', 'Right'),
    ('Jayson', 'Shaw', NULL, '1988-09-13', 1.75, 1, 3, 750000.000, 'Scotland', 'Left'),
	('Fedor', 'Gorst', NULL, '2000-05-31', 1.80, 1, 3, 500000.000, 'Russia', 'Right'),
    ('Joshua', 'Filler', 'The Killer', '1997-10-02', 1.78, 1, 4, 600000.000, 'Germany', 'Right'),
    ('Carlo', 'Biado', NULL, '1983-10-31', 1.72, 1, 3, 450000.000, 'Philippines', 'Right'),
    ('Ko', 'Ping Chung', NULL, '1995-09-07', 1.76, 1, 2, 400000.000, 'Taiwan', 'Right'),
	(N'Dương', N'Quốc Hoàng', NULL, '1987-01-01', 1.75, 1, 1, 100000.000, 'Vietnam', 'Right'),
    ('Francisco', 'Sanchez Ruiz', 'FSC', '1991-12-29', 1.78, 1, 5, 700000.000, 'Spain', 'Right');
GO
-- Bảng Round (Vòng đấu)
CREATE TABLE Round (
    id INT PRIMARY KEY IDENTITY(1,1),
    tournament_id INT NOT NULL,
    round_number NVARCHAR(50) NOT NULL,
    CONSTRAINT FK_Round_Tournament FOREIGN KEY (tournament_id) REFERENCES Tournament(id) ON DELETE CASCADE
);
GO
	INSERT INTO Round (tournament_id, round_number)
	VALUES
    (1, 'Quarterfinals'),
    (1, 'Semifinals'),
    (1, 'Grand Final');
GO

-- Bảng trận đấu
CREATE TABLE tblMatch (
    id INT PRIMARY KEY IDENTITY(1,1),
    tournament_id INT NOT NULL,
    round_id INT NOT NULL,
    player1_id INT ,
    player2_id INT ,
    player1_score INT NOT NULL DEFAULT 0,
    player2_score INT NOT NULL DEFAULT 0,
    winner_id INT NULL,
    match_date DATE NOT NULL,
    first_to INT NOT NULL,
    status NVARCHAR(50) NOT NULL CHECK (status IN ('Scheduled', 'Ongoing', 'Completed')),
    CONSTRAINT FK_Match_Tournament FOREIGN KEY (tournament_id) REFERENCES Tournament(id) ON DELETE CASCADE,
    CONSTRAINT FK_Match_Round FOREIGN KEY (round_id) REFERENCES Round(id) ,
    CONSTRAINT FK_Match_Player1 FOREIGN KEY (player1_id) REFERENCES Player(id) ,
    CONSTRAINT FK_Match_Player2 FOREIGN KEY (player2_id) REFERENCES Player(id),
    CONSTRAINT FK_Match_Winner FOREIGN KEY (winner_id) REFERENCES Player(id) ON DELETE SET NULL
);
GO
-- Vòng 1 (Round of 8)
INSERT INTO tblMatch (tournament_id, round_id, player1_id, player2_id, player1_score, player2_score, winner_id, match_date, first_to, status)
VALUES
    (1, 1, 2, 7, 2, 1, 2, '2025-03-01', 2, 'Completed'), -- Shane Van Boening vs Carlo Biado (Shane thắng)
    (1, 1, 3, 6, 0, 2, 6, '2025-03-01', 2, 'Completed'), -- Ko Pin Yi vs Joshua Filler (Joshua thắng)
    (1, 1, 4, 5, 1, 2, 5, '2025-03-01', 2, 'Completed'), -- Jayson Shaw vs Fedor Gorst (Fedor thắng)
    (1, 1, 8, 9, 0, 2, 9, '2025-03-01', 2, 'Completed'); -- Ko Ping Chung vs Dương Quốc Hoàng (Dương thắng)
GO
-- Vòng 2 (Bán kết - Semifinals)
INSERT INTO tblMatch (tournament_id, round_id, player1_id, player2_id, player1_score, player2_score, winner_id, match_date, first_to, status)
VALUES
    (1, 2, 2, 6, 0, 2, 6, '2025-03-02', 2, 'Completed'), -- Shane Van Boening vs Joshua Filler (Joshua thắng)
    (1, 2, 5, 9, 1, 2, 9, '2025-03-02', 2, 'Completed'); -- Fedor Gorst vs Dương Quốc Hoàng (Dương thắng)
GO
-- Vòng 3 (Chung kết - Final)
INSERT INTO tblMatch (tournament_id, round_id, player1_id, player2_id, player1_score, player2_score, winner_id, match_date, first_to, status)
VALUES
    (1, 3, 6, 9, 1, 2, 9, '2025-03-03', 2, 'Completed'); -- Joshua Filler vs Dương Quốc Hoàng (Dương thắng - VÔ ĐỊCH)
GO
-- Bảng Rack (Tỷ số theo rack)
CREATE TABLE Rack (
	rackId INT primary key IDENTITY(1,1),
    rack_num INT NOT NULL, 
    match_id INT NOT NULL,
    winner_id INT NULL,
    CONSTRAINT FK_Rack_Match FOREIGN KEY (match_id) REFERENCES tblMatch(id) ON DELETE CASCADE,
    CONSTRAINT FK_Rack_Winner FOREIGN KEY (winner_id) REFERENCES Player(id) ON DELETE SET NULL
);
GO
-- Vòng 1 (Round of 8)
INSERT INTO Rack (rack_num, match_id, winner_id) VALUES
    (1, 1, 2), (2, 1, 7), (3, 1, 2),  -- Shane thắng Carlo 2-1
    (1, 2, 6), (2, 2, 6),              -- Joshua thắng Ko Pin Yi 2-0
    (1, 3, 4), (2, 3, 5), (3, 3, 5),  -- Fedor thắng Jayson 2-1
    (1, 4, 9), (2, 4, 9);             -- Dương thắng Ko Ping Chung 2-0

-- Vòng 2 (Semifinals)
INSERT INTO Rack (rack_num, match_id, winner_id) VALUES
    (1, 5, 6), (2, 5, 6),              -- Joshua thắng Shane 2-0
    (1, 6, 5), (2, 6, 9), (3, 6, 9);  -- Dương thắng Fedor 2-1

-- Chung kết (Final)
INSERT INTO Rack (rack_num, match_id, winner_id) VALUES
    (1, 7, 9), (2, 7, 6), (3, 7, 9);  -- Dương thắng Joshua 2-1 (Vô địch)
GO

-- Bảng thống kê theo rack
CREATE TABLE rack_statistic (
    rackId INT,
    player_id INT NOT NULL,
    break_and_run INT DEFAULT 0,--breakNRun thì thông số của đối thủ bằng 0 trừ fouls + tạo rack mới
    break_num INT DEFAULT 0,
    balls_potted INT DEFAULT 0,
    missed_pots INT DEFAULT 0,
    fouls INT DEFAULT 0,
    PRIMARY KEY (rackId , player_id),
	CONSTRAINT FK_rackId FOREIGN KEY (rackId) REFERENCES Rack(rackId) ON DELETE CASCADE,
    CONSTRAINT FK_Statistic_Player FOREIGN KEY (player_id) REFERENCES Player(id) ON DELETE CASCADE,
);
GO
INSERT INTO rack_statistic (rackId, player_id, break_and_run, break_num, balls_potted, missed_pots, fouls)
VALUES
    -- Match 1 (Shane vs Carlo) - Shane thắng 2-0
    (1, 2, 0, 1, 5, 1, 0), (1, 7, 0, 0, 4, 2, 1),
    (2, 2, 1, 1, 9, 0, 0), (2, 7, 0, 0, 0, 0, 0),  -- Shane thực hiện Break and Run

    -- Match 2 (Joshua vs Ko Pin Yi) - Joshua thắng 2-1
    (3, 6, 0, 1, 4, 1, 0), (3, 3, 0, 0, 5, 3, 1),
    (4, 3, 0, 1, 6, 2, 0), (4, 6, 0, 0, 3, 3, 1),
    (5, 6, 1, 1, 9, 0, 0), (5, 3, 0, 0, 0, 0, 0),  -- Joshua thực hiện Break and Run

    -- Match 3 (Fedor vs Jayson) - Fedor thắng 2-0
    (6, 4, 0, 0, 4, 2, 1), (6, 5, 0, 1, 5, 1, 0),
    (7, 4, 0, 1, 6, 1, 0), (7, 5, 0, 0, 3, 3, 2),

    -- Match 4 (Dương vs Ko Ping Chung) - Dương thắng 2-0
    (8, 9, 0, 1, 5, 1, 0), (8, 8, 0, 0, 4, 2, 1),
    (9, 9, 0, 1, 6, 1, 0), (9, 8, 0, 0, 3, 3, 1),

    -- Semifinal 1 (Joshua vs Shane) - Joshua thắng 2-1
    (10, 6, 0, 1, 5, 1, 0), (10, 2, 0, 0, 4, 3, 2),
    (11, 2, 0, 1, 6, 1, 0), (11, 6, 0, 0, 3, 3, 1),
    (12, 6, 1, 1, 9, 0, 0), (12, 2, 0, 0, 0, 0, 0),  -- Joshua thực hiện Break and Run

    -- Semifinal 2 (Dương vs Fedor) - Dương thắng 2-0
    (13, 9, 0, 1, 5, 1, 0), (13, 4, 0, 0, 4, 3, 2),
    (14, 9, 0, 1, 6, 1, 0), (14, 4, 0, 0, 3, 3, 1),

    -- Final (Dương vs Joshua) - Dương thắng 2-1
    (15, 9, 0, 1, 5, 1, 0), (15, 6, 0, 0, 4, 2, 1),
    (16, 6, 0, 1, 6, 1, 0), (16, 9, 0, 0, 3, 2, 1),
    (17, 9, 1, 2, 9, 0, 0), (17, 6, 0, 0, 0, 0, 0);  -- Dương thực hiện Break and Run
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
INSERT INTO Prize (tournament_id, position, amount)  
VALUES  
(1, 'Champion', 600000.00),  -- Giải thưởng vô địch World Pool Championship  
(1, 'Runner-up', 300000.00),  -- Á quân World Pool Championship  
(1, 'Third place winner', 150000.00),  -- hạng 3 World Pool Championship 
(2, 'Champion', 500000.00),  -- Giải thưởng vô địch US Open 9-Ball Championship  
(3, 'Champion', 500000.00),  -- Giải thưởng vô địch World Snooker Championship  
(3, 'Runner-up', 200000.00);  -- Á quân World Snooker Championship  
GO
CREATE TABLE Player_prize(
	playerId INT FOREIGN KEY(playerId) REFERENCES Player(id) ,
	prizeId INT FOREIGN KEY(prizeId) REFERENCES Prize(id)
	constraint pk_plr primary key(playerId,prizeId)
)
GO
INSERT INTO Player_prize VALUES(9,1),(6,2),(2,6),(5,6)
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
INSERT INTO Ranking (player_id, billiard_type, ranking_points, rank_position)  
VALUES  
(1, '8 Ball', 50000, 1),  -- Efren Reyes - Huyền thoại 8 Ball  
(2, '9 Ball', 48000, 2),  -- Shane Van Boening - Hạng 2 thế giới 9 Ball  
(3, '9 Ball', 45000, 3),  -- Ko Pin Yi - Nhà vô địch 9 Ball  
(4, '8 Ball', 42000, 4),  -- Jayson Shaw - Top 8 Ball thế giới  
(5, '9 Ball', 40000, 5),  -- Fedor Gorst - Nhà vô địch 9 Ball  
(6, '9 Ball', 38000, 6),  -- Joshua Filler - Tay cơ mạnh của Đức  
(7, '9 Ball', 36000, 7),  -- Carlo Biado - Vô địch thế giới 9 Ball  
(8, '9 Ball', 34000, 8),  -- Ko Ping Chung - Nhà vô địch từ Đài Loan  
(9, '9 Ball', 32000, 9),  -- Dương Quốc Hoàng - Cơ thủ Việt Nam  
(10, '9 Ball', 30000, 10); -- Francisco Sanchez Ruiz - Đương kim số 1 thế giới 9 Ball  
GO
--queryyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
CREATE FUNCTION Player_schedule(
@tournamentName nvarchar(50),
@playerName nvarchar(50) )
returns table
as
return(
select 
m.match_date as [Date],
p1.first_name+p1.last_name as [Player1 name],
p2.first_name+p2.last_name as [Player2 name],
m.player1_score as [Player1 score],
m.player2_score as [Player2 score],
m.status as [Status]
from 
Tournament t
inner join tblMatch m on m.tournament_id=t.id and t.name=@tournamentName
inner join Player p1 on (p1.id=m.player1_id )
inner join Player p2 on (p2.id=m.player2_id )
where  p2.first_name+p2.last_name=@playerName or p1.first_name+p1.last_name=@playerName
)
--Lấy lịch thi đấu của một người chơi trong một giải đấu
select * from dbo.Player_schedule('World Pool Championship',N'DươngQuốc Hoàng')


CREATE FUNCTION total_player_price(
@year int,
@playerName nvarchar(50) )
returns table
as
return(
select 
player.id as [Player ID],
player.first_name+player.last_name as [Player name],
SUM(p.amount) as [Amount]
from 
Tournament t
inner join Prize p on p.tournament_id=t.id and YEAR(t.end_date)=@year
inner join Player_prize pp  on pp.prizeId=p.id
inner join Player player on player.id=pp.playerId
where player.first_name+player.last_name=@playerName
group by player.id ,player.first_name+player.last_name
)
--Thống kê tổng số tiền thưởng của mỗi người chơi trong một năm
select * from dbo.total_player_price(2024,N'DươngQuốc Hoàng')

--function lấy điểm của người trong trận đấu
CREATE FUNCTION getScore(@playerId INT, @matchId INT)
RETURNS INT
AS
BEGIN
    DECLARE @score INT;
    SELECT @score = 
        CASE 
            WHEN player1_id = @playerId THEN player1_score
            WHEN player2_id = @playerId THEN player2_score
            ELSE NULL
        END
    FROM tblMatch
    WHERE id = @matchId;
    RETURN @score;
END;

--triggerrrrrr
--trigger kiểm tra thông tin của statistic
create trigger trigger_rack_statistic
on rack_statistic for update
as
begin

--update khi có player break_end_run
	if UPDATE(break_and_run)
	begin
		update Rack set winner_id=i.player_id
		from inserted i
		inner join Rack r on r.rackId=i.rackId
	end
--UPDATE potted ball khi update break_num
	if UPDATE(break_num)
	BEGIN
		update rack_statistic set balls_potted=i.balls_potted+i.break_num
		from inserted i
		inner join Rack r on r.rackId=i.rackId
	END

	DECLARE @player2_balls_potted int;
	select @player2_balls_potted =rs.balls_potted
	from rack_statistic rs ,inserted i
	where rs.player_id !=i.player_id

	if exists(
		select *
		from inserted i
			inner join Rack r on r.rackId=i.rackId
		where @player2_balls_potted+i.balls_potted>9
	)
	begin
		ROLLBACK TRANSACTION;
		RAISERROR ('The number of balls potted by both player must under 9 .', 16, 1);
	end
	
end


--update score khi có người thắng 1 rack
create trigger trigger_rack_winner
on Rack for update
as
if UPDATE(winner_id)
begin
	DECLARE
	@matchWinnerId INT,
	@matchId INT, 
	@winnerId INT, 
	@firstTo INT,
	@cur_winner_score INT, 
	@prevRack INT;
	--gán giá trị cho các biến
	SELECT @matchId = match_id, @winnerId = i.winner_id, @prevRack = rack_num,@firstTo = first_to,@matchWinnerId=m.winner_id
    FROM inserted i 
	inner join tblMatch m on i.match_id=m.id;
	--cho trường hợp insert
	IF @winnerId IS NULL
    RETURN;
	--nếu match đã có người thắng thì không update nữa
	IF @matchWinnerId IS NOT NULL
	ROLLBACK TRANSACTION;
	RAISERROR ('Match completed! Player %d has won.', 16, 1, @matchWinnerId);
	RETURN;

	-- Kiểm tra nếu người thắng đã đạt đủ số điểm `first_to`
		SELECT @cur_winner_score = dbo.getScore(@winnerId, @matchId);
		IF @cur_winner_score >= @firstTo
        BEGIN
            -- Nếu đạt first_to, cập nhật winner_id trong bảng tblMatch
            UPDATE tblMatch
            SET winner_id = @winnerId, status = 'Completed'
            WHERE id = @matchId;
            RAISERROR ('Match completed! Player %d has won.', 16, 1, @winnerId);     
            RETURN; -- Kết thúc trigger
        END
	 -- Nếu chưa đạt first_to, tăng điểm cho người thắng
        UPDATE tblMatch
        SET 
            player1_score = CASE WHEN player1_id = @winnerId THEN player1_score + 1 ELSE player1_score END,
            player2_score = CASE WHEN player2_id = @winnerId THEN player2_score + 1 ELSE player2_score END
        WHERE id = @matchId;

        -- Kiểm tra lại điểm sau khi update
        SELECT @cur_winner_score = dbo.getScore(@winnerId, @matchId);

        -- Nếu người thắng đạt first_to sau khi tăng điểm, cập nhật winner_id của trận đấu
        IF @cur_winner_score >= @firstTo
        BEGIN
            UPDATE tblMatch
            SET winner_id = @winnerId, status = 'Completed'
            WHERE id = @matchId;

            RAISERROR ('Match completed! Player %d has won.', 16, 1, @winnerId);
            RETURN;
        END

        -- Nếu chưa đạt first_to, tạo rack mới
        EXEC SP_create_rack @matchId, @prevRack;

end

--trigger tạo trận mới khi winner_id duoc update
create trigger trigger_match_winner
on tblMatch for update
as
if update (winner_id)
begin
    DECLARE @matchId INT,@round NVARCHAR(50);
  
	SELECT @round=r.round_number,@matchId=i.id
	FROM Round r inner join inserted i on 
	r.id=i.round_id

	
	exec  SP_create_match @matchId,@round;
end

--procedure
 --tạo một rack mới khi rack này kết thúc
create proc SP_create_next_rack(@matchId int,@prevRack int)
as
begin 
	 -- Tạo rack mới với rack_num + 1 từ prevRack
    INSERT INTO Rack (rack_num, match_id, winner_id)
    VALUES (@prevRack + 1, @matchId, NULL);
end
--tạo một trận mới()
CREATE  PROCEDURE SP_create_match
    @prevMatch INT,        -- Trận đấu đã hoàn thành
    @prevRound NVARCHAR(50) -- Vòng đấu tiếp theo
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @winnerId INT, @tournamentId INT, @roundNumber INT, @newMatchDate DATE, @matchId INT,@prevRoundId int;

    -- Lấy thông tin từ trận trước
    SELECT @winnerId = winner_id, @tournamentId = tournament_id,@prevRoundId=round_id
    FROM tblMatch
    WHERE id = @prevMatch;

    -- Nếu trận trước chưa có winner thì không tạo trận mới
    IF @winnerId IS NULL
    BEGIN
        RAISERROR ('Previous match does not have a winner.', 16, 1);
        RETURN;
    END
	DECLARE  @nextRound NVARCHAR(50);
    SET @nextRound= CASE 
        WHEN @prevRound= 'Quarterfinals' THEN 'Semifinals' -- Nếu tứ kết thì lên bán kết
        WHEN @prevRound= 'Semifinals' THEN 'Grand Final'-- Nếu bán kết thì lên chung kết
        ELSE NULL
	END;
    IF @nextRound IS NULL
	begin
		RAISERROR ('This is the last round! %s.', 16, 1,@prevRound);
		RETURN;
	end

    -- Lấy số round tương ứng với @nextRound
    SELECT @roundNumber = r.id
    FROM Round r
    WHERE r.round_number= @nextRound and r.tournament_id=@tournamentId;

    -- Tìm ngày đấu cuối cùng của vòng trước
    SELECT @newMatchDate = MAX(match_date)
    FROM tblMatch
    WHERE round_id =@prevRoundId  AND tournament_id = @tournamentId;

    -- Nếu không có trận nào ở vòng trước, đặt ngày thi đấu mới là hôm nay + 2 ngày
    IF @newMatchDate IS NULL
        SET @newMatchDate = DATEADD(DAY, 2, GETDATE());
    ELSE
        SET @newMatchDate = DATEADD(DAY, 2, @newMatchDate);

    -- Tìm trận đấu có sẵn trong vòng tiếp theo
    SELECT TOP 1 @matchId = id
    FROM tblMatch
    WHERE round_id = @roundNumber AND tournament_id = @tournamentId AND player2_id IS NULL
    ORDER BY match_date ASC, id ASC;

    IF @matchId IS NOT NULL
    BEGIN
        -- Nếu có trận đấu sẵn, gán player2_id là winner của trận trước
        UPDATE tblMatch
        SET player2_id = @winnerId
        WHERE id = @matchId;
    END
    ELSE
    BEGIN
        -- Nếu không có trận nào trống, tạo trận mới với winner là player1_id
        INSERT INTO tblMatch (round_id, tournament_id, player1_id, player2_id, match_date, status,first_to)
        VALUES (@roundNumber, @tournamentId, @winnerId, NULL, @newMatchDate, 'Scheduled',3);
    END
END;

GO
--demo tạo add player mới vào tournament
INSERT INTO Register values
(1,2),
(2,2),
(3,2),
(4,2),
(5,2),
(6,2),
(7,2),
(8,2)
GO
INSERT INTO Round (tournament_id, round_number)
	VALUES
    (2, 'Quarterfinals'),
    (2, 'Semifinals'),
    (2, 'Grand Final');

SELECT * FROM ROUND where tournament_id=2
GO











