/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.hidapi;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.stdinc: SDL_bool;

static if(sdlSupport >= SDLSupport.v2_0_18){
	struct SDL_hid_device;
	
	struct SDL_hid_device_info{
		char* path;
		ushort vendor_id;
		ushort product_id;
		wchar_t* serial_number;
		ushort release_number;
		wchar_t* manufacturer_string;
		wchar_t* product_string;
		ushort usage_page;
		ushort usage;
		int interface_number;
		int interface_class;
		int interface_subclass;
		int interface_protocol;
		SDL_hid_device_info* next;
	}
}

mixin(joinFnBinds((){
	string[][] ret;
	static if(sdlSupport >= SDLSupport.v2_0_18){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_hid_init}, q{}],
			[q{int}, q{SDL_hid_exit}, q{}],
			[q{uint}, q{SDL_hid_device_change_count}, q{}],
			[q{SDL_hid_device_info*}, q{SDL_hid_enumerate}, q{ushort vendor_id, ushort product_id}],
			[q{void}, q{SDL_hid_free_enumeration}, q{SDL_hid_device_info* devs}],
			[q{SDL_hid_device*}, q{SDL_hid_open}, q{ushort vendor_id, ushort product_id, const(wchar_t)* serial_number}],
			[q{SDL_hid_device*}, q{SDL_hid_open_path}, q{const(char)* path, int bExclusive=false}],
			[q{int}, q{SDL_hid_write}, q{SDL_hid_device* dev, const(ubyte*) data, size_t length}],
			[q{int}, q{SDL_hid_read_timeout}, q{SDL_hid_device* dev, ubyte* data, size_t length, int milliseconds}],
			[q{int}, q{SDL_hid_read}, q{SDL_hid_device* dev, ubyte* data, size_t length}],
			[q{int}, q{SDL_hid_set_nonblocking}, q{SDL_hid_device* dev, int nonblock}],
			[q{int}, q{SDL_hid_send_feature_report}, q{SDL_hid_device* dev, const(ubyte)* data, size_t length}],
			[q{int}, q{SDL_hid_get_feature_report}, q{SDL_hid_device* dev, ubyte* data, size_t length}],
			[q{int}, q{SDL_hid_get_manufacturer_string}, q{SDL_hid_device* dev, wchar_t* string_, size_t maxlen}],
			[q{int}, q{SDL_hid_get_product_string}, q{SDL_hid_device* dev, wchar_t* string_, size_t maxlen}],
			[q{int}, q{SDL_hid_get_serial_number_string}, q{SDL_hid_device* dev, wchar_t* string_, size_t maxlen}],
			[q{int}, q{SDL_hid_get_indexed_string}, q{SDL_hid_device* dev, int string_index, wchar_t* string_, size_t maxlen}],
			[q{void}, q{SDL_hid_ble_scan}, q{SDL_bool active}],
		]);
	}
	return ret;
}()));
