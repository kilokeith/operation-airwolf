arDrone 	= require 'ar-drone'
client  	= arDrone.createClient()


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
		this.stop().land()