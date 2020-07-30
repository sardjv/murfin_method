import Rails from '@rails/ujs'

window.addEventListener('prev', (event) => {
  Note.getEditNote(Note.getPrevNoteId(event.detail.note_id))
});

window.addEventListener('next', (event) => {
  Note.getEditNote(Note.getNextNoteId(event.detail.note_id))
});

window.addEventListener('ajax:success', (event) => {
  const [data, _status, xhr] = event.detail;

  if (data.constructor !== HTMLDocument) {
    const response = JSON.parse(xhr.response)

    Note.addNotePoint(response.start_time, response.id)

    $('#modal').modal('hide')
  }
});

export class Note {
  static debouncedGetNote = _.debounce(Note.getNote, 1000, {
    'leading': true
  })
  static getNote(date, note_id) {
    if (note_id) {
      Note.getEditNote(note_id)
    } else {
      Note.getNewNote(date)
    }
  }

  static getNewNote(date) {
    Rails.ajax({
      url: '/notes/new',
      type: 'GET',
      data: 'note[start_time]=' + date.toISOString()
    });
  }

  static getEditNote(note_id) {
    Rails.ajax({
      url: '/notes/' + note_id + '/edit',
      type: 'GET',
      dataType: 'html'
    });
  }

  static addNotePoint(date, id) {
    const index = Note.nearestLabel(global.chart.data.originalLabels, date)

    global.chart.data.datasets.forEach((dataset) => {
      // An array of arrays of note_ids like [[], [], [1,2], []].
      let note_ids = dataset.note_ids

      // If the note already exists, remove it (in case the date has changed).
      const existingIndex = _.findIndex(note_ids, (ids) => { return _.includes(ids, id) })
      if (existingIndex != -1) {
        note_ids[existingIndex].pop(id)
      }

      // Add the new note.
      note_ids[index].push(id)

      dataset.note_ids = note_ids
    });
    global.chart.update();
  }

  static getPrevNoteId(note_id) {
    let prev
    global.chart.data.datasets.forEach((dataset) => {
      const ids = _.flatten(dataset.note_ids)
      const currentIndex = ids.indexOf(note_id);
      if (currentIndex === 0) {
        prev = ids.pop()
      } else if (currentIndex > 0) {
        prev = ids[currentIndex - 1]
      }
    });
    return prev
  }

  static getNextNoteId(note_id) {
    let next
    global.chart.data.datasets.forEach((dataset) => {
      const ids = _.flatten(dataset.note_ids)
      const currentIndex = ids.indexOf(note_id);
      if (currentIndex === ids.length - 1) {
        next = ids[0]
      } else if (currentIndex > -1) {
        next = ids[currentIndex + 1]
      }
    });
    return next
  }

  static nearestLabel(labels, date) {
    // Assume labels are sorted chronologically.
    let index = 0
    let nextLabel = labels[index + 1]
    while (index <= labels.length && date >= nextLabel) {
      index++
      nextLabel = labels[index + 1]
    }
    return index
  }
}
