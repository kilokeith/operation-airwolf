arDrone = require('ar-drone')

drones = [
	arDrone.createClient({ip: '192.168.1.50'})
	arDrone.createClient({ip: '192.168.1.51'})
	arDrone.createClient({ip: '192.168.1.52'})
]

drone.after( 100, ->
	@takeoff()
).after( 3000, ->
	@animate('wave', 2000)
).after( 5000, ->
	@stop()
	@land()
) for drone in drones