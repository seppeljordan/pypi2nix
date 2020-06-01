from .framework import IntegrationTest


class PillowTestCase(IntegrationTest):
    name_of_testcase = "pillow"
    code_for_testing = ["import PIL"]
    requirements = ["Pillow==7.1.2"]

    external_dependencies = [
        "pkgconfig",
        "zlib",
        "libjpeg",
        "openjpeg",
        "libtiff",
        "freetype",
        "lcms2",
        "libwebp",
        "tcl",
        "xorg.libxcb",
    ]
