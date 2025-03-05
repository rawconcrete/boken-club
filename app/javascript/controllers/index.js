import { application } from "controllers/application"
import EquipmentStatusController from "./equipment_status_controller"
import HelloController from "./hello_controller"
import MapController from "./map_controller"
import NavbarController from "./navbar_controller"
import SafetyCriticalController from "./safety_critical_controller"
import SearchAdventuresController from "./search_adventures_controller"
import SearchController from "./search_controller"
import SearchLocationsController from "./search_locations_controller"
import SearchSkillsController from "./search_skills_controller"
import SkillsRecommendationController from "./skills_recommendation_controller"
import TravelPlanController from "./travel_plan_controller"

application.register("equipment-status", EquipmentStatusController)
application.register("hello", HelloController)
application.register("map", MapController)
application.register("navbar", NavbarController)
application.register("safety-critical", SafetyCriticalController)
application.register("search-adventures", SearchAdventuresController)
application.register("search", SearchController)
application.register("search-locations", SearchLocationsController)
application.register("search-skills", SearchSkillsController)
application.register("skills-recommendation", SkillsRecommendationController)
application.register("travel-plan", TravelPlanController)
