exec 		= require('child_process').exec
child 		= null

module.exports = do() ->
	console.log 'here'
	return (file) -> 
		console.log 'here2'
		child = exec("open -a vlc '#{file}'")