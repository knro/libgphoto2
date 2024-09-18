# gp-gettext-setup.m4 - set up gettext with some checks        -*- Autoconf -*-
# serial 13
dnl | Increment the above serial number every time you edit this file.
dnl | When it finds multiple m4 files with the same name,
dnl | aclocal will use the one with the highest serial.
dnl
dnl ####################################################################
dnl GP_GETTEXT_SETUP(...)
dnl    Gettext setup with e.g. consistency checks for value of DOMAIN.
dnl ####################################################################
dnl
dnl Usage:
dnl     GP_GETTEXT_SETUP([DOMAIN_LIBGPHOTO2],
dnl                      [libgphoto2-${LIBGPHOTO2_CURRENT_MIN}],
dnl                      [po])
dnl     GP_GETTEXT_SETUP([DOMAIN_LIBGPHOTO2_PORT],
dnl                      [libgphoto2_port-${LIBGPHOTO2_PORT_CURRENT_MIN}],
dnl                      [libgphoto2_port/po])
dnl
dnl with the corresponding top level Makefile.am containing
dnl
dnl     @GP_GETTEXT_SETUP_MK@
dnl
dnl     # Dummy target to force Automake to make the "all" target depend on it
dnl     all-local:
dnl     	@:
dnl
dnl     # Dummy target to force Automake to make the "distclean" target depend on it
dnl     distclean-local:
dnl     	@:
dnl
dnl ####################################################################
dnl
AC_DEFUN([GP_GETTEXT_SETUP], [dnl
AC_REQUIRE([AC_PROG_GREP])dnl
AC_REQUIRE([GP_GETTEXT_SETUP_INIT])dnl
dnl
AC_MSG_CHECKING([translation text domain symbol])
AC_MSG_RESULT([$1])
AC_MSG_CHECKING([translation text domain value])
AC_MSG_RESULT([$2])
AC_MSG_CHECKING([translation subdirectory])
AC_MSG_RESULT([$3])
dnl
dnl The text domain can be evaluated as a shell variable, no need for
dnl recursive make variable evaluation, so we can put the text domain
dnl into the include file and do not need to define it from a make
dnl rule on the compiler command line.
AC_DEFINE_UNQUOTED([$1], ["$2"], [text domain for string translations])
dnl AM_CPPFLAGS="$AM_CPPFLAGS -D$1=\\\""'$2'"\\\""
AC_SUBST([$1], [$2])
dnl
dnl
dnl The following check will have "make all" print something like
dnl     DOMAIN = libgphoto2-6
dnl if the consistency check has been successful, and have "make all" abort
dnl     Error: Inconsistent values for GETTEXT_PACKAGE_LIBGPHOTO2 and po/Makevars DOMAIN.
dnl if the consistency check has failed.
dnl
m4_pattern_allow([AM_V_P])dnl
cat >>${GP_GETTEXT_SETUP_MK} <<EOF
	@set -e; \\
	MAKEVARS_FILE="\$\$(test -f '$3/Makevars' || echo '\$(srcdir)/')$3/Makevars"; \\
	MAKEVARS_DOMAIN="\$\$(\$(SED) -n 's/^DOMAIN \\{0,\\}= \\{0,\\}//p' "\$\$MAKEVARS_FILE")"; \\
	MAKE_TIME_DOMAIN="\$($1)"; \\
	if test "x\$\$MAKEVARS_DOMAIN" = "x\$($1)"; then \\
	     if \$(AM_V_P); then printf "  %-7s %s\n" CHECK "Good: Matching gettext domain values (\$($1))"; fi; \\
	     true; \\
	elif test "x\$\$USE_NLS" = xyes; then \\
	     printf "  %-7s %s\n" CHECK "Error: Mismatching gettext domain values (\$($1) vs \$\${MAKEVARS_DOMAIN})"; \\
	     false; \\
	else \\
	     printf "  %-7s %s\n" CHECK "Warning: Mismatching gettext domain values (\$($1) vs \$\${MAKEVARS_DOMAIN})"; \\
	     true; \\
	fi
EOF
dnl
])dnl
dnl
dnl
dnl ####################################################################
dnl Setup for the po subdir specific setup
dnl ####################################################################
dnl
AC_DEFUN_ONCE([GP_GETTEXT_SETUP_INIT], [dnl
AC_BEFORE([$0], [GP_GETTEXT_SETUP])dnl
dnl
dnl The LOCALEDIR definition contains too many levels of recursive
dnl make variable definitions to evaluate via shell, so we have make
dnl resolve that instead of the shell configure script.
AM_CPPFLAGS="$AM_CPPFLAGS -DLOCALEDIR=\\\""'${localedir}'"\\\""
dnl
dnl
AC_SUBST_FILE([GP_GETTEXT_SETUP_MK])
GP_GETTEXT_SETUP_MK="gp-gettext-setup.mk"
dnl
dnl
cat >${GP_GETTEXT_SETUP_MK} <<EOF

# ${GP_GETTEXT_SETUP_MK} autogenerated by $0

distclean-local: distclean-local-gp-gettext-setup
.PHONY: distclean-local-gp-gettext-setup
distclean-local-gp-gettext-setup:
	-rm -f ${GP_GETTEXT_SETUP_MK}

all-local: all-local-gp-gettext-setup
.PHONY: all-local-gp-gettext-setup
all-local-gp-gettext-setup:
	@:
EOF
dnl
dnl
])dnl
dnl
dnl
dnl ####################################################################
dnl
dnl Local Variables:
dnl mode: autoconf
dnl End:
