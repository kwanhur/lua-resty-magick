# lua-resty-magick
Lua wrapper with [magick](https://github.com/kwanhur/magick) to process image.

Table of Contents
=================

* [Name](#name)
* [Status](#status)
* [Synopsis](#synopsis)
* [Methods](#methods)
    * [new](#new)
    * [load_image](#load-image)
    * [resize](#resize)
    * [set_format](#set-format)
    * [get_blob](#get-blob)
* [Installation](#installation)
* [Dependency](#dependency)
* [Authors](#authors)
* [Copyright and License](#copyright-and-license)

Status
======

This library is produce ready and under active development.

Synopsis
========
```lua
    lua_package_path "/path/to/lua-resty-magick/lib/?.lua;/path/to/magick/?.lua;;";

    server {
        location /t {
            content_by_lua '
              local magick = require('resty.magick.init')
              local options = {
                width = ngx.var.image_width,
                height = ngx.var.image_height,
                quality = ngx.var.image_quality,
                format = ngx.var.image_extension,
              }
              local blob = '' -- fetch image blob content by myself
              local magic = magick:new(options)
              local ok, err = magic:load()
              if not ok then
                  ngx.log(ngx.ERR, err)
                  return
              end
              magick:resize()
              local webp_options = { quality = 75, lossless = "0" }
              ok, err = magic:set_format('webp', webp_options)
              if not ok then
                  ngx.log(ngx.ERR, err)
                  return
              end
              local blob = magic:get_blob()
              ngx.print(blob)
            ';
        }
    }
```

Methods
=======

[Back to TOC](#table-of-contents)

new
---
`syntax: magic = magick:new(options)`

Create a new magick object.

[Back to TOC](#table-of-contents)

load_image
----------
`syntax: ok, err = magic:load_image(blob)`

Load the specified origin magick image

[Back to TOC](#table-of-contents)

resize
----------
`syntax: ok, err = magic:resize()`

Resize the image

[Back to TOC](#table-of-contents)

set_format
----------
`syntax: ok, err = magic:set_format('webp', webp_options)`

Set converter target magick image format

[Back to TOC](#table-of-contents)

get_blob
------
`syntax: blob = magic:get_blob()`

Fetch the magick image blob content

[Back to TOC](#table-of-contents)

Installation
============

You can install it with [opm](https://github.com/openresty/opm#readme).
Just like that: opm install kwanhur/lua-resty-magick

luarocks install [magick](https://github.com/kwanhur/magick#installation)

[Back to TOC](#table-of-contents)

Dependency
============

* [ImageMagick](https://github.com/ImageMagick/ImageMagick)
* [GraphicsMagick](http://hg.code.sf.net/p/graphicsmagick/code)
* [libwebp](https://github.com/webmproject/libwebp)

[Back to TOC](#table-of-contents)

Authors
=======

kwanhur <huang_hua2012@163.com>, VIPS Inc.

[Back to TOC](#table-of-contents)

Copyright and License
=====================

This module is licensed under the BSD 2-Clause License .

Copyright (C) 2016, by kwanhur <huang_hua2012@163.com>, VIPS Inc.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[Back to TOC](#table-of-contents)