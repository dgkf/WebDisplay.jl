using Restful
import Restful.json

const _web = Restful.app()
const extra_header = Ref{String}("")

_web.get("/") do req, res, route
    theme = get(ENV, "WEB_DISPLAY_THEME", "light")
    res.html(extra_header[] * read(joinpath(@__DIR__, "..", "assets", "$theme.html"), String))
end

_web.get("/hist", json) do req, res, route
    from = try parse(Int, req.params["from"]) catch; 1 end
    from > length(_display.hist) && wait(_display.cond)

    res.json(map(first, _display.hist[from:end]))
end

_web.get("/hist/:id") do req, res, route
    id = parse(Int, route.id)
    id > length(_display.hist) && return res.code(404)

    res.status = 200
    res.content_type, res.body = _display.hist[id]
end

_web.delete("/hist/:id") do req, res, route
    id = parse(Int, route.id)
    id > length(_display.hist) && return res.code(404)

    _display.hist[id] = ("", UInt8[])
    res.code(200)
end