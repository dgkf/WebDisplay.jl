using Restful
import Restful.json

const _web = Restful.app()

_web.get("/hist", json) do req, res, route
    from = try parse(Int, req.params["from"]) catch e 1 end
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