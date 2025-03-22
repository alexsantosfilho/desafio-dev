import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  start() {
    document.getElementById("import-status").style.display = "block";
  }
}
