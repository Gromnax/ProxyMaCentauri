@abstract
extends GraphNode
class_name GraphControlNode

var input_signals : Array[SignalConnection] = []

@warning_ignore("unused_signal")
signal output(origin:Node, port:int, value:String)

class SignalConnection:
	var port: int
	var sig: Signal
	var method: Callable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## @deprecated The graph should handle connections,not the node
func listen_start(port: int, sig: Signal, method:Callable = on_unhandled_signal_received) -> bool:
	return true
	@warning_ignore_start("unreachable_code")
	print("listen start:"+str(self))
	if not sig or port < 0 or port > get_input_port_count():
		return false
	var sigco = SignalConnection.new()
	sigco.port = port
	sigco.sig = sig
	sigco.method = method
	input_signals.append(sigco)
	sig.connect(on_unhandled_signal_received)
	print("Connection bien effectuée")
	return true
	@warning_ignore_restore("unreachable_code")

## @deprecated The graph should handle connections,not the node
func listen_stop(port: int, sig: Signal) -> bool:
	return true
	@warning_ignore_start("unreachable_code")
	if not sig or port < 0 or port > get_input_port_count():
		return false
	var sigco : SignalConnection = null
	for connection : SignalConnection in input_signals:
		if connection.port == port and connection.sig == sig:
			sigco = connection
	if not sigco:
		return false
	sigco.sig.disconnect(sigco.method)
	input_signals.erase(sigco)
	return true
	@warning_ignore_restore("unreachable_code")

@abstract
func on_unhandled_signal_received(args: Dictionary={}) -> void;

@abstract
func signal_received(port: int, value:String="") -> void;
