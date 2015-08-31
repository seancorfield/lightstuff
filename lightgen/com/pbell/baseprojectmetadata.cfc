<cfcomponent displayname="LightGen Project Metadata" output="false"><cfscript>

function init ( ) {
	return THIS;
}

function returnMetadata( MetadataInfo , MetadataFileName ) {
	switch ( arguments.MetadataInfo.Type ) {
		case "class": {
			return createObject( "component" , arguments.MetadataInfo.ClassPath ).init( arguments.MetadataFileName );
		}
	};
	
	return "Hello world 23";
}

</cfscript>
<cffunction name="readFile" returntype="string" access="private" output="false">
	<cfargument name="FileName" required="true" type="string">
	<cfset var FileContents = "">
	<cffile action="read" file="#arguments.FileName#" variable="FileContents">
	<cfreturn FileContents>
</cffunction>
</cfcomponent>