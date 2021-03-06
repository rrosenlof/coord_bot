library("rtweet")
library("rjson")

# Grab Coord
coords <- fromJSON(file="./coords.json", simplify=FALSE)
coord <- sample(coords, 1) # TODO: Ensure no repeats -> remove coord from list?
lat <- coord[[1]][['latitude']]
long <- coord[[1]][['longitude']]
print(paste0("LAT: ", lat, " & LONG: ", long))

# Get Image
zoom <- 14
w <- 600
h <- 600
api_key <- Sys.getenv("MAPQUEST_API_TOKEN")
    
(img_url <- paste0(
  "https://www.mapquestapi.com/staticmap/v5/map?key=",api_key,
  "&center=",paste0(lat, ",", long),
  "&zoom=",zoom,
  "&scalebar=false&traffic=false&size=",paste0(w, ",", h),
  "@2x&type=sat"
))

print(paste0("IMAGE: ",img_url))

# Save in temp
temp_file <- tempfile()
download.file(img_url, temp_file)

# Token
coord_bot_token <- rtweet::create_token(
  app = "coord_bot",
  consumer_key = Sys.getenv("COORD_BOT_TWITTER_CONSUMER_API_KEY"),
  consumer_secret = Sys.getenv("COORD_BOT_TWITTER_CONSUMER_API_SECRET"),
  access_token = Sys.getenv("COORD_BOT_TWITTER_ACCESS_TOKEN"),
  access_secret = Sys.getenv("COORD_BOT_TWITTER_ACCESS_TOKEN_SECRET")
)

# Post Tweet
today = format(Sys.Date(), format="%b %d %Y")
rtweet::post_tweet(
  status = paste0("Where am I?\nCoordbot image for ", today, "\n#coordbot"),
  media = temp_file,
  token = coord_bot_token
)

