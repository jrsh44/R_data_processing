library(dplyr)


##      Task 1

dplyr_1 <- function(Users) {
    Users %>%
        filter(Location != "") %>% 
        group_by(Location) %>%
        summarise(TotalUpVotes = sum(UpVotes)) %>%
        arrange(desc(TotalUpVotes)) %>%
        top_n(10, TotalUpVotes)
}


##      Task 2

dplyr_2 <- function(Posts) {
    table <- filter(Posts, (PostTypeId == 1 | PostTypeId == 2))
    table <- data.frame(Year = substring(table$CreationDate, 1, 4),
                        Month = substring(table$CreationDate, 6, 7),
                        Score = table$Score)
    table <- group_by(table, Year, Month)
    temp <- slice(table, which.max(Score))
    table <- count(table, Year, Month)
    table  <- right_join(table, temp, by = c('Year','Month'))
    names(table)[c(3, 4)] <- c('PostsNumber','MaxScore')
    filter(table, PostsNumber > 1000)
}


##      Task 3

dplyr_3 <- function(Posts, Users){
    Posts %>%
        filter(PostTypeId == 1) %>%
        select(Id = OwnerUserId, ViewCount) %>%
        group_by(Id) %>%
        summarise(TotalViews = sum(ViewCount)) %>%
        right_join(data.frame(Id = Users$Id,DisplayName = Users$DisplayName),by = 'Id') %>%
        select(Id, DisplayName, TotalViews) %>%
        top_n(10, TotalViews) %>%
        arrange(desc(TotalViews))
}


##      Task 4

dplyr_4 <- function(Posts, Users){
    Users %>%
        select(Id, DisplayName, Location, Reputation, UpVotes, DownVotes) %>%
        right_join(Posts %>%
                    filter(PostTypeId == 2 & !is.na(OwnerUserId)) %>%
                    select(Id = OwnerUserId) %>%
                    count(Id) %>%
                    rename("AnswersNumber" = "n") %>%
                    left_join(Posts %>%
                                filter(PostTypeId == 1 & !is.na(OwnerUserId)) %>%
                                select(Id = OwnerUserId) %>%
                                count(Id) %>%
                                rename("QuestionsNumber" = "n"),
                                by = "Id") %>%
                    filter(AnswersNumber > QuestionsNumber) %>%
                    top_n(5, AnswersNumber),
                    by = "Id") %>%
        arrange(desc(AnswersNumber)) %>%
        .[, c('DisplayName', 'QuestionsNumber', 'AnswersNumber', 'Location', 'Reputation', 'UpVotes', 'DownVotes')]
}


##      Task 5

dplyr_5 <- function(Posts, Comments, Users){

    Users %>%
        left_join(Posts %>%
                filter(PostTypeId == 1) %>%
                select(PostId = Id, Id = OwnerUserId, Title, CommentCount, ViewCount) %>%
                left_join(Comments %>%
                                select(PostId, Score) %>%
                                group_by(PostId) %>%
                                summarise(CommentsTotalScore = sum(Score)),
                                by = "PostId"),
                                by = "Id") %>%
        select(Title, CommentCount, ViewCount, CommentsTotalScore, DisplayName, Reputation, Location) %>%
        top_n(10, CommentsTotalScore) %>%
        arrange(desc(CommentsTotalScore))
}

#   Function validation

dplyr::all_equal(sql_1(Users), dplyr_1(Users))
dplyr::all_equal(sql_2(Posts), dplyr_2(Posts))
dplyr::all_equal(sql_3(Posts, Users), dplyr_3(Posts, Users))
dplyr::all_equal(sql_4(Posts, Users), dplyr_4(Posts, Users))
dplyr::all_equal(sql_5(Posts, Comments, Users), dplyr_5(Posts, Comments, Users))