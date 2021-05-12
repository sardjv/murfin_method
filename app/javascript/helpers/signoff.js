window.addEventListener('turbo:load', () => {
  if(document.querySelector('.state-badge') !== null) {
    window.addEventListener('ajax:success', (event) => {
      const [data, _status, xhr] = event.detail

      if (xhr.status == 200) {
        $('.state-badge').text(data.plan.state_badge.text)
        $('.state-badge').attr('class', data.plan.state_badge.class)
        $(event.target).text(data.signoff.button.text)
        $(event.target).attr('href', data.signoff.button.href)
        $(event.target).attr('class', data.signoff.button.class)
      }
    })
  }
})
