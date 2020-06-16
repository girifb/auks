dnl Checks for TI-RPC library and headers
dnl (https://raw.githubusercontent.com/kouril/nfs-utils/master/aclocal/libtirpc.m4)
AC_DEFUN([AC_LIBTIRPC], [

  AC_ARG_WITH([tirpcinclude],
              [AC_HELP_STRING([--with-tirpcinclude=DIR],
                              [use TI-RPC headers in DIR])],
              [tirpc_header_dir=$withval],
              [tirpc_header_dir=/usr/include/tirpc])

  dnl if --enable-tirpc was specifed, the following components
  dnl must be present, and we set up HAVE_ macros for them.

  if test "$enable_tirpc" != "no"; then

    dnl look for the library
    AC_CHECK_LIB([tirpc], [clnt_tli_create], [:],
                 [if test "$enable_tirpc" = "yes"; then
			AC_MSG_ERROR([libtirpc not found.])
		  else
			AC_MSG_WARN([libtirpc not found. TIRPC disabled!])
			enable_tirpc="no"
		  fi])
  fi

  if test "$enable_tirpc" != "no"; then
    dnl also must have the headers installed where we expect
    dnl look for headers; add -I compiler option if found
    AC_CHECK_HEADERS([${tirpc_header_dir}/netconfig.h],
    		      AC_SUBST([AM_CPPFLAGS], ["-I${tirpc_header_dir}"]),
		      [if test "$enable_tirpc" = "yes"; then
			 AC_MSG_ERROR([libtirpc headers not found.])
		       else
			 AC_MSG_WARN([libtirpc headers not found. TIRPC disabled!])
			 enable_tirpc="no"
		       fi])

  fi

  dnl now set $LIBTIRPC accordingly
  if test "$enable_tirpc" != "no"; then
    AC_DEFINE([HAVE_LIBTIRPC], 1,
              [Define to 1 if you have and wish to use libtirpc.])
    LIBTIRPC="-ltirpc"
  else
    LIBTIRPC=""
  fi

  AC_SUBST(LIBTIRPC)

])dnl
