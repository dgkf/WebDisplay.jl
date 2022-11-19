using HTTP, JSON3, URIs

const extra_header = Ref{String}("")

_router = HTTP.Router()
HTTP.register!(_router, "GET", "/", function(req::HTTP.Request) 
    theme = get(ENV, "WEB_DISPLAY_THEME", "light")
    HTTP.Response(200, read(joinpath(@__DIR__, "..", "assets", "$theme.html"), String))
end)

HTTP.register!(_router, "GET", "/assets/*", function(req::HTTP.Request) 
    path = URIs.URI(req.target).path
    fullpath = joinpath(@__DIR__, "..", splitpath(path)[2:end]...)
    _, ext = splitext(fullpath)
    if (ext == ".png")
        return HTTP.Response(200, ["Content-Type" => "image/png"], tobytes(read(fullpath)))
    elseif (ext == ".js")
        return HTTP.Response(200, ["Content-Type" => "application/javascript"], read(fullpath, String))
    elseif (ext == ".css")
        return HTTP.Response(200, ["Content-Type" => "text/css"], read(fullpath, String))
    end
end)

HTTP.register!(_router, "GET", "/next", function(req::HTTP.Request)
    wait(_display.cond)
    HTTP.Response(
        200,
        ["Content-Type" => string(_display.content_type)],
        _display.content
    )
end)
