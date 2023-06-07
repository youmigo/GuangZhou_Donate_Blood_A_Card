# Wed Jun  7 19:25:37 2023 edit
# 字符编码：UTF-8
# R 版本：R 4.1.1 x64 for window 11
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

#数据读取区bate Thu Apr  7 01:24:32 2022 ------------------------------
gz.map <-  'https://geo.datav.aliyun.com/areas_v3/bound/geojson?code=440100_full' |> sf::st_read();kittyR::meowR(sound = 4)#猫叫🐱
#读取坐标数据 Wed Jun  7 19:49:20 2023 ------------------------------
dt <- readr::read_csv("data/高德坐标拾取原始数据.csv")#,header = TRUE)
dt |> head()
names(dt) <- c('id','name','lng','lat')


#准备数据 Wed Jun  7 19:27:50 2023 ------------------------------
dt <- tidyr::unite( dt,"xy",lng,lat,sep = ",",remove = F)
xy <- dt[,3]
label <- dt[,2]
amapurl <-
  data.frame( "<a href='",
              "https://uri.amap.com/marker?position=",
         xy,
         '&name=',
         label,
         '&src=🍐&coordinate=&callnative=1',
         '[\']target=\"_blank\">',
         label,
         "</a>"  )
names(amapurl) <- letters[1:length(amapurl)]
amapurl |>
  datatable()
# Wed Jun  7 19:46:23 2023 --
dt <-  tidyr::unite(amapurl,"laburl",names(amapurl),sep = "",remove = T) |> cbind(dt)

DT::datatable(dt)
rm(xy,amapurl,label)
dt <- dt[,-4]
dt <- dt[,-2]
#出图 Thu Jul 21 17:13:24 2022 ------------------------------


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
myicon <- makeIcon(iconUrl = "web/icon.svg",
                       iconWidth = 50.45, iconHeight = 50.20)
# Wed Jun  7 20:10:34 2023 --

mp <-
  leaflet(data = dtsd) |>
  amap() |>
  # addTiles() |>
  addPolygons(data = gz.map,
              fillColor = rainbow(11)
              ,color = 'green') |>
  addCircleMarkers( #底圈，用于分类。
    # data = dtsd,
    lat = ~ lat,
    lng = ~ lng,
    popup = ~ name,
    color = 'green'
# ,      colorRampPalette(
#       c('#99CCFF', '#996600'))(dt |>nrow()) #  按行数生成颜色数
    , clusterOptions = markerClusterOptions() #  放遮盖
  ) |>
  addMarkers( #标注点
    # data = dtsd,
    lat = ~ lat,
    lng = ~ lng,
    popup = ~ laburl
    ,icon = myicon #  pop图表ico
  )
mp

htmlwidgets::saveWidget(mp, file='web/leaflet.html')
#合并表格和地图 Wed Jun  7 20:19:49 2023 ------------------------------
dtfrm <- datatable(data.frame(name=dt[,2])) |>
  formatStyle('name',  color = '#663366', backgroundColor = '#F2F2F2', fontWeight = 'bold')
dtfrm

bshtml <-
bscols(
  widths = c(4,8),
dtfrm,mp
, device = c( "lg"))#"xs", "sm", "md",

bshtml
# htmlwidgets::saveWidget(bshtml, file='web/index.html')

#end Wed Jun  7 20:53:05 2023 --

