# Wed Jun  7 16:58:44 2023 edit
# 字符编码：UTF-8
# R 版本：R 4.1.1 x64 for window 11
# cgh163email@163.com
# 个人笔记不负责任，拎了个梨🍐🍈
#.rs.restartR()
#devtools::install_github("r-spatial/leafpop")
require(leaflet)
require(leafletCN)
require(leafpop)

rm(list = ls());gc()

dt <- readRDS('R4.2.1/dt.rds');head(dt)

leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data = breweries91,
                   popup = popupTable(breweries91))
breweries91@data |> DT::datatable()

leaflet() |> amap() |>
  addPopups(115,23,'tmp')

leaflet() |> amap() |>
  addPopups(115,23, "<a href='http://www.brauerei-ott.de' target=\"_blank\">显示的文字</a>")
#处理为超链接 Wed Jun  7 17:04:15 2023 ------------------------------
dt <- tidyr::unite( dt,"xy",lng,lat,sep = ",",remove = F)
# uri.amap.com/marker?position=121.287689,31.234527&name=测试&src=🍐&coordinate=&callnative=1

# Wed Jun  7 17:13:08 2023 --
xy <- dt[2,3]
label <- dt[2,2]
amapurl <-
  paste0("https://uri.amap.com/marker?position=",
         xy,
         '&name=',
         label,
         '&src=🍐&coordinate=&callnative=1'
         )
lealabel <-
paste0(
  "<a href='",
  amapurl,
  '[\']target=\"_blank\">',
  label,
  "</a>"
)
lealabel
# ltmp <- paste0(
#   "<a href='",
#   "https://surl.amap.com/UsqJjB1ggm5",
#   '\']target=\"_blank\">',
#   label,
#   "</a>"
# )
leaflet() |> amap() |>
  addPopups(115,23, lealabel)

demomap('广州') |> addPopups(lng = dt[2,4] |> as.numeric(),lat = dt[2,5] |> as.numeric(),lealabel)

leaflet() |> amap() |>
  addPopups(115,23, lealabel) |>
  htmlwidgets::saveWidget( file='index.html')


