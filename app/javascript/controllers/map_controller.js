// app/javascript/controllers/map_controller.js
import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    console.log("Map controller connected!");

    // Set the Mapbox access token
    mapboxgl.accessToken = this.apiKeyValue;

    // Log the markers to help with debugging
    console.log("Map markers data:", this.markersValue);

    // Initialize the map
    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    });

    // Add navigation controls
    this.map.addControl(new mapboxgl.NavigationControl(), 'top-right');

    // Wait for map to load before adding markers
    this.map.on('load', () => {
      console.log("Map loaded, adding markers...");
      if (this.markersValue && this.markersValue.length > 0) {
        this.#addMarkersToMap();
        this.#fitMapToMarkers();
      } else {
        console.warn("No markers provided to map");
        // Default to Japan if no markers
        this.map.setCenter([138.2529, 36.2048]);
        this.map.setZoom(5);
      }
    });
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      // Validate coordinates
      if (!this.#isValidCoordinate(marker.lng, marker.lat)) {
        console.error(`Invalid coordinates for marker: ${JSON.stringify(marker)}`);
        return;
      }

      console.log(`Adding marker at coordinates: ${marker.lng}, ${marker.lat}`);

      // Create an ultra-minimalist popup with just essential info
      let popupContent = '';
      if (marker.name) {
        // Don't truncate names, show full name
        const displayName = marker.name;

        // Only show city OR prefecture to save space (prefer prefecture)
        const locationDetail = marker.prefecture || marker.city || '';

        popupContent = `<div class="info-window">
          <p class="marker-location-name">${displayName}</p>
          ${locationDetail ? `<small>${locationDetail}</small>` : ''}
        </div>`;
      }

      // Create a minimal popup with smaller offset and no width constraint
      const popup = new mapboxgl.Popup({
        offset: 10,
        closeButton: false,
        closeOnClick: true,
        className: 'minimal-popup'
      }).setHTML(popupContent || '<div class="info-window"><p>Location</p></div>');

      // Create a custom HTML element for the marker - using a wilderness-themed marker
      const el = document.createElement('div');
      el.className = 'map-marker';
      el.innerHTML = `<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <circle cx="12" cy="10" r="7" fill="#2E7D32" stroke="#1B5E20" stroke-width="1.5"/>
        <path d="M12 3 L14 8 L12 10 L10 8 Z" fill="#1B5E20"/>
        <path d="M7 9 L12 17 L17 9" fill="#4CAF50" stroke="#1B5E20" stroke-width="0.5"/>
      </svg>`;
      el.style.cursor = 'pointer';

      // Add marker to map with the popup
      const mapMarker = new mapboxgl.Marker(el)
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map);

      // Let users click to see the popup rather than showing it automatically
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
      // Handle single marker differently (closer zoom)
      if (validMarkers === 1) {
        const marker = this.markersValue.find(m => this.#isValidCoordinate(m.lng, m.lat));
        this.map.setCenter([marker.lng, marker.lat]);
        this.map.setZoom(14); // Closer zoom for single marker
      } else {
        // Fit to bounds for multiple markers
        this.map.fitBounds(bounds, {
          padding: 70,
          maxZoom: 12,
          duration: 500
        });
      }
    } else {
      // Default to Japan view if no valid markers
      this.map.setCenter([138.2529, 36.2048]);
      this.map.setZoom(5);
    }
  }

  #isValidCoordinate(lng, lat) {
    // Check if coordinates are valid numbers within reasonable ranges
    const validLng = lng !== null && lng !== undefined && !isNaN(parseFloat(lng)) && parseFloat(lng) >= -180 && parseFloat(lng) <= 180;
    const validLat = lat !== null && lat !== undefined && !isNaN(parseFloat(lat)) && parseFloat(lat) >= -90 && parseFloat(lat) <= 90;

    // Filter out coordinates that are exactly 0,0 (middle of ocean)
    const isZeroZero = parseFloat(lng) === 0 && parseFloat(lat) === 0;

    const isValid = validLng && validLat && !isZeroZero;

    if (!isValid) {
      console.warn(`Invalid coordinates: lng=${lng}, lat=${lat}`);
    }

    return isValid;
  }
}
