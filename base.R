
##      Task 1

base_1 <- function(Users) {
    table <- Users[Users$Location != "", c("Location", "UpVotes")]
    table <- aggregate(UpVotes ~ Location, table, sum)
    table <- head(table[order(table[, 2], decreasing = TRUE), ], 10)
    colnames(table)[2] <- "TotalUpVotes"
    rownames(table) <- 1:length(table[ ,1])
    table
}


##      Task 2

base_2 <- function(Posts){
    table <- Posts[(Posts$PostTypeId == 1 | Posts$PostTypeId == 2), ]
    table <- data.frame(
                Year = substring(table$CreationDate, 1, 4),
                Month = substring(table$CreationDate, 6, 7),
                PostsNumber = rep(1, times = length(table$Score)),
                MaxScore = table$Score)
    table <- merge(
        x = aggregate(PostsNumber ~ Year + Month, data = table, sum),
        y = aggregate(MaxScore ~ Year + Month, data = table, max),
        by = c("Year", "Month"),
        all.x = T)
    table <- table[table$PostsNumber > 1000, ]
    table$PostsNumber <- as.integer(table$PostsNumber)
    table$MaxScore <- as.integer(table$MaxScore)
    rownames(table) <- 1:length(table$MaxScore)
    table
}


##      Task 3

base_3 <- function(Posts, Users){
    table <- data.frame(Id = Posts$OwnerUserId,
                    TotalViews = Posts$ViewCount)[Posts$PostTypeId == 1, ]
    table <- aggregate(TotalViews ~ Id, table, sum)
    table <- merge(x = table,
                y = data.frame(Id = Users$Id, DisplayName = Users$DisplayName),
                by = "Id", all.x = TRUE)
    table <- table[, c(1, 3, 2)]
    head(table[order(table[, 3], decreasing = TRUE), ], 10)
}


##      Task 4

base_4 <- function(Posts, Users){
    ans <- Posts[Posts$PostTypeId == 2, ]
    ans <- data.frame(OwnerUserId = ans$OwnerUserId,
                        AnswersNumber = rep(1, times=length(ans[, 1])))
    ans <- aggregate(AnswersNumber ~ OwnerUserId, ans, sum)
    ans$AnswersNumber <- as.integer(ans$AnswersNumber)
    que <- Posts[Posts$PostTypeId == 1, ]
    que <- data.frame(OwnerUserId = que$OwnerUserId,
                        QuestionsNumber = rep(1, times=length(que[, 1])))
    que <- aggregate(QuestionsNumber ~ OwnerUserId, que, sum)
    que$QuestionsNumber <- as.integer(que$QuestionsNumber)
    result <- merge(x = ans, y = que, by = "OwnerUserId", all.x = TRUE)
    result <- result[result$AnswersNumber > result$QuestionsNumber, ]
    result <- head(result[order(result$AnswersNumber, decreasing = TRUE), ], 5)
    temp <- Users[, c("Id","DisplayName","Location","Reputation","UpVotes","DownVotes")]
    names(temp)[1] <- "OwnerUserId"
    result <- merge(x = result, y = temp, by = "OwnerUserId", all.x = TRUE)
    result <- result[order(result$AnswersNumber, decreasing = TRUE), c('DisplayName', 'QuestionsNumber', 'AnswersNumber', 'Location', 'Reputation', 'UpVotes', 'DownVotes')]
    head(result, 5)
}


##      Task 5

base_5 <- function(Posts, Comments, Users){
    table <- data.frame(Id = Comments$PostId, CommentsTotalScore = Comments$Score)
    table <- aggregate(CommentsTotalScore ~ Id, table, sum)
    table <- merge(x = table,
                y = Posts[Posts$PostTypeId == 1 & !is.na(Posts$OwnerUserId), c("Id", "OwnerUserId", "Title", "CommentCount", "ViewCount")],
                by = "Id",
                all.y = TRUE)
    table <- table[c("OwnerUserId", "Title", "CommentCount", "ViewCount", "CommentsTotalScore")]
    colnames(table)[1] <- "Id"
    table <- merge(x = table,
                y = Users[, c("Id","DisplayName", "Reputation", "Location")],
                by = "Id",
                all.x = TRUE)
    table <- table[c("Title", "CommentCount", "ViewCount", "CommentsTotalScore", "DisplayName", "Reputation", "Location")]
    head(table[order(table$CommentsTotalScore, decreasing = TRUE), ], 10)
}


#   Function validation

dplyr::all_equal(sql_1(Users), base_1(Users))
dplyr::all_equal(sql_2(Posts), base_2(Posts))
dplyr::all_equal(sql_3(Posts, Users), base_3(Posts, Users))
dplyr::all_equal(sql_4(Posts, Users), base_4(Posts, Users))
dplyr::all_equal(sql_5(Posts, Comments, Users), base_5(Posts, Comments, Users))
