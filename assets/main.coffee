count = 0
follow = true

get_list = () ->
    fetch '/hist?from=' + (count + 1)
        .then (x) -> x.json()
        .then (list) -> for item in list
            count += 1
            continue if item is ''
            div = document.createElement 'div'
            div.innerHTML = """
                <div>[...]</div> <div onclick="wd_del(this, #{count})">[X]</div>
            """
            document.body.appendChild div
            render count, div, item, ready div, count
        .then -> setTimeout get_list, 0
        .catch ->
            console.error "Disconnected! This session won't reconnect, refresh if you want."
            document.querySelector('#-f').outerHTML = ''

ready = (div, id) -> ->
    div.querySelector('div').textContent = "[#{id}]"
    document.body.scrollTop = document.body.scrollHeight if follow and id is count

render = (id, div, type, cb) -> switch
    when type is 'text/html'
        fetch "/hist/#{id}"
            .then (x) -> x.text()
            .then (x) -> div.insertAdjacentHTML 'beforeend', x
            .then cb
    when type is 'text/plain'
        fetch "/hist/#{id}"
            .then (x) -> x.text()
            .then (x) ->
                pre = document.createElement 'pre'
                pre.textContent = x
                div.appendChild pre
            .then cb
    when type is 'application/pdf'
        cb div.insertAdjacentHTML 'beforeend', """
            <embed src="/hist/#{id}" width="800" height="600" type="application/pdf">
        """
    when type.startsWith 'image/'
        cb div.insertAdjacentHTML 'beforeend', """
            <img src="/hist/#{id}" />
        """
    else
        cb div.insertAdjacentText 'beforeend', "cannot render #{type} msg ##{id}"

window.wd_tf = ->
    follow = !follow
    el = document.querySelector('#-f')
    el.setAttribute 'title', "follow mode: #{if follow then 'on' else 'off'}"
    if follow then el.classList.add 'active' else el.classList.remove 'active'

window.wd_del = (button, id) ->
    button.parentElement.outerHTML = ''
    fetch "/hist/#{id}", method: 'DELETE'
        .then (x) -> x.ok || Promise.reject x
        .catch (e) -> alert "deletion failed ##{id}"

do get_list