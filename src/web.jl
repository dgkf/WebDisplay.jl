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
    HTTP.Response(200, ["Content-Type" => sniff_mime(fullpath)], read(fullpath))
end)

HTTP.register!(_router, "GET", "/next", function(req::HTTP.Request)
    wait(_display.cond)
    HTTP.Response(
        200,
        ["Content-Type" => string(_display.content_type)],
        _display.content
    )
end)
