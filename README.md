createGroup:
{
  title: 'title',
  companyIds: [ 'Company 1', 'Company 2' ],
  paid: true or false,
  price: number,
  priceStamp: 'weekly', 'monthly',
  userId: 'Id who create group'
}

deleteGroup:
{
  groupId: 'Group id for the delete group.'
}

getGroup:
{
  groupId: 'Group id for the get group.'
}

updateGroup:
{
  id: 'Group document id',
  title: 'new title',
  paid: 'new paid',
  priceStamp: 'new price stamp'
}

subscribeGroup:
{
  authId: 'Id who subscribe on the group',
  groupId: 'Group id'
}

getGroupSubscribers:
{
  groupId: 'Group id'
}

getGroupAnalysis:
{
  groupId: 'Group id'
}

createAnalysis:
{
  img: 'path to image',
  timestamp: 'Time Stamp',
  groupId: 'Group Id'
}

deleteAnalysis:
{
  analysisId: 'Analysis Id'
}

getAnalysis:
{
  analysisId: 'Analysis Id'
}

updateAnalysis:
{
  id: 'Analysis document id',
  img: 'new image path',
  timestamp: 'new timestamp'
}

setAnalysisComments:
{
  analysisId: 'Analysis document id'
  content: 'Text for the comment'
  userId: 'User document id'
}

getAnalysisComments:
{
  analysisId: 'Analysis document id'
}

getAnalitics:
{

}

getGroupsByAnaliticId:
{
  analiticId: 'Analitic Document id'
}

getInvestors:
{
  
}
