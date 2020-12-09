window.addEventListener('turbolinks:load', () => {
  window.addEventListener('ajax:success', (event) => {
    const [data, _status, xhr] = event.detail;

    if (xhr.status == 200) {
      $(event.target).text(data.button.text)
      $(event.target).attr('href', data.button.href)
      $(event.target).attr('class', data.button.class)
    }

  });
});
