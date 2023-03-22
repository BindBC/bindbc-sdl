/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl_net;

import bindbc.sdl.config;
static if(bindSDLNet):
import bindbc.sdl.codegen;

import sdl.version_: SDL_version;

alias SDLNet_version = SDL_version;

enum SDLNetSupport: SDLNet_version{
	noLibrary   = SDLNet_version(0,0,0),
	badLibrary  = SDLNet_version(0,0,255),
	v2_0_0      = SDLNet_version(2,0,0),
	v2_0_1      = SDLNet_version(2,0,1),
	v2_2        = SDLNet_version(2,2,0),
	
	deprecated("Please use `v2_0_0` instead") sdlNet200 = SDLNet_version(2,0,0),
	deprecated("Please use `v2_0_1` instead") sdlNet201 = SDLNet_version(2,0,1),
}

enum sdlNetSupport = (){
	version(SDL_Net_2_2)      return SDLNetSupport.v2_2;
	else version(SDL_Net_201) return SDLNetSupport.v2_0_1;
	else                      return SDLNetSupport.v2_0_0;
}();

enum SDL_NET_MAJOR_VERSION = sdlNetSupport.major;
enum SDL_NET_MINOR_VERSION = sdlNetSupport.minor;
enum SDL_NET_PATCHLEVEL    = sdlNetSupport.patch;

pragma(inline, true) void SDL_NET_VERSION(SDLNet_version* X) @nogc nothrow pure @safe{
	X.major = SDL_NET_MAJOR_VERSION;
	X.minor = SDL_NET_MINOR_VERSION;
	X.patch = SDL_NET_PATCHLEVEL;
}

bool SDL_NET_VERSION_ATLEAST(ubyte X, ubyte Y, ubyte Z){ return SDLNet_version(SDL_NET_MAJOR_VERSION, SDL_NET_MINOR_VERSION, SDL_NET_PATCHLEVEL) >= SDLNet_version(X, Y, Z); }

struct IPaddress{
	uint host;
	ushort port;
}

enum: uint{
	INADDR_ANY        = 0x0000_0000,
	INADDR_NONE       = 0xFFFF_FFFF,
	INADDR_LOOPBACK   = 0x7F00_0001,
	INADDR_BROADCAST  = 0xFFFF_FFFF,
}

struct _TCPsocket;
alias TCPsocket = _TCPsocket*;

enum SDLNET_MAX_UDPCHANNELS = 32;

enum SDLNET_MAX_UDPADRESSES = 4;

struct _UDPsocket;
alias UDPsocket = _UDPsocket*;

struct UDPpacket{
	int channel;
	ubyte* data;
	int len;
	int maxlen;
	int status;
	IPaddress address;
}

struct _SDLNet_SocketSet;
alias SDLNet_SocketSet = _SDLNet_SocketSet*;

struct _SDLNet_GenericSocket{
	int ready;
}
alias SDLNet_GenericSocket = _SDLNet_GenericSocket*;

pragma(inline, true) @nogc nothrow{
	int SDLNet_TCP_AddSocket(SDLNet_SocketSet set, TCPsocket sock){
		return SDLNet_AddSocket(set, cast(SDLNet_GenericSocket)sock);
	}
	
	int SDLNet_UDP_AddSocket(SDLNet_SocketSet set, UDPsocket sock){
		return SDLNet_AddSocket(set, cast(SDLNet_GenericSocket)sock);
	}
	
	int SDLNet_TCP_DelSocket(SDLNet_SocketSet set, TCPsocket sock){
		return SDLNet_DelSocket(set, cast(SDLNet_GenericSocket)sock);
	}
	
	int SDLNet_UDP_DelSocket(SDLNet_SocketSet set, UDPsocket sock){
		return SDLNet_DelSocket(set, cast(SDLNet_GenericSocket)sock);
	}
	
	bool SDLNet_SocketReady(TCPsocket sock){
		return (sock !is null) && (cast(SDLNet_GenericSocket)sock).ready;
	}
	
	bool SDLNet_SocketReady(UDPsocket sock){
		return (sock !is null) && (cast(SDLNet_GenericSocket)sock).ready;
	}
	
	pure{
		import sdl.endian: SDL_SwapBE16, SDL_SwapBE32;
		
		void SDLNet_Write16(ushort value, void* areap){
			*cast(ushort*)areap = SDL_SwapBE16(value);
		}
		
		void SDLNet_Write32(uint value, void* areap){
			*cast(uint*)areap = SDL_SwapBE32(value);
		}
		
		ushort SDLNet_Read16(const(void)* areap){
			return SDL_SwapBE16(*cast(const(ushort)*)areap);
		}
		
		uint SDLNet_Read32(const(void)* areap){
			return SDL_SwapBE32(*cast(const(uint)*)areap);
		}
	}
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{const(SDLNet_version)*}, q{SDLNet_Linked_Version}, q{}],
		[q{int}, q{SDLNet_Init}, q{}],
		[q{void}, q{SDLNet_Quit}, q{}],
		[q{int}, q{SDLNet_ResolveHost}, q{IPaddress* address, const(char)* host, ushort port}],
		[q{const(char)*}, q{SDLNet_ResolveIP}, q{const(IPaddress)* ip}],
		[q{int}, q{SDLNet_GetLocalAddresses}, q{IPaddress* addresses, int maxcount}],
		[q{TCPsocket}, q{SDLNet_TCP_Open}, q{IPaddress* ip}],
		[q{TCPsocket}, q{SDLNet_TCP_Accept}, q{TCPsocket server}],
		[q{IPaddress*}, q{SDLNet_TCP_GetPeerAddress}, q{TCPsocket sock}],
		[q{int}, q{SDLNet_TCP_Send}, q{TCPsocket sock, const(void)* data, int len}],
		[q{int}, q{SDLNet_TCP_Recv}, q{TCPsocket sock, void* data, int len}],
		[q{void}, q{SDLNet_TCP_Close}, q{TCPsocket sock}],
		[q{UDPpacket*}, q{SDLNet_AllocPacket}, q{int size}],
		[q{int}, q{SDLNet_ResizePacket}, q{UDPpacket* packet, int newsize}],
		[q{void}, q{SDLNet_FreePacket}, q{UDPpacket* packet}],
		[q{UDPpacket**}, q{SDLNet_AllocPacketV}, q{int howmany, int size}],
		[q{void}, q{SDLNet_FreePacketV}, q{UDPpacket** packetV}],
		[q{UDPsocket}, q{SDLNet_UDP_Open}, q{ushort port}],
		[q{void}, q{SDLNet_UDP_SetPacketLoss}, q{UDPsocket sock, int percent}],
		[q{int}, q{SDLNet_UDP_Bind}, q{UDPsocket sock, int channel, const(IPaddress)* address}],
		[q{void}, q{SDLNet_UDP_Unbind}, q{UDPsocket sock, int channel}],
		[q{IPaddress*}, q{SDLNet_UDP_GetPeerAddress}, q{UDPsocket sock, int channel}],
		[q{int}, q{SDLNet_UDP_SendV}, q{UDPsocket sock, UDPpacket** packets, int npackets}],
		[q{int}, q{SDLNet_UDP_Send}, q{UDPsocket sock, int channel, UDPpacket* packet}],
		[q{int}, q{SDLNet_UDP_RecvV}, q{UDPsocket sock, UDPpacket** packets}],
		[q{int}, q{SDLNet_UDP_Recv}, q{UDPsocket sock, UDPpacket* packet}],
		[q{void}, q{SDLNet_UDP_Close}, q{UDPsocket sock}],
		[q{SDLNet_SocketSet}, q{SDLNet_AllocSocketSet}, q{int maxsockets}],
		[q{int}, q{SDLNet_AddSocket}, q{SDLNet_SocketSet set, SDLNet_GenericSocket sock}],
		[q{int}, q{SDLNet_DelSocket}, q{SDLNet_SocketSet set, SDLNet_GenericSocket sock}],
		[q{int}, q{SDLNet_CheckSockets}, q{SDLNet_SocketSet set, uint timeout}],
		[q{void}, q{SDLNet_FreeSocketSet}, q{SDLNet_SocketSet set}],
		[q{void}, q{SDLNet_SetError}, q{const(char)* fmt, ...}],
		[q{const(char)*}, q{SDLNet_GetError}, q{}],
	]);
	return ret;
}()));

static if(!staticBinding):
import bindbc.loader;

private{
	SharedLib lib;
	SDLNetSupport loadedVersion;
	enum libNamesCT = (){
		version(Windows){
			return [
				`SDL2_net.dll`,
			];
		}else version(OSX){
			return [
				`libSDL2_net.dylib`,
				`/opt/homebrew/lib/libSDL2_net.dylib`,
				`SDL2_net`,
				`/Library/Frameworks/SDL2_net.framework/SDL2_net`,
				`/System/Library/Frameworks/SDL2_net.framework/SDL2_net`,
			];
		}else version(Posix){
			return [
				`libSDL2_net.so`,
				`libSDL2_net-2.0.so`,
				`libSDL2_net-2.0.so.0`,
			];
		}else static assert(0, "BindBC-SDL_net does not have library search paths set up for this platform");
	}();
}

@nogc nothrow:
deprecated("Please use `SDLNet_Linked_Version` instead")
	SDLNetSupport loadedSDLNetVersion(){ return loadedVersion; }

mixin(bindbc.sdl.codegen.makeDynloadFns("Net", [__MODULE__]));
