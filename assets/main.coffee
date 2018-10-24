count = 1

get_list = () ->
    fetch '/hist?from=' + count
        .then (x) -> x.json()
        .then (list) -> for item in list
            div = document.createElement 'div'
            div.setAttribute 'class', 'webdisplay'
            document.body.appendChild div
            render count, div, item
            count += 1
        .finally -> setTimeout get_list, 0

render = (id, div, type) -> switch
    when type is ''
        break
    when type is 'text/html'
        fetch "/hist/#{id}"
            .then (x) -> x.text()
            .then (x) -> div.innerHTML = x
    when type is 'text/plain'
        fetch "/hist/#{id}"
            .then (x) -> x.text()
            .then (x) -> div.textContent = x
    when type is 'application/pdf'
        div.innerHTML = """
            <embed src="/hist/#{id}" width="800" height="600" type="application/pdf">
        """
    when type.startsWith 'image/'
        div.innerHTML = """
            <img src="/hist/#{id}" />
        """
    else
        console.warn("do not know how to render #{type} for id #{id}")

do get_list