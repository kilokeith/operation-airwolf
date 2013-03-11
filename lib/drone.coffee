colors	 	= require 'colors'
arDrone 	= require 'ar-drone'


module.exports = do() ->

	###
		config = {ip, name}
	###
	return class Done
		constructor: (@config, @sequence=[], @timer) ->
			@client = arDrone.createClient(@config)
			#enable shit
			@client.config('general:navdata_demo', 'FALSE')
			#events for clients
			@client.on 'batteryChange', @log_battery

		queue_animation_times: () =>
			times = 0
			#queue animations
			@queue = @sequence.map (i) =>
				times += i[0]
				params =
					interval: i[0]
					command: i[1]
					duration: i[2]
					led: i[3]
					timing: times
				@timer.after "#{params.timing} ms", => @command(params)
				params
			@queue

		command: (i) =>
			duration = i.duration
			console.log "command", "[#{@config.name}]", i
			switch i.command
				when 'takeoff' then @client.takeoff()
				when 'land' then @land()
				when 'stop' then @client.stop()
				when 'up' then @client.up(duration)
				when 'down' then @client.down(duration)
				when 'clockwise' then @client.clockwise(duration)
				when 'counterClockwise' then @client.counterClockwise(duration)
				when 'front' then @client.front(duration)
				when 'back' then @client.back(duration)
				when 'left' then @client.left(duration)
				when 'right' then @client.right(duration)
				else 
					@client.animate(i.command, duration)
					@client.animateLeds(i.led, 2, 2)
		land: () =>
			@client.stop()
			@client.land()

		log_battery: (power) =>
			if power % 5 is 0
				console.log "[#{@config.name}] power level: #{power}%".red

