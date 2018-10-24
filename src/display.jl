using Base.Multimedia
import Base.display

struct _WebDisplay <: AbstractDisplay
    hist::Vector{Tuple{String, Vector{UInt8}}}
    cond::Condition
end

const web_displayable = map(MIME, [ # in "richness" order
    "text/html", "video/mpeg", "video/mp4", "video/ogg", "video/webm",
    "image/svg+xml", "image/png", "image/gif", "image/webp", "image/jpeg",
    "audio/midi", "audio/acc", "audio/wav", "audio/ogg", "audio/webm",
    "application/pdf", "application/xhtml+xml", "text/plain"
])

"this method choose argmax_richness{mime | showable(mime, x) && displayable(mime, d)}"
function display(d::_WebDisplay, x)
    for mime in web_displayable
        showable(mime, x) && return display(d, mime, x)
    end
    throw(MethodError(display, (d, x)))
end

function tobytes(mime::MIME, x)
    buf = IOBuffer()
    show(IOContext(buf, :limit=>true), string(mime), x)
    take!(buf)
end

function display(d::_WebDisplay, mime::Union{map(typeof, web_displayable)...}, x)
    @debug "displaying $mime" length(tobytes(mime, x))
    push!(d.hist, (string(mime), tobytes(mime, x)))
    notify(d.cond)
end

const _display = _WebDisplay([], Condition())