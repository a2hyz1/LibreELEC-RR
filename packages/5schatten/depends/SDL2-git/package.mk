# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="SDL2-git"
PKG_VERSION="0330891"
PKG_SHA256="ff25f262a53f29ff4ef129dded438a9a86f8dac17aae1c422560e04a0517b41c"
PKG_LICENSE="GPL"
PKG_SITE="https://www.libsdl.org/"
PKG_URL="https://github.com/spurious/SDL-mirror/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain yasm:host alsa-lib systemd dbus"
PKG_LONGDESC="SDL2: A cross-platform Graphic API"

# X11 Support
if [ "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libX11 libXrandr"
  SUPPORT_X11="-DVIDEO_X11=ON \
               -DX11_SHARED=ON \
               -DVIDEO_X11_XCURSOR=OFF \
               -DVIDEO_X11_XINERAMA=OFF \
               -DVIDEO_X11_XINPUT=OFF \
               -DVIDEO_X11_XRANDR=ON \
               -DVIDEO_X11_XSCRNSAVER=OFF \
               -DVIDEO_X11_XSHAPE=OFF \
               -DVIDEO_X11_XVM=OFF"
else
  SUPPORT_X11="-DVIDEO_X11=OFF"
fi

# OpenGL Support
if [ ! "$OPENGL" = "no" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $OPENGL"
  SUPPORT_OPENGL="-DVIDEO_OPENGL=ON"
else
  SUPPORT_OPENGL="-DVIDEO_OPENGL=OFF"
fi

# OpenGLES Support
if [ ! "$OPENGLES" = "no" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $OPENGLES"
  SUPPORT_OPENGLES="-DVIDEO_OPENGLES=ON"
else
  SUPPORT_OPENGLES="-DVIDEO_OPENGLES=OFF"
fi

# RPi Video Support
if [ "$OPENGLES" = "bcm2835-driver" ]; then
  SUPPORT_RPI="-DVIDEO_RPI=ON \
               -DVIDEO_VULKAN=OFF \
               -DVIDEO_KMSDRM=OFF"
else
  SUPPORT_RPI="-DVIDEO_RPI=OFF"
fi

# AML Mali Video Support
if [ "$OPENGLES" = "opengl-meson" ] || [ "$OPENGLES" == "opengl-meson-t82x" ]; then
  SUPPORT_MALI="-DVIDEO_MALI=ON \
                -DVIDEO_VULKAN=OFF \
                -DVIDEO_KMSDRM=OFF"
else
  SUPPORT_MALI="-DVIDEO_MALI=OFF"
fi

# Pulseaudio Support
if [ "$PULSEAUDIO_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pulseaudio"

  SUPPORT_PULSEAUDIO="-DPULSEAUDIO=ON \
                      -DPULSEAUDIO_SHARED=ON"
else
  SUPPORT_PULSEAUDIO="-DPULSEAUDIO=OFF \
                      -DPULSEAUDIO_SHARED=OFF"
fi

PKG_CMAKE_OPTS_TARGET="-DSDL_STATIC=OFF \
                       -DLIBC=ON \
                       -DGCC_ATOMICS=ON \
                       -DASSEMBLY=ON \
                       -DALTIVEC=OFF \
                       -DOSS=OFF \
                       -DALSA=ON \
                       -DALSA_SHARED=ON \
                       -DESD=OFF \
                       -DESD_SHARED=OFF \
                       -DARTS=OFF \
                       -DARTS_SHARED=OFF \
                       -DNAS=OFF \
                       -DNAS_SHARED=ON \
                       -DSNDIO=OFF \
                       -DDISKAUDIO=OFF \
                       -DDUMMYAUDIO=OFF \
                       -DVIDEO_WAYLAND=OFF \
                       -DVIDEO_WAYLAND_QT_TOUCH=ON \
                       -DWAYLAND_SHARED=OFF \
                       -DVIDEO_MIR=OFF \
                       -DMIR_SHARED=OFF \
                       -DVIDEO_COCOA=OFF \
                       -DVIDEO_DIRECTFB=OFF \
                       -DVIDEO_VIVANTE=OFF \
                       -DDIRECTFB_SHARED=OFF \
                       -DFUSIONSOUND=OFF \
                       -DFUSIONSOUND_SHARED=OFF \
                       -DVIDEO_DUMMY=OFF \
                       -DINPUT_TSLIB=OFF \
                       -DPTHREADS=ON \
                       -DPTHREADS_SEM=ON \
                       -DDIRECTX=OFF \
                       -DSDL_DLOPEN=ON \
                       -DCLOCK_GETTIME=OFF \
                       -DRPATH=OFF \
                       -DRENDER_D3D=OFF \
                       $SUPPORT_X11 \
                       $SUPPORT_OPENGL \
                       $SUPPORT_OPENGLES \
                       $SUPPORT_RPI \
                       $SUPPORT_MALI \
                       $SUPPORT_PULSEAUDIO"

post_makeinstall_target() {
  $SED "s:\(['=\" ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" $SYSROOT_PREFIX/usr/bin/sdl2-config

  rm -rf $INSTALL/usr/bin
}