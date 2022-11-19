using Base.Multimedia
import Base.display

mutable struct _WebDisplay <: AbstractDisplay
    content::Union{Missing,Vector{UInt8}}
    content_type::MIME
    cond::Condition
end

const web_displayable = map(MIME, [ # in "richness" order
    "text/html", 
    "video/mpeg", 
    "video/mp4", 
    "video/ogg", 
    "video/webm",
    "image/svg+xml", 
    "image/png", 
    "image/gif", 
    "image/webp", 
    "image/jpeg",
    "audio/midi", 
    "audio/acc", 
    "audio/wav", 
    "audio/ogg", 
    "audio/webm",
    "application/pdf", 
    "application/xhtml+xml"
])

function display(d::_WebDisplay, x)
    for mime in web_displayable[1:end-1]
        showable(mime, x) && return display(d, mime, x)
    end

    if showable(MIME("text/plain"), x)
        if "WEB_DISPLAY_TEXT" in keys(ENV)
            return display(d, MIME("text/plain"), x)
        elseif !("WEB_DISPLAY_NOTEXT" in keys(ENV))
            return display(stdout, MIME("text/plain"), x)
        end
    end

    display(stdout, MIME("text/plain"), x)
end

function tobytes(mime::MIME, x)
    buf = IOBuffer()
    show(IOContext(buf, :limit=>true), mime, x)
    take!(buf)
end

function display(d::_WebDisplay, mime::Union{map(typeof, web_displayable)...}, x)
    d.content_type = mime
    d.content = tobytes(mime, x)
    notify(d.cond)

    if isinteractive()
        println(stderr, "[shown as $mime on WebDisplay]")
    end
end

_display = _WebDisplay(missing, MIME("text/plain"), Condition())
