# Copyright (c) 2019 Sean Vig

from pywayland.server import Display
from typing import TYPE_CHECKING

from wlroots import ffi, lib

if TYPE_CHECKING:
    from wlroots.renderer import Renderer


class Compositor:
    def __init__(self, display: Display, renderer: "Renderer"):
        """A compositor for clients to be able to allocate surfaces

        :param display:
            The Wayland server display to attach to the compositor.
        :param renderer:
            The wlroots renderer to attach the compositor to.
        """
        self._ptr = lib.wlr_compositor_create(display._ptr, renderer._ptr)