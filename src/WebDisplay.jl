module WebDisplay
    using Logging

    include("mime.jl")
    include("web.jl")
    include("display.jl")

    function __init__()
        host = get(ENV, "WEB_DISPLAY_HOST", "0.0.0.0")
        port = parse(Int, get(ENV, "WEB_DISPLAY_PORT", "1234"))

        @async with_logger(SimpleLogger(stderr, Logging.Error)) do
            HTTP.serve!(_router, "0.0.0.0", 1234)
        end

        pushdisplay(_display)
        @info "WebDisplay listening on $host:$port"
    end
end
