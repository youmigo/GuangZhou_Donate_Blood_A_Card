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

dt <- readr::read_csv("data/高德坐标拾取原始数据.csv")#,header = TRUE)
dt |> head()
names(dt) <- c('id','name','lng','lat')

#数据读取区bate Thu Apr  7 01:24:32 2022 ------------------------------
gz.map <-  'https://geo.datav.aliyun.com/areas_v3/bound/geojson?code=440100_full' |> sf::st_read();kittyR::meowR(sound = 4)#猫叫🐱

#出图 Thu Jul 21 17:13:24 2022 ------------------------------
vignette(dt[,1:2])
dtfrm <- datatable(dt[,1:2])
dtfrm
dtsd <- SharedData$new(dt)
#pop标签 Tue Jul 26 01:52:22 2022 ------------------------------
greenLeafIcon <- makeIcon(
  iconUrl = "https://s1.ax1x.com/2020/09/23/wvD929.png",
  iconWidth = 28, iconHeight = 48,
  iconAnchorX = 15, iconAnchorY = 45,
  # shadowUrl = "https://s1.ax1x.com/2020/09/23/wvD929.png",
  # shadowWidth = 50, shadowHeight = 64,
  # shadowAnchorX = 4, shadowAnchorY = 62
)
# Tue Jul 26 01:52:49 2022 ---

mp <-
  leaflet(data = dtsd) |>
  amap() |>
  # addTiles() |>
  addPolygons(data = gz.map,
              fillColor = rainbow(11)
              ,color = 'green') |>
  addCircleMarkers(
    # data = dtsd,
    lat = ~ lat,
    lng = ~ lng,
    popup = ~ name,
    color = 'green'
    #   colorRampPalette(
    #   c('#99CCFF', '#996600'))(dt |>nrow()) #  按行数生成颜色数
    , clusterOptions = markerClusterOptions() #  放遮盖
  ) |>
  addMarkers(
    # data = dtsd,
    lat = ~ lat,
    lng = ~ lng,
    popup = ~ name
    # ,icon = greenLeafIcon
  )
mp

htmlwidgets::saveWidget(mp, file='web/leafletHTML.html')


bshtml <- bscols(mp,dtfrm)
bshtml
htmlwidgets::saveWidget(bshtml, file='web/index.html')


saveRDS(dt,'dt.rds')
