<cfcomponent name="admin" 
			 extends="coldbox.system.EventHandler" 
			 output="false"
			 autowire="true">

<cffunction name="reinstateUser" returntype="void" output="false">
	<cfargument name="Event" type="any" required="yes">
	<cfscript>
	name,defaults,successLocation,validationContextList,propertyValue,PropertyList,title,businessObject,TagName,successMessage
	</cfscript>
</cffunction>

<cffunction name="siteIndex" returntype="void" output="false">
	<cfargument name="Event" type="any" required="yes">
	<cfscript>
	successLocation,name,successMessage,action,TagName
	</cfscript>
</cffunction>

<cffunction name="index" returntype="void" output="false">
	<cfargument name="Event" type="any" required="yes">
	<cfscript>
	businessObject,successLocation,name,successMessage,action,TagName
	</cfscript>
</cffunction>

<cffunction name="list" returntype="void" output="false">
	<cfargument name="Event" type="any" required="yes">
	<cfscript>
	businessObject,name,TagName,method
	</cfscript>
</cffunction>

<cffunction name="view" returntype="void" output="false">
	<cfargument name="Event" type="any" required="yes">
	<cfscript>
	businessObject,name,propertyValue,TagName,PropertyList,method
	</cfscript>
</cffunction>

<cffunction name="edit" returntype="void" output="false">
	<cfargument name="Event" type="any" required="yes">
	<cfscript>
	name,successLocation,validationContextList,propertyValue,view,PropertyList,title,businessObject,TagName,successMessage
	</cfscript>
</cffunction>

<cffunction name="default" returntype="void" output="false">
	<cfargument name="Event" type="any" required="yes">
	<cfscript>
	name,TagName
	</cfscript>
</cffunction>

<cffunction name="suspendUser" returntype="void" output="false">
	<cfargument name="Event" type="any" required="yes">
	<cfscript>
	name,defaults,successLocation,validationContextList,propertyValue,PropertyList,title,businessObject,TagName,successMessage
	</cfscript>
</cffunction>

<cffunction name="delete" returntype="void" output="false">
	<cfargument name="Event" type="any" required="yes">
	<cfscript>
	businessObject,successLocation,name,successMessage,propertyValue,TagName
	</cfscript>
</cffunction>

<cffunction name="add" returntype="void" output="false">
	<cfargument name="Event" type="any" required="yes">
	<cfscript>
	name,successLocation,validationContextList,view,PropertyList,title,businessObject,TagName,successMessage
	</cfscript>
</cffunction>

</cfcomponent>