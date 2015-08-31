<cfscript>
	includeUDF = includePath;
	metadataxmlfilepath = expandpath( "processmetadata.xml" );
	processmetadata = createObject( "component" , "/lightgen/com/pbell/processmetadata" ).init( metadataxmlfilepath );
	projectmetadata = createObject( "component" , "projectmetadata" ).init();
	cftemplate = createObject( "component" , "/lightgen/com/pbell/cftemplate" ).init( includeUDF );
	lightgen = createObject( "component" , "/lightgen/com/pbell/lightgen" ).init( processmetadata , projectmetadata , cftemplate );
	
</cfscript>
<cfoutput>
<h1>Sample Generator: Controller Gen</h1>

<cfif NOT structKeyExists( url , "generate" )>
	<p>Click <a href="index.cfm?generate=true">here</a> to generate controllers.</p>
<cfelse>
	<p>Generating controllers . . .</p>
	<p>#lightgen.generate()#</p>
	<p>Done</p>
</cfif>

<cffunction name="includePath" output="true" access="public" returntype="string" hint="I include files RELATIVE TO THIS FILE.">
	<cfargument name="relativePath" type="string" required="true" />
	<cfargument name="Metadata" type="any" required="true" />
	<cfset var GeneratedContent = "">
	<cfsavecontent variable="GeneratedContent"><cfinclude template="#arguments.relativePath#" /></cfsavecontent>
	<cfreturn GeneratedContent />	
</cffunction>
</cfoutput>