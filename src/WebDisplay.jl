module WebDisplay
    include("web.jl")
    include("display.jl")

    function __init__()
        host = get(ENV, "WEB_DISPLAY_HOST", "0.0.0.0")
        port = try parse(Int, ENV["WEB_DISPLAY_PORT"]) catch; rand(6000:9000) end
        @async _web.listen(host, port)
        pushdisplay(_display)
        @info "WebDisplay listening on $host:$port"
    end
end