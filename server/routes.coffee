express = require 'express'
router = express.Router()
serverController = require './serverController'

router.post '/api/addUsers', serverController.addUsers

router.post '/api/createGroup', serverController.createGroup
router.post '/api/deleteGroup', serverController.deleteGroup
router.post '/api/getGroup', serverController.getGroup
router.post '/api/updateGroup', serverController.updateGroup
router.post '/api/subscribeGroup', serverController.subscribeGroup
router.post '/api/getGroupSubscribers', serverController.getGroupSubscribers
router.post '/api/createAnalysis', serverController.createAnalysis
router.post '/api/deleteAnalysis', serverController.deleteAnalysis
router.post '/api/getAnalysis', serverController.getAnalysis
router.post '/api/updateAnalysis', serverController.updateAnalysis
router.post '/api/getAnalitics', serverController.getAnalitics
router.post '/api/getGroupsByAnaliticId', serverController.getGroupsByAnaliticId
router.post '/api/getInvestors', serverController.getInvestors
router.post '/api/getGroupAnalysis', serverController.getGroupAnalysis
router.post '/api/setAnalysisComments', serverController.setAnalysisComments
router.post '/api/getAnalysisComments', serverController.getAnalysisComments






module.exports = router
