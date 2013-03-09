Twit 		= require 'twit'

#stream way
twitter = new Twit
	consumer_key: "SCZTAFZWXYihecad5eXuVA"
	consumer_secret: "4wEAbn6oUClrFJvocdUQNncZ9aRaMS7R7XU8q1m1k"
	access_token: "29282347-xd1HQ7dMHIdZFDER2QUPqYqsd7U6ixO7lScm2P8QQ"
	access_token_secret:  "Z7wRXCaT3Uqm7o54iSjK1Vl4VQRbdkolgtHUUxtUFco"

#run the search and reset timer
setup_tweet_stream = ->
	console.log 'setting up tweet_pipe', search
	stream = twitter.stream "user"

	stream.on "tweet", (tweet) ->
		#console.log 'incoming tweet', tweet
		if tweet?.text? and tweet.text.search('shake') >= -1 and tweet.text.search(/^RT/) is -1
			stream.emit "data", tweet.text + "\n"
			#do the dance
			

	stream.on "error", (error) ->
		console.log "Uh oh: " + error

	stream.on "end", ->
		console.log "Pipe ended. Restart!".red
		setup_tweet_stream()



