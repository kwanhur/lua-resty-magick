-- Copyright (C) by Kwanhur Huang


local modulename = "magickInit"
local _M = {}
local mt = { __index = _M }
_M._VERSION = '0.1.1'
_M._NAME = modulename

local magick = require("magick.wand")

local tonumber = tonumber
local tostring = tostring
local setmetatable = setmetatable

local DEFAULT_FILTER = "Triangle"
local DEFAULT_QUALITY = 75
local DEFAULT_UNIT = -1

local is_jpg = function(postfix)
    return postfix == 'jpg' or postfix == 'jpeg'
end

_M.new = function(self, options)
    self.width = tonumber(options.width) or DEFAULT_UNIT
    self.height = tonumber(options.height) or DEFAULT_UNIT
    self.quality = tonumber(options.quality) or DEFAULT_QUALITY
    self.format = options.format
    self.filter = options.filter or DEFAULT_FILTER
    self.src = nil
    return setmetatable(self, mt)
end

_M.load_image = function(self, blob)
    return magick.load_image_from_blob(blob)
end

_M.resize = function(self)
    local ok, msg, code

    local max_width = self.width
    local max_height = self.height
    local quality = self.quality

    if not max_width or not max_height or max_width == DEFAULT_UNIT or max_height == DEFAULT_UNIT then
        return
    end

    local sx = tonumber(self.src:get_width())
    local sy = tonumber(self.src:get_height())
    local s_quality = tonumber(self.src:get_quality())

    self.src:strip()
    if quality and 0 < quality and quality <= s_quality then
        ok, msg, code = self.src:set_quality(quality)
    else
        ok, msg, code = self.src:set_quality(75)
    end
    if not ok then
        return ok, msg, code
    end

    if max_width >= sx and max_height >= sy then
        ngx.log(ngx.WARN, "too large size:", max_width, "x", max_height, " ", sx, "x", sy)
        return
    end

    if is_jpg(self.format) then
        ok, msg, code = self.src:set_property("jpeg:sampling-factor", "2x2,1x1,1x1")
        if not ok then
            return ok, msg, code
        end
    end

    local dx, dy = sx, sy
    if dx > max_width then
        dy = dy * max_width / dx
        if dy < 1 then
            dy = 1
        end
        dx = max_width
    end
    if dy > max_height then
        dx = dx * max_height / dy
        if dx < 1 then
            dx = 1
        end
        dy = max_height
    end
    return self.src:resize(dx, dy, self.filter)
end

_M.set_format = function(self, format, options)
    local ok, msg, code
    if format == 'webp' then
        local quality = tonumber(options.quality)
        ok, msg, code = self.src:set_format("webp")
        if not ok then
            return ok, msg, code
        end
        ok, msg, code = self.src:set_option("webp", "lossless", tostring(options.lossless or "0"))
        if not ok then
            return ok, msg, code
        end

        if quality ~= nil and 0 < quality and quality <= 100 then
            ok, msg, code = self.src:set_quality(quality)
        else
            ok, msg, code = self.src:set_quality(DEFAULT_QUALITY)
        end
    else
        ok, msg, code = self.src:set_format(format)
    end
    return ok, msg, code
end

_M.get_blob = function(self)
    return self.src:get_blob()
end

return _M