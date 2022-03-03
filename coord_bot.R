library("rtweet")

# Grab Coord – TODO
lat <- "30.329288"
long <- "-87.653162"

# Get Image
zoom <- 17
w <- 600
h <- 600
api_key <- Sys.getenv("MAPQUEST_API_TOKEN")
    
(img_url <- paste0(
  "https://www.mapquestapi.com/staticmap/v5/map?key=#",api_key,
  "&center=#",paste0(lon, ",", lat),
  "&zoom=",zoom,
  "&scalebar=false&traffic=false&size=",paste0(w, ",", h),
  "@2x&type=sat"
))

# Save in temp
temp_file <- tempfile()
download.file(img_url, temp_file)

# Token
coord_bot_token <- rtweet::create_token(
  app = "coord_bot",
  consumer_key = Sys.getenv("COORD_BOT_TWITTER_CONSUMER_API_KEY"),
  consumer_secret = Sys.getenv("COORD_BOT_TWITTER_CONSUMER_API_SECRET"),
  access_token = Sys.getenv("COORD_BOT_TWITTER_ACCESS_TOKEN"),
  access_secret = Sys.getenv("COORD_BOT_TWITTER_ACCESS_TOKEN_SECRET"),
  set_renv = FALSE
)

# Post Tweet
rtweet::post_tweet(
  status = paste0("Where am I?\nCoordbot image for ",Sys.Date, "\n#coordbot"),
  media = temp_file,
  token = coord_bot_token
)

