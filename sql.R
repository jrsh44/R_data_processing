library(sqldf)


##      Task 1

sql_1 <- function(Users) {
    sqldf::sqldf("
        SELECT Location, SUM(UpVotes) as TotalUpVotes
        FROM Users
        WHERE Location != ''
        GROUP BY Location
        ORDER BY TotalUpVotes DESC
        LIMIT 10
    ")
}


##      Task 2

sql_2 <- function(Posts){
    sqldf::sqldf("
        SELECT STRFTIME('%Y', CreationDate) AS Year, STRFTIME('%m', CreationDate) AS Month,
            COUNT(*) AS PostsNumber, MAX(Score) AS MaxScore
        FROM Posts
        WHERE PostTypeId IN (1, 2)
        GROUP BY Year, Month
        HAVING PostsNumber > 1000
    ")
}


##      Task 3

sql_3 <- function(Posts, Users) {
     Questions <- sqldf( 'SELECT OwnerUserId, SUM(ViewCount) as TotalViews
                                      FROM Posts
                                      WHERE PostTypeId = 1
                                      GROUP BY OwnerUserId' )
     sqldf( "SELECT Id, DisplayName, TotalViews
                FROM Questions
                JOIN Users
                ON Users.Id = Questions.OwnerUserId
                ORDER BY TotalViews DESC
                LIMIT 10")
}


##      Task 4

sql_4 <- function(Posts, Users){
    sqldf::sqldf("
        SELECT DisplayName, QuestionsNumber, AnswersNumber, Location, Reputation, UpVotes, DownVotes
        FROM (
            SELECT *
            FROM (
                    SELECT COUNT(*) as AnswersNumber, OwnerUserId
                    FROM Posts
                    WHERE PostTypeId = 2
                    GROUP BY OwnerUserId
                ) AS Answers
            JOIN
                (
                    SELECT COUNT(*) as QuestionsNumber, OwnerUserId
                    FROM Posts
                    WHERE PostTypeId = 1
                    GROUP BY OwnerUserId
                ) AS Questions
                ON Answers.OwnerUserId = Questions.OwnerUserId
                WHERE AnswersNumber > QuestionsNumber
                ORDER BY AnswersNumber DESC
                LIMIT 5
            ) AS PostsCounts
        JOIN Users
        ON PostsCounts.OwnerUserId = Users.Id
    ")
}


##      Task 5

sql_5 <- function(Posts, Comments, Users){
    PostsBestComments <- sqldf::sqldf("
                                        SELECT Posts.OwnerUserId, Posts.Title, Posts.CommentCount, Posts.ViewCount,
                                                CmtTotScr.CommentsTotalScore
                                        FROM (
                                                SELECT PostId, SUM(Score) AS CommentsTotalScore
                                                FROM Comments
                                                GROUP BY PostId
                                            ) AS CmtTotScr
                                        JOIN Posts ON Posts.Id = CmtTotScr.PostId
                                        WHERE Posts.PostTypeId=1")
    sqldf::sqldf("
        SELECT Title, CommentCount, ViewCount, CommentsTotalScore, DisplayName, Reputation, Location
        FROM PostsBestComments
        JOIN Users ON PostsBestComments.OwnerUserId = Users.Id
        ORDER BY CommentsTotalScore DESC
        LIMIT 10
    ")
}