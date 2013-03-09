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
				this.clockwise(0.5)
			.after 3000, () ->
				this.stop()
				this.land()
		
		next() if next

	land: (next=null) ->
		console.log 'land'
		client.stop()
		client.land()
		next() if next

	
	exit: -> process.exit()


#aliases
commands.fuck = commands.land
commands.die = commands.exit


#prompt
prompt = ->
	cmdr.prompt 'what is thy bidding?: ', (cmd) ->
		console.log commands[cmd]
		if commands[cmd]
			commands[cmd].call(null, prompt) 
		else
			prompt()
		
prompt()