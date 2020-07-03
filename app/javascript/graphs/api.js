export class API {
  static url() {
    if (window.location.pathname == '/') {
      // Can't call root/.json.
      return '/pages/home.json'
    } else {
      return window.location.pathname + '.json'
    }
  }
}
