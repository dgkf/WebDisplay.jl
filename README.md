WebDisplay.jl
=============

Display text, image, audio and videos in a web page. Probably the simplest approach to plot in a remote server.

### Installation

`WebDisplay.jl` depends on `Restful.jl`, which is under developement. For maximum compatibility, we recommand install the
tested version (#2877b87) with the following code.

```
julia> ] # this brings you to the `pkg>` prompt
(v1.0) pkg> add Restful#b84b54bac6987176d926abc1b319fd69
(v1.0) pkg> add https://github.com/ylxdzsw/WebDisplay.jl
```

### Usage

```julia
using WebDisplay
```

Yes, you are done. Now values returned in the REPL are displayed at the printed link (it looks like `[ Info: WebDisplay listening on 0.0.0.0:6490`).
You can still print things to the terminal by `println` or `@info`.

### Configuration

WebDisplay reads several environment variables. They can be set in shell or by runing `ENV[name]=value` in Julia *before*
`using WebDisplay`.

- `WEB_DISPLAY_HOST`: the host to listen to. Since the primary usecase of WebDisplay is to show plots in a remote server,
the default value is `0.0.0.0`, which means everyone can access your secret output.
- `WEB_DISPLAY_PORT`: the TCP port to listen to. The default value is `rand(6000:9000)`.
- `WEB_DISPLAY_THEME`: the web page CSS theme. Avaliable values: `light` (default) and `dark`.
- `WEB_DISPLAY_NOTEXT`: do not catch "text/plain" displays if this variable exists.

In addition, you can set a custom header for the webpage like the following example. Refresh the webpage to take effect.

```
WebDisplay.extra_header[] = """
    <script src="http://echarts.baidu.com/dist/echarts.min.js"></script>
    <script src="http://echarts.baidu.com/asset/theme/dark.js"></script>
"""
```

### Troubleshooting

#### Julia still trys to open browser / GTK window to show images

Most likely because another package (like `Gadfly`) pushed another display into the stack. You can inspect the stack with
`@info map(typeof, Base.Multimedia.displays)`. If `_WebDisplay` is not the *last* element, run `popdisplay()` until it is.

### Snippets

#### insert a document section

````julia
using Markdown # this is a stdlib so you already have

md"""
# Document section

write something explanatory for the code

```julia
E = mc²
```
"""

````

#### Save Results

save the history data for reproducing the webpage

```julia
using JLD2 # https://github.com/JuliaIO/JLD2.jl

header = WebDisplay.extra_header[]
hist = WebDisplay._display.hist

# save REPL command history incase you need them in the future
repl = Base.active_repl.interface.modes[1].hist
repl_hist = repl.history[repl.start_idx+1:end]

@save "hist.jld2" header hist repl_hist
```

load and restore

```julia
@load "hist.jld2" header hist

WebDisplay.extra_header[] = header
resize!(WebDisplay._display.hist, length(hist));
WebDisplay._display.hist .= hist
```

Another approach is to save the generated webpage. [SingleFile](https://github.com/gildas-lormeau/SingleFile) is an
excellent tool that can save the whole page into a single HTML file.
