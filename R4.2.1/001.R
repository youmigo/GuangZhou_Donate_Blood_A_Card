# Thu Jul 21 16:00:11 2022 edit
# 字符编码：UTF-8
# R 版本：R 4.2.1 x64 for window 11
# cgh163email@163.com
# 个人笔记不负责任，拎了个梨🍐🍈
#.rs.restartR()
require(leaflet)
require(leafletCN)
library(crosstalk)

require(leafpop)
library(DT)
require(leafem)
rm(list = ls());gc()

dt <- read.csv("data/广州优待证A卡免费旅游景点.csv",header = TRUE)
dt |> View()
names(dt) <- c('id','name','lng','lat')

#数据读取区bate Thu Apr  7 01:24:32 2022 ------------------------------
gz.map <-  'https://geo.datav.aliyun.com/areas_v3/bound/geojson?code=440100_full' |> sf::st_read()

#出图 Thu Jul 21 17:13:24 2022 ------------------------------

dtfrm <- datatable(dt)
dtfrm
dtsd <- SharedData$new(dtfrm);kittyR::meowR(sound = 4)#猫叫🐱

mp <-
leaflet(data = dtsd) |> amap() |>
  # addTiles() |>
  addPolylines(data =gz.map,
               color = '#CC6699'
  ) |>
  addCircleMarkers(
    lat = ~ lat,
    lng = ~ lng,
    popup = ~ name,
    color = colorRampPalette(
      c('#99CCFF', '#996600'))(dtsd$data() |>nrow())
    , clusterOptions = markerClusterOptions() #  放遮盖
  ) |>
  addMarkers(
    lat = ~ lat,
    lng = ~ lng,
    popup = ~ name,
    # color = colorRampPalette(
    #   c('#336666', '#996600'))(dtsd$data() |>nrow())
    # ,clusterOptions = markerClusterOptions() #  放遮盖
  )
mp


bscols(
 mp,dtfrm
)
