package;

#if nodejs
import js.npm.ws.WebSocket;
#elseif js
import js.html.WebSocket;
#end
import haxe.EnumFlags;

enum ClientGroup {
	User;
	Leader;
	Admin;
}

typedef ClientData = {
	name:String,
	group:Int
}

class Client {

	#if nodejs
	public final ws:WebSocket;
	public final id:Int;
	#end
	public var name:String;
	public var group:EnumFlags<ClientGroup>;
	public var isLeader(get, set):Bool;
	public var isAdmin(get, set):Bool;

	public function new(?ws:WebSocket, ?id:Int, name:String, group:Int) {
		#if nodejs
		this.ws = ws;
		this.id = id;
		#end
		this.name = name;
		this.group = new EnumFlags(group);
	}

	inline function get_isLeader():Bool {
		return group.has(Leader);
	}

	inline function set_isLeader(flag:Bool):Bool {
		return setGroupFlag(Leader, flag);
	}

	inline function get_isAdmin():Bool {
		return group.has(Admin);
	}

	inline function set_isAdmin(flag:Bool):Bool {
		return setGroupFlag(Admin, flag);
	}

	function setGroupFlag(type:ClientGroup, flag:Bool):Bool {
		if (flag) group.set(type);
		else group.unset(type);
		return flag;
	}

	public function getData():ClientData {
		return {
			name: name,
			group: group.toInt()
		}
	}

	public static function fromData(data:ClientData):Client {
		return new Client(data.name, data.group);
	}

}
