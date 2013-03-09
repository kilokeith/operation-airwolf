color 		= require 'color'
cmdr 		= require 'commander'
_ 			= require 'underscore'
async 		= require 'async'
arDrone 	= require 'ar-drone'

vlc 		= require './vlc'

client  	= arDrone.createClient()

animation_sequence = [
	'phiM30Deg'
	'phi30Deg'
	'thetaM30Deg'
	'theta30Deg'
	'theta20degYaw200deg'
	'theta20degYawM200deg'
	'turnaround'
	'turnaroundGodown'
	'yawShake'
	'yawDance'
	'phiDance'
	'thetaDance'
	'vzDance'
	'wave'
	'phiThetaMixed'
	'doublePhiThetaMixed'
]

interval = 2000

#anable shit
client.config('general:navdata_demo', 'FALSE')

commands = 
	sko: (next=null) ->
		console.log 'sko'

		#play mp3
		vlc('audio/shake.mp3')

		client.takeoff()

		for i in animation_sequence then do(i) ->

			client.after interval, () ->
				console.log i
				this.animate i, interval

		client.after 2000, () ->
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
	if power % 5 is 0
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
