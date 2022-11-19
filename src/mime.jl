const _exts = Dict(
    ".png" => "image/png",
    ".js"  => "application/javascript",
    ".css" => "text.css"
)

function sniff_mime(path)
    _, ext = splitext(path)
    get(_exts, ext, "text/plain")
end
