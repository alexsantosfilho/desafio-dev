import consumer from "channels/consumer"
import * as Turbo from "@hotwired/turbo"

consumer.subscriptions.create("ImportStatusChannel", {
  connected() {
    console.log("Connected to the import status channel!");
  },
  disconnected() {
    console.log("Disconnected from the import status channel!");
  },
  received(data) {
    console.log("Received data from channel:", data);
    if (data && data.turbo_stream) {
      console.log("Turbo Stream data received:", data.turbo_stream);
      try {
        Turbo.renderStreamMessage(data.turbo_stream);
        console.log("Turbo Stream message rendered successfully.");
      } catch (e) {
        console.error("Error rendering Turbo Stream message:", e);
      }
    } else {
      console.log("No Turbo Stream data received.");
    }
  }
});