<cfcomponent displayname="LightGen" output="false"><cfscript>

function init ( processmetadata , projectmetadata , cftemplate ) {
	variables.processmetadata = arguments.processmetadata;
	variables.projectmetadata = arguments.projectmetadata;
	variables.cftemplate = arguments.cftemplate;
	variables.NumberofSteps = variables.processmetadata.getNumberofSteps();
	return THIS;
}

// *************  Public methods ************* 

function generate() {
	var i = 0;
	var GenerationMessage = "<ul><li>#variables.NumberofSteps# step generation process</li>";
	for (i = 1 ; i lte variables.NumberofSteps ; i++ ){
		GenerationMessage &= generateStep( i );
	}
	GenerationMessage &= "<li>Generation completed successfully</li></ul>";
	return GenerationMessage;
}


// *************  Private methods ************* 

function generateFile( MetadataFile , Template , MetadataFileName ) {
	var ArgStruct = StructNew();
	ArgStruct.Metadata = arguments.MetadataFile;
	ArgStruct.TemplateFilePath = expandPath( "#arguments.Template#" );
	ArgStruct.DestinationFilePath = expandPath( "targetdirectory/#arguments.MetadataFileName#.cfc" );
	ArgStruct.ScratchpadDirectory = expandPath( "scratchpad/" );
	ArgStruct.ScratchpadPath = "scratchpad";
	cftemplate.generate(ArgumentCollection=ArgStruct);
}

function generateStep( StepNumber ) {
	var i = arguments.StepNumber;
	var ResponseMessage = "<li>Step #i#:<ul>";
	var ListtoIterateOver = variables.processmetadata.getListtoIterateOver( i );
	var Template = variables.processmetadata.getTemplate( i );
	var MetadataInfo = MetadataInfo = variables.processmetadata.getMetadataInfo( i );
	var MetadataFileName = ";"
	var MetadataFile = "";
	var j = 0;
	for ( j = 1 ; j lte listlen( ListtoIterateOver ) ; j++ ) { 
		MetadataFileName = ListGetAt( ListtoIterateOver , j );
		ResponseMessage &= "<li>Generating #MetadataFileName#.cfc</li>";
		MetadataFile = variables.projectmetadata.returnMetadata( MetadataInfo , MetadataFileName );
		generateFile( MetadataFile , Template , MetadataFileName );
	};	
	ResponseMessage &= "</ul></li>"
	return ResponseMessage;
}

function getNumberofSteps() {
	return variables.NumberofSteps;
}

</cfscript></cfcomponent>