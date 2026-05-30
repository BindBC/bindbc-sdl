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
	majorVersion = sdlNetVersion.major,
	minorVersion = sdlNetVersion.minor,
	microVersion = sdlNetVersion.patch,
	versionNum = SDL_VERSIONNUM(majorVersion, minorVersion, microVersion),
	
	SDL_NET_MAJOR_VERSION = majorVersion,
	SDL_NET_MINOR_VERSION = minorVersion,
	SDL_NET_MICRO_VERSION = microVersion,
	SDL_NET_VERSION = versionNum,
}

pragma(inline,true)
bool versionAtLeast(uint x, uint y, uint z) nothrow @nogc pure @safe =>
	(majorVersion >= x) &&
	(majorVersion >  x || minorVersion >= y) &&
	(majorVersion >  x || minorVersion >  y || microVersion >= z);
alias SDL_NET_VERSION_ATLEAST = versionAtLeast;

mixin(makeEnumBind(q{NET_Status}, members: (){
	EnumMember[] ret = [
		{{q{failure},    q{NET_FAILURE}},    q{-1}},
		{{q{waiting},    q{NET_WAITING}},    q{ 0}},
		{{q{success},    q{NET_SUCCESS}},    q{ 1}},
	];
	return ret;
}()));

struct NET_Address;

struct NET_StreamSocket;

struct NET_Server;

mixin(makeEnumBind(q{NETProp_Server}, members: (){
	EnumMember[] ret = [
		{{q{reuseAddrBoolean},    q{NET_PROP_SERVER_REUSEADDR_BOOLEAN}},    q{"NET.server.reuseaddr"}},
	];
	return ret;
}()));

struct NET_DatagramSocket;

struct NET_Datagram{
	NET_Address* addr;
	ushort port;
	ubyte* buf;
	int bufLen;
}

mixin(makeEnumBind(q{NETProp_DatagramSocket}, members: (){
	EnumMember[] ret = [
		{{q{reuseAddrBoolean},         q{NET_PROP_DATAGRAM_SOCKET_REUSEADDR_BOOLEAN}},          q{"NET.datagram_socket.reuseaddr"}},
		{{q{allowBroadcastBoolean},    q{NET_PROP_DATAGRAM_SOCKET_ALLOW_BROADCAST_BOOLEAN}},    q{"NET.datagram_socket.allow_broadcast"}},
	];
	return ret;
}()));

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{NET_Version}, q{}},
		{q{bool}, q{NET_Init}, q{}},
		{q{void}, q{NET_Quit}, q{}},
		{q{NET_Address*}, q{NET_ResolveHostname}, q{const(char)* host}},
		{q{NET_Status}, q{NET_WaitUntilResolved}, q{NET_Address* address, int timeout}},
		{q{NET_Status}, q{NET_GetAddressStatus}, q{NET_Address* address}},
		{q{const(char)*}, q{NET_GetAddressString}, q{NET_Address* address}},
		{q{NET_Address*}, q{NET_RefAddress}, q{NET_Address* address}},
		{q{void}, q{NET_UnrefAddress}, q{NET_Address* address}},
		{q{void}, q{NET_SimulateAddressResolutionLoss}, q{int percentLoss}},
		{q{int}, q{NET_CompareAddresses}, q{const(NET_Address)* a, const(NET_Address)* b}},
		{q{NET_Address**}, q{NET_GetLocalAddresses}, q{int* numAddresses}},
		{q{void}, q{NET_FreeLocalAddresses}, q{NET_Address** addresses}},
		{q{NET_StreamSocket*}, q{NET_CreateClient}, q{NET_Address* address, ushort port, SDL_PropertiesID props}},
		{q{NET_Status}, q{NET_WaitUntilConnected}, q{NET_StreamSocket* sock, int timeout}},
		{q{NET_Server*}, q{NET_CreateServer}, q{NET_Address* addr, ushort port, SDL_PropertiesID props}},
		{q{bool}, q{NET_AcceptClient}, q{NET_Server* server, NET_StreamSocket** clientStream}},
		{q{void}, q{NET_DestroyServer}, q{NET_Server* server}},
		{q{NET_Address*}, q{NET_GetStreamSocketAddress}, q{NET_StreamSocket* sock}},
		{q{NET_Status}, q{NET_GetConnectionStatus}, q{NET_StreamSocket* sock}},
		{q{bool}, q{NET_WriteToStreamSocket}, q{NET_StreamSocket* sock, const(void)* buf, int bufLen}},
		{q{int}, q{NET_GetStreamSocketPendingWrites}, q{NET_StreamSocket* sock}},
		{q{int}, q{NET_WaitUntilStreamSocketDrained}, q{NET_StreamSocket* sock, int timeout}},
		{q{int}, q{NET_ReadFromStreamSocket}, q{NET_StreamSocket* sock, void* buf, int bufLen}},
		{q{void}, q{NET_SimulateStreamPacketLoss}, q{NET_StreamSocket* sock, int percentLoss}},
		{q{void}, q{NET_DestroyStreamSocket}, q{NET_StreamSocket* sock}},
		{q{NET_DatagramSocket*}, q{NET_CreateDatagramSocket}, q{NET_Address* addr, ushort port, SDL_PropertiesID props}},
		{q{bool}, q{NET_SendDatagram}, q{NET_DatagramSocket* sock, NET_Address* address, ushort port, const(void)* buf, int bufLen}},
		{q{bool}, q{NET_ReceiveDatagram}, q{NET_DatagramSocket* sock, NET_Datagram** dgram}},
		{q{void}, q{NET_DestroyDatagram}, q{NET_Datagram* dgram}},
		{q{void}, q{NET_SimulateDatagramPacketLoss}, q{NET_DatagramSocket* sock, int percentLoss}},
		{q{void}, q{NET_DestroyDatagramSocket}, q{NET_DatagramSocket* sock}},
		{q{int}, q{NET_WaitUntilInputAvailable}, q{void** vSockets, int numSockets, int timeout}},
	];
	return ret;
}()));

static if(!staticBinding):
import bindbc.loader;

mixin(makeDynloadFns("SDLNet", makeLibPaths(["SDL3_net"]), [__MODULE__]));
