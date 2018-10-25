WebDisplay.jl
=============

Display text, image, audio and videos in a web page. Possibly the simplest approach to plot in a remote server if you
just don't like Jupyter.

### Installation

```julia
julia> ] # this brings you to the `pkg>` prompt
(v1.0) pkg> add https://github.com/ylxdzsw/WebDisplay.jl
```

### Usage

```julia
using WebDisplay
```

Yes, you are done. Now values returned in the REPL are displayed at the printed link (it looks like `[ Info: WebDisplay listening on 0.0.0.0:6490`).

### Configuration

WebDisplay reads several environment variables. They can be set in shell or by runing `ENV[name]=value` in Julia *before*
`using WebDisplay`.

- `WEB_DISPLAY_HOST`: the host to listen to. Since the primary usecase of WebDisplay is to show plots in a remote server,
the default value is `0.0.0.0`, which means everyone can access your secret output.
- `WEB_DISPLAY_PORT`: the TCP port to listen to. The default value is `rand(6000:9000)`.
- `WEB_DISPLAY_THEME`: the web page CSS theme. Avaliable values: `light` (default) and `dark`.

### Save Results

Sometimes you may want to store the precious results.

- All data need to regenerate the webpage is in `WebDisplay._display.hist`, which can be saved in a file using [JLD2](https://github.com/JuliaIO/JLD2.jl).
`_display` is immutable. To recover the webpage from your saved array `a`, you can run `x = WebDisplay._display.hist; resize!(x, length(a)); x[:] = a[:]`.
- Alternatively, you can also save the webpage. [SingleFile](https://github.com/gildas-lormeau/SingleFile) is an excellent
tool that can save the whole page into a single HTML file.
- By the way, your REPL history is `a = Base.active_repl.interface.modes[1].hist; a.history[a.start_idx:end]`

### My REPL do not work / no response / output disappears

That's because all displays are redirected to the webpage. To print something to the terminal, you can use `println` or `@info`.

### Julia still trys to open browser / GTK window to show images

Most likely because another package (like `Gadfly`) pushed another display into the stack. You can inspect the stack with
`@info map(typeof, Base.Multimedia.displays)`. If `_WebDisplay` is not the *last* element, run `popdisplay()` until it is.