<cfcomponent displayname="LightGen Process Metadata" output="false"><cfscript>

// *************  Constructor method(s) ************* 

function init ( MetadataXmlFilePath ) {
	variables.Metadata = ArrayNew( 1 );
	loadXml( arguments.MetadataXmlFilePath );
	return THIS;
}

// *************  Public methods ************* 

function getNumberofSteps() {
	return ArrayLen( variables.Metadata );
}

function getListtoIterateOver( Step ) {
	switch ( variables.Metadata[ arguments.Step ].List.Type ) {
		case "FilesInDirectory": {
			var Directory = variables.Metadata[ arguments.Step ].List.Directory;
			var Exclude = variables.Metadata[ arguments.Step ].List.Exclude;
			return getFilesInDirectory( Directory , Exclude );
		}
	};
}

function getTemplate( Step ) {
	return variables.Metadata[ arguments.Step ].Template;
}

function getMetadataInfo( Step ) {
	return variables.Metadata[ arguments.Step ].Metadata;
}

// *************  Private methods ************* 


function loadXml ( MetadataXmlFilePath ) {
	var XmlString = readFile( arguments.MetadataXmlFilePath );
	var XmlDocument = XMLParse( XmlString );
	var i = 0;
	variables.MetadataXML = XMLSearch( XmlDocument , "//generate/" )[1].XMLChildren;
	for (i = 1 ; i lte ArrayLen( variables.MetadataXML ) ; i++ ){
		saveStep( variables.MetadataXML[ i ] , i );
	};
}

function saveStep ( StepXML , StepNumber ) {
	var i = arguments.StepNumber;
	variables.Metadata[ i ] = structNew();
	variables.Metadata[ i ].Title = arguments.StepXML.XMLAttributes.Title;
	variables.Metadata[ i ].Template = arguments.StepXML.XMLAttributes.Template;
	var ListXML = XMLSearch( arguments.StepXML , "list" )[1];
	variables.Metadata[ i ].List = structNew();
	variables.Metadata[ i ].List.Type = ListXML.XmlAttributes.Type;
	variables.Metadata[ i ].List.Exclude = ListXML.XmlAttributes.Exclude;
	variables.Metadata[ i ].List.Directory = ListXML.XmlAttributes.Directory;
	var MetadataXML = XMLSearch( arguments.StepXML , "metadata" )[1];
	variables.Metadata[ i ].Metadata = structNew();
	variables.Metadata[ i ].Metadata.Type = MetadataXML.XmlAttributes.Type;
	variables.Metadata[ i ].Metadata.Classpath = MetadataXML.XmlAttributes.Classpath;
}


</cfscript>
<cffunction name="readFile" returntype="string" access="private" output="false">
	<cfargument name="FileName" required="true" type="string">
	<cfset var FileContents = "">
	<cffile action="read" file="#arguments.FileName#" variable="FileContents">
	<cfreturn FileContents>
</cffunction>

<cffunction name="getFilesInDirectory" returntype="string" access="private" output="false">
	<cfargument name="Directory" required="true" type="string">
	<cfargument name="Exclude" required="true" type="string">
	<cfscript>
		var FileList = "";
		var FileQuery = "";
		var DirectoryPath = expandPath("#Directory#");
		var ExcludethisName = false;
	</cfscript>
	<cfdirectory action="list" directory="#DirectoryPath#" name="FileQuery">
	<cfloop query="FileQuery">
		<cfset ExcludeThisName = len( Exclude ) AND ( left( Name , len( arguments.Exclude )) EQ arguments.Exclude )>
		<cfif NOT ExcludeThisName>
			<cfset FileList = ListAppend( FileList , ListGetAt( Name , 1 , "." ) )>
		</cfif>
	</cfloop>
	<cfreturn FileList>
</cffunction>
</cfcomponent>