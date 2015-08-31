<cfcomponent extends="lightbase.com.pbell.base.basedatatype" output="false"><cfscript>

// ***************** PUBLIC METHODS *****************

function processField( PropertyName , Event , DataTypeProperties ) {
	var Properties = ProcessDataTypeProperties( arguments.DataTypeProperties );
	return arguments.Event.get( "#arguments.PropertyName#_1" ) & arguments.Event.get( "#arguments.PropertyName#_2" );
}

function format( PropertyName , PropertyValue , DataTypeProperties ) {
	var Properties = ProcessDataTypeProperties( arguments.DataTypeProperties );
	return "(#left( arguments.PropertyValue , 3 )#) #mid( arguments.PropertyValue , 3 , 3 )# #right( arguments.PropertyValue , 4 )#";
}

// ***************** PRIVATE METHODS *****************


</cfscript>
<cffunction name="field" returntype="string" output="false">
	<cfargument name="PropertyName" type="string" required="true">
	<cfargument name="PropertyValue" type="string" required="true">
	<cfset var FieldHTML = "">
<cfsavecontent variable="FieldHTML"><cfoutput>
<input type='text' name='#arguments.PropertyName#_1' size="3" maxlength="3" value='#left( arguments.PropertyValue , 3 )#' />
<input type='text' name='#arguments.PropertyName#_2' size="7" maxlength="7" value='#right( arguments.PropertyValue , 7 )#' />
</cfoutput></cfsavecontent>
	<cfreturn FieldHTML>
</cffunction>
</cfcomponent>