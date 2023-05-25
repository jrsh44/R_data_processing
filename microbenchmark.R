library(microbenchmark)


##      Task 1

microbenchmark::microbenchmark(
    sql = sql_1(Users),
    base = base_1(Users),
    dplyr = dplyr_1(Users),
    table = table_1(Users),
    times = 10)

#   Results of a test carried out for "times = 100"

# Unit: milliseconds
#   expr      min        lq      mean    median        uq      max neval
#    sql 218.0927 226.08225 237.56048 232.13610 246.39920 281.0746   100
#   base 158.1000 165.08320 178.63763 172.06015 184.18005 281.5125   100
#  dplyr  34.4166  36.96135  46.85809  38.80810  43.00335 196.5424   100
#  table  23.7926  25.38110  31.62233  26.39555  28.77620  91.0843   100


##      Task 2

microbenchmark::microbenchmark(
    sql = sql_2(Posts),
    base = base_2(Posts),
    dplyr = dplyr_2(Posts),
    table = table_2(Posts),
    times = 10)

#   Results of a test carried out for "times = 100"

# Unit: milliseconds
#   expr       min         lq       mean     median        uq       max neval
#    sql 1431.6430 1478.34150 1538.69154 1501.55340 1557.7308 2502.0638   100
#   base  255.0366  264.83605  300.11955  297.37200  314.0605  451.2084   100
#  dplyr   53.9659   55.88565   77.63357   60.88935   95.9672  234.1515   100
#  table   57.6096   99.48970  105.78727  104.27070  110.0534  251.0455   100


##      Task 3

microbenchmark::microbenchmark(
    sql = sql_3(Posts, Users),
    base = base_3(Posts, Users),
    dplyr = dplyr_3(Posts, Users),
    table = table_3(Posts, Users),
    times = 10)

#   Results of a test carried out for "times = 100"

#     Unit: milliseconds
#   expr       min         lq       mean     median        uq       max neval
#    sql 1710.1749 1768.21450 1887.34659 1836.78765 1923.6761 2793.3962   100
#   base  401.3966  420.57630  466.17252  460.23530  486.8613  702.4357   100
#  dplyr   85.3093  108.11195  132.35198  132.71720  143.3931  297.7806   100
#  table   22.2459   24.26875   28.45975   25.23875   27.0331   99.8315   100


##      Task 4

microbenchmark::microbenchmark(
    sql = sql_4(Posts, Users),
    base = base_4(Posts, Users),
    dplyr = dplyr_4(Posts, Users),
    table = table_4(Posts, Users),
    times = 10)

#   Results of a test carried out for "times = 100"

#     Unit: milliseconds
#   expr       min        lq       mean     median        uq       max neval
#    sql 1714.6749 1775.9108 1851.98834 1824.71100 1902.7885 2176.4625   100
#   base  620.0265  665.6301  703.75231  688.95885  729.5345  948.0758   100
#  dplyr  294.6541  329.4850  357.44668  350.53050  384.4424  550.2431   100
#  table   25.8610   28.6434   40.68562   30.05665   33.0122  228.7178   100


##      Task 5

microbenchmark::microbenchmark(
    sql = sql_5(Posts, Comments, Users),
    base = base_5(Posts, Comments, Users),
    dplyr = dplyr_5(Posts, Comments, Users),
    table = table_5(Posts, Comments, Users),
    times = 10)

#   Results of a test carried out for "times = 100"

#     Unit: milliseconds
#   expr       min        lq      mean    median        uq       max neval
#    sql 2064.5725 2158.0221 2242.8025 2214.4223 2274.2887 3074.4509   100
#   base 1317.7495 1423.2400 1493.9782 1453.3227 1545.5766 1868.3320   100
#  dplyr  243.8664  270.9872  320.8981  308.0462  338.6726  614.0736   100
#  table   80.1796   96.9455  133.5814  136.3904  147.9700  299.0290   100