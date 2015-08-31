<cfset Item = event.getViewData()>
<cfoutput>
<h1>#Item._getFormTitle()#</h1>

<cfif event.getFormReturning()>
	#Item.errorDisplay()#
</cfif>

#event.getFormHeader()#
<input type="hidden" name="object" value="#event.getObject()#">

<cfloop list="#Item._getPropertyNameList()#" index="PropertyName">
#Item.title( PropertyName )#:<br />
#Item.field( PropertyName )#<br /><br />
</cfloop>
#event.getFormSubmit()#
#event.getFormFooter()#
</cfoutput>