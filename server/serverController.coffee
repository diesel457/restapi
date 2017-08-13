async = require 'async'

fieldsNotExist = (schema, data) ->
  notExist = []

  for field in schema
    value = data[field]
    unless value
      notExist.push field

  notExist

serverController =

  # Users
  addUsers: (req, res) ->
    { model } = req
    users = [
      {
        name: 'Dima Rakov',
        type: 'investor'
      }
      {
        name: 'Boris Britva',
        type: 'analyst'
      }
    ]

    async.eachSeries (users), (user, cb) ->
      model.add 'auths', user, -> cb()
    , ->
      res.json success: 'Users was created.'

  # Groups
  createGroup: (req, res) ->
    { model } = req
    group = req.body || {}
    schema = [ 'title', 'companyIds', 'paid', 'price', 'priceStamp', 'userId' ]
    notExist = fieldsNotExist schema, group

    res.json err: "Please fill: #{notExist}" if notExist?.length

    groupId = model.add 'groups', group, ->
      res.json success: model.get "groups.#{groupId}"

  deleteGroup: (req, res) ->
    { model } = req
    { groupId } = req.body

    return res.json err: 'groupId is undefined.' unless groupId
    $group = model.at "groups.#{groupId}"

    $group.fetch ->
      return res.json err: 'Group is not exist.' unless $group.get()

      model.del "groups.#{groupId}", ->
        res.json success: "Document #{groupId} is deleted."

  getGroup: (req, res) ->
    { model } = req
    { groupId } = req.body

    return res.json err: 'groupId is undefined.' unless groupId
    $group = model.at "groups.#{groupId}"

    $group.fetch ->
      return res.json err: 'Group is not exist.' unless $group.get()

      res.json success: model.get "groups.#{groupId}"

  updateGroup: (req, res) ->
    { model } = req
    group = req.body

    return res.json err: 'group is undefined.' unless group.id
    $group = model.at "groups.#{group.id}"

    $group.fetch ->
      return res.json err: 'Group is not exist.' unless $group.get()

      for key, value of group
        $group.setDiffDeep key, value

      res.json model.get "groups.#{group.id}"

  subscribeGroup: (req, res) ->
    { model } = req
    { authId, groupId } = req.body

    unless authId or groupId
      return res.json err: 'authId or groupId is not defined.'

    $group = model.at "groups.#{groupId}"
    $group.fetch ->
      return res.json err: 'Group is not exist.' unless $group.get()

      unless ($group.get('subscribeIds') || []).indexOf(authId) is -1
        return res.json err: 'Auth is subscribed on the group.'

      $group.push 'subscribeIds', authId, ->
        res.json success: $group.get()

  getGroupSubscribers: (req, res) ->
    { model } = req
    { groupId } = req.body

    $group = model.at "groups.#{groupId}"
    $group.fetch ->
      return res.json err: 'Group is not exist.' unless $group.get()

      subscribeIds = $group.get('subscribeIds')
      $subscribers = model.query 'auths', _id: $in: subscribeIds

      $subscribers.fetch ->
        unless $subscribers.get()?.length
          return res.json err: 'Subscribes is not exists.'

        res.json success: $subscribers.get()

  getGroupAnalysis: (req, res) ->
    { model } = req
    { groupId } = req.body

    $analysis = model.query 'analysis', { groupId }
    $analysis.fetch ->
      return res.json err: 'Analysis is not exist.' unless $analysis.get()
      res.json $analysis.get()

  # Analysis

  createAnalysis: (req, res) ->
    { model } = req
    analysis = req.body || {}
    schema = [ 'img', 'timestamp', 'groupId' ]
    notExist = fieldsNotExist schema, analysis

    res.json err: "Please fill: #{notExist}" if notExist?.length

    analysisId = model.add 'analysis', analysis, ->
      res.json success: model.get "analysis.#{analysisId}"

  deleteAnalysis: (req, res) ->
    { model } = req
    { analysisId } = req.body

    return res.json err: 'analysisId is undefined.' unless analysisId
    $analysis = model.at "analysis.#{analysisId}"

    $analysis.fetch ->
      return res.json err: 'Analysis is not exist.' unless $analysis.get()

      model.del "analysis.#{analysisId}", ->
        res.json success: "Document #{analysisId} is deleted."

  getAnalysis: (req, res) ->
    { model } = req
    { analysisId } = req.body

    return res.json err: 'analysisId is undefined.' unless analysisId
    $analysis = model.at "analysis.#{analysisId}"

    $analysis.fetch ->
      return res.json err: 'Analysis is not exist.' unless $analysis.get()

      res.json success: $analysis.get()

  updateAnalysis: (req, res) ->
    { model } = req
    analysis = req.body

    return res.json err: 'analysis is undefined.' unless analysis.id
    $analysis = model.at "analysis.#{analysis.id}"

    $analysis.fetch ->
      return res.json err: 'Analysis is not exist.' unless $analysis.get()

      for key, value of analysis
        $analysis.setDiffDeep key, value

      res.json model.get "analysis.#{analysis.id}"

  setAnalysisComments: (req, res) ->
    { model } = req
    { analysisId, content, userId } = req.body

    $analysisComments = model.query 'analysisComments', {}
    $analysisComments.fetch ->
      comment =
        analysisId: analysisId
        content: content
        userId: userId

      commentId = model.add 'analysisComments', comment, ->
        res.json success: model.get("analysisComments.#{commentId}")

  getAnalysisComments: (req, res) ->
    { model } = req
    { analysisId } = req.body
    $analysisComments = model.query 'analysisComments', analysisId: analysisId
    $analysisComments.fetch ->
      unless $analysisComments.get().length
        return res.json err: 'Analysis comments is not exist.'

      res.json $analysisComments.get()

  # Analitics

  getAnalitics: (req, res) ->
    { model } = req

    $analysts = model.query 'auths', type: 'analyst'

    $analysts.fetch ->
      return res.json(err: 'Analitics is not exist.') unless $analysts.get()?.length
      res.json $analysts.get()

  getGroupsByAnaliticId: (req, res) ->
    { model } = req
    { analiticId } = req.body

    $groups = model.query 'groups', userId: analiticId

    $groups.fetch ->
      return res.json(err: "Analitic didn't have groups.") unless $groups.get()?.length
      res.json $groups.get()

  # Investors

  getInvestors: (req, res) ->
    { model } = req

    $investors = model.query 'auths', type: 'investor'

    $investors.fetch ->
      return res.json(err: 'Investor is not exist.') unless $investors.get()?.length
      res.json $investors.get()

module.exports = serverController
