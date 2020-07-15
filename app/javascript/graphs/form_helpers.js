export class FormHelpers {
  static setDatepicker(field_id, date) {
    $(field_id).val(this.dateToString(date))
  }

  static dateToString(date) {
    const day = ('0' + date.getDate()).slice(-2);
    const month = ('0' + (date.getMonth() + 1)).slice(-2);
    return date.getFullYear()+'-'+(month)+'-'+(day);
  }
}
