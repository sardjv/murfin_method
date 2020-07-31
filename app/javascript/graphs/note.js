import Rails from '@rails/ujs'
import iconPath from '!!svg-url-loader!../../../node_modules/bootstrap-icons/icons/envelope.svg';

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

    Note.addNotePoint(response.start_time, response)

    $('#modal').modal('hide')
  }
});

export class Note {
  static icon() {
    let noteIcon = new Image();
    noteIcon.width = noteIcon.height = '30';
    noteIcon.src = iconPath;
    return noteIcon;
  }

  static debouncedGetNewNote = _.debounce(Note.getNewNote, 1000, {
    'leading': true
  })
  static getNewNote(date) {
    Rails.ajax({
      url: '/notes/new',
      type: 'GET',
      data: 'note[start_time]=' + date.toISOString()
    });
  }

  static debouncedGetEditNote = _.debounce(Note.getEditNote, 1000, {
    'leading': true
  })
  static getEditNote(note_id) {
    Rails.ajax({
      url: '/notes/' + note_id + '/edit',
      type: 'GET',
      dataType: 'html'
    });
  }

  static addNotePoint(date, new_note) {
    const index = Note.nearestLabel(global.chart.data.originalLabels, date)

    global.chart.data.datasets.forEach((dataset) => {
      // An array of arrays of notes, grouped by date, like [[], [{id: 1,...},{id: 2,...}]].
      let all_notes = dataset.notes

      // If the note already exists, remove it (in case the date has changed).
      all_notes = _.map(all_notes, (date_notes) => {
        return _.compact(_.map(date_notes, (note) => {
          if (note.id != new_note.id) {
            return note
          }
        }));
      });

      // Add the new/moved note on the right date.
      all_notes[index].push(new_note)

      dataset.notes = all_notes
    });
    global.chart.update();
  }

  static getPrevNoteId(note_id) {
    let prev
    global.chart.data.datasets.forEach((dataset) => {
      const notes = _.flatten(dataset.notes)
      const currentIndex = _.findIndex(notes, (note) => { return note.id === note_id });
      if (currentIndex === 0) {
        prev = notes.pop()
      } else if (currentIndex > 0) {
        prev = notes[currentIndex - 1]
      }
    });
    return prev.id
  }

  static getNextNoteId(note_id) {
    let next
    global.chart.data.datasets.forEach((dataset) => {
      const notes = _.flatten(dataset.notes)
      const currentIndex = _.findIndex(notes, (note) => { return note.id === note_id });
      if (currentIndex === notes.length - 1) {
        next = notes[0]
      } else if (currentIndex > -1) {
        next = notes[currentIndex + 1]
      }
    });
    return next.id
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
