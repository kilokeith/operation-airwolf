colors 		= require 'colors'
cmdr 		= require 'commander'
_ 			= require 'underscore'
async 		= require 'async'
Timer 		= require './timer.js'
arDrone 	= require 'ar-drone'

vlc 		= require './vlc'
twitter		= require './twitter'

client  	= arDrone.createClient()

queue 		= null
# animation_sequence = [
# 	'phiM30Deg'
# 	'phi30Deg'
# 	'thetaM30Deg'
# 	'theta30Deg'
# 	'theta20degYaw200deg'
# 	'theta20degYawM200deg'
# 	'turnaround'
# 	'turnaroundGodown'
# 	'yawShake'
# 	'yawDance'
# 	'phiDance'
# 	'thetaDance'
# 	'vzDance'
# 	'wave'
# 	'phiThetaMixed'
# 	'doublePhiThetaMixed'
# ]

animation_sequence = [
	[0, 'takeoff', 0, "blank"]
	[15000, 'doublePhiThetaMixed', 2000, 'blinkRed']
	[2000, 'doublePhiThetaMixed', 2000, 'blinkGreen']
	[1000, 'doublePhiThetaMixed', 1000, 'blinkOrange']
	[1000, 'wave', 3000, 'leftGreenRightRed']
	[2000, 'doublePhiThetaMixed', 2000, 'blinkRed']
	[2000, 'doublePhiThetaMixed', 2000, 'blinkGreen']
	[2000, 'flipBehind', 15, 'leftGreenRightRed']
	[3000, 'land', 0, 'blank']
]

timer = new Timer('100 ms')

#enable shit
client.config('general:navdata_demo', 'FALSE')


run_a_thing = (f, cb) ->
	f(cb) if typeof f is 'function'


set_animation_queue = () ->
	#queue = async.queue(run_a_thing, 1)
	
	times = 0

	#queue animations
	for i in animation_sequence then do(i) ->
		interval = i[0]
		command = i[1]
		duration = i[2]
		led = i[3]
		times += interval
		t = times
		
		timer.after "#{t} ms", () ->
			console.log "command", command, i
			switch command
				when 'takeoff' then commands.takeoff()
				when 'land' then commands.land()
				else 
					client.animate(command, duration)
					client.animateLeds(led, 2, 2)

commands = 
	sko: (next=null) ->
		console.log 'sko'
		timer.start()
		next() if next

	takeoff: (next=null) ->
		console.log 'takeoff'
		#play mp3
		vlc('audio/shake.mp3')
		client.takeoff()

		next() if next

	land: (next=null) ->
		console.log 'land'
		client.stop()
		client.land()
		timer.stop()
		next() if next
	
	exit: ->
		timer.stop()
		process.exit()

	crash: -> moo(func)

#logs battery
log_battery = (power) ->
	if power % 5 is 0
		console.log "power level: #{power}%".red

#events for clients
client.on 'batteryChange', log_battery


#aliases
commands.fuck = commands.land
commands.die = commands.exit

#please land, oh dear lord
process.on 'exit', commands.land
process.on 'uncaughtException', commands.land

#twitter shit
twitter.on 'got_tweet', commands.sko

#prompt
prompt = ->
	cmdr.prompt 'what is thy bidding?: ', (cmd) ->
		console.log "OK (#{cmd})".green
		if commands[cmd] and typeof commands[cmd] is 'function'
			commands[cmd].call(null, prompt) 
		else
			prompt()

#queue up animations
set_animation_queue()
#start initial prompt
prompt()