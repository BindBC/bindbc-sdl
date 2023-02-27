/*
*            Copyright 2022 – 2023 Aya Partridge
* Distributed under the Boost Software License, Version 1.0.
*     (See accompanying file LICENSE_1_0.txt or copy at
*           http://www.boost.org/LICENSE_1_0.txt)
*/

#include <stddef.h>
#include <stdarg.h>

typedef long             c_long;
typedef unsigned long    c_ulong;

//these `c_` types are here because these types use #define on some platforms
typedef wchar_t          c_wchar_t;
typedef va_list          c_va_list;
