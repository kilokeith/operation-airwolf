color 		= require 'color'

arDrone 	= require 'ar-drone'
client  	= arDrone.createClient()

spawn 		= require('child_process').spawn
exec 		= require('child_process').exec

cmdr 		= require 'commander'

commands = 
	sko: (next=null) ->
		console.log 'sko'
		client.takeoff()

		client
			.after 5000, () ->
				console.log "beat drop"
				this.animateLeds('snakeGreenRed', 5, 2)
			# .after 1000, () ->
			# 	console.log "yawDance"
			# 	this.animate('yawDance', 15000)
			.after 1000, () ->
				console.log "beat drop"
				this.clockwise(-0.5)
				this.up(0.5)
			.after 1000, () ->
				console.log "beat drop"
				this.clockwise(0.5)
				this.down(0.5)
			.after 3000, () ->
				console.log "flipLeft"
				this.animate('flipLeft', 15)
			.after 3000, () ->
				console.log "flipReft"
				this.animate('flipRight', 15)
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

prompt()
