// app/javascript/controllers/index.js
// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";

console.log("✅ Stimulus Controllers Loading...");
eagerLoadControllersFrom("controllers", application);
console.log("✅ Stimulus Controllers Loaded!");

document.addEventListener("turbo:load", () => {
  application.controllers.forEach((controller) => {
    console.log(`🚀 Stimulus Controller Loaded: ${controller.identifier}`);
    controller.connect();
  });
});
