exec 		= require('child_process').exec
child 		= null

module.exports = do() ->
	return (file) -> 
		child = exec("open -a vlc '#{file}'")