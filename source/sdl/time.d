/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.time;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.stdinc: SDL_Time;

struct SDL_DateTime{
	int year, month, day;
	int hour, minute, second, nanosecond;
	int dayOfWeek;
	int utcOffset;
	
	alias day_of_week = dayOfWeek;
	alias utc_offset = utcOffset;
}

mixin(makeEnumBind(q{SDL_DateFormat}, members: (){
	EnumMember[] ret = [
		{{q{yyyymmdd},  q{SDL_DATE_FORMAT_YYYYMMDD}},  q{0}},
		{{q{ddmmyyyy},  q{SDL_DATE_FORMAT_DDMMYYYY}},  q{1}},
		{{q{mmddyyyy},  q{SDL_DATE_FORMAT_MMDDYYYY}},  q{2}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_TimeFormat}, members: (){
	EnumMember[] ret = [
		{{q{_24Hr}, q{SDL_TIME_FORMAT_24HR}}, q{0}},
		{{q{_12Hr}, q{SDL_TIME_FORMAT_12HR}}, q{1}},
	];
	return ret;
}()));

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{bool}, q{SDL_GetDateTimeLocalePreferences}, q{SDL_DateFormat* dateFormat, SDL_TimeFormat* timeFormat}},
		{q{bool}, q{SDL_GetCurrentTime}, q{SDL_Time* ticks}},
		{q{bool}, q{SDL_TimeToDateTime}, q{SDL_Time ticks, SDL_DateTime* dt, bool localTime}},
		{q{bool}, q{SDL_DateTimeToTime}, q{const SDL_DateTime* dt, SDL_Time* ticks}},
		{q{void}, q{SDL_TimeToWindows}, q{SDL_Time ticks, uint* dwLowDateTime, uint* dwHighDateTime}},
		{q{SDL_Time}, q{SDL_TimeFromWindows}, q{uint dwLowDateTime, uint dwHighDateTime}},
		{q{int}, q{SDL_GetDaysInMonth}, q{int year, int month}},
		{q{int}, q{SDL_GetDayOfYear}, q{int year, int month, int day}},
		{q{int}, q{SDL_GetDayOfWeek}, q{int year, int month, int day}},
	];
	return ret;
}()));
