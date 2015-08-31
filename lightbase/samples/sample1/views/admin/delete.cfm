<cfset Item = event.getViewData()>
<cfoutput>
<h1>Delete #Item._getTitle()#</h1>

Are you sure you want to delete this #Item._getTitle()# (#Item.toString()#)? <a href="index.cfm?action=#event.getAction()#&object=#event.getObject()#&Id=#event.getId()#&deleteConfirmed=1">delete</a> - <a href="index.cfm?action=admin.list&object=#event.getObject()#">cancel</a>
</cfoutput>