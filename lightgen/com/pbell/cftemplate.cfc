<cfcomponent displayname="CF Template" hint="I take metadata, a complete path (with filename) to a cf-template and a complete path (with filename) to a destination directory and publish the generated script to the destination directory" output="no"><cfscript>
function init( includeUDF ) {
	variables.includeUDF = arguments.includeUDF;
	variables.OpenTagString = "<<";
	variables.CloseTagString = ">>";
	variables.VariableString = "%";
	variables.EscapedVariableString = "%%";
	return THIS;
}
		
</cfscript>

<cffunction name="generate" returntype="string" access="public" output="no" hint="I generate a script using a cf-template and its associated metadata.">
	<cfargument Name="Metadata" type="any" required="yes" hint="The metadata required for generation." />
	<cfargument Name="TemplateFilePath" type="string" required="yes" hint="I am the filepath (including the file name and extension) of the CF Template to return.">
	<cfargument Name="DestinationFilePath" type="string" required="yes" hint="The physical path to publish the generated script to including the file name and file extension.">
	<cfargument Name="ScratchpadDirectory" type="string" required="yes" hint="The physical directory to use for temporary generation artifacts.">
	<cfargument Name="ScratchpadPath" type="string" required="yes" hint="The path for accessing the scratchpad from cftemplate.">
	<cfset var TemplateScript = "">
	<cfset var TemplateScratchpadName = "#CreateUUID()#.cfm">
	<cfset var GeneratedScript = "">
	<cffile action="read" file="#TemplateFilePath#" variable="TemplateScript">	
	<cfscript>
		// TRANSFORM TEMPLATE FOR PROCESSING
		// Turn CF Template tag and variable identifiers into arbritrary strings
		TemplateScript = Replace(TemplateScript, OpenTagString, "!!START_CFTEMPLATE!!", "all");
		TemplateScript = Replace(TemplateScript, CloseTagString, "!!END_CFTEMPLATE!!", "all");
		TemplateScript = Replace(TemplateScript, EscapedVariableString, "!!EscapedVariableString!!", "all");
		TemplateScript = Replace(TemplateScript, VariableString, "!!VariableString!!", "all");

		// Turn ColdFusion tag and variable identifiers into arbritrary strings
		TemplateScript = Replace(TemplateScript, "<", "!!START_CF_TAG!!", "all");
		TemplateScript = Replace(TemplateScript, ">", "!!END_CF_TAG!!", "all");
		TemplateScript = Replace(TemplateScript, "####", "!!EscapedCFVariableString!!", "all");
		TemplateScript = Replace(TemplateScript, "##", "!!CFVariableString!!", "all");
		
		// Turn CF Template tag and variable identifiers into ColdFusion tag and variable identifiers
		TemplateScript = Replace(TemplateScript, "!!START_CFTEMPLATE!!", "<", "all");
		TemplateScript = Replace(TemplateScript, "!!END_CFTEMPLATE!!", ">", "all");
		TemplateScript = Replace(TemplateScript, "!!VariableString!!", "##", "all");
		
	</cfscript>	
	<!--- Save the transformed template to the scratchpad directory for parsing --->
	<cffile action="write" addnewline="yes" file="#ScratchpadDirectory##TemplateScratchpadName#" output="#TemplateScript#" fixnewline="no">
	<!--- Run the template to generate code --->
	<cfset GeneratedScript = includeUDF( "#ScratchPadPath#/#TemplateScratchpadName#" , arguments.Metadata )>
	<!--- Delete any scratchpad files --->
	<cfdirectory action="list" directory="#ScratchpadDirectory#" name="ScratchpadFileList">
	<cfoutput query="ScratchpadFileList">
		<cfif Right(name, 4) EQ ".cfm">
			<cffile action="delete" file="#ScratchpadDirectory##name#">
		</cfif>
	</cfoutput>
	<cfscript>
		// Transform the code back to CF
		GeneratedScript = Replace(GeneratedScript, "!!START_CF_TAG!!", "<", "all");
		GeneratedScript = Replace(GeneratedScript, "!!END_CF_TAG!!", ">", "all");
		GeneratedScript = Replace(GeneratedScript, "!!EscapedCFVariableString!!", "####", "all");
		GeneratedScript = Replace(GeneratedScript, "!!CFVariableString!!", "##", "all");
		GeneratedScript = Replace(GeneratedScript, "!!EscapedVariableString!!", EscapedVariableString, "all");
	</cfscript>	
	<cfif FileExists("DestinationFilePath")>
		<cffile action="delete" file="#DestinationFilePath#">
	</cfif>
	<cffile action="write" addnewline="no" file="#DestinationFilePath#" output="#GeneratedScript#" fixnewline="no">
</cffunction>

</cfcomponent>