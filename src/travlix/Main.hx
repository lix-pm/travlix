package travlix;

import tink.Cli;
import asys.io.Process;

using tink.CoreApi;

/**
 *  CI runner for lix
 */
class Main {
	static function main() Cli.process(Sys.args(), new Main()).handle(Cli.exit);
	
	function new() {}
	
	/**
	 *  
	 */
	@:defaultCommand
	public function help() {
		Sys.println(Cli.getDoc(this));
	}
	
	
	@:command
	public var run = new Run();
	
}