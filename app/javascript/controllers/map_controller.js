// app/javascript/controllers/map_controller.js
import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    // Set the Mapbox access token
    mapboxgl.accessToken = this.apiKeyValue;

    // Initialize the map
    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    });

    console.log("Map markers:", this.markersValue);

    if (this.markersValue.length > 0) {
      this.#addMarkersToMap();
      this.#fitMapToMarkers();
    } else {
      console.error("No markers provided to map");
      // Default to Japan if no markers
      this.map.setCenter([138.2529, 36.2048]);
      this.map.setZoom(5);
    }
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      // Validate coordinates
      if (!this.#isValidCoordinate(marker.lng, marker.lat)) {
        console.error(`Invalid coordinates for marker: ${JSON.stringify(marker)}`);
        return;
      }

      console.log(`Adding marker at: ${marker.lng}, ${marker.lat}`);

      // Create popup with location info if available
      let popupContent = '';
      if (marker.name || marker.city || marker.prefecture) {
        popupContent = `<div class="info-window">
          ${marker.name ? `<h5>${marker.name}</h5>` : ''}
          ${marker.city || marker.prefecture ? `<p>${[marker.city, marker.prefecture].filter(Boolean).join(', ')}</p>` : ''}
        </div>`;
      }

      const popup = popupContent ?
        new mapboxgl.Popup({ offset: 25 }).setHTML(popupContent) : null;

      // Add marker to map
      new mapboxgl.Marker()
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map);
    });
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds();
    let validMarkers = 0;

    this.markersValue.forEach(marker => {
      if (this.#isValidCoordinate(marker.lng, marker.lat)) {
        bounds.extend([marker.lng, marker.lat]);
        validMarkers++;
      }
    });

    if (validMarkers > 0) {
      // Use a larger padding for a more zoomed-out view
      this.map.fitBounds(bounds, {
        padding: 150,
        maxZoom: 12,
        duration: 0
      });
    } else {
      // Default to Japan view if no valid markers
      this.map.setCenter([138.2529, 36.2048]);
      this.map.setZoom(5);
    }
  }

  #isValidCoordinate(lng, lat) {
    // Check if coordinates are valid numbers within reasonable ranges
    const validLng = lng !== null && lng !== undefined && !isNaN(lng) && lng >= -180 && lng <= 180;
    const validLat = lat !== null && lat !== undefined && !isNaN(lat) && lat >= -90 && lat <= 90;

    // Filter out coordinates that are exactly 0,0 (middle of ocean)
    const isZeroZero = lng === 0 && lat === 0;

    return validLng && validLat && !isZeroZero;
  }
}
