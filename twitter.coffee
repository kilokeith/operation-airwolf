Twit 		= require 'twit'

#stream config
twitter = new Twit
	consumer_key: "SCZTAFZWXYihecad5eXuVA"
	consumer_secret: "4wEAbn6oUClrFJvocdUQNncZ9aRaMS7R7XU8q1m1k"
	

module.exports = do() ->
	console.log 'setting up tweet_pipe', search
	stream = twitter.stream "user"

	stream.on "tweet", (tweet) ->
		#console.log 'incoming tweet', tweet
		if tweet?.text? and tweet.text.search('shake') >= -1 and tweet.text.search(/^RT/) is -1
			stream.emit "data", tweet.text + "\n"
			#do the dance
			stream.emit "got_tweet"
			

	stream.on "error", (error) ->
		console.log "Uh oh: " + error

	stream.on "end", ->
		console.log "Pipe ended. Restart!".red
		setup_tweet_stream()


	return stream