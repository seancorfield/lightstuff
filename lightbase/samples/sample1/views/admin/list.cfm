<cfset List = event.getViewData()>
<cfset Item = List.getFirst()>
<cfoutput>
<h1>#Item._get("Title")# Administrator</h1>

	<cfif structkeyexists( session , "message" )>
		Message: #session.message#<br />
		<cfset structDelete( session , "message" )>
	</cfif>

<a href="index.cfm?action=admin.add&Object=#event.getObject()#">add</a><br />
<table border=1>
<tr>
<cfloop list="#Item._getPropertyNameList()#" index="PropertyName">
<td>#Item.title( PropertyName )#</td>
</cfloop>
<td>edit</td>
<td>delete</td>
</tr>

<cfloop condition="#List.hasMore()#">
<tr><cfset Item = List.getNext()>
<cfloop list="#Item._getPropertyNameList()#" index="PropertyName">
	<td>#Item.format( PropertyName )#</td>
</cfloop>
<td><a href="index.cfm?action=admin.edit&Object=#event.getObject()#&Id=#Item.get("Id")#">edit</a></td>
<td><a href="index.cfm?action=admin.delete&Object=#event.getObject()#&Id=#Item.get("Id")#">delete</a></td>
</tr>
</cfloop>
</table>

<br /><a href="index.cfm?action=admin">Back</a>
</cfoutput>