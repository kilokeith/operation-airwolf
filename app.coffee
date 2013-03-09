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
			.after 15500, () ->
				console.log "beat drop"
				this.clockwise(0.5)
				this.animateLeds('snakeGreenRed', 5, 2)
			.after 300, () ->
				console.log "beat drop"
				this.animate('yawShake', 15)
			.after 300, () ->
				console.log "beat drop"
				this.animate('yawDance', 15)
			.after 300, () ->
				console.log "beat drop"
				this.animate('phiDance', 15)
			.after 300, () ->
				console.log "beat drop"
				this.animate('thetaDance', 15)
			.after 300, () ->
				console.log "beat drop"
				this.animate('vzDance', 15)
			.after 300, () ->
				console.log "beat drop"
				this.animate('wave', 15)
			.after 300, () ->
				console.log "beat drop"
				this.animate('phiThetaMixed', 15)
			.after 300, () ->
				console.log "beat drop"
				this.animate('doublePhiThetaMixed', 15)
			.after 300, () ->
				console.log "beat drop"
				this.clockwise(-0.5)
			.after 300, () ->
				console.log "beat drop"
				this.clockwise(0.5)
			.after 3000, () ->
				console.log "flipLeft"
				this.animate('flipLeft', 15)
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
		
prompt()5
