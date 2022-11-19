_last = null
count = 0
follow = true

async function next() {
  const res = await fetch("/next");

  count += 1
  div = document.createElement('div')
  div.innerHTML = '<div>[...]</div><div onclick="wd_del(this, '+count+')">[X]</div>'
  document.body.appendChild(div)

  const type = res.headers.get("content-type");
  const text = await res.text();

  render(count, div, type, text)
  div.querySelector('div').textContent = "["+count+"]"
  if (follow) { div.scrollIntoView({ behavior: "smooth" }) }

  setTimeout(next, 0)
}

function render(id, div, type, content) {
  switch(type) {
    case "text/html": {
      return div.insertAdjacentHTML('beforeend', content)
    }
    case "text/plain": {
      pre = document.createElement('pre')
      pre.textContent = content
      return div.appendChild(pre)
    }
    case "application/pdf": {
      return div.insertAdjacentHTML(
        'beforeend',
        '<embed src="/hist/'+id+'" width="800" height="600" type="application/pdf">'
      )
    }
    case type.startsWith("image/"): {
      return div.insertAdjacentHTML(
        'beforeend', 
        '<img src="/hist/'+id+'"/>'
      )
    }
    default: {
      return div.insertAdjacentText('beforeend', "cannot render "+type+" msg #"+id)
    }
  }
}

function wd_tf() {
  follow = !follow
  el = document.querySelector('#-f')
  el.setAttribute('title', "follow mode: " + (follow ? 'on' : 'off'))
  if (follow) {
    el.classList.add('active') 
  } else {
    el.classList.remove('active')
  }
}

function wd_del(button, id) {
  button.parentElement.outerHTML = ''
}

document.addEventListener("DOMContentLoaded", next)
