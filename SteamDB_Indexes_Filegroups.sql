-- =============================================
-- Создание базы данных Steam
-- =============================================
CREATE DATABASE SteamDB;
GO

USE SteamDB;
GO

-- =============================================
-- 1. Таблица Разработчики (Developers)
-- =============================================
CREATE TABLE Developers (
    DeveloperID INT PRIMARY KEY IDENTITY(1,1),
    DeveloperName NVARCHAR(100) NOT NULL,
    Country NVARCHAR(50),
    FoundedDate DATE
);

-- =============================================
-- 2. Таблица Издатели (Publishers)
-- =============================================
CREATE TABLE Publishers (
    PublisherID INT PRIMARY KEY IDENTITY(1,1),
    PublisherName NVARCHAR(100) NOT NULL,
    Website NVARCHAR(200)
);

-- =============================================
-- 3. Таблица Жанры (Genres)
-- =============================================
CREATE TABLE Genres (
    GenreID INT PRIMARY KEY IDENTITY(1,1),
    GenreName NVARCHAR(50) NOT NULL UNIQUE
);

-- =============================================
-- 4. Таблица Игры (Games)
-- =============================================
CREATE TABLE Games (
    GameID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(200) NOT NULL,
    ReleaseDate DATE,
    Price DECIMAL(10, 2) DEFAULT 0.00 CHECK (Price >= 0), -- Ограничение DEFAULT и CHECK
    DeveloperID INT FOREIGN KEY REFERENCES Developers(DeveloperID),
    PublisherID INT FOREIGN KEY REFERENCES Publishers(PublisherID)
);

-- =============================================
-- 5. Таблица Связи Игр и Жанров (GameGenres) - Связь M:N
-- =============================================
CREATE TABLE GameGenres (
    GameID INT FOREIGN KEY REFERENCES Games(GameID),
    GenreID INT FOREIGN KEY REFERENCES Genres(GenreID),
    PRIMARY KEY (GameID, GenreID)
);

-- =============================================
-- 6. Таблица Пользователи (Users)
-- =============================================
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    RegistrationDate DATETIME DEFAULT GETDATE(), -- Ограничение DEFAULT
    IsActive BIT DEFAULT 1 -- Ограничение DEFAULT
);

-- =============================================
-- 7. Таблица Профили пользователей (UserProfiles) - Связь 1:1
-- =============================================
CREATE TABLE UserProfiles (
    UserID INT PRIMARY KEY FOREIGN KEY REFERENCES Users(UserID),
    RealName NVARCHAR(100),
    AvatarURL NVARCHAR(255),
    Bio NVARCHAR(500)
);

-- =============================================
-- 8. Таблица Достижения (Achievements)
-- =============================================
CREATE TABLE Achievements (
    AchievementID INT PRIMARY KEY IDENTITY(1,1),
    GameID INT FOREIGN KEY REFERENCES Games(GameID),
    AchievementName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Points INT DEFAULT 10 CHECK (Points > 0) -- Ограничение DEFAULT и CHECK
);

-- =============================================
-- 9. Таблица Достижения пользователей (UserAchievements) - Связь M:N
-- =============================================
CREATE TABLE UserAchievements (
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    AchievementID INT FOREIGN KEY REFERENCES Achievements(AchievementID),
    UnlockDate DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (UserID, AchievementID)
);

-- =============================================
-- 10. Таблица Обзоры (Reviews)
-- =============================================
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    GameID INT FOREIGN KEY REFERENCES Games(GameID),
    ReviewText NVARCHAR(MAX),
    IsRecommended BIT DEFAULT 1,
    ReviewDate DATETIME DEFAULT GETDATE(),
    Rating INT CHECK (Rating BETWEEN 1 AND 10) -- Ограничение CHECK
);

-- =============================================
-- 11. Таблица Друзья (Friends) - Связь M:N (Self-referencing)
-- =============================================
CREATE TABLE Friends (
    UserID1 INT FOREIGN KEY REFERENCES Users(UserID),
    UserID2 INT FOREIGN KEY REFERENCES Users(UserID),
    FriendshipDate DATE DEFAULT GETDATE(),
    PRIMARY KEY (UserID1, UserID2),
    CHECK (UserID1 <> UserID2) -- Нельзя добавить себя в друзья
);

-- =============================================
-- ЗАПОЛНЕНИЕ ТАБЛИЦ (INSERT)
-- =============================================

-- 1. Разработчики
INSERT INTO Developers (DeveloperName, Country, FoundedDate) VALUES 
('Valve', 'USA', '1996-01-01'),
('CD Projekt Red', 'Poland', '2002-05-01'),
('Rockstar Games', 'USA', '1998-01-01'),
('Mojang', 'Sweden', '2009-05-01'),
('Ubisoft', 'France', '1986-03-28'),
('Bethesda', 'USA', '1986-06-01');

-- 2. Издатели
INSERT INTO Publishers (PublisherName, Website) VALUES 
('Valve Corporation', 'valvesoftware.com'),
('CD Projekt', 'cdprojekt.com'),
('Take-Two Interactive', 'take2games.com'),
('Microsoft', 'microsoft.com'),
('Ubisoft', 'ubisoft.com'),
('Bethesda Softworks', 'bethesda.net');

-- 3. Жанры
INSERT INTO Genres (GenreName) VALUES 
('Action'), ('Adventure'), ('RPG'), ('Simulation'), ('Strategy'), ('Indie');

-- 4. Игры
INSERT INTO Games (Title, ReleaseDate, Price, DeveloperID, PublisherID) VALUES 
('Half-Life 2', '2004-11-16', 9.99, 1, 1),
('The Witcher 3', '2015-05-19', 29.99, 2, 2),
('GTA V', '2013-09-17', 19.99, 3, 3),
('Minecraft', '2011-11-18', 26.95, 4, 4),
('Assassin''s Creed Valhalla', '2020-11-10', 59.99, 5, 5),
('Skyrim', '2011-11-11', 39.99, 6, 6);

-- 5. Связь Игр и Жанров (M:N)
INSERT INTO GameGenres (GameID, GenreID) VALUES 
(1, 1), (1, 2), -- Half-Life 2: Action, Adventure
(2, 3), (2, 2), -- Witcher 3: RPG, Adventure
(3, 1), (3, 2), -- GTA V: Action, Adventure
(4, 4), (4, 6), -- Minecraft: Simulation, Indie
(5, 1), (5, 3), -- AC Valhalla: Action, RPG
(6, 3), (6, 2); -- Skyrim: RPG, Adventure

-- 6. Пользователи
INSERT INTO Users (Username, Email) VALUES 
('GamerPro', 'pro@mail.com'),
('NoobMaster', 'noob@mail.com'),
('SniperWolf', 'wolf@mail.com'),
('PuzzleKing', 'puzzle@mail.com'),
('RPG_Lover', 'rpg@mail.com'),
('SpeedRunner', 'fast@mail.com');

-- 7. Профили (1:1)
INSERT INTO UserProfiles (UserID, RealName, AvatarURL, Bio) VALUES 
(1, 'John Doe', 'avatar1.jpg', 'Love FPS games'),
(2, 'Jane Smith', 'avatar2.jpg', 'Just started gaming'),
(3, 'Mike Ross', 'avatar3.jpg', 'Sniper expert'),
(4, 'Sarah Connor', 'avatar4.jpg', 'Puzzle solver'),
(5, 'Alice Wonder', 'avatar5.jpg', 'RPG addict'),
(6, 'Bob Builder', 'avatar6.jpg', 'Speedrun everything');

-- 8. Достижения
INSERT INTO Achievements (GameID, AchievementName, Description, Points) VALUES 
(1, 'Lambda Locator', 'Find all lambda caches', 50),
(1, 'Zombie Chopper', 'Kill 100 zombies', 20),
(2, 'Geralt of Rivia', 'Complete the game on Death March', 100),
(3, 'Los Santos Legend', 'Complete all missions', 80),
(4, 'The End?', 'Kill the Ender Dragon', 90),
(6, 'Dragonborn', 'Defeat Alduin', 100);

-- 9. Достижения пользователей (M:N)
INSERT INTO UserAchievements (UserID, AchievementID) VALUES 
(1, 1), (1, 2), -- GamerPro
(2, 5), -- NoobMaster
(3, 3), -- SniperWolf
(4, 4), -- PuzzleKing
(5, 6), -- RPG_Lover
(6, 1); -- SpeedRunner

-- 10. Обзоры
INSERT INTO Reviews (UserID, GameID, ReviewText, IsRecommended, Rating) VALUES 
(1, 1, 'Best game ever!', 1, 10),
(2, 4, 'Very addictive.', 1, 9),
(3, 3, 'Good story, but online is toxic.', 0, 7),
(4, 2, 'Masterpiece RPG.', 1, 10),
(5, 6, 'Classic.', 1, 9),
(6, 1, 'Speedrun ready.', 1, 8);

-- 11. Друзья (M:N)
INSERT INTO Friends (UserID1, UserID2) VALUES 
(1, 2), (1, 3), (2, 4), (3, 5), (4, 6), (5, 1);

-- =============================================
-- ЗАПРОСЫ SELECT ДЛЯ ПРОВЕРКИ
-- =============================================

-- 1. Вывести все игры с их разработчиками и издателями
SELECT g.Title, d.DeveloperName, p.PublisherName, g.Price
FROM Games g
JOIN Developers d ON g.DeveloperID = d.DeveloperID
JOIN Publishers p ON g.PublisherID = p.PublisherID;

-- 2. Вывести список всех пользователей и их реальные имена (через 1:1)
SELECT u.Username, u.Email, up.RealName
FROM Users u
JOIN UserProfiles up ON u.UserID = up.UserID;

-- 3. Вывести все игры и их жанры (M:N)
SELECT g.Title, gen.GenreName
FROM Games g
JOIN GameGenres gg ON g.GameID = gg.GameID
JOIN Genres gen ON gg.GenreID = gen.GenreID
ORDER BY g.Title;

-- 4. Вывести список друзей пользователя 'GamerPro' (UserID = 1)
SELECT u1.Username AS UserName, u2.Username AS FriendName
FROM Friends f
JOIN Users u1 ON f.UserID1 = u1.UserID
JOIN Users u2 ON f.UserID2 = u2.UserID
WHERE u1.UserID = 1;

-- 5. Вывести средний рейтинг для каждой игры
SELECT g.Title, AVG(CAST(r.Rating AS DECIMAL(10,2))) AS AverageRating
FROM Games g
JOIN Reviews r ON g.GameID = r.GameID
GROUP BY g.Title;