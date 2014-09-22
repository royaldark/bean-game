"use strict"
express = require("express")
controller = require("./game.controller")
router = express.Router()

router.get "/", controller.index
router.get "/:id", controller.show
router.post "/", controller.create
router.put "/:id", controller.update
router.patch "/:id", controller.update
router.delete "/:id", controller.destroy
router.post '/:id/nextPhase', controller.nextPhase
router.post '/:id/nextTurn', controller.nextTurn

module.exports = router
