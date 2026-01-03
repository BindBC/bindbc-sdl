/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.hidapi;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.properties: SDL_PropertiesID;

struct SDL_HIDDevice;
alias SDL_hid_device = SDL_HIDDevice;

mixin(makeEnumBind(q{SDL_HIDBusType}, aliases: [q{SDL_HIDAPIBus}, q{SDL_hid_api_bus}, q{SDL_hid_bus_type}], members: (){
	EnumMember[] ret = [
		{{q{unknown},      q{SDL_HID_API_BUS_UNKNOWN}},      q{0x00}},
		{{q{usb},          q{SDL_HID_API_BUS_USB}},          q{0x01}},
		{{q{bluetooth},    q{SDL_HID_API_BUS_BLUETOOTH}},    q{0x02}},
		{{q{i2c},          q{SDL_HID_API_BUS_I2C}},          q{0x03}},
		{{q{spi},          q{SDL_HID_API_BUS_SPI}},          q{0x04}},
	];
	return ret;
}()));

struct SDL_HIDDeviceInfo{
	char* path;
	ushort vendorID;
	ushort productID;
	wchar_t* serialNumber;
	ushort releaseNumber;
	wchar_t* manufacturerString;
	wchar_t* productString;
	ushort usagePage;
	ushort usage;
	int interfaceNumber;
	int interfaceClass;
	int interfaceSubclass;
	int interfaceProtocol;
	SDL_HIDBusType busType;
	SDL_HIDDeviceInfo* next;
	
	alias vendor_id = vendorID;
	alias product_id = productID;
	alias serial_number = serialNumber;
	alias release_number = releaseNumber;
	alias manufacturer_string = manufacturerString;
	alias product_string = productString;
	alias usage_page = usagePage;
	alias interface_number = interfaceNumber;
	alias interface_class = interfaceClass;
	alias interface_subclass = interfaceSubclass;
	alias interface_protocol = interfaceProtocol;
	alias bus_type = busType;
}
alias SDL_hid_device_info = SDL_HIDDeviceInfo;

static if(sdlVersion >= Version(3,4,0))
mixin(makeEnumBind(q{SDLProp_HIDAPI}, aliases: [q{SDLProp_hidapi}], members: (){
	EnumMember[] ret = [
		{{q{libusbDeviceHandlePointer},    q{SDL_PROP_HIDAPI_LIBUSB_DEVICE_HANDLE_POINTER}},    q{"SDL.hidapi.libusb.device.handle"}},
	];
	return ret;
}()));

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{SDL_hid_init}, q{}, aliases: [q{SDL_HIDInit}]},
		{q{int}, q{SDL_hid_exit}, q{}, aliases: [q{SDL_HIDExit}]},
		{q{uint}, q{SDL_hid_device_change_count}, q{}, aliases: [q{SDL_HIDDeviceChangeCount}]},
		{q{SDL_HIDDeviceInfo*}, q{SDL_hid_enumerate}, q{ushort vendorID, ushort productID}, aliases: [q{SDL_HIDEnumerate}]},
		{q{void}, q{SDL_hid_free_enumeration}, q{SDL_HIDDeviceInfo* devs}, aliases: [q{SDL_HIDFreeEnumeration}]},
		{q{SDL_HIDDevice*}, q{SDL_hid_open}, q{ushort vendorID, ushort productID, const(wchar_t)* serialNumber}, aliases: [q{SDL_HIDOpen}]},
		{q{SDL_HIDDevice*}, q{SDL_hid_open_path}, q{const(char)* path}, aliases: [q{SDL_HIDOpenPath}]},
		{q{int}, q{SDL_hid_write}, q{SDL_HIDDevice* dev, const(ubyte)* data, size_t length}, aliases: [q{SDL_HIDWrite}]},
		{q{int}, q{SDL_hid_read_timeout}, q{SDL_HIDDevice* dev, ubyte* data, size_t length, int milliseconds}, aliases: [q{SDL_HIDReadTimeout}]},
		{q{int}, q{SDL_hid_read}, q{SDL_HIDDevice* dev, ubyte* data, size_t length}, aliases: [q{SDL_HIDRead}]},
		{q{int}, q{SDL_hid_set_nonblocking}, q{SDL_HIDDevice* dev, int nonBlock}, aliases: [q{SDL_HIDSetNonBlocking}]},
		{q{int}, q{SDL_hid_send_feature_report}, q{SDL_HIDDevice* dev, const(ubyte)* data, size_t length}, aliases: [q{SDL_HIDSendFeatureReport}]},
		{q{int}, q{SDL_hid_get_feature_report}, q{SDL_HIDDevice* dev, ubyte* data, size_t length}, aliases: [q{SDL_HIDGetFeatureReport}]},
		{q{int}, q{SDL_hid_get_input_report}, q{SDL_HIDDevice* dev, ubyte* data, size_t length}, aliases: [q{SDL_HIDGetInputReport}]},
		{q{int}, q{SDL_hid_close}, q{SDL_HIDDevice* dev}, aliases: [q{SDL_HIDClose}]},
		{q{int}, q{SDL_hid_get_manufacturer_string}, q{SDL_HIDDevice* dev, wchar_t* string, size_t maxLen}, aliases: [q{SDL_HIDGetManufacturerString}]},
		{q{int}, q{SDL_hid_get_product_string}, q{SDL_HIDDevice* dev, wchar_t* string, size_t maxLen}, aliases: [q{SDL_HIDGetProductString}]},
		{q{int}, q{SDL_hid_get_serial_number_string}, q{SDL_HIDDevice* dev, wchar_t* string, size_t maxLen}, aliases: [q{SDL_HIDGetSerialNumberString}]},
		{q{int}, q{SDL_hid_get_indexed_string}, q{SDL_HIDDevice* dev, int stringIndex, wchar_t* string, size_t maxLen}, aliases: [q{SDL_HIDGetIndexedString}]},
		{q{SDL_HIDDeviceInfo*}, q{SDL_hid_get_device_info}, q{SDL_HIDDevice* dev}, aliases: [q{SDL_HIDGetDeviceInfo}]},
		{q{int}, q{SDL_hid_get_report_descriptor}, q{SDL_HIDDevice* dev, ubyte* buf, size_t buf_size}, aliases: [q{SDL_HIDGetReportDescriptor}]},
		{q{void}, q{SDL_hid_ble_scan}, q{bool active}, aliases: [q{SDL_HIDBLEScan}]},
	];
	if(sdlVersion >= Version(3,4,0)){
		FnBind[] add = [
			{q{SDL_PropertiesID}, q{SDL_hid_get_properties}, q{SDL_HIDDevice* dev}, aliases: [q{SDL_HIDGetProperties}]},
		];
		ret ~= add;
	}
	return ret;
}()));
