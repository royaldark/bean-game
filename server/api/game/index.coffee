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
router.post '/:id/buyBeanField', controller.buyBeanField
router.post '/:id/harvest/:fieldId', controller.harvest
router.post '/:id/plant/:cardId/field/:fieldId', controller.plantCard
router.post '/:id/drawTwo', controller.drawTwo
router.post '/:id/drawThree', controller.drawThree

module.exports = router
