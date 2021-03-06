/*
Attempt to get unpublished content that has not been scheduled for publishing
* Not is recycle bin
* Does not have a entry in the "umbracoContentScedule"-table
*/
SELECT un.[id]
      ,[uniqueId]
      ,[parentId]
      ,[level]
      ,[path]
      ,[sortOrder]
      ,[trashed]
      ,[nodeUser]
      ,[text]
      ,[nodeObjectType]
      ,[createDate]
	  ,ud.edited
	  ,ud.published
	  ,ucs.action
  FROM umbracoNode AS un
	INNER JOIN umbracoDocument as ud on ud.nodeId = un.id
	LEFT OUTER JOIN umbracoContentSchedule as ucs on ucs.nodeId = un.id
  WHERE 
	un.nodeObjectType = 'C66BA18E-EAF3-4CFF-8A22-41B16D66A972' AND
	un.trashed = 0 AND ud.edited = 1 AND ud.published = 1 AND ucs.[action] is null

-- New solution

SELECT ul.[id]
      ,ul.[userId]
      ,ul.[NodeId]
      ,ul.[entityType]
      ,ul.[Datestamp]
      ,ul.[logHeader]
      ,ul.[logComment]
	  ,un.[text] as NodeName
	  ,un.[path] as NodePath
	  ,ucs.[action] as NodeScheduleAction
	  ,uu.userName
	  ,uu.userEmail
	  ,uu.avatar as userAvatar
	  
  FROM umbracoLog as ul
	INNER JOIN umbracoNode as un ON un.id = ul.NodeId
	INNER JOIN umbracoUser as uu ON uu.id = ul.userId
	INNER JOIN umbracoDocument as ud on ud.nodeId = un.id
	LEFT OUTER JOIN umbracoContentSchedule as ucs ON ucs.nodeId = ul.NodeId

  WHERE 
	ul.userId is not NULL 
	AND ul.nodeId is not NULL
	AND ul.nodeId > 0 -- Only include actual nodes
	AND ul.entityType = 'Document' 

	AND un.nodeObjectType = 'C66BA18E-EAF3-4CFF-8A22-41B16D66A972' 
	AND	un.trashed = 0 
	AND ud.edited = 1 
	AND ud.published = 1 
	AND ucs.[action] is null
	AND ul.logHeader = 'Save'

  ORDER by ul.Datestamp DESC