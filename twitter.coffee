twitter 	= require 'ntwitter'
Twit 		= require 'twit'

# #search every 10 seconds
# search_interval = 1 * 10 * 1000
# search_timer = null

# #keys
# twit = new twitter
# 	consumer_key: "SCZTAFZWXYihecad5eXuVA"
# 	consumer_secret: "4wEAbn6oUClrFJvocdUQNncZ9aRaMS7R7XU8q1m1k"

# search_twitter = () ->
# 	console.log 'searching twitter'
# 	search_str = "#harlemshake AND -rt"
# 	twit.search search_str, {rpp:100}, (err, data) ->
# 		unless err or data.length is 0
# 			console.log 'incoming tweets'
# 			#console.log data.results

# #set a timer to search
# set_search_timer = ->
# 	search_timer = setTimeout do_search, search_interval

# #run the search and reset timer
# do_search = ->
# 	clearTimeout search_timer if search_timer
# 	twitter.search_twitter()
# 	set_search_timer()


#stream way
twitter = new Twit
	consumer_key: "SCZTAFZWXYihecad5eXuVA"
	consumer_secret: "4wEAbn6oUClrFJvocdUQNncZ9aRaMS7R7XU8q1m1k"

#run the search and reset timer
setup_tweet_stream = ->
	console.log 'setting up tweet_pipe', search
	stream = twitter.stream "statuses/filter", {track: '#harlemshake'}

	stream.on "tweet", (tweet) ->
		#console.log 'incoming tweet', tweet
		if tweet?.text? and tweet.text.search(/^RT/) is -1
			stream.emit "data", tweet.text + "\n"
			#do the dance
			

	stream.on "error", (error) ->
		console.log "Uh oh: " + error

	stream.on "end", ->
		console.log "Pipe ended. Restart!".red
		setup_tweet_stream()



