color 		= require 'color'
cmdr 		= require 'commander'
arDrone 	= require 'ar-drone'

vlc 		= require './vlc'

client  	= arDrone.createClient()


commands = 
	sko: (next=null) ->ewo
		console.log 'sko'

		#play mp3
		vlc('audio/shake.mp3')

		client.takeoff()

		client
			.after 5000, () ->
				console.log "beat drop"
				this.animateLeds('blinkGreen', 5, 2)

			.after 300, () ->
				console.log "beat drop"
				this.animateLeds('blinkRed', 5, 2)
				this.clockwise(-0.5)
				this.up(0.5)
				this.left(0.5)
				this.front(0.5)
			.after 300, () ->
				console.log "beat drop"
				this.clockwise(0.5)
				this.down(0.5)
				this.right(0.5)
				this.back(0.5)
			.after 300, () ->
				console.log "beat drop"
				this.animateLeds('blinkRed', 5, 2)
				this.clockwise(-0.5)
				this.up(0.5)
				this.left(0.5)
				this.front(0.5)
			.after 300, () ->
				console.log "beat drop"
				this.clockwise(0.5)
				this.down(0.5)
				this.right(0.5)
				this.back(0.5)
			.after 300, () ->
				console.log "beat drop"
				this.animateLeds('blinkRed', 5, 2)
				this.clockwise(-0.5)
				this.up(0.5)
				this.left(0.5)
				this.front(0.5)
			.after 300, () ->
				console.log "beat drop"
				this.clockwise(0.5)
				this.down(0.5)
				this.right(0.5)
				this.back(0.5)
			.after 300, () ->
				console.log "beat drop"
				this.animateLeds('blinkRed', 5, 2)
				this.clockwise(-0.5)
				this.up(0.5)
				this.left(0.5)
				this.front(0.5)
			.after 300, () ->
				console.log "beat drop"
				this.clockwise(0.5)
				this.down(0.5)
				this.right(0.5)
				this.back(0.5)
			.after 300, () ->
				console.log "beat drop"
				this.animateLeds('blinkRed', 5, 2)
				this.clockwise(-0.5)
				this.up(0.5)
				this.left(0.5)
				this.front(0.5)
			.after 300, () ->
				console.log "beat drop"
				this.clockwise(0.5)
				this.down(0.5)
				this.right(0.5)
				this.back(0.5)


			# .after 300, () ->
			# 	console.log "flipLeft"
			# 	this.animate('flipLeft', 15)
			# .after 300, () ->
			# 	console.log "flipReft"
			# 	this.animate('flipRight', 15)
			.after 2000, () ->
				this.stop()
				this.land()
		
		next() if next

	land: (next=null) ->
		console.log 'land'
		client.stop()
		client.land()
		next() if next
	
	exit: -> process.exit()

	crash: -> moo(func)

#logs battery
log_battery = (power) ->
	if power % 10 is 0
		console.log "#{power}%".red

#events for clients
client.on 'batteryChange', log_battery


#aliases
commands.fuck = commands.land
commands.die = commands.exit

#please land, oh dear lord
process.on 'exit', commands.land
process.on 'uncaughtException', commands.land



#prompt
prompt = ->
	cmdr.prompt 'what is thy bidding?: ', (cmd) ->
		console.log commands[cmd]
		if commands[cmd]
			commands[cmd].call(null, prompt) 
		else
			prompt()
bbvbvbvbvbbvbv
prompt()
