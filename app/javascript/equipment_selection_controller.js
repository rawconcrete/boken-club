<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">Equipment</h5>
  </div>
  <div class="card-body">
    <div class="selected-items mb-3">
      <% travel_plan.equipment.each do |item| %>
        <div class="badge bg-primary p-2 m-1 d-inline-flex align-items-center">
          <%= item.name %>
          <button type="button" class="btn-close ms-2"
                  data-action="click->travel-plan#removeEquipment"
                  data-equipment-id="<%= item.id %>"></button>
          <input type="hidden" name="travel_plan[equipment_ids][]" value="<%= item.id %>">
        </div>
      <% end %>
    </div>
    <div data-travel-plan-target="selectedEquipment"></div>
    <% Equipment.all.each do |equipment| %>
      <div class="form-check">
        <%= check_box_tag "travel_plan[equipment_ids][]", equipment.id,
            travel_plan.equipment_ids.include?(equipment.id),
            id: "equipment_#{equipment.id}",
            class: "form-check-input" %>
        <%= label_tag "equipment_#{equipment.id}", equipment.name, class: "form-check-label" %>
      </div>
    <% end %>
  </div>
</div>
