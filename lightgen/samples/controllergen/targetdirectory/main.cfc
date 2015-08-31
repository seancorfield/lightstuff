<cfcomponent name="main" 
			 extends="coldbox.system.EventHandler" 
			 output="false"
			 autowire="true">

<cffunction name="default" returntype="void" output="false">
	<cfargument name="Event" type="any" required="yes">
	<cfscript>
	name,data,TagName
	</cfscript>
</cffunction>

</cfcomponent>