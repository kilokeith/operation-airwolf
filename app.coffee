###
	Hey swarmers, using the Stanford method of ad-hoc swarms
	http://drones.johnback.us/blog/2013/02/03/programming-multiple-parrot-a-dot-r-drones-on-one-network-with-node-dot-js/
###

colors 		= require 'colors'
cmdr 		= require 'commander'
util 		= require 'util'

Timer 		= require './lib/timer.js'
vlc 		= require './lib/vlc'
twitter		= require './lib/twitter'
Drone		= require './lib/drone'


#animation timer
timer = new Timer('100 ms')
drones = null

#aniamtions are sequential timings (0+15000+100+2000...)

main_sequence = [
	[0, 'takeoff', 0, "blank"]
	[15000, 'up', 0.6, "blinkRed"]
	[100, 'doublePhiThetaMixed', 2000, 'blinkRed']
	[2000, 'doublePhiThetaMixed', 2000, 'blinkGreen']
	[1000, 'doublePhiThetaMixed', 1000, 'blinkOrange']
	[1000, 'wave', 3000, 'leftGreenRightRed']
	[2000, 'doublePhiThetaMixed', 2000, 'blinkRed']
	[2000, 'doublePhiThetaMixed', 2000, 'blinkGreen']
	[2000, 'flipBehind', 15, 'leftGreenRightRed']
	[3000, 'land', 0, 'blank']
]

shake_sequence = [
	[15000, 'takeoff', 0, "blank"]
	[2000, 'doublePhiThetaMixed', 2000, 'blinkGreen']
	[1000, 'wave', 1000, 'blinkOrange']
	[1000, 'doublePhiThetaMixed', 3000, 'leftGreenRightRed']
	[2000, 'wave', 2000, 'blinkRed']
	[2000, 'doublePhiThetaMixed', 2000, 'blinkGreen']
	[2000, 'flipAhead', 15, 'leftGreenRightRed']
	[3000, 'land', 0, 'blank']
]





#inits the drones and queues animations
setup_drones = ->
	#our swarm
	drones = [
		new Drone({ip:'192.168.1.50', name:'Groupon1'}, shake_sequence, timer)
		new Drone({ip:'192.168.1.51', name:'EandEDrone1'}, main_sequence, timer)
		new Drone({ip:'192.168.1.52', name:'Groupon2'}, shake_sequence, timer)
	]
	
	#for each drone
	for drone in drones
		#get it's animation timings
		queue = drone.queue_animation_times()
		###
		#for each animation
		for params in queue
			#queue up the timing
			#console.log "#{params.timing} ms", params
			timer.after "#{params.timing} ms", do(drone, params) -> drone.command(params)
		###
				

#terminal commands 
commands = 
	sko: (next=null) ->
		console.log 'sko'
		#play mp3
		vlc('audio/shake.mp3')
		#start animations
		timer.start()
		next() if next

	land: (next=null) ->
		console.log 'land'
		drone.land() for drone in drones
		next() if next
	
	exit: ->
		timer.stop()
		process.exit()

	crash: -> moo(func)



#----------command aliases----------#
commands.fuck = commands.land
commands.die = commands.exit


#-----------error handling----------#
#please land, oh dear lord
#process.on 'exit', commands.land
#process.on 'uncaughtException', commands.land



#--------------TWITTER--------------#
twitter.on 'got_tweet', commands.sko
#-----------------------------------#



#---------terminal prompt-----------#
prompt = ->
	cmdr.prompt 'what is thy bidding?: ', (cmd) ->
		console.log "OK (#{cmd})".green
		if commands[cmd] and typeof commands[cmd] is 'function'
			commands[cmd].call(null, prompt) 
		else
			prompt()


#------------MAGIC TIME------------#
setup_drones()
#start initial prompt
prompt()