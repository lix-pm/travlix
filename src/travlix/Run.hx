package travlix;

import tink.Cli;
import tink.stringly.CommaSeparatedArray;
import tink.streams.Stream;
import asys.io.Process;

using tink.io.Sink;
using tink.io.Source;
using tink.CoreApi;

class Run {
	public function new() {}
	
	/**
	 *  List of travix-supported targets to be run
	 *  (e.g. node,js,java)
	 */
	@:required
	public var target:CommaSeparatedArray<String>;
	
	/**
	 *  List of switchx-supported haxe versions
	 *  (e.g. 3.2.1,3.4.2)
	 */
	@:required
	public var haxe:CommaSeparatedArray<String>;
	
	
	/**
	 *  List of lix-supported haxe libraries
	 *  (e.g. haxelib:tink_core#1.11.0,haxelib:tink_core#1.12.0)
	 */
	public var lib:CommaSeparatedArray<String>;
	
	
	/**
	 * Show this help 
	 */
	@:command @:skipFlags
	public function help() {
		Sys.println(Cli.getDoc(this));
	}
	
	/**
	 *  Run test matrix
	 */
	@:defaultCommand
	public function run() {
		return prepare().next(function(_) {
			return Promise.inSequence([for(haxe in haxe) {
				cmd('switchx', ['install', haxe], 'switchx: Installing Haxe Version: $haxe')
					.next(function(_):Promise<Noise> {
						function runTargets():Promise<Noise>
							return Promise.inSequence([for(target in target)
								cmd('travix', [target], 'travix: Running target - $target', true)
							]);
							
						return if(lib != null && lib.length > 0)
							Promise.inSequence([for(lib in lib) 
								cmd('lix', ['install', lib], 'lix: Installing Library - $lib')
									.next(function(_) return runTargets())
							]);
						else
							runTargets();
					});
			}]);
		});
	}
	
	function prepare() {
		return hasCommand('yarn').next(function(has) {
			var pm, globalInstall;
			if(has) {
				pm = 'yarn';
				globalInstall = ['yarn', 'global', 'add'];
			} else {
				pm = 'npm';
				globalInstall = ['npm', 'install', '-g'];
			}
			
			return cmd(globalInstall[0], globalInstall.slice(1).concat(['--silent', 'haxeshim', 'switchx', 'lix.pm', 'haxe-travix']), '$pm: Downloading Node Libraries')
				.next(function(_) return cmd('lix', ['download'], 'lix: Downloading Libraries'));
		});
	}
	
	function hasCommand(name:String) {
		var which = if(Sys.systemName() == 'Windows') 'where' else 'which';
		return cmd(which, [name]).swap(true).recover(function(_) return false);
	}
	
	
	var stdout = Sink.ofNodeStream('stdout', js.Node.process.stdout);
	function cmd(name, args, ?message:String, ?print = false):Promise<tink.Chunk> {
		return Future.async(function(cb) {
			if(message != null) Sys.println(message);
			var proc = new Process(name, args);
			proc.exitCode().next(function(code) {
				return if(code == 0) {
					if(print) proc.stdout.pipeTo(stdout).handle(function(_) Sys.println(''));
					proc.stdout.all();
				} else 
					proc.stderr.all().next(function(c) return new Error(c.toString()));
			}).handle(cb);
		}, true);
	}
}