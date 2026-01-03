/+
+            Copyright 2025 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl_net;

import bindbc.sdl.config;
static if(sdlNetVersion):
import bindbc.sdl.codegen;

import sdl.version_: SDL_VERSIONNUM;

enum{
	SDL_Net_MajorVersion = sdlNetVersion.major,
	SDL_Net_MinorVersion = sdlNetVersion.minor,
	SDL_Net_MicroVersion = sdlNetVersion.patch,
	SDL_Net_Version = SDL_VERSIONNUM(SDL_Net_MajorVersion, SDL_Net_MinorVersion, SDL_Net_MicroVersion),
	
	SDL_NET_MAJOR_VERSION = SDL_Net_MajorVersion,
	SDL_NET_MINOR_VERSION = SDL_Net_MinorVersion,
	SDL_NET_MICRO_VERSION = SDL_Net_MicroVersion,
	SDL_NET_VERSION = SDL_Net_Version,
}

pragma(inline,true)
bool SDL_NET_VERSION_ATLEAST(uint x, uint y, uint z) nothrow @nogc pure @safe =>
	(SDL_Net_MajorVersion >= x) &&
	(SDL_Net_MajorVersion >  x || SDL_Net_MinorVersion >= y) &&
	(SDL_Net_MajorVersion >  x || SDL_Net_MinorVersion >  y || SDL_Net_MicroVersion >= z);

struct SDLNet_Address;

struct SDLNet_StreamSocket;

struct SDLNet_Server;

struct SDLNet_DatagramSocket;

struct SDLNet_Datagram{
	SDLNet_Address* addr;
	ushort port;
	ubyte* buf;
	int bufLen;
	
	alias buflen = bufLen;
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{SDLNet_Version}, q{}},
		{q{void}, q{SDLNet_Quit}, q{}},
		{q{SDLNet_Address*}, q{SDLNet_ResolveHostname}, q{const(char)* host}},
		{q{int}, q{SDLNet_WaitUntilResolved}, q{SDLNet_Address* address, int timeout}},
		{q{int}, q{SDLNet_GetAddressStatus}, q{SDLNet_Address* address}},
		{q{const(char)*}, q{SDLNet_GetAddressString}, q{SDLNet_Address* address}},
		{q{SDLNet_Address*}, q{SDLNet_RefAddress}, q{SDLNet_Address* address}},
		{q{void}, q{SDLNet_UnrefAddress}, q{SDLNet_Address* address}},
		{q{void}, q{SDLNet_SimulateAddressResolutionLoss}, q{int percentLoss}},
		{q{int}, q{SDLNet_CompareAddresses}, q{const(SDLNet_Address)* a, const(SDLNet_Address)* b}},
		{q{SDLNet_Address**}, q{SDLNet_GetLocalAddresses}, q{int* numAddresses}},
		{q{void}, q{SDLNet_FreeLocalAddresses}, q{SDLNet_Address** addresses}},
		{q{SDLNet_StreamSocket*}, q{SDLNet_CreateClient}, q{SDLNet_Address* address, ushort port}},
		{q{int}, q{SDLNet_WaitUntilConnected}, q{SDLNet_StreamSocket* sock, int timeout}},
		{q{SDLNet_Server*}, q{SDLNet_CreateServer}, q{SDLNet_Address* addr, ushort port}},
		{q{bool}, q{SDLNet_AcceptClient}, q{SDLNet_Server* server, SDLNet_StreamSocket** clientStream}},
		{q{void}, q{SDLNet_DestroyServer}, q{SDLNet_Server* server}},
		{q{SDLNet_Address*}, q{SDLNet_GetStreamSocketAddress}, q{SDLNet_StreamSocket* sock}},
		{q{int}, q{SDLNet_GetConnectionStatus}, q{SDLNet_StreamSocket* sock}},
		{q{bool}, q{SDLNet_WriteToStreamSocket}, q{SDLNet_StreamSocket* sock, const(void)* buf, int bufLen}},
		{q{int}, q{SDLNet_GetStreamSocketPendingWrites}, q{SDLNet_StreamSocket* sock}},
		{q{int}, q{SDLNet_WaitUntilStreamSocketDrained}, q{SDLNet_StreamSocket* sock, int timeout}},
		{q{int}, q{SDLNet_ReadFromStreamSocket}, q{SDLNet_StreamSocket* sock, void* buf, int bufLen}},
		{q{void}, q{SDLNet_SimulateStreamPacketLoss}, q{SDLNet_StreamSocket* sock, int percentLoss}},
		{q{void}, q{SDLNet_DestroyStreamSocket}, q{SDLNet_StreamSocket* sock}},
		{q{SDLNet_DatagramSocket*}, q{SDLNet_CreateDatagramSocket}, q{SDLNet_Address* addr, ushort port}},
		{q{bool}, q{SDLNet_SendDatagram}, q{SDLNet_DatagramSocket* sock, SDLNet_Address* address, ushort port, const(void)* buf, int bufLen}},
		{q{bool}, q{SDLNet_ReceiveDatagram}, q{SDLNet_DatagramSocket* sock, SDLNet_Datagram** dgram}},
		{q{void}, q{SDLNet_DestroyDatagram}, q{SDLNet_Datagram* dgram}},
		{q{void}, q{SDLNet_SimulateDatagramPacketLoss}, q{SDLNet_DatagramSocket* sock, int percentLoss}},
		{q{void}, q{SDLNet_DestroyDatagramSocket}, q{SDLNet_DatagramSocket* sock}},
		{q{int}, q{SDLNet_WaitUntilInputAvailable}, q{void** vSockets, int numSockets, int timeout}},
	];
	return ret;
}()));

static if(!staticBinding):
import bindbc.loader;

mixin(makeDynloadFns("SDLNet", makeLibPaths(["SDL3_net"]), [__MODULE__]));
