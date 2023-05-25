library(data.table)

##      Task 1

table_1 <- function(Users) {
    table <- data.table(Users)
    table <- table[Location != "", .(sum(UpVotes)), by = .(Location)]
    colnames(table) <- c("Location", "TotalUpVotes")
    table <- table[order(-TotalUpVotes, Location)]
    head(table, 10)
}


##      Task 2

table_2 <- function(Posts){
    table <- data.table(Posts[Posts$PostTypeId == 1 | Posts$PostTypeId == 2, ])
    table <- data.table(Year = substring(table$CreationDate, 1, 4),
                    Month = substring(table$CreationDate, 6, 7),
                    MaxScore = table$Score)
    table <- table[, .(PostsNumber = .N, MaxScore = max(MaxScore)), by = .(Year, Month)]
    table[PostsNumber > 1000]
}


##      Task 3

table_3 <- function(Posts, Users){
    table <- data.table(Posts[(Posts$PostTypeId == 1 & !is.na(Posts$OwnerUserId)), c('OwnerUserId','ViewCount')])
    table <- table[, .(sum(ViewCount, na.rm = TRUE)), by = .(OwnerUserId)]
    colnames(table) <- c("Id", "TotalViews")
    table <- merge(table, data.table(Users[,c('Id','DisplayName')]),by = 'Id',all.x = TRUE)[, c(1, 3, 2)]
    head(table[order(table[, 3], decreasing = TRUE), ], 10)
}


##      Task 4

table_4 <- function(Posts, Users){
    ans <- data.table(Posts[Posts$PostTypeId == 2 & !is.na(Posts$OwnerUserId), "OwnerUserId"])
    colnames(ans) <- c("Id")
    ans <- ans[, .(AnswersNumber = .N), by = .(Id)]
    que <- data.table(Posts[Posts$PostTypeId == 1 & !is.na(Posts$OwnerUserId), "OwnerUserId"])
    colnames(que) <- c("Id")
    que <- que[, .(QuestionsNumber = .N), by = .(Id)]
    comb <- merge(ans, que, by="Id", all.x = TRUE)
    comb <- comb[AnswersNumber > QuestionsNumber]
    table <- data.table(Users[, c("Id","DisplayName", "Location", "Reputation", "UpVotes", "DownVotes")])
    table <- merge(table, head(comb[order(comb[, 2], decreasing = TRUE), ], 5), by = "Id", all.y = TRUE)
    table <- table[, c('DisplayName', 'QuestionsNumber', 'AnswersNumber', 'Location', 'Reputation', 'UpVotes', 'DownVotes')]
    table[order(table$AnswersNumber, decreasing = TRUE), ]
}


##      Task 5

table_5 <- function(Posts, Comments, Users){
    table <- data.table(Comments[c("PostId", "Score")])
    colnames(table) <- c("Id", "Score")
    table <- table[, .(CommentsTotalScore = sum(Score)), by = .(Id)]
    table <- merge(x = table,
                y = data.table(Posts[Posts$PostTypeId==1 ,c("Id","OwnerUserId","Title","CommentCount","ViewCount")]),
                by = "Id",
                all.y = TRUE)
    table <- table[, -1]
    colnames(table)[2] <- c("Id")
    table <- merge(x = table,
                y = data.table(Users[c("Id","DisplayName","Reputation","Location")]),
                by = "Id",
                all.y = TRUE)
    head(table[order(table[, "CommentsTotalScore"], decreasing = TRUE), c("Title", "CommentCount", "ViewCount", "CommentsTotalScore", "DisplayName", "Reputation", "Location")], 10)
}


#   Function validation

dplyr::all_equal(sql_1(Users), table_1(Users))
dplyr::all_equal(sql_2(Posts), table_2(Posts))
dplyr::all_equal(sql_3(Posts, Users), table_3(Posts, Users))
dplyr::all_equal(sql_4(Posts, Users), table_4(Posts, Users))
dplyr::all_equal(sql_5(Posts, Comments, Users), table_5(Posts, Comments, Users))
