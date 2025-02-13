// app/javascript/application.js
// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers"; // ensure controllers are loaded
import "@popperjs/core";
import "bootstrap";

import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus-loading";

window.Stimulus = Application.start();
const context = require.context("controllers", true, /\.js$/);
Stimulus.load(definitionsFromContext(context));

console.log("✅ Stimulus Loaded Successfully!");
import "controllers"
